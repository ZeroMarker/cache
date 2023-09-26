Class dhc.ca.cache.udata.uDeptIncomeObj Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property fdept As %String(TRUNCATE = 1);

Property item As %String(TRUNCATE = 1);

Property tdept As %String(TRUNCATE = 1);

Property money As %Float;

Storage Default
{
<Data name="uDeptIncomeObjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>fdept</Value>
</Value>
<Value name="3">
<Value>item</Value>
</Value>
<Value name="4">
<Value>money</Value>
</Value>
<Value name="5">
<Value>tdept</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uDeptIncomeObjD</DataLocation>
<DefaultData>uDeptIncomeObjDefaultData</DefaultData>
<IdLocation>^dhc.ca.c.uDeptIncomeObjD</IdLocation>
<IndexLocation>^dhc.ca.c.uDeptIncomeObjI</IndexLocation>
<StreamLocation>^dhc.ca.c.uDeptIncomeObjS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
