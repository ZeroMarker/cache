Class dhc.ca.cache.report.DeptIncomeItemTA Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MonthName As %String(TRUNCATE = 1);

Property ItemName As %String(TRUNCATE = 1);

Property ItemValue As %Library.Float;

Storage Default
{
<Data name="DeptIncomeItemTADefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemName</Value>
</Value>
<Value name="3">
<Value>MonthName</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>ItemValue</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cach70D.DeptIncomeIt60CD</DataLocation>
<DefaultData>DeptIncomeItemTADefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cach70D.DeptIncomeIt60CD</IdLocation>
<IndexLocation>^dhc.ca.cach70D.DeptIncomeIt60CI</IndexLocation>
<StreamLocation>^dhc.ca.cach70D.DeptIncomeIt60CS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
