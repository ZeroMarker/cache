Class web.DHCENS.STBLL.EMPI.MODEL.PAAdm Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "PA_Adm";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 就诊号码
Property PAADMVisitNumber As %Library.Integer(XMLNAME = "PAADM_VisitNumber");

/// 患者主索引
Property PAADMPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PAADM_PatientID");

/// 就诊类别代码
Property PAADMEncounterType As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_EncounterType");

/// 就诊状态代码
Property PAADMStatus As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_Status");

/// 接诊医生
Property PAADMAttendDocCode As %Library.String(MAXLEN = 10, XMLNAME = "PAADM_AttendDocCode");

/// 入院医生
Property PAADMAdmitDocCode As %Library.String(MAXLEN = 10, XMLNAME = "PAADM_AdmitDocCode");

/// 入院日期
Property PAADMStartDate As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_StartDate");

/// 入院时间
Property PAADMStartTime As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_StartTime");

/// 入院科室代码
Property PAADMAdmDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADM_AdmDeptCode");

/// 入院原因
Property PAADMAdmitReason As %Library.String(MAXLEN = 100, XMLNAME = "PAADM_AdmitReason");

/// 当前科室代码
Property PAADMCurDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADM_CurDeptCode");

/// 当前病区代码
Property PAADMCurwardCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADM_CurwardCode");

/// 当前房间代码
Property PAADMCurRoomCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADM_CurRoomCode");

/// 当前床号
Property PAADMCurBedNo As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_CurBedNo");

/// 出院日期
Property PAADMEndDate As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_EndDate");

/// 出院时间
Property PAADMEndTime As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_EndTime");

/// 出院科室代码
Property PAADMDisDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADM_DisDeptCode");

/// 出院情况代码
Property PAADMDisStatusCode As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_DisStatusCode");

/// 最后更新日期
Property PAADMUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_UpdateDate");

/// 最后更新时间
Property PAADMUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "PAADM_UpdateTime");

/// 最后更新人编码
Property PAADMUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "PAADM_UpdateUserCode");

/// 医院编码
Property PAADMHosCode As %Library.String(MAXLEN = 10, XMLNAME = "PAADM_HosCode");

}
