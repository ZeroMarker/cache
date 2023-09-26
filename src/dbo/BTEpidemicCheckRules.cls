///     
Class dbo.BTEpidemicCheckRules Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_EpidemicCheckRules, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexRuleType On (HospitalDR, RuleType) [ SqlName = Index_RuleType, Type = index ];

/// DDL Primary Key Specification
Index PKBTEPIDEMICCHECKRULES On RowID [ PrimaryKey, SqlName = PK_BT_EPIDEMICCHECKRULES, Type = index, Unique ];

/// Foreign Key FKEpidemicCheckRulesHosp created via DDL
ForeignKey FKEpidemicCheckRulesHosp(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_EpidemicCheckRulesHosp ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property RuleType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property RuleGroup As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTEpidemicCheckRulesDefaultData">
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
<Value>HosptialDR</Value>
</Value>
<Value name="5">
<Value>RuleType</Value>
</Value>
<Value name="6">
<Value>RuleGroup</Value>
</Value>
<Value name="7">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTEpidemicCheckRulesD</DataLocation>
<DefaultData>BTEpidemicCheckRulesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTEpidemicCheckRulesD</IdLocation>
<IndexLocation>^dbo.BTEpidemicCheckRulesI</IndexLocation>
<StreamLocation>^dbo.BTEpidemicCheckRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
