Class dhc.pa.data.JXScoreForBonus Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = JXScoreForBonusRowid ]
{

Property Year As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property Period As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 4 ];

Property UnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property YewuValue As %Library.Float [ SqlColumnNumber = 6 ];

Property GuanliValue As %Library.Float [ SqlColumnNumber = 7 ];

Property TargetValue As %Library.Float [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="JXScoreForBonusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusPeriod</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>BonusUnitCode</Value>
</Value>
<Value name="5">
<Value>BonusYear</Value>
</Value>
<Value name="6">
<Value>GuanliValue</Value>
</Value>
<Value name="7">
<Value>TargetValue</Value>
</Value>
<Value name="8">
<Value>YewuValue</Value>
</Value>
<Value name="9">
<Value>Period</Value>
</Value>
<Value name="10">
<Value>UnitCode</Value>
</Value>
<Value name="11">
<Value>Year</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.data.JXScoreForBonusD</DataLocation>
<DefaultData>JXScoreForBonusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.data.JXScoreForBonusD</IdLocation>
<IndexLocation>^dhc.pa.data.JXScoreForBonusI</IndexLocation>
<StreamLocation>^dhc.pa.data.JXScoreForBonusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
