/// 名称: DHCMA.CPW.SD.Stand.OrderLink
/// 描述: 标准化-医嘱对照
/// 编写者：zqy
/// 编写日期: 2021-03-30
Class DHCMA.CPW.SD.Stand.OrderLink Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 字典
Property Dic As DHCMA.CPW.SD.Stand.Dic;

/// 字典子项
Property DicSub As DHCMA.CPW.SD.Stand.Dicsub;

/// 对照类型
Property MatchType As %String(MAXLEN = 50, TRUNCATE = 1);

/// 关联医嘱项 DHCMA.Util.EPx.OrdMast
Property OrdMastID As %String(MAXLEN = 5000, TRUNCATE = 1);

Index IdxDic On Dic;

Index IdxDicSub On DicSub;

ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.Stand.OrderLink
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.Stand.OrderLink).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.Stand.OrderLink).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  更新标准化-医嘱对照
/// Table：       DHCMA.CPW.SD.Stand.OrderLink
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID          	= $p(aInputStr,aSeparete,1)
	Set DicId          	= $p(aInputStr,aSeparete,2)
	Set DicSubId      	= $p(aInputStr,aSeparete,3)
	Set MatchType       = $p(aInputStr,aSeparete,4)
	Set OrdMastID       = $p(aInputStr,aSeparete,5)	
	Quit:(DicId="")&&(DicSubId="") return
	Set objDic=##class(DHCMA.CPW.SD.Stand.Dic).GetObjById(DicId)
	Set objDicSub=##class(DHCMA.CPW.SD.Stand.Dicsub).GetObjById(DicSubId)
	Quit:('$IsObject(objDic))&&('$IsObject(objDicSub)) return
	If ID="" {                                  
		Set obj=##class(DHCMA.CPW.SD.Stand.OrderLink).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.Stand.OrderLink).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	//写入数据
	Set obj.Dic   	  	= objDic
	Set obj.DicSub     	= objDicSub
	Set obj.MatchType	= MatchType
	Set obj.OrdMastID	= OrdMastID
	
	//检查Save是否成功
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zqy
/// CreatDate：   2021-03-30
/// Description:  删除标准化-医嘱对照
/// Table：       DHCMA.CPW.SD.Stand.OrderLink
/// Input：       aId :  DHCMA.CPW.SD.Stand.OrderLink.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.Stand.OrderLink).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.Stand.OrderLink).%DeleteId(aId)
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
<Data name="OrderLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Dic</Value>
</Value>
<Value name="3">
<Value>DicSub</Value>
</Value>
<Value name="4">
<Value>MatchType</Value>
</Value>
<Value name="5">
<Value>OrdMastID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Stand.OrderLinkD</DataLocation>
<DefaultData>OrderLinkDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Stand.OrderLinkD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Stand.OrderLinkI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Stand.OrderLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
