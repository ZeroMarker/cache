Class DWR.MSG.Frequency Extends (%Persistent, %XML.Adaptor)
{

Property freqId As %String;

Property freqDesc As %String;

Storage Default
{
<Data name="FrequencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>freqId</Value>
</Value>
<Value name="3">
<Value>freqDesc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.FrequencyD</DataLocation>
<DefaultData>FrequencyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.FrequencyD</IdLocation>
<IndexLocation>^DWR.MSG.FrequencyI</IndexLocation>
<StreamLocation>^DWR.MSG.FrequencyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
