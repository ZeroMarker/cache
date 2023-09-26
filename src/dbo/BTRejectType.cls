///     
Class dbo.BTRejectType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_RejectType, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTREJECTTYPE On RowID [ PrimaryKey, SqlName = PK_BT_REJECTTYPE, Type = index, Unique ];

/// Foreign Key FKWorkGroup created via DDL
ForeignKey FKWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroup ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Property QSIType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 是否合格
Property IsQualified As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTRejectTypeDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>QSIType</Value>
</Value>
<Value name="7">
<Value>WorkGroupDR</Value>
</Value>
<Value name="8">
<Value>IsQualified</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRejectTypeD</DataLocation>
<DefaultData>BTRejectTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRejectTypeD</IdLocation>
<IndexLocation>^dbo.BTRejectTypeI</IndexLocation>
<StreamLocation>^dbo.BTRejectTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
