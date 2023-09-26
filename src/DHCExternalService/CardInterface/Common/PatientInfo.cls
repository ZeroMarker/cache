Class DHCExternalService.CardInterface.Common.PatientInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 病人ID(登记号)
Property PatientID As %String(TRUNCATE = 1);

/// 病人表RowID
Property PapmiRowID As %String(TRUNCATE = 1);

/// 姓名
Property PatientName As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 病人类型
Property PatType As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 手机号(个人电话)
Property Mobile As %String(TRUNCATE = 1);

/// 医保号
Property PatYBCode As %String(TRUNCATE = 1);

/// 门诊病案号
Property OPMRID As %String(TRUNCATE = 1);

/// 住院病案号
Property IPMRID As %String(TRUNCATE = 1);

}
