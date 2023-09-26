Class web.DHCENS.STBLL.DRUG.MODEL.Response Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Response";

Property header As web.DHCENS.STBLL.DRUG.MODEL.Header(XMLNAME = "Header");

Property RespInventory As web.DHCENS.STBLL.DRUG.MODEL.GetInventory(XMLNAME = "Body");

}
