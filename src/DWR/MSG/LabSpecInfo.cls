Class DWR.MSG.LabSpecInfo Extends (%Persistent, %XML.Adaptor)
{

Parameter XMLNAME = "LabSpec";

Property labSpec As %String;

Property labSpecCode As %String;

Property labCont As %String;

Property labContCode As %String;

Storage Default
{
<Data name="LabSpecInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>labSpec</Value>
</Value>
<Value name="3">
<Value>labSpecCode</Value>
</Value>
<Value name="4">
<Value>labCont</Value>
</Value>
<Value name="5">
<Value>labContCode</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.LabSpecInfoD</DataLocation>
<DefaultData>LabSpecInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.LabSpecInfoD</IdLocation>
<IndexLocation>^DWR.MSG.LabSpecInfoI</IndexLocation>
<StreamLocation>^DWR.MSG.LabSpecInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
