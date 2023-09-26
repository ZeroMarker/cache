Class web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.code Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "code";

Property code As %Library.String(MAXLEN = 100, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

Property content As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.content(XMLPROJECTION = "CONTENT");

}
