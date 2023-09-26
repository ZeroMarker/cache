Class web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.documentHeader Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "documentHeader";

Property realmCode As %Library.String(MAXLEN = 100, XMLNAME = "realmCode");

Property typeId As %Library.String(MAXLEN = 100, XMLNAME = "typeId");

Property template As %Library.String(MAXLEN = 100, XMLNAME = "template");

Property id As %Library.String(MAXLEN = 100, XMLNAME = "id");

Property title As %Library.String(MAXLEN = 100, XMLNAME = "title");

Property effectiveTime As %Library.String(MAXLEN = 100, XMLNAME = "effectiveTime");

Property confidentiality As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.confidentiality;

Property versionNumber As %Library.String(MAXLEN = 100, XMLNAME = "versionNumber");

Property author As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.author;

Property custodian As %Library.String(MAXLEN = 100, XMLNAME = "custodian");

Property patient As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.patient;

Property participant As web.DHCENS.STBLL.LIS.MODEL.clinicalDocument.participant;

}
