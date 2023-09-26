Class DWR.MSG.Diagnosis Extends (%Persistent, %XML.Adaptor)
{

Property diaId As %String;

Property diaDesc As %String;

Property diaNote As %String;

Property diaDoctor As %String;

Property diaDate As %String;

Property diaTime As %String;

Property diaType As %String;

Storage Default
{
<Data name="DiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>diaId</Value>
</Value>
<Value name="3">
<Value>diaDesc</Value>
</Value>
<Value name="4">
<Value>diaNote</Value>
</Value>
<Value name="5">
<Value>diaDoctor</Value>
</Value>
<Value name="6">
<Value>diaDate</Value>
</Value>
<Value name="7">
<Value>diaTime</Value>
</Value>
<Value name="8">
<Value>diaType</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.DiagnosisD</DataLocation>
<DefaultData>DiagnosisDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.DiagnosisD</IdLocation>
<IndexLocation>^DWR.MSG.DiagnosisI</IndexLocation>
<StreamLocation>^DWR.MSG.DiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
