///     
Class dbo.BBTreatType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_TreatType ]
{

/// DDL Primary Key Specification
Index PKBBTREATTYPE On RowID [ PrimaryKey, SqlName = PK_BB_TREATTYPE, Type = index, Unique ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexDataType On DataType [ SqlName = Index_DataType, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Property DataType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBTreatTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>DataType</Value>
</Value>
</Data>
<DataLocation>^dbo.BBTreatTypeD</DataLocation>
<DefaultData>BBTreatTypeDefaultData</DefaultData>
<IdLocation>^dbo.BBTreatTypeD</IdLocation>
<IndexLocation>^dbo.BBTreatTypeI</IndexLocation>
<StreamLocation>^dbo.BBTreatTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
