Class web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.certificate Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "certificate";

Property name As web.DHCENS.STBLL.PIS.MODEL.clinicalDocument.name;

Property value As %Library.String(MAXLEN = 100, XMLNAME = "value");

}
