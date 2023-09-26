/// FA奖金方案调整
Class dhc.bonus.data.BonusSchemeAdjust Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSchemeAdjustID ]
{

Property AdjustDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6 ];

Property AdjustDesc As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 2 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BonusSchemeAdjustDefaultData">
<Value name="1">
<Value>PeriodCode</Value>
</Value>
<Value name="2">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="3">
<Value>BonusSchemeID</Value>
</Value>
<Value name="4">
<Value>BonusYear</Value>
</Value>
<Value name="5">
<Value>BonusPeriod</Value>
</Value>
<Value name="6">
<Value>AdjustDesc</Value>
</Value>
<Value name="7">
<Value>AdjustDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusSchemeAdjustD</DataLocation>
<DefaultData>BonusSchemeAdjustDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusSchemeAdjustD</IdLocation>
<IndexLocation>^dhcbsBonusSchemeAdjustI</IndexLocation>
<StreamLocation>^dhcbsBonusSchemeAdjustS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
