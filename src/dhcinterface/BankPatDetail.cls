/// 银医卡请求消息--病人信息集合定义
Class dhcinterface.BankPatDetail Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 病人唯一主索引
Property PatientID As %String(TRUNCATE = 1);

/// 银医卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 住址
Property Address As %String(MAXLEN = 32768, TRUNCATE = 1);

/// 邮编
Property Zip As %String(TRUNCATE = 1);

/// 联系电话
Property TelephoneNo As %String(TRUNCATE = 1);

/// 手机号
Property Mobile As %String(TRUNCATE = 1);

/// 旧银医卡号
Property OldPatientCard As %String(TRUNCATE = 1);

/// 工作单位 
Property Workplace As %String(TRUNCATE = 1);

/// 病人类型
Property PatType As %String(TRUNCATE = 1);

}
