///     
Class dbo.BTRGSquad Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTRG_Squad, StorageStrategy = Default ]
{

/// Foreign Key FKRGSquadGroup created via DDL
ForeignKey FKRGSquadGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Squad_Group ];

Index IndexSquadCName On CName [ SqlName = Index_Squad_CName, Type = index ];

Index IndexSquadMaster On (ReagentGroupDR, Code) [ SqlName = Index_Squad_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTRGSQUAD On RowID [ PrimaryKey, SqlName = PK_BTRG_SQUAD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTRGSquadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReagentGroupDR</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTRGSquadD</DataLocation>
<DefaultData>BTRGSquadDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTRGSquadD</IdLocation>
<IndexLocation>^dbo.BTRGSquadI</IndexLocation>
<StreamLocation>^dbo.BTRGSquadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
