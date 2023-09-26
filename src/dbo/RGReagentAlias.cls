///     
Class dbo.RGReagentAlias Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RG_ReagentAlias, StorageStrategy = Default ]
{

/// Foreign Key FKRGReagentAliasReagent created via DDL
ForeignKey FKRGReagentAliasReagent(ReagentDR) References dbo.BTRGReagent(PKBTRGREAGENT) [ SqlName = FK_RG_ReagentAlias_Reagent ];

/// Foreign Key FKRGReagentAliasUser created via DDL
ForeignKey FKRGReagentAliasUser(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_ReagentAlias_User ];

/// DDL Primary Key Specification
Index PKRGReagentAlias On RowID [ PrimaryKey, SqlName = PK_RG_ReagentAlias, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReagentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Alias As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RGReagentAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>ReagentDR</Value>
</Value>
<Value name="4">
<Value>Alias</Value>
</Value>
<Value name="5">
<Value>UserDR</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.RGReagentAliasD</DataLocation>
<DefaultData>RGReagentAliasDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RGReagentAliasD</IdLocation>
<IndexLocation>^dbo.RGReagentAliasI</IndexLocation>
<StreamLocation>^dbo.RGReagentAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
