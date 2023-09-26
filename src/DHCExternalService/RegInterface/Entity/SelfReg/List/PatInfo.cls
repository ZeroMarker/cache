Class DHCExternalService.RegInterface.Entity.SelfReg.List.PatInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 病人姓名
Property PatientName As %String(TRUNCATE = 1);

/// 性别代码
Property Sex As %String(TRUNCATE = 1);

/// 性别
Property SexCode As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 联系电话
Property TelephoneNo As %String(TRUNCATE = 1);

/// 移动电话
Property Mobile As %String(TRUNCATE = 1);

/// 病案号
Property DocumentID As %String(TRUNCATE = 1);

/// 家庭住址
Property Address As %String(TRUNCATE = 1);

/// 证件类型（代码）
Property IDTypeCode As %String(TRUNCATE = 1);

/// 证件类型（描述）
Property IDTypeDesc As %String(TRUNCATE = 1);

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 医保卡号
Property InsureCardNo As %String(TRUNCATE = 1);

/// 账户信息
Property AccInfo As %String(TRUNCATE = 1);

/// 账户信息余额
Property AccInfoBalance As %String(TRUNCATE = 1);

/// 账户信息ID
Property AccInfoNo As %String(TRUNCATE = 1);

/// 卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 医保标志
Property YBFlag As %String(TRUNCATE = 1);

/// 病人类型描述
Property PatType As %String(TRUNCATE = 1);

/// 病人类型代码
Property PatTypeCode As %String(TRUNCATE = 1);

}
