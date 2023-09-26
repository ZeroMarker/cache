Class web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.administrativeGender Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "administrativeGender";

Property content As web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.content(XMLPROJECTION = "CONTENT");

Property code As %Library.String(MAXLEN = 100, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

}
