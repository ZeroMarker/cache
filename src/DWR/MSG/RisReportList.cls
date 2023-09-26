Class DWR.MSG.RisReportList Extends (%Persistent, %XML.Adaptor)
{

Property ordItemId As %String;

Property ordItemDesc As %String;

Property ordStatus As %String;

Property ordDate As %String;

Property ordTime As %String;

Property reportUser As %String;

Property reportDate As %String;

Property reportTime As %String;

Property recDeparment As %String;

Property risRegId As %String;

Property studyId As %String;

Property reportStatus As %String;

Storage Default
{
<Data name="RisReportListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ordItemId</Value>
</Value>
<Value name="3">
<Value>ordItemDesc</Value>
</Value>
<Value name="4">
<Value>ordStatus</Value>
</Value>
<Value name="5">
<Value>ordStartDate</Value>
</Value>
<Value name="6">
<Value>ordStartTime</Value>
</Value>
<Value name="7">
<Value>reportUser</Value>
</Value>
<Value name="8">
<Value>reportDate</Value>
</Value>
<Value name="9">
<Value>reportTime</Value>
</Value>
<Value name="10">
<Value>recDeparment</Value>
</Value>
<Value name="11">
<Value>risRegId</Value>
</Value>
<Value name="12">
<Value>studyId</Value>
</Value>
<Value name="13">
<Value>reportStatus</Value>
</Value>
<Value name="14">
<Value>admId</Value>
</Value>
<Value name="15">
<Value>ordDate</Value>
</Value>
<Value name="16">
<Value>ordTime</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.RisReportListD</DataLocation>
<DefaultData>RisReportListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.RisReportListD</IdLocation>
<IndexLocation>^DWR.MSG.RisReportListI</IndexLocation>
<StreamLocation>^DWR.MSG.RisReportListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
