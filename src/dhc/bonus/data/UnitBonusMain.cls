Class dhc.bonus.data.UnitBonusMain Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UnitBonusMainID ]
{

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 2 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property CalcFlag As %Library.Integer [ SqlColumnNumber = 5 ];

Property CalcDate As %Library.Date [ SqlColumnNumber = 6 ];

Property AuditingFlag As %Library.Integer [ SqlColumnNumber = 7 ];

Property AuditingDate As %Library.Date [ SqlColumnNumber = 8 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 9 ];

Property IsPay As %Library.Integer [ SqlColumnNumber = 10 ];

Property IssuedPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Property IssuedDate As %Library.TimeStamp [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="UnitBonusMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemeID</Value>
</Value>
<Value name="3">
<Value>BonusYear</Value>
</Value>
<Value name="4">
<Value>BonusPeriod</Value>
</Value>
<Value name="5">
<Value>CalcFlag</Value>
</Value>
<Value name="6">
<Value>CalcDate</Value>
</Value>
<Value name="7">
<Value>AuditingFlag</Value>
</Value>
<Value name="8">
<Value>AuditingDate</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>IsPay</Value>
</Value>
<Value name="11">
<Value>IssuedDate</Value>
</Value>
<Value name="12">
<Value>IssuedPerson</Value>
</Value>
</Data>
<DataLocation>^dhcbsUnitBonusMainD</DataLocation>
<DefaultData>UnitBonusMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsUnitBonusMainD</IdLocation>
<IndexLocation>^dhcbsUnitBonusMainI</IndexLocation>
<StreamLocation>^dhcbsUnitBonusMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
