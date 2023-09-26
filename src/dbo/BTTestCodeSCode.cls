///     
Class dbo.BTTestCodeSCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeSCode, StorageStrategy = Default ]
{

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexSCode On SCode [ SqlName = Index_SCode, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property TCName As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 4 ];

Property SpecimenType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTTestCodeSCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCode</Value>
</Value>
<Value name="3">
<Value>TCName</Value>
</Value>
<Value name="4">
<Value>SpecimenType</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeSCodeD</DataLocation>
<DefaultData>BTTestCodeSCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodeSCodeD</IdLocation>
<IndexLocation>^dbo.BTTestCodeSCodeI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeSCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
