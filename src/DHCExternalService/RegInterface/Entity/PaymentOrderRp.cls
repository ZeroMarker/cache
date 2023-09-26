Class DHCExternalService.RegInterface.Entity.PaymentOrderRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLNAME = "PaymentOrderRp";

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1, XMLNAME = "ResultCode");

Property ResultContent As %String(TRUNCATE = 1, XMLNAME = "ResultContent");

Property SwqCode As %String(TRUNCATE = 1, XMLNAME = "SwqCode");

Property AdmitRange As %String(TRUNCATE = 1, XMLNAME = "AdmitRange");

Property RegFee As %String(TRUNCATE = 1, XMLNAME = "RegFee");

Property AdmitAddress As %String(TRUNCATE = 1, XMLNAME = "AdmitAddress");

Property OrderContent As %String(TRUNCATE = 1, XMLNAME = "OrderContent");

Property TransactionId As %String(TRUNCATE = 1, XMLNAME = "TransactionId");

}
