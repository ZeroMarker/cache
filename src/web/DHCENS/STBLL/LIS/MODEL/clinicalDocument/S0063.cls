Class web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0063 Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "section";

Property code As %String(MAXLEN = 100, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

Property desc As %String(MAXLEN = 100, XMLNAME = "desc", XMLPROJECTION = "ATTRIBUTE");

Property text As %String(MAXLEN = 100, XMLNAME = "text");

Property E01 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc(XMLNAME = "E01");

Property E02 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc(XMLNAME = "E02");

Property E03 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc(XMLNAME = "E03");

Property E04 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc(XMLNAME = "E04");

Property E05 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc(XMLNAME = "E05");

Property E06 As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.desc(XMLNAME = "E06");

Property S0064 As list Of web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.S0064(XMLNAME = "section", XMLPROJECTION = "ELEMENT");

}
