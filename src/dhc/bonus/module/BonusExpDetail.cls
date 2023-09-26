Class dhc.bonus.module.BonusExpDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusExpDetailID ]
{

//所属年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

//奖金期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//科目编码

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//科目名称

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

//项目金额

Property ItemValue As %Library.Float [ SqlColumnNumber = 6 ];

//计提系数

Property ItemRate As %Library.Float [ SqlColumnNumber = 7 ];

//科室ID

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 8 ];

//操作员

Property Operator As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

//数据状态

Property State As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Property UpdateDate As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Property MethordDr As %Library.String [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BonusExpDetailDefaultData">
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
<Value>ItemCode</Value>
</Value>
<Value name="5">
<Value>ItemName</Value>
</Value>
<Value name="6">
<Value>ItemRate</Value>
</Value>
<Value name="7">
<Value>ItemValue</Value>
</Value>
<Value name="8">
<Value>BonusUnitID</Value>
</Value>
<Value name="9">
<Value>Operator</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>MethordDr</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusExpDetailD</DataLocation>
<DefaultData>BonusExpDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusExpDetailD</IdLocation>
<IndexLocation>^dhcbsBonusExpDetailI</IndexLocation>
<StreamLocation>^dhcbsBonusExpDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
