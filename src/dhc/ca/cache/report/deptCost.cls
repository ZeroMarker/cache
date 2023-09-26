/// Creator: 王赢赢
/// CreatDate: 2009-1-7
/// Description: 科室收入成本收益明细表
Class dhc.ca.cache.report.deptCost Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//Projection DetailReport As %Projection.Java(ROOTDIR = "c:\aaa");

Property cost As %String(TRUNCATE = 1);

Property deptName As %String(TRUNCATE = 1);

Property itemName As %String(TRUNCATE = 1);

Property itemAll As %String(TRUNCATE = 1);

Property num As %String(TRUNCATE = 1);

Property orderNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="deptCostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>cost</Value>
</Value>
<Value name="3">
<Value>deptName</Value>
</Value>
<Value name="4">
<Value>itemAll</Value>
</Value>
<Value name="5">
<Value>itemName</Value>
</Value>
<Value name="6">
<Value>num</Value>
</Value>
<Value name="7">
<Value>orderNum</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.deptCostD</DataLocation>
<DefaultData>deptCostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.deptCostD</IdLocation>
<IndexLocation>^dhc.ca.c.deptCostI</IndexLocation>
<StreamLocation>^dhc.ca.c.deptCostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
