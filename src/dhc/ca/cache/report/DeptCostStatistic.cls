Class dhc.ca.cache.report.DeptCostStatistic Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//金额

Property money As %Float;

//金额类别

Property deptOrder As %String(TRUNCATE = 1);

//项目类别

Property itemNum As %String(TRUNCATE = 1);

//科室类别

Property deptNum As %String(TRUNCATE = 1);

//项目

Property itemName As %String(TRUNCATE = 1);

//科室

Property deptName As %String(TRUNCATE = 1);

//月份名称

Property monthName As %String(TRUNCATE = 1);

//月份

Property month As %String(TRUNCATE = 1);

Property itemOrder As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DeptCostStatisticDefaultData">
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
<Value>monthName</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.DeptCostStatisticD</DataLocation>
<DefaultData>DeptCostStatisticDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.DeptCostStatisticD</IdLocation>
<IndexLocation>^dhc.ca.c.DeptCostStatisticI</IndexLocation>
<StreamLocation>^dhc.ca.c.DeptCostStatisticS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
