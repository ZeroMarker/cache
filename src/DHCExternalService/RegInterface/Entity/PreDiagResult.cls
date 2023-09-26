Class DHCExternalService.RegInterface.Entity.PreDiagResult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "PreDiagResult";

Parameter XMLIGNOREINVALIDTAG = 1;

Property OrganizationCode As %String(TRUNCATE = 1, XMLNAME = "OrganizationCode");

Property DepartmentCode As %String(TRUNCATE = 1, XMLNAME = "DepartmentCode");

Property DoctorCode As %String(TRUNCATE = 1, XMLNAME = "DoctorCode");

Property ChiefComplaint As %String(TRUNCATE = 1, XMLNAME = "ChiefComplaint");

Property PrimaryDiagnosis As %String(TRUNCATE = 1, XMLNAME = "PrimaryDiagnosis");

Property SecondaryDiagnosis As %String(TRUNCATE = 1, XMLNAME = "SecondaryDiagnosis");

Property OrganizationContact As %String(TRUNCATE = 1, XMLNAME = "OrganizationContact");

}
