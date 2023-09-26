/// rbrvs测算明细表
Class dhc.bonus.rbrvs.rvsModuleCalcDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = rvsModuleCalcDetailID ]
{

/// 测算主表ID
Property rvsModuleCalcMainID As dhc.bonus.rbrvs.rvsModuleCalcMain [ SqlColumnNumber = 2 ];

/// 核算大科
Property bonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

/// RVRVS项目ID
Property bonusSubItemID As dhc.bonus.subs.BonusSubItem [ SqlColumnNumber = 4 ];

/// 开单数量
Property makeItemNum As %Library.Float [ SqlColumnNumber = 5 ];

/// 开单分值
Property makeItemScore As %Library.Float [ SqlColumnNumber = 6 ];

/// 执行数量
Property execItemNum As %Library.Float [ SqlColumnNumber = 7 ];

/// 执行分值
Property execItemScore As %Library.Float [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="rvsModuleCalcDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>templateCode</Value>
</Value>
<Value name="3">
<Value>rvsModuleCalcMainID</Value>
</Value>
<Value name="4">
<Value>bonusUnitID</Value>
</Value>
<Value name="5">
<Value>bonusSubItemID</Value>
</Value>
<Value name="6">
<Value>makeItemNum</Value>
</Value>
<Value name="7">
<Value>makeItemScore</Value>
</Value>
<Value name="8">
<Value>execItemNum</Value>
</Value>
<Value name="9">
<Value>execItemScore</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus62A0.rvsModuleCaA25AD</DataLocation>
<DefaultData>rvsModuleCalcDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.bonus62A0.rvsModuleCaA25AD</IdLocation>
<IndexLocation>^dhc.bonus62A0.rvsModuleCaA25AI</IndexLocation>
<StreamLocation>^dhc.bonus62A0.rvsModuleCaA25AS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
