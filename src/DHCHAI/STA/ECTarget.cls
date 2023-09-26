/// 名称: DHCHAI.STA.ECTarget
/// 描述: 数据类型
/// 编写者：jiangpengpeng
/// 编写日期: 2018-06-12
Class DHCHAI.STA.ECTarget Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property ECCode As %String(TRUNCATE = 1) [ Required ];

/// 描述
Property ECDesc As %String(TRUNCATE = 1) [ Required ];

/// 计算方法
Property ECMethod As %String(MAXLEN = 200);

/// 说明
Property ECRemarks As %String;

/// 是否有效
Property ECIsActive As %String;

Index IdxofCode On ECCode As Exact;

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  根据ID取统计结果
/// Table：       DHCHAI.STA.ECTarget
/// Input：       aId : DHCHAI.STA.ECTarget
/// Return：      返回obj
/// w ##class(DHCHAI.STA.ECTarget).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.STA.ECTarget
{
	New (aId)
	Quit:'##class(DHCHAI.STA.ECTarget).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.STA.ECTarget).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  根据Code取统计结果
/// Table：       DHCHAI.STA.ECType
/// Input：       Code 
/// Return：      返回obj
/// w ##class(DHCHAI.STA.ECTarget).GetObjByCode(1)
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.STA.ECTarget
{
	New (aCode)
	Quit:aCode="" ""
	
	Set ID=$o(^DHCHAI.STA.ECTargetI("IdxofCode",aCode,""))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  更新统计结果信息
/// Table：       DHCHAI.STA.ECTarget
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.STA.ECTarget).Update("^BabyHAICase^新生儿感染例次数^^^1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID      	= $p(aInputStr,aSeparete,1)
	Set ECCode    = $p(aInputStr,aSeparete,2)
	Set ECDesc     = $p(aInputStr,aSeparete,3)
	Set ECMethod 	= $p(aInputStr,aSeparete,4)
	Set ECRemarks 	= $p(aInputStr,aSeparete,5)
	Set ECIsActive	= $p(aInputStr,aSeparete,6)
	
	Quit:ECCode="" return
	
	Set:ID="" ID=$o(^DHCHAI.STA.ECTargetI("IdxofCode",ECCode,""))
	
	If ID="" {
		Set obj=##class(DHCHAI.STA.ECTarget).%New()
	}Else{
		Set obj=##class(DHCHAI.STA.ECTarget).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ECCode   = ECCode
	Set obj.ECDesc    = ECDesc
	Set obj.ECMethod   = ECMethod
	Set obj.ECRemarks = ECRemarks
	Set obj.ECIsActive = ECIsActive
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  删除统计结果信息
/// Table：       DHCHAI.STA.ECTarget
/// Input：       aId : DHCHAI.STA.ECTarget.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.STA.ECTarget).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.STA.ECTarget).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="ECTargetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECCode</Value>
</Value>
<Value name="3">
<Value>ECDesc</Value>
</Value>
<Value name="4">
<Value>ECMethod</Value>
</Value>
<Value name="5">
<Value>ECRemarks</Value>
</Value>
<Value name="6">
<Value>ECIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.STA.ECTargetD</DataLocation>
<DefaultData>ECTargetDefaultData</DefaultData>
<IdLocation>^DHCHAI.STA.ECTargetD</IdLocation>
<IndexLocation>^DHCHAI.STA.ECTargetI</IndexLocation>
<StreamLocation>^DHCHAI.STA.ECTargetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
