Class DHCExternalService.RegInterface.Entity.ScheduleCancelDetail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME;

Parameter XMLIGNOREINVALIDTAG = 1;

Property hospitalId As %String(TRUNCATE = 1);

Property deptId As %String(TRUNCATE = 1);

Property doctorId As %String(TRUNCATE = 1);

Property replaceDoctorId As %String(TRUNCATE = 1);

Property replaceDoctorName As %String(TRUNCATE = 1);

Property regDate As %String(TRUNCATE = 1);

Property shiftCode As %String(TRUNCATE = 1);

Property reason As %String(TRUNCATE = 1);

}
