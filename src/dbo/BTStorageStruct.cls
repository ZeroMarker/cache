Class dbo.BTStorageStruct Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_StorageStruct ]
{

/// Foreign Key FKWorkGroupDR created via DDL
ForeignKey FKWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupDR ];

/// Foreign Key FKStorageStructDR created via DDL
ForeignKey FKStorageStructDR(StorageStructDR) References dbo.BTStorageStruct(PKBTSTORAGESTRUCT) [ SqlName = FK_StorageStructDR ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTSTORAGESTRUCT On RowID [ PrimaryKey, SqlName = PK_BT_RACKTYPE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

Property RowSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property ColSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Property StorageStructDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property BLLType As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 11 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BTStorageStructDefaultData">
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
<Value>RowSum</Value>
</Value>
<Value name="5">
<Value>ColSum</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>StorageStructDR</Value>
</Value>
<Value name="10">
<Value>BLLType</Value>
</Value>
<Value name="11">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTStorageStructD</DataLocation>
<DefaultData>BTStorageStructDefaultData</DefaultData>
<IdLocation>^dbo.BTStorageStructD</IdLocation>
<IndexLocation>^dbo.BTStorageStructI</IndexLocation>
<StreamLocation>^dbo.BTStorageStructS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
