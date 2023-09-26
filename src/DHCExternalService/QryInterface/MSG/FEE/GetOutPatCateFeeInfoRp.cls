Class DHCExternalService.QryInterface.MSG.FEE.GetOutPatCateFeeInfoRp Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(MAXLEN = 256, TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property MedicareID As %String(TRUNCATE = 1);

Property PatName As %String(TRUNCATE = 1);

Property PatAge As %String(TRUNCATE = 1);

Property PatSex As %String(TRUNCATE = 1);

Property AdmReason As %String(TRUNCATE = 1);

Property Department As %String(TRUNCATE = 1);

Property AdmDate As %String(TRUNCATE = 1);

Property DisDate As %String(TRUNCATE = 1);

Property AdmInDays As %String(TRUNCATE = 1);

/// 总金额
Property TotalAmount As %String(TRUNCATE = 1);

/// 自负金额
Property PrivateAmount As %String(TRUNCATE = 1);

Property CateFeeS As list Of DHCExternalService.QryInterface.MSG.FEE.CateFee;

}
