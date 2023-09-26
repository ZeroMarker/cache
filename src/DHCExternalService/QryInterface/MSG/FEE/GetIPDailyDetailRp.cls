Class DHCExternalService.QryInterface.MSG.FEE.GetIPDailyDetailRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(MAXLEN = 256, TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property PatName As %String(TRUNCATE = 1);

Property PatAge As %String(TRUNCATE = 1);

Property PatSex As %String(TRUNCATE = 1);

Property AdmReason As %String(TRUNCATE = 1);

Property Department As %String(TRUNCATE = 1);

Property Ward As %String(TRUNCATE = 1);

Property BedNO As %String(TRUNCATE = 1);

Property PatFee As %String(TRUNCATE = 1);

Property Deposit As %String(TRUNCATE = 1);

Property VisitStatus As %String(TRUNCATE = 1);

Property PrintFlag As %String(TRUNCATE = 1);

/// zhho打印次数
Property PrintTimes As %String(TRUNCATE = 1);

Property TarItemList As list Of DHCExternalService.QryInterface.MSG.FEE.TarItemDetail;

}
