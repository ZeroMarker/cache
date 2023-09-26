Class DWR.MSG.LisReportList Extends (%Persistent, %XML.Adaptor)
{

Property ordIndex As %String;

Property ordLabNo As %String;

Property arcItemId As %String;

Property ordItemDesc As %String;

Property ordStatus As %String;

Property ordDate As %String;

Property ordTime As %String;

Property ordLabSpec As %String;

Property recDept As %String;

Property reportStatus As %String;

Property reportUser As %String;

Property reportDate As %String;

Property reportTime As %String;

Property reportNote As %String;

Property reportException As %String;

Storage Default
{
<Data name="LisReportListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ordIndex</Value>
</Value>
<Value name="3">
<Value>ordLabNo</Value>
</Value>
<Value name="4">
<Value>ordItemDesc</Value>
</Value>
<Value name="5">
<Value>ordStatus</Value>
</Value>
<Value name="6">
<Value>ordDate</Value>
</Value>
<Value name="7">
<Value>ordTime</Value>
</Value>
<Value name="8">
<Value>ordLabSpec</Value>
</Value>
<Value name="9">
<Value>recDept</Value>
</Value>
<Value name="10">
<Value>reportStatus</Value>
</Value>
<Value name="11">
<Value>reportUser</Value>
</Value>
<Value name="12">
<Value>reportTime</Value>
</Value>
<Value name="13">
<Value>reportNote</Value>
</Value>
<Value name="14">
<Value>reportDate</Value>
</Value>
<Value name="15">
<Value>arcItemId</Value>
</Value>
<Value name="16">
<Value>reportException</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.LisReportListD</DataLocation>
<DefaultData>LisReportListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.LisReportListD</IdLocation>
<IndexLocation>^DWR.MSG.LisReportListI</IndexLocation>
<StreamLocation>^DWR.MSG.LisReportListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
