Class dhc.ca.cache.report.MedicalTechnologyGains Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//金额

Property money As %Float;

//金额类别

Property type As %String(TRUNCATE = 1);

//科室名称

Property deptName As %String(TRUNCATE = 1);

//科室层级

Property deptLevel As %String(TRUNCATE = 1);

//科室顺序

Property deptOrder As %String(TRUNCATE = 1);

//月份

Property month As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MedicalTechnologyGainsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>deptLevel</Value>
</Value>
<Value name="3">
<Value>deptName</Value>
</Value>
<Value name="4">
<Value>deptOrder</Value>
</Value>
<Value name="5">
<Value>money</Value>
</Value>
<Value name="6">
<Value>type</Value>
</Value>
<Value name="7">
<Value>month</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cach70D.MedicalTechn8BDD</DataLocation>
<DefaultData>MedicalTechnologyGainsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cach70D.MedicalTechn8BDD</IdLocation>
<IndexLocation>^dhc.ca.cach70D.MedicalTechn8BDI</IndexLocation>
<StreamLocation>^dhc.ca.cach70D.MedicalTechn8BDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
