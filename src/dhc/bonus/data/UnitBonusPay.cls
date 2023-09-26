/// FA核算单元奖金主表
Class dhc.bonus.data.UnitBonusPay Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UnitBonusPayID ]
{

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property RealBonusID As dhc.bonus.data.BonusSchemeItem [ SqlColumnNumber = 6 ];

Property RealBonus As %Library.Float [ SqlColumnNumber = 7 ];

Property DeptPersonNumber As %Library.Integer [ SqlColumnNumber = 8 ];

Property IsAuditing As %Library.Integer [ SqlColumnNumber = 9 ];

Property AuditingDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10 ];

Property IsPay As %Library.Integer [ SqlColumnNumber = 11 ];

Property PayDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 13 ];

Property IssuedPerson As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

Property IssuedDate As %Library.TimeStamp [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="UnitBonusPayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusSchemeID</Value>
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
<Value>RealBonusID</Value>
</Value>
<Value name="7">
<Value>RealBonus</Value>
</Value>
<Value name="8">
<Value>DeptPersonNumber</Value>
</Value>
<Value name="9">
<Value>IsAuditing</Value>
</Value>
<Value name="10">
<Value>AuditingDate</Value>
</Value>
<Value name="11">
<Value>IsPay</Value>
</Value>
<Value name="12">
<Value>PayDate</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>IssuedDate</Value>
</Value>
<Value name="15">
<Value>IssuedPerson</Value>
</Value>
</Data>
<DataLocation>^dhcbsUnitBonusPayD</DataLocation>
<DefaultData>UnitBonusPayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsUnitBonusPayD</IdLocation>
<IndexLocation>^dhcbsUnitBonusPayI</IndexLocation>
<StreamLocation>^dhcbsUnitBonusPayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
