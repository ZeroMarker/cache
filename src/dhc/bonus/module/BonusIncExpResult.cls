Class dhc.bonus.module.BonusIncExpResult Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusIncExpResultID ]
{

//所属年

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

//奖金期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//科室编码

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 4 ];

//科目名称

Property IncValue As %Library.Float [ SqlColumnNumber = 5 ];

//项目金额

Property ExpValue As %Library.Float [ SqlColumnNumber = 6 ];

//计算时间

Property CalcDate As %Library.String [ SqlColumnNumber = 7 ];

//操作员

Property Operator As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

//审核时间

Property CheckDate As %Library.String [ SqlColumnNumber = 9 ];

//审核人

Property CheckMan As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

//数据状态

Property State As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

//操作员

Property UpdateDate As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BonusIncExpResultDefaultData">
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
<Value>IncValue</Value>
</Value>
<Value name="6">
<Value>ExpValue</Value>
</Value>
<Value name="7">
<Value>CalcDate</Value>
</Value>
<Value name="8">
<Value>Operator</Value>
</Value>
<Value name="9">
<Value>CheckDate</Value>
</Value>
<Value name="10">
<Value>CheckMan</Value>
</Value>
<Value name="11">
<Value>State</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsmdBonusIncExpResultD</DataLocation>
<DefaultData>BonusIncExpResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmdBonusIncExpResultD</IdLocation>
<IndexLocation>^dhcbsmdBonusIncExpResultI</IndexLocation>
<StreamLocation>^dhcbsmdBonusIncExpResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
