/// 就诊状态信息
Class web.DHCENS.STBLL.EMPI.MODEL.DisCharge Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "OpPAAdm";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAADMVisitNumber");

/// 出院日期
Property PAADMEndDate As %Library.String(MAXLEN = 5, XMLNAME = "PAADMEndDate");

/// 出院时间
Property PAADMEndTime As %Library.String(MAXLEN = 10, XMLNAME = "PAADMEndTime");

/// 出院科室代码
Property PAADMDisDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMDisDeptCode");

/// 出院情况代码
Property PAADMDisStatusCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMDisStatusCode");

/// 出院病区代码
Property PAADMDisWardCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMDisWardCode");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新人描述
Property UpdateUserDesc As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserDesc");

/// 最后更新日期
Property UpdateDate As %Library.String(XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(XMLNAME = "UpdateTime");

}
