Class web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.participant Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "participant";

Property code As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.code;

Property addr As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr;

Property telecom As %Library.String(MAXLEN = 100, XMLNAME = "telecom");

Property name As %Library.String(MAXLEN = 100, XMLNAME = "name");

}
