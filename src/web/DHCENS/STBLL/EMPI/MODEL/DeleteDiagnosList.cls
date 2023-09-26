Class web.DHCENS.STBLL.EMPI.MODEL.DeleteDiagnosList Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "DeleteDiagnosisRt";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 病人ID
Property PATPatientID As %Library.Integer(XMLNAME = "PATPatientID");

/// 就诊号
Property PAADMVisitNumber As %Library.Integer(XMLNAME = "PAADMVisitNumber");

/// 诊断信息
Property PAADMDiagnoses As list Of web.DHCENS.STBLL.EMPI.MODEL.PAADMDiagnoses(XMLNAME = "PAADMDiagnoses");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserCode");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 10, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 10, XMLNAME = "UpdateTime");

}
