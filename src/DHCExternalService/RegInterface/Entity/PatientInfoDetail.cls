Class DHCExternalService.RegInterface.Entity.PatientInfoDetail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property patientId As %String(TRUNCATE = 1);

Property patientName As %String(TRUNCATE = 1);

Property gender As %String(TRUNCATE = 1);

Property healthCardNo As %String(TRUNCATE = 1);

Property oldCardNo As %String(TRUNCATE = 1);

Property idCardNo As %String(TRUNCATE = 1);

Property oppatNo As %String(TRUNCATE = 1);

Property birthday As %String(TRUNCATE = 1);

Property medicareCardNo As %String(TRUNCATE = 1);

}
