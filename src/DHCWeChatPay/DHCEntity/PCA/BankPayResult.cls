Class DHCWeChatPay.DHCEntity.PCA.BankPayResult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 0;

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// BankID	银行代码
Property BankCode As %String(TRUNCATE = 1);

/// BankDate	银行交易时间
Property BankDate As %String(TRUNCATE = 1);

/// BankTradeNo	---支付宝交易流水号
Property BankTradeNo As %String(TRUNCATE = 1);

/// ResultCode	交易结果,错误代码表0000：成功
Property ResultCode As %String(TRUNCATE = 1);

/// ResultContent	对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// PayCardNo	支付宝账户
Property PayCardNo As %String(TRUNCATE = 1);

/// BankAccDate	银行账务日期
Property BankAccDate As %String(TRUNCATE = 1);

/// RevTranFlag	正反交易标志0-扣费，1-退费
Property RevTranFlag As %String(TRUNCATE = 1);

/// PatientID	患者主索引--登记号
Property PatientID As %String(TRUNCATE = 1);

/// PayAmt	扣款总金额
Property PayAmt As %String(TRUNCATE = 1);

/// HISTradeNo	HIS流水号--订单号
Property HISTradeNo As %String(TRUNCATE = 1);

/// OrgHISTradeNo	原HIS流水号--原订单号
Property OrgHISTradeNo As %String(TRUNCATE = 1);

}
