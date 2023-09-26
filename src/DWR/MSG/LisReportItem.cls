Class DWR.MSG.LisReportItem Extends (%Persistent, %XML.Adaptor)
{

Property serialNo As %String;

Property itemCode As %String;

Property itemDesc As %String;

Property abbreviation As %String;

Property result As %String;

Property resultValue As %String;

Property unit As %String;

Property flagUpDown As %String;

Property naturalRange As %String;

Property reportDate As %String;

Property reportTime As %String;

Property resultList As list Of DWR.MSG.LisReportResult(XMLNAME = "resultList");

Storage Default
{
<Data name="LisReportItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>serialNo</Value>
</Value>
<Value name="3">
<Value>itemCode</Value>
</Value>
<Value name="4">
<Value>itemDesc</Value>
</Value>
<Value name="5">
<Value>abbreviation</Value>
</Value>
<Value name="6">
<Value>result</Value>
</Value>
<Value name="7">
<Value>resultValue</Value>
</Value>
<Value name="8">
<Value>unit</Value>
</Value>
<Value name="9">
<Value>flagUpDown</Value>
</Value>
<Value name="10">
<Value>naturalRange</Value>
</Value>
<Value name="11">
<Value>reportDate</Value>
</Value>
<Value name="12">
<Value>reportTime</Value>
</Value>
<Value name="13">
<Value>resultList</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.LisReportItemD</DataLocation>
<DefaultData>LisReportItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.LisReportItemD</IdLocation>
<IndexLocation>^DWR.MSG.LisReportItemI</IndexLocation>
<StreamLocation>^DWR.MSG.LisReportItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
