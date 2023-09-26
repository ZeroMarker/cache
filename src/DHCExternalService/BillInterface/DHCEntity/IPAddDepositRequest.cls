/// Creator:wangjian
/// CreatDate:2013-02-20
/// Description:住院预交金充值入参
Class DHCExternalService.BillInterface.DHCEntity.IPAddDepositRequest Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 0;

//=0 导入时空字符将被保存成$C(0),$C(0)导成XML时是空标签(i.e. <tag />)；如果导入时是缺少标签，将保存成"",""导成XML时没有标签。

//=1 导入时缺少标签和空字符串都保存成"";""和$C(0)导成XML时是空标签(i.e. <tag />)

//=inputonly 导入时缺少标签和空字符串都保存成"";$C(0)导成XML时是空标签(i.e. <tag />),""导成XML时没有标签。

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// TerminalID	终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// HospitalId	医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// ExtUserID	操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// PatientCard	卡号
Property PatientCard As %String(TRUNCATE = 1);

/// CardTypeCode	卡类型
Property CardTypeCode As %String(TRUNCATE = 1);

/// PatientID	患者ID
Property PatientID As %String(TRUNCATE = 1);

/// Adm	就诊号
Property Adm As %String(TRUNCATE = 1);

/// Amount	充值金额
Property Amount As %String(TRUNCATE = 1);

/// PayModeCode	支付方式 1 现金 2 银行卡
Property PayModeCode As %String(TRUNCATE = 1);

/// TransactionId	交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// BankCode	交易银行
Property BankCode As %String(TRUNCATE = 1);

/// BankAccDate	银行交易日期
Property BankAccDate As %String(TRUNCATE = 1);

/// BankTransactionId	银行交易流水号
Property BankTransactionId As %String(TRUNCATE = 1);

/// BankCardNo	银行卡号
Property BankCardNo As %String(TRUNCATE = 1);

Property TypeCode As %String(TRUNCATE = 1);

Property BillDate As %String(TRUNCATE = 1);

}
