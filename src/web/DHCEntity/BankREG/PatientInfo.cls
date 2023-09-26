Class web.DHCEntity.BankREG.PatientInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 住址
Property Address As %String(TRUNCATE = 1);

/// 工作单位
Property Company As %String(TRUNCATE = 1);

/// 联系人地址
Property ContactAddress As %String(TRUNCATE = 1);

/// 联系人姓名
Property ContactName As %String(TRUNCATE = 1);

/// 联系人电话
Property ContactTelNo As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 职业状况
Property EmployStatus As %String(TRUNCATE = 1);

/// 身份证号
Property IDCode As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

/// 是否医保病人
Property InsuStatus As %String(TRUNCATE = 1);

/// 名
Property LastName As %String(TRUNCATE = 1);

/// 信息校验
Property MAC As %String(TRUNCATE = 1);

/// 婚姻状况
Property MaritalStatus As %String(TRUNCATE = 1);

/// 手机号
Property Mobile As %String(TRUNCATE = 1);

/// 民族
Property Nation As %String(TRUNCATE = 1);

/// 职业
Property Occupation As %String(TRUNCATE = 1);

/// 与病人关系
Property Relation As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 联系电话
Property TelephoneNo As %String(TRUNCATE = 1);

/// 邮编
Property Zip As %String(TRUNCATE = 1);

/// 姓
Property FirstName As %String(TRUNCATE = 1, XMLNAME = "FirstName");

/// 银医卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 病人唯一主索引
Property PatientID As %String(TRUNCATE = 1, XMLNAME = "PatientID");

}
