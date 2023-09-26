Class web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.age Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "age";

Property unit As %Library.String(MAXLEN = 100, XMLNAME = "unit", XMLPROJECTION = "ATTRIBUTE");

Property value As %Library.String(MAXLEN = 100, XMLNAME = "value", XMLPROJECTION = "ATTRIBUTE");

}
