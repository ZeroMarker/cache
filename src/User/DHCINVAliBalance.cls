Class User.DHCINVAliBalance Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, SqlRowIdName = IAT_RowID, SqlTableName = DHC_INVAliBalance, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IAT_TradeNo
Property IATTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IAT_TradeNo ];

/// IAT_BankNo
Property IATBankNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IAT_BankNo ];

/// IAT_HopDr
Property IATHopDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IAT_HopDr ];

/// IAT_TrannelNo
Property IATTrannelNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IAT_TrannelNo ];

/// IAT_TerminalNo
Property IATTerminalNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IAT_TerminalNo ];

/// IAT_UserId
Property IATUserId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IAT_UserId ];

/// IAT_BankCardNo
Property IATBankCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IAT_BankCardNo ];

/// IAT_HISTradeTime
Property IATHISTradeTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IAT_HISTradeTime ];

/// IAT_HISTradeNo
Property IATHISTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IAT_HISTradeNo ];

/// IAT_TradeFlag
Property IATTradeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IAT_TradeFlag ];

/// IAT_PaymodeDr
Property IATPaymodeDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IAT_PaymodeDr ];

/// IAT_TradeAmt
Property IATTradeAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IAT_TradeAmt ];

/// IAT_BankTradeTime
Property IATBankTradeTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IAT_BankTradeTime ];

/// IAT_BankTradeNo
Property IATBankTradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IAT_BankTradeNo ];

/// IAT_BankFinDate
Property IATBankFinDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IAT_BankFinDate ];

Index BANKFINDATE On IATBankFinDate;

Index BANKTRADETIME On IATBankTradeTime;

Index HISTIME On IATHISTradeTime;

Index TRADENO On IATHISTradeNo;

Storage SQLStorage
{
<Data name="DHCINVAliBalanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IATBankNo</Value>
</Value>
<Value name="3">
<Value>IATBankFinDate</Value>
</Value>
<Value name="4">
<Value>IATBankNo</Value>
</Value>
<Value name="5">
<Value>IATBankTradeNo</Value>
</Value>
<Value name="6">
<Value>IATBankTradeTime</Value>
</Value>
<Value name="7">
<Value>IATHISTradeNo</Value>
</Value>
<Value name="8">
<Value>IATHISTradeTime</Value>
</Value>
<Value name="9">
<Value>IATHopDr</Value>
</Value>
<Value name="10">
<Value>IATPaymodeDr</Value>
</Value>
<Value name="11">
<Value>IATTerminalNo</Value>
</Value>
<Value name="12">
<Value>IATTradeAmt</Value>
</Value>
<Value name="13">
<Value>IATTradeFlag</Value>
</Value>
<Value name="14">
<Value>IATTradeNo</Value>
</Value>
<Value name="15">
<Value>IATTrannelNo</Value>
</Value>
<Value name="16">
<Value>IATUserId</Value>
</Value>
<Value name="17">
<Value>IATBankCardNo</Value>
</Value>
</Data>
<DataLocation>^User.DHCINVAliBalanceD</DataLocation>
<DefaultData>DHCINVAliBalanceDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.DHCINVAliBalanceD</IdLocation>
<IndexLocation>^User.DHCINVAliBalanceI</IndexLocation>
<StreamLocation>^User.DHCINVAliBalanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
