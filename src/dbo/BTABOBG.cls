///     
Class dbo.BTABOBG Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_ABOBG, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTABOBG On RowID [ PrimaryKey, SqlName = PK_BT_ABOBG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property ABO As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTABOBGDefaultData">
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
</Data>
<DataLocation>^dbo.BTABOBGD</DataLocation>
<DefaultData>BTABOBGDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTABOBGD</IdLocation>
<IndexLocation>^dbo.BTABOBGI</IndexLocation>
<StreamLocation>^dbo.BTABOBGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
