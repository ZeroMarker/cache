/// ZB奖金指标采集
Class dhc.bonus.data.testTemp Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusCollectTempID ]
{

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property BonusTargetCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property Flag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property InterLocMethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 8 ];

Property TargetValue As %Library.Float [ SqlColumnNumber = 6 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 7 ];

Property status As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Index TargetCode On BonusTargetCode;

Index UnitCode On BonusUnitCode;

Storage Default
{
<Data name="testTempDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusPeriod</Value>
</Value>
<Value name="3">
<Value>BonusTargetCode</Value>
</Value>
<Value name="4">
<Value>BonusUnitCode</Value>
</Value>
<Value name="5">
<Value>BonusYear</Value>
</Value>
<Value name="6">
<Value>Flag</Value>
</Value>
<Value name="7">
<Value>InterLocMethodID</Value>
</Value>
<Value name="8">
<Value>TargetValue</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>status</Value>
</Value>
</Data>
<DataLocation>^dhcbstestTempD</DataLocation>
<DefaultData>testTempDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbstestTempD</IdLocation>
<IndexLocation>^dhcbstestTempI</IndexLocation>
<StreamLocation>^dhcbstestTempS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
