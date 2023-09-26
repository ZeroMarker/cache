Class User.DHCINVBankBalance Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IBT_RowID, SqlTableName = DHC_INVBankBalance, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IBT_TradeNo
Property IBTTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IBT_TradeNo ];

/// IBT_BankNo
Property IBTBankNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IBT_BankNo ];

/// IBT_HopDr
Property IBTHopDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IBT_HopDr ];

/// IBT_TrannelNo
Property IBTTrannelNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IBT_TrannelNo ];

/// IBT_TerminalNo
Property IBTTerminalNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IBT_TerminalNo ];

/// IBT_UserId
Property IBTUserId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IBT_UserId ];

/// IBT_BankCardNo
Property IBTBankCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IBT_BankCardNo ];

/// IBT_HISTradeTime
Property IBTHISTradeTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IBT_HISTradeTime ];

/// IBT_HISTradeNo
Property IBTHISTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IBT_HISTradeNo ];

/// IBT_TradeFlag
Property IBTTradeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IBT_TradeFlag ];

/// IBT_PaymodeDr
Property IBTPaymodeDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IBT_PaymodeDr ];

/// IBT_TradeAmt
Property IBTTradeAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IBT_TradeAmt ];

/// IBT_BankTradeTime
Property IBTBankTradeTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IBT_BankTradeTime ];

/// IBT_BankTradeNo
Property IBTBankTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IBT_BankTradeNo ];

/// IBT_BankFinDate
Property IBTBankFinDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IBT_BankFinDate ];

Index BANKFINDATE On IBTBankFinDate;

Index BANKTRADETIME On IBTBankTradeTime;

Index HISTIME On IBTHISTradeTime;

Index TRADENO On IBTHISTradeNo;

Storage SQLStorage
{
<Data name="DHCINVBankBalanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IBTBankCardNo</Value>
</Value>
<Value name="3">
<Value>IBTBankFinDate</Value>
</Value>
<Value name="4">
<Value>IBTBankNo</Value>
</Value>
<Value name="5">
<Value>IBTBankTradeNo</Value>
</Value>
<Value name="6">
<Value>IBTBankTradeTime</Value>
</Value>
<Value name="7">
<Value>IBTHISTradeNo</Value>
</Value>
<Value name="8">
<Value>IBTHISTradeTime</Value>
</Value>
<Value name="9">
<Value>IBTHopDr</Value>
</Value>
<Value name="10">
<Value>IBTPaymodeDr</Value>
</Value>
<Value name="11">
<Value>IBTTerminalNo</Value>
</Value>
<Value name="12">
<Value>IBTTradeAmt</Value>
</Value>
<Value name="13">
<Value>IBTTradeFlag</Value>
</Value>
<Value name="14">
<Value>IBTTradeNo</Value>
</Value>
<Value name="15">
<Value>IBTTrannelNo</Value>
</Value>
<Value name="16">
<Value>IBTUserId</Value>
</Value>
</Data>
<DataLocation>^User.DHCINVBankBalanceD</DataLocation>
<DefaultData>DHCINVBankBalanceDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCINVBankBalanceD</IdLocation>
<IndexLocation>^User.DHCINVBankBalanceI</IndexLocation>
<StreamLocation>^User.DHCINVBankBalanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
