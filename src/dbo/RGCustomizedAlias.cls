///     
Class dbo.RGCustomizedAlias Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_CustomizedAlias, StorageStrategy = Default ]
{

/// Foreign Key FKRGCustomizedAliasUser created via DDL
ForeignKey FKRGCustomizedAliasUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_CustomizedAlias_User ];

/// DDL Primary Key Specification
Index PKRGCustomizedAlias On RowID [ PrimaryKey, SqlName = PK_RG_CustomizedAlias, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TableName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 3 ];

Property DataID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property DataAlias As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="RGCustomizedAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>DataID</Value>
</Value>
<Value name="5">
<Value>DataAlias</Value>
</Value>
<Value name="6">
<Value>UserDR</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.RGCustomizedAliasD</DataLocation>
<DefaultData>RGCustomizedAliasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGCustomizedAliasD</IdLocation>
<IndexLocation>^dbo.RGCustomizedAliasI</IndexLocation>
<StreamLocation>^dbo.RGCustomizedAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
