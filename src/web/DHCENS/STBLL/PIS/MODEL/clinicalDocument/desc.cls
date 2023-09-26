Class web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.desc Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "desc";

Property content As web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.content(XMLPROJECTION = "CONTENT");

Property desc As %Library.String(MAXLEN = 100, XMLNAME = "desc", XMLPROJECTION = "ATTRIBUTE");

}
