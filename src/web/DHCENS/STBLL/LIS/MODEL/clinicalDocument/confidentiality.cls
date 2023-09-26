Class web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.confidentiality Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "documentHeader";

Property content As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.content(XMLPROJECTION = "CONTENT");

Property code As %Library.String(MAXLEN = 100, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

}
