/// rbrvs模板明细表
Class dhc.bonus.rbrvs.rvsTemplateDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = rvsTemplateDetailID ]
{

/// 模板ID
Property rvsTemplateMainID As dhc.bonus.rbrvs.rvsTemplateMain [ SqlColumnNumber = 2 ];

/// 模板RVRVS项目
Property BonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 3 ];

/// 消耗用时值
Property useMinuteValue As %Library.Float [ SqlColumnNumber = 4 ];

/// 承担风险值
Property workRiskValue As %Library.Float [ SqlColumnNumber = 5 ];

/// 技术难度值
Property techDifficultyValue As %Library.Float [ SqlColumnNumber = 6 ];

/// 工作消耗值
Property workCostValue As %Library.Float [ SqlColumnNumber = 7 ];

/// 开单计提
Property makeRate As %Library.Float [ SqlColumnNumber = 8 ];

/// 执行计提
Property execRate As %Library.Float [ SqlColumnNumber = 9 ];

/// 开单分值
Property makeItemScore As %Library.Float [ SqlColumnNumber = 10 ];

/// 执行分值
Property execItemScore As %Library.Float [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="rvsTemplateDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>rvsTemplateMainID</Value>
</Value>
<Value name="3">
<Value>useMinuteValue</Value>
</Value>
<Value name="4">
<Value>workRiskValue</Value>
</Value>
<Value name="5">
<Value>techDifficultyValue</Value>
</Value>
<Value name="6">
<Value>workCostValue</Value>
</Value>
<Value name="7">
<Value>BonusSubItemID</Value>
</Value>
<Value name="8">
<Value>makeRate</Value>
</Value>
<Value name="9">
<Value>execRate</Value>
</Value>
<Value name="10">
<Value>makeItemScore</Value>
</Value>
<Value name="11">
<Value>execItemScore</Value>
</Value>
</Data>
<DataLocation>^dhcbsrvsTemplateDetailD</DataLocation>
<DefaultData>rvsTemplateDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsrvsTemplateDetailD</IdLocation>
<IndexLocation>^dhcbsrvsTemplateDetailI</IndexLocation>
<StreamLocation>^dhcbsrvsTemplateDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
