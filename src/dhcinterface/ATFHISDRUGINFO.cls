Class dhcinterface.ATFHISDRUGINFO Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property DRUGCODE As %String(TRUNCATE = 1);

Property DRUGNAME As %String(TRUNCATE = 1);

Property SPECIFICATION As %String(TRUNCATE = 1);

Property PACKNAME As %String(TRUNCATE = 1);

Property MANUFACTORY As %String(TRUNCATE = 1);

Property PYCODE As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ATFHISDRUGINFODefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DRUGCODE</Value>
</Value>
<Value name="3">
<Value>DRUGNAME</Value>
</Value>
<Value name="4">
<Value>MANUFACTORY</Value>
</Value>
<Value name="5">
<Value>PACKNAME</Value>
</Value>
<Value name="6">
<Value>PYCODE</Value>
</Value>
<Value name="7">
<Value>SPECIFICATION</Value>
</Value>
</Data>
<DataLocation>^dhcinterface.ATFHISDRUGINFOD</DataLocation>
<DefaultData>ATFHISDRUGINFODefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcinterface.ATFHISDRUGINFOD</IdLocation>
<IndexLocation>^dhcinterface.ATFHISDRUGINFOI</IndexLocation>
<StreamLocation>^dhcinterface.ATFHISDRUGINFOS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
