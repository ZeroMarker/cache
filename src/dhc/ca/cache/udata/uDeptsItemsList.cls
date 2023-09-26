Class dhc.ca.cache.udata.uDeptsItemsList Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property DeptsItemsObj As list Of uDeptsItemsObj(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "EXPLICIT");

Storage Default
{
<Data name="uDeptsItemsListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptsItemsObj</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uDeptsItemsListD</DataLocation>
<DefaultData>uDeptsItemsListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uDeptsItemsListD</IdLocation>
<IndexLocation>^dhc.ca.c.uDeptsItemsListI</IndexLocation>
<StreamLocation>^dhc.ca.c.uDeptsItemsListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
