Class DHCExternalService.CardInterface.Entity.FindCardFromIDNoRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

/// 患者唯一编号
Property PatientID As %String(TRUNCATE = 1);

/// 卡类型
Property CardTypeCode As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// /证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// /患者姓名
Property PatName As %String(TRUNCATE = 1);

Property ExtUserID As %String(TRUNCATE = 1);

Property CardStatus As %String(TRUNCATE = 1);

}
