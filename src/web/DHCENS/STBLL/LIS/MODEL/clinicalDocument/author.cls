Class web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.author Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "documentHeader";

Property content As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.content(XMLPROJECTION = "CONTENT");

Property id As %Library.String(MAXLEN = 100, XMLNAME = "id", XMLPROJECTION = "ATTRIBUTE");

}
