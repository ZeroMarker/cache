Class web.DHCENS.STBLL.ORDER.MODEL.Respbody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property ResultCode As %Library.String(XMLNAME = "ResultCode");

Property ResultContent As %Library.String(XMLNAME = "ResultContent");

Property AddOrdersRp As web.DHCENS.STBLL.ORDER.MODEL.RespOrderList(XMLNAME = "AdditionalOrdersRp");

}
