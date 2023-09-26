Class web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.maritalStatus Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "maritalStatus";

Property content As web.DHCENS.STBLL.EMR.MODEL.clinicalDocument.content(XMLPROJECTION = "CONTENT");

Property code As %Library.String(MAXLEN = 100, XMLNAME = "code", XMLPROJECTION = "ATTRIBUTE");

}
