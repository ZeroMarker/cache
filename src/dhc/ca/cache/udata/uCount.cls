Class dhc.ca.cache.udata.uCount Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property num As %Integer;

Property lev As %Integer;

Storage Default
{
<Data name="uCountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>num</Value>
</Value>
<Value name="3">
<Value>cost</Value>
</Value>
<Value name="4">
<Value>lev</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uCountD</DataLocation>
<DefaultData>uCountDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uCountD</IdLocation>
<IndexLocation>^dhc.ca.c.uCountI</IndexLocation>
<StreamLocation>^dhc.ca.c.uCountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
