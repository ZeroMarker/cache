Class DHCExternalService.QryInterface.MSG.FEE.IPInvInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "InvInfo";

Parameter XMLIGNORENULL = 1;

Property StartDate As %String(TRUNCATE = 1);

Property EndDate As %String(TRUNCATE = 1);

Property BillNo As %String(TRUNCATE = 1);

Property InvNo As %String(TRUNCATE = 1);

Property Deposit As %String(TRUNCATE = 1);

Property TotalAmount As %String(TRUNCATE = 1);

Property ChargeFlag As %String(TRUNCATE = 1);

Property AdmLoc As %String(TRUNCATE = 1);

}
