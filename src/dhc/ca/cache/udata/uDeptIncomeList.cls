Class dhc.ca.cache.udata.uDeptIncomeList Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property deptIncomeList As list Of dhc.ca.cache.udata.uDeptIncomeObj(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "EXPLICIT");

Storage Default
{
<Data name="uDeptIncomeListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>uDeptIncomeList</Value>
</Value>
<Value name="3">
<Value>deptIncomeList</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uDeptIncomeListD</DataLocation>
<DefaultData>uDeptIncomeListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uDeptIncomeListD</IdLocation>
<IndexLocation>^dhc.ca.c.uDeptIncomeListI</IndexLocation>
<StreamLocation>^dhc.ca.c.uDeptIncomeListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
