Class web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.participant Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "participant";

Property code As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.code;

Property addr As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.addr;

Property name As %Library.String(MAXLEN = 100, XMLNAME = "name");

Property telecom As %Library.String(MAXLEN = 100, XMLNAME = "telecom");

}
