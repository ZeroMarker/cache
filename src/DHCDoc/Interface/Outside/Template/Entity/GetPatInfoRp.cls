Class DHCDoc.Interface.Outside.Template.Entity.GetPatInfoRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

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

/// 医保标志（0：非医保，1：医保）
Property YBFlag As %String(TRUNCATE = 1);

/// 病人类型描述
Property PatType As %String(TRUNCATE = 1);

/// 联系电话号码
Property MobilePhone As %String(TRUNCATE = 1);

/// 卡号(仅APP用)
Property CardNo As %String(TRUNCATE = 1);

/// 卡类型(仅APP用)
Property CardTypeCode As %String(TRUNCATE = 1);

/// HIS病人主索引ID
Property PAPMIID As %String(TRUNCATE = 1);

}
