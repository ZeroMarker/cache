Class web.DHCEQ.Interface.Outer.BAUseRecord Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zy 2021-09-07
/// 取效益设备使用记录
/// 入参：startDate:开始日期：YYYY-MM-DD
///       endDate  :结束日期：YYYY-MM-DD
///       equipNo  :设备编号
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Interface.Outer.BAUseRecord","BAUseRecord","2020-07-01","2020-09-01","3221709000014")
Query BAUseRecord(startDate As %String = "", endDate As %String = "", equipNo As %String = "") As %Query(ROWSPEC = "URRowID:%String,UREquipDR:%String,UREquipName:%String,URNo:%String,URUseDate:%String,URStartTime:%String,UREndDate:%String,UREndTime:%String,URWorkLoadNum:%String,URWorkLoadUnitDR:%String,URUseLocDR:%String,URPatientID:%String,URPrice:%String,URTotalFee:%String,URServiceItemDR:%String,URExType:%String,URExID:%String,URModelDR:%String,URDoctorOrderID:%String,UROperator:%String,URPositiveFlag:%String,URSampleNo:%String,URExposureNum:%String,URStartDate:%String,URPatientSex:%String,URPatientAge:%String,URPatientName:%String,UROtherInfo:%String,URExecDeptDR:%String,URStatFlag:%String,URDeviceStatus:%String,URAverageTime:%String,URAdmissionType:%String,UROrdDate:%String,UROrdTime:%String,URPreOccurDate:%String,URPreOccurTime:%String,URPreDate:%String,URPreTime:%String,URRegDate:%String,URRegTime:%String,URReportDate:%String,URReportTime:%String,URCheckPart:%String,URDoctorID:%String,URRequestDeptDR:%String,URReportDoctorDR:%String,URTWorkLoadNum:%String,URHold1:%String,URHold2:%String,URHold3:%String,URHold4:%String,URHold5:%String") [ SqlProc ]
{
}

ClassMethod BAUseRecordExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", equipNo As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s EquipID=##class(web.DHCEQEquip).GetEquipIDByNo(equipNo)
 	s startDate=##class(web.DHCEQCommon).TransValueFromPage(startDate,"date")  
 	s endDate=##class(web.DHCEQCommon).TransValueFromPage(endDate,"date")
 	i (EquipID="")||(startDate="")||(endDate="")  Quit $$$OK
 	i '$Data(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID))  Quit $$$OK
 	
 	s vDate=startDate-1
 	f  s vDate=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID,vDate))  q:(vDate="")||(vDate>endDate)  d
 	.s URRowID=0
 	.f  s URRowID=$o(^DHCEQUseRecord(0,"SourceDate",2,1,EquipID,vDate,URRowID))  q:URRowID=""  d
 	..d BAUseRecord
 	
 	Quit $$$OK
BAUseRecord
 	d ResetVariablesBAUseRecord
 	s DataList=$g(^DHCEQUseRecord(URRowID))
 	s UREquipDR=EquipID
 	s UREquipName=$p($g(^DHCEQEquip(EquipID)),"^",1)
 	s URNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
 	s URUseDate=$p(DataList,"^",3)
 	s URStartTime=$p(DataList,"^",4)
 	s UREndDate=$p(DataList,"^",5)
 	s UREndTime=$p(DataList,"^",6)
 	s URWorkLoadNum=$p(DataList,"^",7)
 	s URWorkLoadUnitDR=$p(DataList,"^",8)
 	s URUseLocDR=$p(DataList,"^",9)
 	s URPatientID=$p(DataList,"^",10)
 	s URPrice=$p(DataList,"^",11)
 	s URTotalFee=$p(DataList,"^",12)
 	//s URYear=$p(DataList,"^",13)
 	//s URMonth=$p(DataList,"^",14)
 	s URServiceItemDR=$p(DataList,"^",15)
 	s URExType=$p(DataList,"^",16)
 	s URExID=$p(DataList,"^",17)
 	//s URIsInputFlag=$p(DataList,"^",18)
 	//s URStatus=$p(DataList,"^",19)
 	//s URInvalidFlag=$p(DataList,"^",20)
 	//s URRemark=$p(DataList,"^",21)
 	//s URAddUserDR=$p(DataList,"^",22)
 	//s URAddDate=$p(DataList,"^",23)
 	//s URAddTime=$p(DataList,"^",24)
 	//s URUpdateUserDR=$p(DataList,"^",25)
 	//s URUpdateDate=$p(DataList,"^",26)
 	//s URUpdateTime=$p(DataList,"^",27)
 	s URModelDR=$p(DataList,"^",28)
 	//s URCancelDate=$p(DataList,"^",29)
 	//s URCancelTime=$p(DataList,"^",30)
 	//s URCancelUser=$p(DataList,"^",31)
 	//s URSubmitDate=$p(DataList,"^",32)
 	//s URSubmitTime=$p(DataList,"^",33)
 	//s URSubmitUser=$p(DataList,"^",34)
 	//s URAuditDate=$p(DataList,"^",35)
 	//s URAuditTime=$p(DataList,"^",36)
 	//s URAuditUser=$p(DataList,"^",37)
 	s URDoctorOrderID=$p(DataList,"^",38)
 	s UROperator=$p(DataList,"^",39)
 	s URPositiveFlag=$p(DataList,"^",40)
 	s URSampleNo=$p(DataList,"^",41)
 	s URExposureNum=$p(DataList,"^",42)
 	s URStartDate=$p(DataList,"^",43)
 	s URPatientSex=$p(DataList,"^",44)
 	s URPatientAge=$p(DataList,"^",45)
 	s URPatientName=$p(DataList,"^",46)
 	s UROtherInfo=$p(DataList,"^",47)
 	s URExecDeptDR=$p(DataList,"^",48)
 	s URStatFlag=$p(DataList,"^",49)
 	s URDeviceStatus=$p(DataList,"^",50)
 	s URAverageTime=$p(DataList,"^",51)
 	s URAdmissionType=$p(DataList,"^",52)
 	s UROrdDate=$p(DataList,"^",53)
 	s UROrdTime=$p(DataList,"^",54)
 	s URPreOccurDate=$p(DataList,"^",55)
 	s URPreOccurTime=$p(DataList,"^",56)
 	s URPreDate=$p(DataList,"^",57)
 	s URPreTime=$p(DataList,"^",58)
 	s URRegDate=$p(DataList,"^",59)
 	s URRegTime=$p(DataList,"^",60)
 	s URReportDate=$p(DataList,"^",61)
 	s URReportTime=$p(DataList,"^",62)
 	s URCheckPart=$p(DataList,"^",63)
 	s URDoctorID=$p(DataList,"^",64)
 	s URRequestDeptDR=$p(DataList,"^",65)
 	s URReportDoctorDR=$p(DataList,"^",66)
 	s URTWorkLoadNum=$p(DataList,"^",67)
 	s URHold1=$p(DataList,"^",68)
 	s URHold2=$p(DataList,"^",69)
 	s URHold3=$p(DataList,"^",70)
 	s URHold4=$p(DataList,"^",71)
 	s URHold5=$p(DataList,"^",72)
 	d OutputRowBAUseRecord
 	quit
OutputRowBAUseRecord
	s Data=$lb(URRowID,UREquipDR,UREquipName,URNo,URUseDate,URStartTime,UREndDate,UREndTime,URWorkLoadNum,URWorkLoadUnitDR,URUseLocDR,URPatientID,URPrice,URTotalFee,URServiceItemDR,URExType,URExID,URModelDR,URDoctorOrderID,UROperator,URPositiveFlag,URSampleNo,URExposureNum,URStartDate,URPatientSex,URPatientAge,URPatientName,UROtherInfo,URExecDeptDR,URStatFlag,URDeviceStatus,URAverageTime,URAdmissionType,UROrdDate,UROrdTime,URPreOccurDate,URPreOccurTime,URPreDate,URPreTime,URRegDate,URRegTime,URReportDate,URReportTime,URCheckPart,URDoctorID,URRequestDeptDR,URReportDoctorDR,URTWorkLoadNum,URHold1,URHold2,URHold3,URHold4,URHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBAUseRecord
	s (DataList,UREquipDR,UREquipName,URNo,URUseDate,URStartTime,UREndDate,UREndTime,URWorkLoadNum,URWorkLoadUnitDR,URUseLocDR,URPatientID,URPrice,URTotalFee,URServiceItemDR,URExType,URExID,URModelDR,URDoctorOrderID,UROperator,URPositiveFlag,URSampleNo,URExposureNum,URStartDate,URPatientSex,URPatientAge,URPatientName,UROtherInfo,URExecDeptDR,URStatFlag,URDeviceStatus,URAverageTime,URAdmissionType,UROrdDate,UROrdTime,URPreOccurDate,URPreOccurTime,URPreDate,URPreTime,URRegDate,URRegTime,URReportDate,URReportTime,URCheckPart,URDoctorID,URRequestDeptDR,URReportDoctorDR,URTWorkLoadNum,URHold1,URHold2,URHold3,URHold4,URHold5)=""
	quit
}

ClassMethod BAUseRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BAUseRecordExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BAUseRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BAUseRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
