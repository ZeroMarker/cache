/// 用于传输卡状态更改的信息
Class DHCExternalService.BillInterface.DHCEntity.CardStatusChange Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// New校验码为空时，按病人ID计算
Property SecrityNo As %String(TRUNCATE = 1);

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 卡号行号
Property CardID As %String(TRUNCATE = 1);

/// 登记号
Property RegNo As %String(TRUNCATE = 1);

/// 身份证号
Property IDCardNo As %String(TRUNCATE = 1);

/// 证件类型
Property CredType As %String(TRUNCATE = 1);

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 卡类型
Property CardTypeDefine As %String(TRUNCATE = 1);

/// 卡有效标志
Property ActiveFlag As %String(TRUNCATE = 1);

/// 卡有效状态
Property Flag As %String(TRUNCATE = 1);

/// 新卡卡号
Property ExchangeCardNo As %String(TRUNCATE = 1);

/// 开始日期
Property DateFrom As %String(TRUNCATE = 1);

/// 结束日期
Property DateTo As %String(TRUNCATE = 1);

/// 补卡人姓名
Property RLName As %String(TRUNCATE = 1);

/// 证件号码
Property RLCredNo As %String(TRUNCATE = 1);

/// 证件类型
Property RLCredType As %String(TRUNCATE = 1);

/// 证件类型ID
Property RLCredTypeID As %String(TRUNCATE = 1);

/// 地址
Property RLAddress As %String(TRUNCATE = 1);

/// 联系电话
Property RLPhoneNo As %String(TRUNCATE = 1);

/// 单据号码
Property RLProof As %String(TRUNCATE = 1);

/// 备注
Property RLRemark As %String(TRUNCATE = 1);

/// 用户
Property UserDR As %String(TRUNCATE = 1);

/// 电脑IP地址
Property ComputerIP As %String(TRUNCATE = 1);

}
