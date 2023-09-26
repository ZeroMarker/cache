/// 门诊患者就诊信息
Class web.DHCENS.STBLL.EMPI.MODEL.OpPAAdm Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "OpPAAdm";

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

/// 就诊科室代码
Property PAADMOPDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMOPDeptCode");

/// 就诊科室描述
Property PAADMOPDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMOPDeptDesc");

/// 就诊医生代码
Property PAADMOPDocCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMOPDocCode");

/// 就诊医生描述
Property PAADMOPDocDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMOPDocDesc");

/// 就诊日期
Property PAADMOPTime As %Library.String(MAXLEN = 20, XMLNAME = "PAADMOPTime");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新人描述
Property UpdateUserDesc As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserDesc");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "UpdateTime");

/// 就诊序号
Property PAADMOPNo As %Library.String(MAXLEN = 3, XMLNAME = "PAADMOPNo");

/// 诊室
Property PAADMOPRoomCode As %Library.String(MAXLEN = 20, XMLNAME = "PAADMOPRoomCode");

/// 就诊时段
Property PAADMOPTimeRange As %Library.String(MAXLEN = 20, XMLNAME = "PAADMOPTimeRange");

/// 叫号状态
Property PAADMOPQueueNumberStatus As %Library.String(MAXLEN = 10, XMLNAME = "PAADMOPQueueNumberStatus");

/// 费别代码
Property FeeTypeCode As %Library.String(MAXLEN = 5, XMLNAME = "FeeTypeCode");

/// 费别描述
Property FeeTypeDesc As %Library.String(MAXLEN = 10, XMLNAME = "FeeTypeDesc");

/// 就诊科室简称
Property PAADMOOPShortDeptDesc As %Library.String(MAXLEN = 10, XMLNAME = "PAADMOOPShortDeptDesc");

}
