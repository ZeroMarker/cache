Class web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.author Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "documentHeader";

Property content As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.content(XMLPROJECTION = "CONTENT");

Property id As %Library.String(MAXLEN = 100, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

}
