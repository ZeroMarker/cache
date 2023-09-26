Class web.DHCENS.STBLL.RIS.MODEL.ResponseInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Response";

Property header As web.DHCENS.STBLL.RIS.MODEL.ResponseHeader(XMLNAME = "Header");

Property Respbody As web.DHCENS.STBLL.RIS.MODEL.ResponseBody(XMLNAME = "Body");

}
