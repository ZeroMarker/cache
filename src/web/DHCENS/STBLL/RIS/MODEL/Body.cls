Class web.DHCENS.STBLL.RIS.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property PATPatientInfo As web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew(XMLNAME = "PATPatientInfo");

Property PATAdmInfo As web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo(XMLNAME = "PATAdmInfo");

Property AppBills As list Of web.DHCENS.STBLL.RIS.MODEL.RisAppInfo(XMLNAME = "AddRisAppBillRt", XMLPROJECTION = "ELEMENT");

Property AppBillsNew As list Of web.DHCENS.STBLL.RIS.MODEL.RisAppInfoNew(XMLNAME = "AddRisAppBillRt", XMLPROJECTION = "ELEMENT");

Property CriticalValueList As web.DHCENS.STBLL.RIS.MODEL.ReCriticalValuesRt(XMLNAME = "AddReCriticalValuesRt");

Property RisBookRt As web.DHCENS.STBLL.RIS.MODEL.SendRisBookInfo(XMLNAME = "RisBookRt");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新人描述
Property UpdateUserDesc As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserDesc");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "UpdateTime");

}
