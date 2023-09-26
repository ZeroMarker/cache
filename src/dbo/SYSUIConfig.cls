///     
Class dbo.SYSUIConfig Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_UIConfig, StorageStrategy = Default ]
{

Index IndexUIConfigCode On Code [ SqlName = Index_UIConfig_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSUICONFIG On RowID [ PrimaryKey, SqlName = PK_SYS_UICONFIG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 3 ];

Property Genus As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 120) [ SqlColumnNumber = 5 ];

Property Conf As %Library.String(COLLATION = "Exact", MAXLEN = 4098) [ Required, SqlColumnNumber = 6 ];

Storage Default
{
<Data name="SYSUIConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Genus</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Conf</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSUIConfigD</DataLocation>
<DefaultData>SYSUIConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSUIConfigD</IdLocation>
<IndexLocation>^dbo.SYSUIConfigI</IndexLocation>
<StreamLocation>^dbo.SYSUIConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
