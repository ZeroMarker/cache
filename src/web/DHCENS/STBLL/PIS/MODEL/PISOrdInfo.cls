Class web.DHCENS.STBLL.PIS.MODEL.PISOrdInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PISOrdListInfo";

Property PISOrdInfo As list Of web.DHCENS.STBLL.PIS.MODEL.PISSpecInfo(XMLNAME = "PISOrdInfo", XMLPROJECTION = "ELEMENT");

}
