Class DHCExternalService.RegInterface.Entity.PatientPayDetail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property patientId As %String(TRUNCATE = 1);

Property patientName As %String(TRUNCATE = 1);

Property doctorId As %String(TRUNCATE = 1);

Property healthCardNo As %String(TRUNCATE = 1);

Property doctorName As %String(TRUNCATE = 1);

Property deptId As %String(TRUNCATE = 1);

Property deptName As %String(TRUNCATE = 1);

Property clinicSeq As %String(TRUNCATE = 1);

Property clinicTime As %String(TRUNCATE = 1);

Property hospitalId As %String(TRUNCATE = 1);

}
