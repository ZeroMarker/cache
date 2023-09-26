/// Creator:Lid
/// CreatDate:2011-11-17
/// Description:用于临时存储银医卡交易的入参信息
Class DHCExternalService.BillInterface.DHCEntity.BankTradeInput Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// TradeCode	*交易编码
Property TradeCode As %String(TRUNCATE = 1);

/// BankID	*银行代码
Property BankID As %String(TRUNCATE = 1);

/// HospitalID	医院编码
Property HospitalID As %String(TRUNCATE = 1);

/// ClientType	渠道代码
Property ClientType As %String(TRUNCATE = 1);

/// TerminalID	科室代码
Property TerminalID As %String(TRUNCATE = 1);

/// ExtUserID	操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// HISDate	HIS交易时间 YYYYMMDDHHMMSS
Property HISDate As %String(TRUNCATE = 1);

/// HISTradeNo HIS唯一流水号
Property HISTradeNo As %String(TRUNCATE = 1);

/// PayCardNo	银联卡号
Property PayCardNo As %String(TRUNCATE = 1);

/// RevTranFlag	正反交易标志 0-扣费，1-退费
Property RevTranFlag As %String(TRUNCATE = 1);

/// PatientID	患者主索引
Property PatientID As %String(TRUNCATE = 1);

/// MobileNo	手机/电话号码
Property MobileNo As %String(TRUNCATE = 1);

/// PayAmt	扣款总金额
Property PayAmt As %String(TRUNCATE = 1);

/// PayDetails	支付明细循环体开始
Property PayDetails As list Of DHCExternalService.BillInterface.DHCEntity.PayDetail;

/// OrgBankAccDate	原扣费账务日期
Property OrgBankAccDate As %String(TRUNCATE = 1);

/// OrgBankTradeNo	原银行交易流水号
Property OrgBankTradeNo As %String(TRUNCATE = 1);

/// RecAmt	退款金额（差额）
Property RecAmt As %String(TRUNCATE = 1);

/// OrgPaySeqNo	原支付小票号HIS生成，唯一
Property OrgPaySeqNo As %String(TRUNCATE = 1);

/// OrgHISTradeNo	原HIS流水号
Property OrgHISTradeNo As %String(TRUNCATE = 1);

/// OrgPayAmt   原交易金额
Property OrgPayAmt As %String(TRUNCATE = 1);

Storage Default
{
<Data name="BankTradeInputDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BankTradeInfo</Value>
</Value>
<Value name="3">
<Value>CardNo</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>PatAmt</Value>
</Value>
<Value name="6">
<Value>SecrityNo</Value>
</Value>
<Value name="7">
<Value>StartDate</Value>
</Value>
<Value name="8">
<Value>Userid</Value>
</Value>
<Value name="9">
<Value>BankCardNo</Value>
</Value>
<Value name="10">
<Value>BankCode</Value>
</Value>
<Value name="11">
<Value>Charge</Value>
</Value>
<Value name="12">
<Value>HospitalID</Value>
</Value>
<Value name="13">
<Value>PaidTransactionId</Value>
</Value>
<Value name="14">
<Value>PatientID</Value>
</Value>
<Value name="15">
<Value>TelNo</Value>
</Value>
<Value name="16">
<Value>TerminalID</Value>
</Value>
<Value name="17">
<Value>TotalCharge</Value>
</Value>
<Value name="18">
<Value>TradeCode</Value>
</Value>
<Value name="19">
<Value>TransactionId</Value>
</Value>
<Value name="20">
<Value>CTxnDtTm</Value>
</Value>
<Value name="21">
<Value>TranWay</Value>
</Value>
</Data>
<DataLocation>^web.DHCEntit5BA.BankTradeInputD</DataLocation>
<DefaultData>BankTradeInputDefaultData</DefaultData>
<IdLocation>^web.DHCEntit5BA.BankTradeInputD</IdLocation>
<IndexLocation>^web.DHCEntit5BA.BankTradeInputI</IndexLocation>
<StreamLocation>^web.DHCEntit5BA.BankTradeInputS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
