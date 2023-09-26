/// FA核算单元奖金明细表 
/// d ##class(dhc.bonus.data.UnitBonusDetail).%BuildIndces()
Class dhc.bonus.data.UnitBonusDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UnitBonusDetailID ]
{

Property BonusSchemeItemID As dhc.bonus.data.BonusSchemeItem [ SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property BonusType As %Library.Integer [ SqlColumnNumber = 6 ];

Property DataSource As %Library.Integer [ SqlColumnNumber = 7 ];

Property BonusValue As %Library.Float [ SqlColumnNumber = 8 ];

Property AuditingState As %Library.Integer [ SqlColumnNumber = 9 ];

Property AuditingDate As %Library.Date [ SqlColumnNumber = 10 ];

Property UpdateDate As %Library.TimeStamp [ Required, SqlColumnNumber = 11 ];

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 12 ];

Property SuperiorUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 13 ];

Property BonusFormula As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

//Index YearPeriodItem On (BonusYear, BonusPeriod, BonusUnitID, BonusSchemeID, BonusSchemeItemID);

Index YearPeriodItem On (BonusYear, BonusPeriod, BonusUnitID, BonusSchemeItemID);

Storage Default
{
<Data name="UnitBonusDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemeItemID</Value>
</Value>
<Value name="3">
<Value>BonusUnitID</Value>
</Value>
<Value name="4">
<Value>BonusYear</Value>
</Value>
<Value name="5">
<Value>BonusPeriod</Value>
</Value>
<Value name="6">
<Value>BonusType</Value>
</Value>
<Value name="7">
<Value>DataSource</Value>
</Value>
<Value name="8">
<Value>BonusValue</Value>
</Value>
<Value name="9">
<Value>AuditingState</Value>
</Value>
<Value name="10">
<Value>AuditingDate</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>BonusSchemeID</Value>
</Value>
<Value name="13">
<Value>SuperiorUnitID</Value>
</Value>
<Value name="14">
<Value>BonusFormula</Value>
</Value>
</Data>
<DataLocation>^dhcbsUnitBonusDetailD</DataLocation>
<DefaultData>UnitBonusDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsUnitBonusDetailD</IdLocation>
<IndexLocation>^dhcbsUnitBonusDetailI</IndexLocation>
<StreamLocation>^dhcbsUnitBonusDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
