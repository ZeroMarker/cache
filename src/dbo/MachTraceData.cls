Class dbo.MachTraceData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MachTraceData ]
{

Index IndexMaster On (MachineID, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexSeqNo On (MachineID, SeqNo) [ SqlName = Index_SeqNo, Type = index ];

Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

Property MachineID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Way As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 7 ];

Property SeqNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="MachTraceDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineID</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>Way</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>SeqNo</Value>
</Value>
</Data>
<DataLocation>^dbo.MachTraceDataD</DataLocation>
<DefaultData>MachTraceDataDefaultData</DefaultData>
<IdLocation>^dbo.MachTraceDataD</IdLocation>
<IndexLocation>^dbo.MachTraceDataI</IndexLocation>
<StreamLocation>^dbo.MachTraceDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
