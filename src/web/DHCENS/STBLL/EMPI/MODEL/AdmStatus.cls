/// 就诊状态信息
Class web.DHCENS.STBLL.EMPI.MODEL.AdmStatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "OpPAAdm";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAADMVisitNumber");

/// 就诊科室代码
Property PAADMDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMOPDeptCode");

/// 就诊科室描述
Property PAADMDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "PAADMOPDeptDesc");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新人描述
Property UpdateUserDesc As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserDesc");

/// 最后更新日期
Property UpdateDate As %Library.String(XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(XMLNAME = "UpdateTime");

}
