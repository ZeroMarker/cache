/// Creator: 王赢赢
/// CreatDate: 2009-1-13
/// Description: 科室收入成本收益明细表
Class dhc.ca.cache.report.deptRevenue Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//Projection DetailReport As %Projection.Java(ROOTDIR = "c:\aaa");

Property revenue As %Float;

Property deptName As %String(TRUNCATE = 1);

Property itemName As %String(TRUNCATE = 1);

Property itemAll As %String(TRUNCATE = 1);

Property num As %String(TRUNCATE = 1);

Property orderNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="deptRevenueDefaultData">
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
<Value>revenue</Value>
</Value>
<Value name="7">
<Value>num</Value>
</Value>
<Value name="8">
<Value>orderNum</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.deptRevenueD</DataLocation>
<DefaultData>deptRevenueDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.deptRevenueD</IdLocation>
<IndexLocation>^dhc.ca.c.deptRevenueI</IndexLocation>
<StreamLocation>^dhc.ca.c.deptRevenueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
