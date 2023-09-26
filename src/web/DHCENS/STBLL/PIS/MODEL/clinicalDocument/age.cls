Class web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.age Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "age";

Property value As %Library.String(MAXLEN = 100, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

Property unit As %Library.String(MAXLEN = 100, XMLNAME = "unit", XMLPROJECTION = "ATTRIBUTE");

}
