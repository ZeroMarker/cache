Class dhcinterface.confirmRegistrationRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property PatientID As %String(TRUNCATE = 1);

Property RBASId As %String(TRUNCATE = 1);

Property TransactionId As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property ClientAddress As %String(TRUNCATE = 1);

Property Method As %String(TRUNCATE = 1);

}
