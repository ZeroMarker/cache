Class web.DHCENS.STBLL.ORDER.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property oEOrds As web.DHCENS.STBLL.ORDER.MODEL.OEOrder(XMLNAME = "AddOrdersRt");

Property oEOrdStatus As web.DHCENS.STBLL.ORDER.MODEL.OEOrder(XMLNAME = "UpdateOrdersRt");

Property UpdateOrdersRt As web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatusList(XMLNAME = "UpdateOrdersRt");

}
