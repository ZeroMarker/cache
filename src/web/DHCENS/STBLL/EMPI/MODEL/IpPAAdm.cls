/// 住院患者就诊信息
Class web.DHCENS.STBLL.EMPI.MODEL.IpPAAdm Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "IpPAAdm";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAADMVisitNumber");

/// 就诊类型代码
Property PAADMEncounterTypeCode As %Library.String(MAXLEN = 5, XMLNAME = "PAADMEncounterTypeCode");

/// 就诊类型描述
Property PAADMEncounterTypeDesc As %Library.String(MAXLEN = 10, XMLNAME = "PAADMEncounterTypeDesc");

/// 入院医生代码
Property PAADMAdmitDocCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmitDocCode");

/// 入院医生描述
Property PAADMAdmitDocDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmitDocDesc");

/// 入院日期
Property PAADMStartDate As %Library.String(MAXLEN = 20, XMLNAME = "PAADMStartDate");

/// 入院时间
Property PAADMStartTime As %Library.String(MAXLEN = 20, XMLNAME = "PAADMStartTime");

/// 入院科室代码
Property PAADMAdmDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmDeptCode");

/// 入院科室描述
Property PAADMAdmDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmDeptDesc");

/// 入院病区代码
Property PAADMAdmWardCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmWardCode");

/// 入院病区描述
Property PAADMAdmWardDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMAdmWardDesc");

/// 病床号
Property PAADMCurBedNo As %Library.String(MAXLEN = 20, XMLNAME = "PAADMCurBedNo");

/// 诊断信息
Property PAADMDiagnose As list Of web.DHCENS.STBLL.EMPI.MODEL.PADiagnose(XMLNAME = "PAADMDiagnoseList");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新人描述
Property UpdateUserDesc As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserDesc");

/// 最后更新日期
Property UpdateDate As %Library.String(XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(XMLNAME = "UpdateTime");

/// 费别代码
Property FeeTypeCode As %Library.String(MAXLEN = 5, XMLNAME = "FeeTypeCode");

/// 费别描述
Property FeeTypeDesc As %Library.String(MAXLEN = 10, XMLNAME = "FeeTypeDesc");

/// 住院次数
Property PAADMVisitTimes As %Library.String(MAXLEN = 10, XMLNAME = "PAADMVisitTimes");

}
