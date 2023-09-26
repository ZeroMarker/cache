///     
Class dbo.SYSPermission Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_Permission, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKSYSPERMISSION On RowID [ PrimaryKey, SqlName = PK_SYS_Permission, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Property PLevel As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="SYSPermissionDefaultData">
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
<Value>PLevel</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSPermissionD</DataLocation>
<DefaultData>SYSPermissionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSPermissionD</IdLocation>
<IndexLocation>^dbo.SYSPermissionI</IndexLocation>
<StreamLocation>^dbo.SYSPermissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
