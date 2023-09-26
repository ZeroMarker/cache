Class web.DHCENS.STBLL.MEDADE.MODEL.SynPatInfusionRp Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Header As web.DHCENS.STBLL.MEDADE.MODEL.Header(XMLNAME = "Header");

Property Body As web.DHCENS.STBLL.MEDADE.MODEL.SynPatInfusionRtList(XMLNAME = "Body");

}
