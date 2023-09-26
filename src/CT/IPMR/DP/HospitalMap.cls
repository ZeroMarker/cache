/// 名称: CT.IPMR.DP.HospitalMap
/// 描述: 医院对照
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.DP.HospitalMap Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病案医院ID （指向MA_IPMR_BT.Hospital）
Property DHIpmrHospID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// HIS医院ID （指向CT_IPMR_DP.Hospital.DHHospID）
Property DHHisHospID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

Index IndexOfHisHospID On DHHisHospID [ Unique ];

Index IndexOfIpmrHospID On DHIpmrHospID;

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  取医院对照
/// Table：       CT.IPMR.DP.HospitalMap
/// Input：       Id : CT.IPMR.DP.HospitalMap.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.DP.HospitalMap).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.DP.HospitalMap
{
	new (aId)
	quit:'##class(CT.IPMR.DP.HospitalMap).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.DP.HospitalMap).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  取医院对照
/// Table：       CT.IPMR.DP.HospitalMap
/// Input：       Id : CT_IPMR_DP.Hospital.DHHospID
/// Return：      返回Object
/// w ##class(CT.IPMR.DP.HospitalMap).GetObjByHisHospID("2||1")
ClassMethod GetObjByHisHospID(aHisHospID As %String) As CT.IPMR.DP.HospitalMap
{
	new (aHisHospID)
	Set id = $o(^CT.IPMR.DP.HospitalMapI("IndexOfHisHospID"," "_aHisHospID,""))
	quit:'##class(CT.IPMR.DP.HospitalMap).%ExistsId(id) ""
	set obj=##Class(CT.IPMR.DP.HospitalMap).%OpenId(id)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-25
/// Description:  更新医院对照
/// Table：       CT.IPMR.DP.HospitalMap
/// Input：       InputStr ：对照数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.DP.HospitalMap).Update("^1^175","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID			= $p(aInputStr,aSeparate,1)
	Set IpmrHospID	= $p(aInputStr,aSeparate,2)
	Set HisHospID 	= $p(aInputStr,aSeparate,3)
	Quit:(IpmrHospID="")||(HisHospID="") return

	Set objIpmrHosp = ##class(MA.IPMR.BT.Hospital).GetObjById(IpmrHospID)
	Quit:'$IsObject(objIpmrHosp) return
	
	Set objHisHosp = ##class(CT.IPMR.DP.Hospital).GetObjByOID(HisHospID)
	Quit:'$IsObject(objHisHosp) return

	Set tID1 = $o(^CT.IPMR.DP.HospitalMapI("IndexOfHisHospID"," "_HisHospID,""))
	Quit:tID1'="" -100
	
	If ID="" {
		Set obj=##class(CT.IPMR.DP.HospitalMap).%New()
	}Else{
		Set obj=##class(CT.IPMR.DP.HospitalMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DHIpmrHospID	= IpmrHospID
	Set obj.DHHisHospID	= HisHospID
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
/// Description:  删除医院对照
/// Table：       CT.IPMR.DP.HospitalMap
/// Input：       Id : CT.IPMR.DP.HospitalMap.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.DP.HospitalMap).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.DP.HospitalMap).%DeleteId(aId)
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
<Value>DHIpmrHospID</Value>
</Value>
<Value name="3">
<Value>DHHisHospID</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.DP.HospitalMapD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.DP.HospitalMapD</IdLocation>
<IndexLocation>^CT.IPMR.DP.HospitalMapI</IndexLocation>
<StreamLocation>^CT.IPMR.DP.HospitalMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
