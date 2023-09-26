Class DHCExternalService.RegInterface.Entity.SelfReg.RegFeeToINSURp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "RegFeeToINSURp";

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1, XMLNAME = "ResultCode");

Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ResultContent");

Property TransactionId As %String(TRUNCATE = 1, XMLNAME = "TransactionId");

}
