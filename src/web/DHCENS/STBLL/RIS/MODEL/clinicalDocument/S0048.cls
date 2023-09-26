Class web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.S0048 Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "section";

Property code As %String(MAXLEN = 100, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

Property desc As %String(MAXLEN = 100, XMLNAME = "desc", XMLPROJECTION = "ATTRIBUTE");

Property text As %String(MAXLEN = 100, XMLNAME = "text");

Property E07 As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc(XMLNAME = "E07");

Property E01 As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc(XMLNAME = "E01");

Property E02 As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.desc(XMLNAME = "E02");

}
