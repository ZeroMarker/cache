Class web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.patient Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "patient";

Property medicareNo As %Library.String(MAXLEN = 100, XMLNAME = "medicareNo");

Property admvisitNo As %Library.String(MAXLEN = 100, XMLNAME = "admvisitNo");

Property medRecordNo As %Library.String(MAXLEN = 100, XMLNAME = "medRecordNo");

Property healthCardNo As %Library.String(MAXLEN = 100, XMLNAME = "healthCardNo");

Property certificate As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.certificate;

Property addr As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.addr;

Property name As %Library.String(MAXLEN = 100, XMLNAME = "name");

Property telecom As %Library.String(MAXLEN = 100, XMLNAME = "telecom");

Property administrativeGender As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.administrativeGender;

Property maritalStatus As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.maritalStatus;

Property ethnicGroup As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.ethnicGroup;

Property age As web.DHCENS.STBLL.RIS.MODEL.clinicalDocument.age;

}
