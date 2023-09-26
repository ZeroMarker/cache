/// 名称: DHCHAI.BT.InfSub
/// 描述: 感染诊断分类表
/// 编写者：chenjb
/// 编写日期: 2017-01-10
Class DHCHAI.BT.InfSub Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean;

Index IdxofCode On BTCode As Exact;

Index IdxofDesc On BTDesc As Exact;

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  根据ID取感染诊断分类信息
/// Table：       DHCHAI.BT.InfSub
/// Input：       aId : DHCHAI.BT.InfSub.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfSub).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.InfSub
{
	New (aId)
	Quit:'##class(DHCHAI.BT.InfSub).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.InfSub).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2017-10-26
/// Description:  根据描述取感染诊断分类表信息
/// Table：       DHCHAI.BT.InfSub
/// Input：       aDesc : DHCHAI.BT.InfSub.Desc
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfSub).GetObjByDesc("上呼吸道感染")
ClassMethod GetObjByDesc(aDesc As %String) As DHCHAI.BT.InfSub
{
	New (aDesc)
	Quit:(aDesc="") ""
	Set ID=$o(^DHCHAI.BT.InfSubI("IdxofDesc",aDesc,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  更新感染诊断分类信息
/// Table：       DHCHAI.BT.InfSub
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfSub).Update("^C001^CDesc^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set IsActive = +$p(aInputStr,aSeparete,4)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.InfSubI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.InfSub).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.InfSub).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTIsActive = IsActive
	
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

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  删除感染诊断分类信息
/// Table：       DHCHAI.BT.InfSub
/// Input：       aId : DHCHAI.BT.InfSub.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfSub).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.InfSub")
	Quit:Flg'=1 -777

	Set sc = ##class(DHCHAI.BT.InfSub).%DeleteId(aId)
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
<Data name="InfSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.InfSubD</DataLocation>
<DefaultData>InfSubDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.InfSubD</IdLocation>
<IndexLocation>^DHCHAI.BT.InfSubI</IndexLocation>
<StreamLocation>^DHCHAI.BT.InfSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
