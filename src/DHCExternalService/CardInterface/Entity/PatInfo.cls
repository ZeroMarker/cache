Class DHCExternalService.CardInterface.Entity.PatInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock, SoapBodyUse = literal ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 病人唯一主索引PMI
Property PatientID As %String(TRUNCATE = 1);

/// 卡类型代码,在已经卡类型的情况下使用
Property CardTypeCode As %String(TRUNCATE = 1);

/// 银行代码
Property BankCode As %String(TRUNCATE = 1);

/// 银医卡号
Property PatientCard As %String(TRUNCATE = 1);

/// 健康卡对应的银行卡卡号
Property HTBankCardNo As %String(TRUNCATE = 1);

/// 终端编码
Property TerminalID As %String(TRUNCATE = 1);

// 换卡使用

/// 旧银医卡号
Property OldPatientCard As %String(TRUNCATE = 1);

/// 新银医卡号
Property NewPatientCard As %String(TRUNCATE = 1);

// End

/// 银医卡校验码
Property SecurityNo As %String(TRUNCATE = 1);

/// 芯片序列号
Property ChipSerialNo As %String(TRUNCATE = 1);

/// 银行业务流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 费用类别
Property PatientType As %String(TRUNCATE = 1);

/// 患者姓名
Property PatientName As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 出生日期
Property DOB As %String(TRUNCATE = 1);

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 婚姻状况
Property MaritalStatus As %String(TRUNCATE = 1);

/// 民族
Property Nation As %String(TRUNCATE = 1);

/// 职业
Property Occupation As %String(TRUNCATE = 1);

/// 国籍
Property Nationality As %String(TRUNCATE = 1);

/// 证件类型
Property IDType As %String(TRUNCATE = 1);

// 建卡\信息变更使用

/// 证件号
Property IDNo As %String(TRUNCATE = 1);

/// 身份证头像
Property PhotoInfo As %String(TRUNCATE = 1);

/// 证件号  
Property IDCode As %String(TRUNCATE = 1);

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
Property Mobile As %String(TRUNCATE = 1);

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

/// 签约标志(0=没有签约,1= 签约)
Property SignedStatus As %String(TRUNCATE = 1);

///  北京社保病人标志(Y=北京社保病人,N= 非北京社保病人)
Property InsureCardFlag As %String(TRUNCATE = 1);

/// 北京社保卡号
Property InsureCardNo As %String(TRUNCATE = 1);

/// 卡费以及预存金额支付方式
Property PayMode As %String(TRUNCATE = 1);

/// 交款总金额
Property TotalAmount As %String(TRUNCATE = 1);

/// 如为银行卡支付、支付银行名称
Property PayBankName As %String(TRUNCATE = 1);

/// 如果为银行卡支付、支付银行卡类型
Property PayCardType As %String(TRUNCATE = 1);

/// 如果为银行卡支付、支付银行卡号
Property PayCardNo As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 绑定标志
Property BindFlag As %String(TRUNCATE = 1);

/// 健康卡RowID
Property CardDR As %String(TRUNCATE = 1);

Property ChargeDepositAmt As %String(TRUNCATE = 1);

Property AccountPassword As %String(TRUNCATE = 1);

Property TheArea As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

}
