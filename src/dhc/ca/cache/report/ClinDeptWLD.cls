Class dhc.ca.cache.report.ClinDeptWLD Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DeptName As %String(TRUNCATE = 1);

Property ItemName As %String(TRUNCATE = 1);

Property ItemValue As %Library.Float;

Storage Default
{
<Data name="ClinDeptWLDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptName</Value>
</Value>
<Value name="3">
<Value>ItemName</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>ItemValue</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cache.re70D.ClinDeptWLDD</DataLocation>
<DefaultData>ClinDeptWLDDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cache.re70D.ClinDeptWLDD</IdLocation>
<IndexLocation>^dhc.ca.cache.re70D.ClinDeptWLDI</IndexLocation>
<StreamLocation>^dhc.ca.cache.re70D.ClinDeptWLDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
