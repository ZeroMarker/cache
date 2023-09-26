Class DHCExternalService.CardInterface.Entity.UpdatePatMobileRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLSEQUENCE = 0;

Property TradeCode As %String(TRUNCATE = 1);

/// 患者唯一编号
Property PatientID As %String(TRUNCATE = 1);

Property BankCode As %String(TRUNCATE = 1);

/// 卡类型
Property CardTypeCode As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 联系电话
Property TelephoneNo As %String(TRUNCATE = 1);

/// /证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// /患者姓名
Property PatName As %String(TRUNCATE = 1);

Property TransactionId As %String(TRUNCATE = 1);

Property ExtUserID As %String(TRUNCATE = 1);

/// 联系人姓名(联系人)
Property ContactName As %String(TRUNCATE = 1);

/// 联系人地址(联系地址)
Property ContactAddress As %String(TRUNCATE = 1);

/// 与病人关系(关系)
Property Relation As %String(TRUNCATE = 1);

/// 联系人电话(联系电话)
Property ContactTelNo As %String(TRUNCATE = 1);

Property ContactIDNo As %String(TRUNCATE = 1);

Property ContactIDType As %String(TRUNCATE = 1);

/// 病人类型
Property PatType As %String(TRUNCATE = 1);

/// /性别
Property PatSex As %String(TRUNCATE = 1);

/// /住址
Property Address As %String(TRUNCATE = 1);

/// 出生日期
Property PatBirth As %String(TRUNCATE = 1);

/// 院区Id
Property HospitalId As %String(TRUNCATE = 1);

}
