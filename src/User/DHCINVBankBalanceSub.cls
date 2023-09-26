Class User.DHCINVBankBalanceSub Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = IBTS_RowID, SqlTableName = DHC_INVBankBalanceSub ]
{

/// 银行代码
Property IBTSBankCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = IBTS_BankCode ];

/// 医院代码
Property IBTSHospCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IBTS_HospCode ];

/// 渠道代码 
Property IBTSChanCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = IBTS_ChanCode ];

/// 交易操作员
Property IBTSUserId As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = IBTS_UserId ];

/// 银行卡号
Property IBTSBankCardNo As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = IBTS_BankCardNo ];

/// HIS交易时间
Property IBTSHisDateTime As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = IBTS_HisDateTime ];

/// HIS交易流水号
Property IBTSHisTradedNo As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = IBTS_HisTradedNo ];

/// 交易标志
Property IBTSTradeType As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = IBTS_TradeType ];

/// 应收金额
Property IBTSMustPay As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = IBTS_MustPay ];

/// 实收金额
Property IBTSRealPay As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = IBTS_RealPay ];

/// 银行交易时间 
Property IBTSBankDateTime As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = IBTS_BankDateTime ];

/// 银行交易流水号
Property IBTSBankTradeNo As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = IBTS_BankTradeNo ];

/// 银行交易财务日期
Property IBTSBankFinDate As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = IBTS_BankFinDate ];

/// 交易代码 4200\4201\1000\1003
Property IBTSTradeID As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = IBTS_TradeID ];

/// 发票rowid
Property IBTSPRTDR As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = IBTS_PRTDR ];

/// 处理状态 Y/N
Property IBTSProcess As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = IBTS_Process ];

/// 处理人
Property IBTSPrcUser As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = IBTS_PrcUser ];

/// 处理日期
Property IBTSPrcDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = IBTS_PrcDate ];

/// 处理时间
Property IBTSPrcTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = IBTS_PrcTime ];

Property IBTSNote1 As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = IBTS_Note1 ];

Property IBTSNote2 As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = IBTS_Note2 ];

Property IBTSNote3 As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = IBTS_Note3 ];

Index HisTradedNo On IBTSHisTradedNo As Exact;

Index BankTradeNo On IBTSBankTradeNo As Exact;

Index PrcDate On IBTSPrcDate As Exact;

Index BankCardNo On IBTSBankCardNo As Exact;

Index PrtDr On IBTSPRTDR As Exact;

Storage Default
{
<Data name="DHCINVBankBalanceSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IBTSSub</Value>
</Value>
<Value name="3">
<Value>IBTSBankCardNo</Value>
</Value>
<Value name="4">
<Value>IBTSBankCode</Value>
</Value>
<Value name="5">
<Value>IBTSBankDateTime</Value>
</Value>
<Value name="6">
<Value>IBTSBankFinDate</Value>
</Value>
<Value name="7">
<Value>IBTSBankTradeNo</Value>
</Value>
<Value name="8">
<Value>IBTSChanCode</Value>
</Value>
<Value name="9">
<Value>IBTSHisDateTime</Value>
</Value>
<Value name="10">
<Value>IBTSHisTradedNo</Value>
</Value>
<Value name="11">
<Value>IBTSHospCode</Value>
</Value>
<Value name="12">
<Value>IBTSMustPay</Value>
</Value>
<Value name="13">
<Value>IBTSNote1</Value>
</Value>
<Value name="14">
<Value>IBTSNote2</Value>
</Value>
<Value name="15">
<Value>IBTSNote3</Value>
</Value>
<Value name="16">
<Value>IBTSNote4</Value>
</Value>
<Value name="17">
<Value>IBTSRealPay</Value>
</Value>
<Value name="18">
<Value>IBTSTradeType</Value>
</Value>
<Value name="19">
<Value>IBTSUserId</Value>
</Value>
<Value name="20">
<Value>IBTSPrcDate</Value>
</Value>
<Value name="21">
<Value>IBTSPrcTime</Value>
</Value>
<Value name="22">
<Value>IBTSPrcUser</Value>
</Value>
<Value name="23">
<Value>IBTSProcess</Value>
</Value>
<Value name="24">
<Value>IBTSPRTDR</Value>
</Value>
<Value name="25">
<Value>IBTSTradeID</Value>
</Value>
</Data>
<DataLocation>^User.DHCINVBankBalanceSubD</DataLocation>
<DefaultData>DHCINVBankBalanceSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCINVBankBalanceSubD</IdLocation>
<IndexLocation>^User.DHCINVBankBalanceSubI</IndexLocation>
<StreamLocation>^User.DHCINVBankBalanceSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
