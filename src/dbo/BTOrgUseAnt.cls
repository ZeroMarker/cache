///     
Class dbo.BTOrgUseAnt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_OrgUseAnt ]
{

/// DDL Primary Key RUGenusDR
Index IndexMaster On (OrgWCode, AntiWCode) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTORGUSEANT On RowID [ PrimaryKey, SqlName = PK_BT_ORGUSEANT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property OrgWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 3 ];

Property AntiWCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTOrgUseAntDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrgWCode</Value>
</Value>
<Value name="3">
<Value>AntiWCode</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTOrgUseAntD</DataLocation>
<DefaultData>BTOrgUseAntDefaultData</DefaultData>
<IdLocation>^dbo.BTOrgUseAntD</IdLocation>
<IndexLocation>^dbo.BTOrgUseAntI</IndexLocation>
<StreamLocation>^dbo.BTOrgUseAntS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
