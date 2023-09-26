Class web.DHCENS.STBLL.Method.Model.ReportRequest Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Request";

Property header As web.DHCENS.STBLL.Method.Model.Header(XMLNAME = "Header");

Property Respbody As web.DHCENS.STBLL.Method.Model.Respbody(XMLNAME = "Body");

}
