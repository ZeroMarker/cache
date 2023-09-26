///     
Class dbo.BTEpidemicCheckFormula Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EpidemicCheckFormula, StorageStrategy = Default ]
{

/// Foreign Key FKEpidemicCheckFormula created via DDL
ForeignKey FKEpidemicCheckFormula(EpidemicCheckRulesDR) References dbo.BTEpidemicCheckRules(PKBTEPIDEMICCHECKRULES) [ SqlName = FK_EpidemicCheckFormula ];

/// Foreign Key FKEpidemicCheckFormulaLocation created via DDL
ForeignKey FKEpidemicCheckFormulaLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_EpidemicCheckFormulaLocation ];

Index IndexDataMaster On (EpidemicCheckRulesDR, OrderNo) [ SqlName = Index_DataMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTEPIDEMICCHECKFORMULA On RowID [ PrimaryKey, SqlName = PK_BT_EPIDEMICCHECKFORMULA, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property EpidemicCheckRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property FormulaItems As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Property FormulaDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Property FormulaType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTEpidemicCheckFormulaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpidemicCheckRulesDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>FormulaItems</Value>
</Value>
<Value name="5">
<Value>FormulaDesc</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>FormulaType</Value>
</Value>
<Value name="8">
<Value>LocationDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEpidemicCheckFormulaD</DataLocation>
<DefaultData>BTEpidemicCheckFormulaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTEpidemicCheckFormulaD</IdLocation>
<IndexLocation>^dbo.BTEpidemicCheckFormulaI</IndexLocation>
<StreamLocation>^dbo.BTEpidemicCheckFormulaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
