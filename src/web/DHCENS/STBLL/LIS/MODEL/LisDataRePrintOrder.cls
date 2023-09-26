Class web.DHCENS.STBLL.LIS.MODEL.LisDataRePrintOrder Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Orders";

Property OrdId As list Of %String(XMLPROJECTION = "ELEMENT");

}
