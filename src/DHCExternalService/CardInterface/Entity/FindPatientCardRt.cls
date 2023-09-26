/// 就诊卡查询
Class DHCExternalService.CardInterface.Entity.FindPatientCardRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

Property IDType As %String(TRUNCATE = 1);

Property IDNo As %String(TRUNCATE = 1);

Property PatientName As %String(TRUNCATE = 1);

Property CardTypeCode As %String(TRUNCATE = 1);

Property PatientCard As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property TerminalID As %String(TRUNCATE = 1);

Property MobilePhone As %String(TRUNCATE = 1);

Property PatientSex As %String(TRUNCATE = 1);

Property PatientDob As %String(TRUNCATE = 1);

/// 1：根据患者信息进行查找  other：根据卡号卡类型进行查找
Property SearchFlag As %String(TRUNCATE = 1);

Property HospitalId As %String(TRUNCATE = 1);

}
