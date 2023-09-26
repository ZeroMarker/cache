Class DHCExternalService.RegInterface.Entity.SelfReg.SavePatientCardRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1, XMLNAME = "TradeCode");

/// TerminalID终端代码
Property TerminalID As %String(TRUNCATE = 1, XMLNAME = "TerminalID");

/// ExtUserID操作员代码
Property UserID As %String(TRUNCATE = 1, XMLNAME = "UserID");

/// 就诊卡号
Property PatientCard As %String(TRUNCATE = 1, XMLNAME = "PatientCard");

/// 就诊卡校验码
Property SecurityNo As %String(TRUNCATE = 1, XMLNAME = "SecurityNo");

/// 芯片序列号
Property ChipSerialNo As %String(TRUNCATE = 1);

/// 银行业务流水号
Property TransactionId As %String(TRUNCATE = 1, XMLNAME = "TransactionId");

/// 费用类别
Property PatientType As %String(TRUNCATE = 1);

/// 患者姓名
Property PatientName As %String(TRUNCATE = 1, XMLNAME = "PatientName");

/// 性别
Property Sex As %String(TRUNCATE = 1, XMLNAME = "Sex");

/// 出生日期
Property DOB As %String(TRUNCATE = 1, XMLNAME = "DOB");

/// 婚姻状况
Property MaritalStatus As %String(TRUNCATE = 1);

/// 民族
Property Nation As %String(TRUNCATE = 1);

/// 职业
Property Occupation As %String(TRUNCATE = 1);

/// 国籍
Property Nationality As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1, XMLNAME = "IDType");

/// 证件号
Property IDNo As %String(TRUNCATE = 1, XMLNAME = "IDNo");

/// 家庭住址
Property Address As %String(TRUNCATE = 1);

/// 家庭所在地
Property AddressLocus As %String(TRUNCATE = 1);

/// 邮编
Property Zip As %String(TRUNCATE = 1);

/// 工作单位
Property Company As %String(TRUNCATE = 1);

/// 单位所在地
Property CompanyAddr As %String(TRUNCATE = 1);

/// 单位邮编
Property CompanyZip As %String(TRUNCATE = 1);

/// 单位电话
Property CompanyTelNo As %String(TRUNCATE = 1);

/// 联系电话(家庭电话)
Property TelephoneNo As %String(TRUNCATE = 1);

/// 手机号(个人电话)
Property Mobile As %String(TRUNCATE = 1, XMLNAME = "Mobile");

/// 联系人姓名(联系人)
Property ContactName As %String(TRUNCATE = 1, XMLNAME = "ContactName");

/// 联系人地址(联系地址)
Property ContactAddress As %String(TRUNCATE = 1);

/// 与病人关系(关系)
Property Relation As %String(TRUNCATE = 1);

/// 联系人电话(联系电话)
Property ContactTelNo As %String(TRUNCATE = 1, XMLNAME = "ContactTelNo");

/// 社保标志(Y=社保患者，N=非社保患者)
Property InsureCardFlag As %String(TRUNCATE = 1, XMLNAME = "InsureCardFlag");

/// 社保卡号
Property InsureCardNo As %String(TRUNCATE = 1, XMLNAME = "InsureCardNo");

/// 卡押金金额
Property CardDepositAmt As %String(TRUNCATE = 1, XMLNAME = "CardDepositAmt");

/// 卡类型代码
Property CardTypeCode As %String(TRUNCATE = 1, XMLNAME = "CardTypeCode");

/// 支付方式：1:现金3:POS
Property PayModeCode As %String(TRUNCATE = 1, XMLNAME = "PayModeCode");

/// 支付银行
Property PayBankCode As %String(TRUNCATE = 1, XMLNAME = "PayBankCode");

/// 支付卡号
Property PayCardNo As %String(TRUNCATE = 1, XMLNAME = "PayCardNo");

/// 支付交易信息串（应该包括银行代码、支付卡号、银行交易日期、银行交易流水号）
Property PayTradeStr As %String(TRUNCATE = 1, XMLNAME = "PayTradeStr");

}
