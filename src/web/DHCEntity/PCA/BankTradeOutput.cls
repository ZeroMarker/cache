/// Creator:Lid
/// CreatDate:2011-11-17
/// Description:用于临时存储银医卡交易的出参信息
Class web.DHCEntity.PCA.BankTradeOutput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// BankID	银行代码
Property BankCode As %String(TRUNCATE = 1);

/// BankDate	银行交易时间YYYYMMDDHHMMSS
Property BankDate As %String(TRUNCATE = 1);

/// BankTradeNo	银行唯一流水号
Property BankTradeNo As %String(TRUNCATE = 1);

/// ResultCode	交易结果,错误代码表0000：成功
Property ResultCode As %String(TRUNCATE = 1);

/// ResultContent	对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// PayCardNo	银联卡号
Property PayCardNo As %String(TRUNCATE = 1);

/// BankAccDate	银行账务日期
Property BankAccDate As %String(TRUNCATE = 1);

/// RevTranFlag	正反交易标志0-扣费，1-退费
Property RevTranFlag As %String(TRUNCATE = 1);

/// PatientID	患者主索引
Property PatientID As %String(TRUNCATE = 1);

/// PayAmt	扣款总金额
Property PayAmt As %String(TRUNCATE = 1);

/// HISTradeNo	HIS流水号
Property HISTradeNo As %String(TRUNCATE = 1);

/// OrgHISTradeNo	原HIS流水号
Property OrgHISTradeNo As %String(TRUNCATE = 1);

/// OrgPaySeqNo	原支付小票号HIS生成，唯一
Property OrgPaySeqNo As %String(TRUNCATE = 1);

/// FullPaymentFlag	足额支付标志（0足额，1可用余额不足）
Property FullPaymentFlag As %String(TRUNCATE = 1);

/// Balance	差额
Property Balance As %String(TRUNCATE = 1);

Storage Default
{
<Data name="BankTradeOutputDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctDate</Value>
</Value>
<Value name="3">
<Value>BankCode</Value>
</Value>
<Value name="4">
<Value>ErrorMsg</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>ResultCode</Value>
</Value>
<Value name="7">
<Value>TransactionId</Value>
</Value>
<Value name="8">
<Value>AcctTime</Value>
</Value>
</Data>
<DataLocation>^web.DHCEnti5BA.BankTradeOut5FDD</DataLocation>
<DefaultData>BankTradeOutputDefaultData</DefaultData>
<IdLocation>^web.DHCEnti5BA.BankTradeOut5FDD</IdLocation>
<IndexLocation>^web.DHCEnti5BA.BankTradeOut5FDI</IndexLocation>
<StreamLocation>^web.DHCEnti5BA.BankTradeOut5FDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
