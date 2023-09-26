/// Creator: 王赢赢
/// CreatDate: 2009-2-2
/// Description: 项目汇总查询
Class dhc.ca.cache.report.itemSummary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property money As %String(TRUNCATE = 1);

Property deptName As %String(TRUNCATE = 1);

Property deptNum As %String(TRUNCATE = 1);

Property deptOrder As %String(TRUNCATE = 1);

Property itemName As %String(TRUNCATE = 1);

Property itemNum As %String(TRUNCATE = 1);

Property itemOrder As %String(TRUNCATE = 1);

Storage Default
{
<Data name="itemSummaryDefaultData">
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
</Data>
<DataLocation>^dhc.ca.c.itemSummaryD</DataLocation>
<DefaultData>itemSummaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.itemSummaryD</IdLocation>
<IndexLocation>^dhc.ca.c.itemSummaryI</IndexLocation>
<StreamLocation>^dhc.ca.c.itemSummaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
