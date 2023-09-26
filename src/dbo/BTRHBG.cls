///     
Class dbo.BTRHBG Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_RHBG, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTRHBG On RowID [ PrimaryKey, SqlName = PK_BT_RHBG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property RH As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTRHBGDefaultData">
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
<Value>RH</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRHBGD</DataLocation>
<DefaultData>BTRHBGDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRHBGD</IdLocation>
<IndexLocation>^dbo.BTRHBGI</IndexLocation>
<StreamLocation>^dbo.BTRHBGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
