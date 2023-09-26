/// 名称: DHCHAI.BT.LocationLink
/// 描述: 关联科室表
/// 编写者：liyi
/// 编写日期: 2018-05-08
Class DHCHAI.BT.LocationLink Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.BT.Location [ Cardinality = parent, Inverse = ChildLink ];

/// 关联科室
Property BTLinkLocDr As DHCHAI.BT.Location [ Required ];

/// 是否有效
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 关联科室索引
Index IndexLinkLocDr On BTLinkLocDr As Exact;

/// Creator：     liyi
/// CreatDate：   2018-05-08
/// Description:  根据ID获取关联科室ID列表
/// Table：       DHCHAI.BT.LocationLink
/// Input：       id:    DHCHAI.BT.LocationLink.ID
/// Return：      关联科室字符串
/// w ##class(DHCHAI.BT.LocationLink).GetLocLinks(1)
ClassMethod GetLocLinks(aLocID As %String) As %String
{
	New (aLocID)
	Set return=""
	Quit:aLocID="" return
	
	Set xSubID = ""
	For {
		Set xSubID = $o(^DHCHAI.BT.LocationD(aLocID,"Link",xSubID))
		Quit:xSubID=""
		
		Set objLocLink = ..GetObjById(aLocID_"||"_xSubID)
		Continue:'$IsObject(objLocLink)
		Continue:objLocLink.BTIsActive'=1
		Continue:'$IsObject(objLocLink.BTLinkLocDr)
		
		Set return=return_"|"_objLocLink.BTLinkLocDr.%Id()
	}
	Set return = $e(return,2,$l(return))
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-05-08
/// Description:  根据ID作废关联科室信息
/// Table：       DHCHAI.BT.LocationLink
/// Input：       id:    DHCHAI.BT.LocationLink.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocationLink).CancelById(1)
ClassMethod CancelById(id As %String, aActUserDr As %String) As %String
{
	New (id,aActUserDr)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.BT.LocationLink).%OpenId(id)
	Quit:'$IsObject(obj) return
	
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(aActUserDr)
	Set obj.BTIsActive		= 0
	Set obj.BTActDate		= +$h
	Set obj.BTActTime		= +$p($h,",",2)
	Set obj.BTActUserDr		= objActUser
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-05-08
/// Description:  根据ID取关联科室信息
/// Table：       DHCHAI.BT.LocationLink
/// Input：       aId : DHCHAI.BT.LocationLink.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.LocationLink).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.LocationLink
{
	New (aId)
	Quit:'##class(DHCHAI.BT.LocationLink).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.LocationLink).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2018-05-08
/// Description:  更新关联科室信息
/// Table：       DHCHAI.BT.LocationLink
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocationLink).Update("1||1^1^23^1^^^9")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Parref		= $p(aInputStr,aSeparete,2)
	Set LinkLocDr	= $p(aInputStr,aSeparete,3)
	Set IsActive	= +$p(aInputStr,aSeparete,4)
	Set ActDate		= $p(aInputStr,aSeparete,5)
	Set ActTime		= $p(aInputStr,aSeparete,6)
	Set ActUserDr	= $p(aInputStr,aSeparete,7)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(Parref="")||(LinkLocDr="")||(IsActive="")||(ActDate="")||(ActTime="") return
	
	Set objParref=##class(DHCHAI.BT.Location).GetObjById(Parref)
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Set objLinkLoc=##class(DHCHAI.BT.Location).GetObjById(LinkLocDr)
	Quit:'$isobject(objLinkLoc) return
	Quit:'$isobject(objParref) return
	
	If ID'=""{
		Set obj=##class(DHCHAI.BT.LocationLink).%OpenId(ID)
	}else{
		Set SubID=$o(^DHCHAI.BT.LocationI("Link","IndexLinkLocDr",LinkLocDr,Parref,0))
		If SubID="" {
			Set obj=##class(DHCHAI.BT.LocationLink).%New()
		}Else{
			Set obj=##class(DHCHAI.BT.LocationLink).%OpenId(Parref_"||"_SubID)
		}
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref	    = objParref
	Set obj.BTLinkLocDr	= objLinkLoc
	Set obj.BTIsActive	= IsActive
	Set obj.BTActDate	= ActDate
	Set obj.BTActTime	= ActTime
	Set obj.BTActUserDr	= objActUser
	
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

/// Creator：     liyi
/// CreatDate：   2018-05-08
/// Description:  删除关联科室
/// Table：       DHCHAI.BT.LocationLink
/// Input：       aId : DHCHAI.BT.LocationLink.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.LocationLink).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.LocationLink).%DeleteId(aId)
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
<Data name="LocationLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTLinkLocDr</Value>
</Value>
<Value name="3">
<Value>BTIsActive</Value>
</Value>
<Value name="4">
<Value>BTActDate</Value>
</Value>
<Value name="5">
<Value>BTActTime</Value>
</Value>
<Value name="6">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Link")</DataLocation>
<DefaultData>LocationLinkDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Link")</IdLocation>
<IndexLocation>^DHCHAI.BT.LocationI("Link")</IndexLocation>
<StreamLocation>^DHCHAI.BT.LocationLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
