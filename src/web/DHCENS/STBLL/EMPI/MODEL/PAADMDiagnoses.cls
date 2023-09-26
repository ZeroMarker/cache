/// 诊断信息
Class web.DHCENS.STBLL.EMPI.MODEL.PAADMDiagnoses Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PAADMDiagnoses";

/// 诊断id
Property PADDiagId As %Library.String(MAXLEN = 10, XMLNAME = "PADDiagId");

}
