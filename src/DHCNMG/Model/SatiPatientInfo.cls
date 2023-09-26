Class DHCNMG.Model.SatiPatientInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "JWIPAdmInfo";

/*
<JWIPAdmInfo>
	<PatientId>33006910</PatientId>
	<DischargeDateTime>2018-02-03 11:00:00</DischargeDateTime>
	<AdmissionDateTime>2018-01-29 08:30:01</AdmissionDateTime>
	<DeptDischarge>210402</DeptDischarge>
</JWIPAdmInfo>
*/
Property PatientId As %String;

Property DischargeDateTime As %String;

Property AdmissionDateTime As %String;

Property DeptDischarge As %String;

}
