Class dhcinterface.PatRegisteredMsgRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

//挂号信息

Property TransactionId As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property ClientAddress As %String(TRUNCATE = 1);

}
