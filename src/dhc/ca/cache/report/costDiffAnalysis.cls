/// Creator: 王赢赢
/// CreatDate: 2009-2-8
/// Description: 成本差异分析
Class dhc.ca.cache.report.costDiffAnalysis Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property month As %String(TRUNCATE = 1);

Property money As %String(TRUNCATE = 1);

Property deptName As %String(TRUNCATE = 1);

Property deptNum As %String(TRUNCATE = 1);

Property deptOrder As %String(TRUNCATE = 1);

Property itemName As %String(TRUNCATE = 1);

Property itemNum As %String(TRUNCATE = 1);

Property itemOrder As %String(TRUNCATE = 1);

Property bedNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="costDiffAnalysisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>deptName</Value>
</Value>
<Value name="3">
<Value>deptNum</Value>
</Value>
<Value name="4">
<Value>deptOrder</Value>
</Value>
<Value name="5">
<Value>itemName</Value>
</Value>
<Value name="6">
<Value>itemNum</Value>
</Value>
<Value name="7">
<Value>itemOrder</Value>
</Value>
<Value name="8">
<Value>money</Value>
</Value>
<Value name="9">
<Value>month</Value>
</Value>
<Value name="10">
<Value>bedNum</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.costDiffAnalysisD</DataLocation>
<DefaultData>costDiffAnalysisDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.costDiffAnalysisD</IdLocation>
<IndexLocation>^dhc.ca.c.costDiffAnalysisI</IndexLocation>
<StreamLocation>^dhc.ca.c.costDiffAnalysisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
