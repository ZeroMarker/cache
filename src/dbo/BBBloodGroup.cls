///     
Class dbo.BBBloodGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_BloodGroup, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBBLOODGROUP On RowID [ PrimaryKey, SqlName = PK_BB_BLOODGROUP, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property ABO As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 5 ];

Property RH As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 6 ];

Property IsUrgIssue As %Library.Boolean [ SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Property IsDifficult As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BBBloodGroupDefaultData">
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
<Value>ABO</Value>
</Value>
<Value name="5">
<Value>RH</Value>
</Value>
<Value name="6">
<Value>IsUrgIssue</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>IsDifficult</Value>
</Value>
</Data>
<DataLocation>^dbo.BBBloodGroupD</DataLocation>
<DefaultData>BBBloodGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBBloodGroupD</IdLocation>
<IndexLocation>^dbo.BBBloodGroupI</IndexLocation>
<StreamLocation>^dbo.BBBloodGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
