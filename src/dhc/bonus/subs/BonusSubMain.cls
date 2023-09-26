/// SH奖金辅助指标汇总表
Class dhc.bonus.subs.BonusSubMain Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubMainID ]
{

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 2 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property BonusValue As %Library.Float [ SqlColumnNumber = 6 ];

Property DataType As %Library.Integer [ SqlColumnNumber = 7 ];

Property UpadeDate As %Library.TimeStamp [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BonusSubMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusUnitID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>BonusYear</Value>
</Value>
<Value name="5">
<Value>BonusPeriod</Value>
</Value>
<Value name="6">
<Value>BonusValue</Value>
</Value>
<Value name="7">
<Value>DataType</Value>
</Value>
<Value name="8">
<Value>UpadeDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusSubMainD</DataLocation>
<DefaultData>BonusSubMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusSubMainD</IdLocation>
<IndexLocation>^dhcbsBonusSubMainI</IndexLocation>
<StreamLocation>^dhcbsBonusSubMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
