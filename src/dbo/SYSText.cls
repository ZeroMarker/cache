///     
Class dbo.SYSText Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_Text ]
{

/// DDL Primary Key Specification
Index PKSYSTEXT On RowID [ PrimaryKey, SqlName = PK_SYS_TEXT, Type = index, Unique ];

Index IndexMaster On (PageCode, GetCode) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PageCode As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

Property GetCode As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="SYSTextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PageCode</Value>
</Value>
<Value name="3">
<Value>GetCode</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSTextD</DataLocation>
<DefaultData>SYSTextDefaultData</DefaultData>
<IdLocation>^dbo.SYSTextD</IdLocation>
<IndexLocation>^dbo.SYSTextI</IndexLocation>
<StreamLocation>^dbo.SYSTextS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
