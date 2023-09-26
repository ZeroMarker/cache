Class DHCExternalService.QryInterface.MSG.FEE.GetPatInfoRp Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(MAXLEN = 256, TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property PatName As %String(TRUNCATE = 1);

}
