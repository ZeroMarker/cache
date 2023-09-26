Class dbo.MachExtractData Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MachExtractData ]
{

Index IndexMaster On (MachineID, ResultDate, Epis) [ SqlName = Index_Master, Type = index ];

Index IndexSeqNo On (MachineID, SeqNo) [ SqlName = Index_SeqNo, Type = index ];

Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

Property MachineID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property Epis As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property ResultDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property ResultTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property QC As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 8 ];

Property SeqNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="MachExtractDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineID</Value>
</Value>
<Value name="3">
<Value>Epis</Value>
</Value>
<Value name="4">
<Value>ResultDate</Value>
</Value>
<Value name="5">
<Value>ResultTime</Value>
</Value>
<Value name="6">
<Value>QC</Value>
</Value>
<Value name="7">
<Value>Result</Value>
</Value>
<Value name="8">
<Value>SeqNo</Value>
</Value>
</Data>
<DataLocation>^dbo.MachExtractDataD</DataLocation>
<DefaultData>MachExtractDataDefaultData</DefaultData>
<IdLocation>^dbo.MachExtractDataD</IdLocation>
<IndexLocation>^dbo.MachExtractDataI</IndexLocation>
<StreamLocation>^dbo.MachExtractDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
