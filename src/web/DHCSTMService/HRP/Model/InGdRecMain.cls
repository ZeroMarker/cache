Class web.DHCSTMService.HRP.Model.InGdRecMain Extends XmlCommon
{

Parameter XMLNAME = "InGdRecMain";

Property HospitalCode As %Library.String(MAXLEN = "", XMLNAME = "HospitalCode");

Property FromLocCode As %Library.String(MAXLEN = "", XMLNAME = "FromLocCode");

Property VenCode As %Library.String(MAXLEN = "", XMLNAME = "VenCode");

Property UserCode As %Library.String(MAXLEN = "", XMLNAME = "UserCode");

Property SpdIngrNo As %Library.String(MAXLEN = "", XMLNAME = "SpdIngrNo");

Property ToLocCode As %Library.String(MAXLEN = "", XMLNAME = "ToLocCode");

Property InGdRecDetail As list Of web.DHCSTMService.HRP.Model.InGdRecDetail(XMLNAME = "InGdRecDetail", XMLPROJECTION = "element");

}
