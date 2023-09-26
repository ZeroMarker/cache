Class dbo.BBOperation Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_Operation ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

Index IndexHISCode On HISCode [ SqlName = Index_HISCode, Type = index ];

/// Foreign Key FKBBOpeLocation created via DDL
ForeignKey FKBBOpeLocation(LinkLocationDR) References dbo.BBOpeLocation(PKBBOpeLocation) [ SqlName = FK_BB_OpeLocation ];

/// DDL Primary Key Specification
Index PKBBOperation On RowID [ PrimaryKey, SqlName = PK_BB_Operation, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property LevelNo As %Library.SmallInt [ Required, SqlColumnNumber = 5 ];

Property LinkLocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 7 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBOperationDefaultData">
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
<Value>LevelNo</Value>
</Value>
<Value name="5">
<Value>LinkLocationDR</Value>
</Value>
<Value name="6">
<Value>HISCode</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBOperationD</DataLocation>
<DefaultData>BBOperationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBOperationD</IdLocation>
<IndexLocation>^dbo.BBOperationI</IndexLocation>
<StreamLocation>^dbo.BBOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
