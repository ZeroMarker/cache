/// ZD方案周期设置
Class dhc.bonus.data.SchemePeriod Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SchemePeriodID ]
{

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property StartDate As %Library.Date [ SqlColumnNumber = 4 ];

Property EndDate As %Library.Date [ SqlColumnNumber = 5 ];

//Flag:0=数据采集，1=奖金核算，2=财务结账

Property Flag As %Library.Integer [ SqlColumnNumber = 6 ];

Property UpdateDate As %Library.Date [ SqlColumnNumber = 7 ];

Index IdxYear On BonusYear;

Storage Default
{
<Data name="SchemePeriodDefaultData">
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
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>Flag</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsSchemePeriodD</DataLocation>
<DefaultData>SchemePeriodDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSchemePeriodD</IdLocation>
<IndexLocation>^dhcbsSchemePeriodI</IndexLocation>
<StreamLocation>^dhcbsSchemePeriodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
