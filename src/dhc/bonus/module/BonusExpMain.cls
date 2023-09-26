Class dhc.bonus.module.BonusExpMain Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusExpMainID ]
{

//所属年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

//奖金期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//科目编码

Property ItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//科目名称

Property ItemName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

//项目金额

Property ItemValue As %Library.Float [ SqlColumnNumber = 6 ];

//科室ID

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 7 ];

//操作员

Property Operator As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

//数据状态

Property State As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

Property UpdateDate As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Index expData On (BonusYear, BonusPeriod, ItemCode, BonusUnitID);

Storage Default
{
<Data name="BonusExpMainDefaultData">
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
<Value>ItemValue</Value>
</Value>
<Value name="7">
<Value>BonusUnitID</Value>
</Value>
<Value name="8">
<Value>Operator</Value>
</Value>
<Value name="9">
<Value>State</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsmoduleBonusExpMainD</DataLocation>
<DefaultData>BonusExpMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmoduleBonusExpMainD</IdLocation>
<IndexLocation>^dhcbsmoduleBonusExpMainI</IndexLocation>
<StreamLocation>^dhcbsmoduleBonusExpMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
