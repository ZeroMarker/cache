Class web.DHCSTMService.HRP.Model.InGdRecDetail Extends XmlCommon
{

Parameter XMLNAME = "InGdRecDetail";

Property InciCode As %Library.String(MAXLEN = "", XMLNAME = "InciCode");

Property uomDesc As %Library.String(MAXLEN = "", XMLNAME = "uomDesc");

Property Qty As %Library.String(MAXLEN = "", XMLNAME = "Qty");

Property Rp As %Library.String(MAXLEN = "", XMLNAME = "Rp");

Property ManfCode As %Library.String(MAXLEN = "", XMLNAME = "ManfCode");

Property ExpDate As %Date(XMLNAME = "ExpDate");

Property BatNo As %Library.String(MAXLEN = "", XMLNAME = "BatNo");

/// 第三方入库子表ID,更新发票用
Property SpdDetailId As %Library.String(MAXLEN = "", XMLNAME = "SpdDetailId");

Property productionDate As %Library.String(MAXLEN = "", XMLNAME = "productionDate");

Property Invno As %Library.String(MAXLEN = "", XMLNAME = "Invno");

Property InvDate As %Date(XMLNAME = "InvDate");

Property BarCode As %Library.String(MAXLEN = "", XMLNAME = "BarCode");

}
