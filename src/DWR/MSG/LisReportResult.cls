Class DWR.MSG.LisReportResult Extends (%Persistent, %XML.Adaptor)
{

Parameter XMLNAME = "Result";

Property reportDate As %String;

Property resultValue As %String;

Property flagUpDown As %String;

Storage Default
{
<Data name="LisReportResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>reportDate</Value>
</Value>
<Value name="3">
<Value>resultValue</Value>
</Value>
<Value name="4">
<Value>flagUpDown</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.LisReportResultD</DataLocation>
<DefaultData>LisReportResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.LisReportResultD</IdLocation>
<IndexLocation>^DWR.MSG.LisReportResultI</IndexLocation>
<StreamLocation>^DWR.MSG.LisReportResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
