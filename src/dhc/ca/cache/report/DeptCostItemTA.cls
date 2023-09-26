Class dhc.ca.cache.report.DeptCostItemTA Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MonthName As %String(TRUNCATE = 1);

Property ItemName As %String(TRUNCATE = 1);

Property ItemValue As %Library.Float;

Storage Default
{
<Data name="DeptCostItemTADefaultData">
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
<DataLocation>^dhc.ca.cache70D.DeptCostItemTAD</DataLocation>
<DefaultData>DeptCostItemTADefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cache70D.DeptCostItemTAD</IdLocation>
<IndexLocation>^dhc.ca.cache70D.DeptCostItemTAI</IndexLocation>
<StreamLocation>^dhc.ca.cache70D.DeptCostItemTAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
