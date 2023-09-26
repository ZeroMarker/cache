/// Rbrvs模型测算主表
Class dhc.bonus.rbrvs.rvsModuleCalcMain Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = rvsModuleCalcMainID ]
{

/// 测算次数
Property calcNum As %Library.Integer [ SqlColumnNumber = 2 ];

/// 模板ID
Property rvsTemplateMainID As dhc.bonus.rbrvs.rvsTemplateMain [ SqlColumnNumber = 3 ];

/// 操作人员
Property operatePerson As %Library.String [ SqlColumnNumber = 4 ];

/// 操作日期
Property operateDate As %Library.String [ SqlColumnNumber = 5 ];

/// 操作日期
Property CalcDesc As %Library.String [ SqlColumnNumber = 6 ];

/// 分值单价
Property ItemPrice As %Library.Float [ SqlColumnNumber = 7 ];

/// 计划分配总计金额
Property CalcTotal As %Library.Float [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="rvsModuleCalcMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>calcNum</Value>
</Value>
<Value name="3">
<Value>rvsTemplateMainID</Value>
</Value>
<Value name="4">
<Value>operatePerson</Value>
</Value>
<Value name="5">
<Value>operateDate</Value>
</Value>
<Value name="6">
<Value>CalcDesc</Value>
</Value>
<Value name="7">
<Value>CalcTotal</Value>
</Value>
<Value name="8">
<Value>ItemPrice</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus62A0.rvsModuleCa2247D</DataLocation>
<DefaultData>rvsModuleCalcMainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.bonus62A0.rvsModuleCa2247D</IdLocation>
<IndexLocation>^dhc.bonus62A0.rvsModuleCa2247I</IndexLocation>
<StreamLocation>^dhc.bonus62A0.rvsModuleCa2247S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
