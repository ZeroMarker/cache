Class web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "addr";

Property desc As %Library.String(MAXLEN = 100, XMLNAME = "desc", XMLPROJECTION = "ATTRIBUTE");

Property text As %Library.String(MAXLEN = 100, XMLNAME = "text");

Property houseNumber As %Library.String(MAXLEN = 100, XMLNAME = "houseNumber");

Property streetName As %Library.String(MAXLEN = 100, XMLNAME = "streetName");

Property township As %Library.String(MAXLEN = 100, XMLNAME = "township");

Property county As %Library.String(MAXLEN = 100, XMLNAME = "county");

Property city As %Library.String(MAXLEN = 100, XMLNAME = "city");

Property state As %Library.String(MAXLEN = 100, XMLNAME = "state");

Property postalCode As %Library.String(MAXLEN = 100, XMLNAME = "postalCode");

}
