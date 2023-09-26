/// 名称: CT.IPMR.DP.LocationMap
/// 描述: 科室对照
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DP.LocationMap Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病案科室ID （指向MA_IPMR_BT.Location）
Property DLIpmrLocID As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// HIS科室ID （指向CT_IPMR_DP.Location.DLLocID）
Property DLHisLocID As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

Index IndexOfHisLoc On DLHisLocID [ Unique ];

Index IndexOfIpmrLoc On DLIpmrLocID;

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  取科室对照
/// Table：       CT.IPMR.DP.LocationMap
/// Input：       Id : CT.IPMR.DP.LocationMap.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.DP.LocationMap).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.DP.LocationMap
{
	new (aId)
	quit:'##class(CT.IPMR.DP.LocationMap).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.DP.LocationMap).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  取科室对照
/// Table：       CT.IPMR.DP.LocationMap
/// Input：       Id : CT_IPMR_DP.Location.DLLocID
/// Return：      返回Object
/// w ##class(CT.IPMR.DP.LocationMap).GetObjByHisLocID("151||1")
ClassMethod GetObjByHisLocID(aHisLocID As %String) As CT.IPMR.DP.LocationMap
{
	new (aHisLocID)
	Set id = $o(^CT.IPMR.DP.LocationMapI("IndexOfHisLoc"," "_aHisLocID,""))
	quit:'##class(CT.IPMR.DP.LocationMap).%ExistsId(id) ""
	set obj=##Class(CT.IPMR.DP.LocationMap).%OpenId(id)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  更新科室对照
/// Table：       CT.IPMR.DP.LocationMap
/// Input：       InputStr ：对照数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.LocationMap).Update("^1^1||2","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID			= $p(aInputStr,aSeparate,1)
	Set IpmrLocID	= $p(aInputStr,aSeparate,2)
	Set HisLocID 	= $p(aInputStr,aSeparate,3)
	Quit:(IpmrLocID="")||(HisLocID="") return

	Set objIpmrLoc = ##class(MA.IPMR.BT.Location).GetObjById(IpmrLocID)
	Quit:'$IsObject(objIpmrLoc) return
	
	Set objHisLoc= ##class(CT.IPMR.DP.Location).GetObjByOID(HisLocID)
	Quit:'$IsObject(objHisLoc) return
	
	Set tID = $o(^CT.IPMR.DP.LocationMapI("IndexOfHisLoc"," "_HisLocID,""))
	Quit:tID'="" -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.DP.LocationMap).%New()
	}Else{
		Set obj=##class(CT.IPMR.DP.LocationMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DLIpmrLocID	= IpmrLocID
	Set obj.DLHisLocID	= HisLocID
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
/// CreatDate：   2019-10-25
/// Description:  删除科室对照
/// Table：       CT.IPMR.DP.LocationMap
/// Input：       Id : CT.IPMR.DP.LocationMap.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.DP.LocationMap).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.DP.LocationMap).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DLIpmrLocID</Value>
</Value>
<Value name="3">
<Value>DLHisLocID</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.DP.LocationMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.DP.LocationMapD</IdLocation>
<IndexLocation>^CT.IPMR.DP.LocationMapI</IndexLocation>
<StreamLocation>^CT.IPMR.DP.LocationMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
