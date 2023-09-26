/// 工作量项目提取明细表BonusSubExpendDetail
Class dhc.bonus.subs.BonusSubExpendDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubExpendDetailID ]
{

//奖金核算单元

Property BonusUnitID As dhc.bonus.data.BonusUnit [ Required, SqlColumnNumber = 2 ];

//辅助核算项目

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

//核算年度

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//核算期间

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

//执行单元

Property ExecuteUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 6 ];

//核算单位

Property CalculateUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

//计提前分解值

Property ItemValue As %Library.Float [ Required, SqlColumnNumber = 8 ];

//计提系数

Property ItemRate As %Library.Float [ SqlColumnNumber = 9 ];

//计提结果

Property ItemResult As %Library.Float [ Required, SqlColumnNumber = 10 ];

Property State As %Library.Integer [ SqlColumnNumber = 11 ];

Property InterLocMethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 12 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 13 ];

Property BonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 14 ];

Property UnitType As %Library.Integer [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BonusSubExpendDetailDefaultData">
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
<Value>ExecuteUnitID</Value>
</Value>
<Value name="7">
<Value>CalculateUnit</Value>
</Value>
<Value name="8">
<Value>ItemValue</Value>
</Value>
<Value name="9">
<Value>ItemRate</Value>
</Value>
<Value name="10">
<Value>ItemResult</Value>
</Value>
<Value name="11">
<Value>State</Value>
</Value>
<Value name="12">
<Value>InterLocMethodID</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>BonusSubItemID</Value>
</Value>
<Value name="15">
<Value>UnitType</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubExpendDetailD</DataLocation>
<DefaultData>BonusSubExpendDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubExpendDetailD</IdLocation>
<IndexLocation>^dhcbsSubExpendDetailI</IndexLocation>
<StreamLocation>^dhcbsSubExpendDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
