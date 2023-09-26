Class User.DHCTeleTransaction Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_TeleTransaction ]
{

Property ErrorMsg As %String(TRUNCATE = 1) [ SqlFieldName = TT_ErrorMsg ];

Property RecordType As %String(TRUNCATE = 1) [ SqlFieldName = TT_RecordType ];

Property RequestMsg As %GlobalCharacterStream [ SqlFieldName = TT_RequestMsg ];

Property ResponseMsg As %GlobalCharacterStream [ SqlFieldName = TT_ResponseMsg ];

Property TransactionDate As %Date [ SqlFieldName = TT_TransactionDate ];

Property TransactionId As %String(TRUNCATE = 1) [ SqlFieldName = TT_TransactionId ];

Property TransactionStatus As %Integer [ SqlFieldName = TT_TransactionStatus ];

Property TransactionType As %String(TRUNCATE = 1) [ SqlFieldName = TT_TransactionType ];

Index TransactionIndex On TransactionId [ Unique ];

Storage Default
{
<Data name="DHCTeleTransactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ErrorMsg</Value>
</Value>
<Value name="3">
<Value>RecordType</Value>
</Value>
<Value name="4">
<Value>RequestMsg</Value>
</Value>
<Value name="5">
<Value>ResponseMsg</Value>
</Value>
<Value name="6">
<Value>TransactionDate</Value>
</Value>
<Value name="7">
<Value>TransactionId</Value>
</Value>
<Value name="8">
<Value>TransactionStatus</Value>
</Value>
<Value name="9">
<Value>TransactionType</Value>
</Value>
</Data>
<DataLocation>^User.DHCTeleTransactionD</DataLocation>
<DefaultData>DHCTeleTransactionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCTeleTransactionD</IdLocation>
<IndexLocation>^User.DHCTeleTransactionI</IndexLocation>
<StreamLocation>^User.DHCTeleTransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
