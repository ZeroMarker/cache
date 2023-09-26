Class dhc.ca.cache.report.CheckBlance Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

//核算成本

Property checkCost As %Float;

//核算收入

Property checkIncome As %Float;

//结余

Property checkBlance As %Float;

//科室

Property deptName As %String(TRUNCATE = 1);

//科室级别

Property deptNum As %String(TRUNCATE = 1);

//科室顺序

Property deptOrder As %String(TRUNCATE = 1);

//月份

Property month As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CheckBlanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>checkBlance</Value>
</Value>
<Value name="3">
<Value>checkCost</Value>
</Value>
<Value name="4">
<Value>checkIncome</Value>
</Value>
<Value name="5">
<Value>deptName</Value>
</Value>
<Value name="6">
<Value>deptNum</Value>
</Value>
<Value name="7">
<Value>deptOrder</Value>
</Value>
<Value name="8">
<Value>month</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cache.re70D.CheckBlanceD</DataLocation>
<DefaultData>CheckBlanceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cache.re70D.CheckBlanceD</IdLocation>
<IndexLocation>^dhc.ca.cache.re70D.CheckBlanceI</IndexLocation>
<StreamLocation>^dhc.ca.cache.re70D.CheckBlanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
