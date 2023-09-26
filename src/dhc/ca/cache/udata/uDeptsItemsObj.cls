Class dhc.ca.cache.udata.uDeptsItemsObj Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property Dept As %String(TRUNCATE = 1);

Property Item As %String(TRUNCATE = 1);

Property Money As %Float;

Storage Default
{
<Data name="uDeptsItemsObjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Dept</Value>
</Value>
<Value name="3">
<Value>Item</Value>
</Value>
<Value name="4">
<Value>Money</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uDeptsItemsObjD</DataLocation>
<DefaultData>uDeptsItemsObjDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uDeptsItemsObjD</IdLocation>
<IndexLocation>^dhc.ca.c.uDeptsItemsObjI</IndexLocation>
<StreamLocation>^dhc.ca.c.uDeptsItemsObjS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
