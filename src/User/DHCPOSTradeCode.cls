Class User.DHCPOSTradeCode Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = IBPOS_RowID, SqlTableName = DHC_POSTradeCode ]
{

/// 返回码
Property IBTSBankCode As %String(MAXLEN = 300, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = IBPOS_Code ];

/// 错误类型
Property IBTSHospCode As %String(MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IBPOS_Type ];

/// 原因描述
Property IBTSChanCode As %String(MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = IBPOS_Reason ];

/// POS显示内容
Property IBTSUserId As %String(MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = IBPOS_Message ];

Index BankCode On IBTSBankCode;

Storage Default
{
<Data name="DHCPOSTradeCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IBTSBankCode</Value>
</Value>
<Value name="3">
<Value>IBTSChanCode</Value>
</Value>
<Value name="4">
<Value>IBTSHospCode</Value>
</Value>
<Value name="5">
<Value>IBTSUserId</Value>
</Value>
</Data>
<DataLocation>^User.DHCPOSTradeCodeD</DataLocation>
<DefaultData>DHCPOSTradeCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPOSTradeCodeD</IdLocation>
<IndexLocation>^User.DHCPOSTradeCodeI</IndexLocation>
<StreamLocation>^User.DHCPOSTradeCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
