Class dhc.bonus.data.DeptScoreDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DeptScoreDetailID ]
{

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ Required, SqlColumnNumber = 2 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 4 ];

Property hisUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 5 ];

Property TargetValue As %Library.Float [ SqlColumnNumber = 6 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="DeptScoreDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusYear</Value>
</Value>
<Value name="3">
<Value>BonusPeriod</Value>
</Value>
<Value name="4">
<Value>BonusUnitID</Value>
</Value>
<Value name="5">
<Value>hisUnitID</Value>
</Value>
<Value name="6">
<Value>TargetValue</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsDeptScoreDetailD</DataLocation>
<DefaultData>DeptScoreDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsDeptScoreDetailD</IdLocation>
<IndexLocation>^dhcbsDeptScoreDetailI</IndexLocation>
<StreamLocation>^dhcbsDeptScoreDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
