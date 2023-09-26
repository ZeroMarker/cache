Import SQLUser

Class web.DHCANShift Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Query FindANShift(opaId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   ANS_Type As ShiftType,
	   ANS_Consciousness As Consciousness,
	   ANS_RespRate As RespRate,
	   ANS_RespMode As RespMode,
	   ANS_Respiration As Respiration,
	   ANS_HeartRate As HeartRate,
	   ANS_HeartRhythm As HeartRhythm,
	   ANS_BPSystolic As Systolic,
	   ANS_BPDiastolic As Diastolic,
	   ANS_OxygenSaturation As OxygenSaturation,
	   ANS_Temperature As Temperature,
	   ANS_ExtremityMove As ExtremityMove,
	   ANS_Complication As Complication,
	   ANS_PatTransferMode As PatTransferMode,
	   ANS_ShiftPlace As ShiftPlace,
	   ANS_ShiftCtcp_Dr As ShiftDoctorId,
	   ANS_ReliefCtcp_Dr As ReliefDoctorId,
	   ANS_Date As ShiftDate,
	   ANS_Time As ShiftTime,
	   ANS_CatheterType As CatheterType,
	   ANS_Check As ShiftCheck,
	   ANS_IntravenInfusion As IntravenInfusion,
	   ANS_IntravenPuncSite As IntravenPuncSite,
	   ANS_DeepIntravenPunc As DeepIntravenPunc,
	   ANS_BodySurfIdentity As BodySurfIdentity,
	   ANS_VadeMecum As VadeMecum,
	   ANS_VadeMecumOther As VadeMecumOther,
	   ANS_Catheter As Catheter,
	   ANS_CathOther As CathOther,
	   ANS_MonitorTech As MonitorTech,
	   ANS_MonitorTechOther As MonitorTechOther,
	   ANS_Note As Note,
	   ANS_Constitution As Constitution,
	   ANS_BloodVessel As BloodVessel,
	   ANS_Mentation As Mentation,
	   ANS_Skin As Skin,
	   ANS_BloodTranfused As BloodTranfused,
	   ANS_BloodTranfusedOther As BloodTranfusedOther,
	   ANS_CareProvType As CareProvType
	   FROM DHC_AN_Shift
	   Where ANS_Parref=:opaId
}

/// 保存麻醉交接班记录
ClassMethod SaveANShift(opaId As %String, para As %String) As %String
{
	q:(opaId="")!(para="") "数据参数不全"
	s shiftId=$p(para,$c(3),1)
	s anShift=""
	i (##class(User.DHCANShift).%ExistsId(shiftId)) s anShift=##class(User.DHCANShift).%OpenId(shiftId)
	e  s anShift=##class(User.DHCANShift).%New(opaId)
	s anShift.ANSType=$p(para,$c(3),2)
	s anShift.ANSConsciousness=$p(para,$c(3),3)
	s anShift.ANSRespRate=+$p(para,$c(3),4)
	s anShift.ANSRespMode=$p(para,$c(3),5)
	s anShift.ANSRespiration=+$p(para,$c(3),6)
	s anShift.ANSHeartRate=+$p(para,$c(3),7)
	s anShift.ANSHeartRhythm=$p(para,$c(3),8)
	s anShift.ANSBPSystolic=+$p(para,$c(3),9)
	s anShift.ANSBPDiastolic=+$p(para,$c(3),10)
	s anShift.ANSOxygenSaturation=+$p(para,$c(3),11)
	s anShift.ANSTemperature=+$p(para,$c(3),12)
	s anShift.ANSExtremityMove=$p(para,$c(3),13)
	s anShift.ANSComplication=$p(para,$c(3),14)
	s anShift.ANSPatTransferMode=$p(para,$c(3),15)
	s anShift.ANSShiftPlace=$p(para,$c(3),16)
	s anShift.ANSShiftCtcpDr=$p(para,$c(3),17)
	s anShift.ANSReliefCtcpDr=$p(para,$c(3),18)
	s shiftDate=$p(para,$c(3),19)
	i (shiftDate'="") s anShift.ANSDate=##class(DHCANOPCom).ConvertToDateH(shiftDate)
	s shiftTime=$p(para,$c(3),20)
	i (shiftTime'="") s anShift.ANSTime=$zth(shiftTime,3)
	s anShift.ANSCatheterType=$p(para,$c(3),21)
	s anShift.ANSCheck=$p(para,$c(3),22)
	s anShift.ANSIntravenInfusion=$p(para,$c(3),23)
	s anShift.ANSIntravenPuncSite=$p(para,$c(3),24)
	s anShift.ANSDeepIntravenPunc=$p(para,$c(3),25)
	s anShift.ANSBodySurfIdentity=$p(para,$c(3),26)
	s anShift.ANSVadeMecum=$p(para,$c(3),27)
	s anShift.ANSVadeMecumOther=$p(para,$c(3),28)
	s anShift.ANSCatheter=$p(para,$c(3),29)
	s anShift.ANSCathOther=$p(para,$c(3),30)
	s anShift.ANSMonitorTech=$p(para,$c(3),31)
	s anShift.ANSMonitorTechOther=$p(para,$c(3),32)
	s anShift.ANSNote=$p(para,$c(3),33)
	s anShift.ANSConstitution=$p(para,$c(3),34)
	s anShift.ANSBloodVessel=$p(para,$c(3),35)
	s anShift.ANSMentation=$p(para,$c(3),36)
	s anShift.ANSSkin=$p(para,$c(3),37)
	s anShift.ANSBloodTranfused=$p(para,$c(3),38)
	s anShift.ANSBloodTranfusedOther=$p(para,$c(3),39)
	s anShift.ANSCareProvType=$p(para,$c(3),40)
	s anShift.ANSParref=##class(User.DHCANOPArrange).%OpenId(opaId)
	
	d anShift.%Save()
	
	q anShift.%Id()
}

ClassMethod DeleteShiftRecord(shiftRecordId As %String) As %String
{
	&sql(delete from dhc_an_shift where %ID=:shiftRecordId)
	
	q SQLCODE
}

}
