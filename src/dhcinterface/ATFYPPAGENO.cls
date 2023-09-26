Class dhcinterface.ATFYPPAGENO Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property WARDSN As %String(TRUNCATE = 1) [ Required ];

Property GROUPNO As %String(TRUNCATE = 1);

Property CONFIRMTIME As %String(TRUNCATE = 1);

Property CONFIRMOPER As %String(TRUNCATE = 1);

Property SUBMITTIME As %String(TRUNCATE = 1);

Property PAGENO As %String(TRUNCATE = 1);

Property FLAG As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ATFYPPAGENODefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CONFIRMOPER</Value>
</Value>
<Value name="3">
<Value>CONFIRMTIME</Value>
</Value>
<Value name="4">
<Value>GROUPNO</Value>
</Value>
<Value name="5">
<Value>SUBMITTIME</Value>
</Value>
<Value name="6">
<Value>WARDSN</Value>
</Value>
<Value name="7">
<Value>FLAG</Value>
</Value>
<Value name="8">
<Value>PAGENO</Value>
</Value>
</Data>
<DataLocation>^dhcinterface.ATFYPPAGENOD</DataLocation>
<DefaultData>ATFYPPAGENODefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcinterface.ATFYPPAGENOD</IdLocation>
<IndexLocation>^dhcinterface.ATFYPPAGENOI</IndexLocation>
<StreamLocation>^dhcinterface.ATFYPPAGENOS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
