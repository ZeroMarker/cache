Class web.DHCSTMService.HRP.Model.ReqItmInfo Extends XmlCommon
{

Parameter XMLNAME = "detail";

///  材料编码
Property invcode As %Library.String(MAXLEN = "", XMLNAME = "inv_code");

///  成本价码
Property rp As %Library.String(MAXLEN = "", XMLNAME = "rp");

///  数量
Property qty As %Library.String(MAXLEN = "", XMLNAME = "amount");

}
