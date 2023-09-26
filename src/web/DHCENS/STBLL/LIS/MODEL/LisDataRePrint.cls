Class web.DHCENS.STBLL.LIS.MODEL.LisDataRePrint Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Request";

Property Orders As web.DHCENS.STBLL.LIS.MODEL.LisDataRePrintOrder(XMLPROJECTION = "ELEMENT");

}
