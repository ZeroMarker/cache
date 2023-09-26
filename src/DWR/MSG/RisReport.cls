Class DWR.MSG.RisReport Extends (%Persistent, %XML.Adaptor)
{

Property reportMainTitle As %String;

Property reportSubTitle As %String;

Property patName As %String;

Property sex As %String;

Property age As %String;

Property regNo As %String;

Property admDept As %String;

Property wardDesc As %String;

Property bedCode As %String;

Property studyId As %String;

Property diagnosis As %String;

Property examDept As %String;

Property itemCode As %String;

Property itemDesc As %String;

Property examDescEx As %String;

Property resultDescEx As %String;

Property memoEx As %String;

Property seeDescEx As %String;

Property reportDate As %String;

Property reportDoc As %String;

Property verifyDate As %String;

Property verifyDoc As %String;

Property reportURL As %String;

Property imageURL As %String;

Storage Default
{
<Data name="RisReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>reportMainTitle</Value>
</Value>
<Value name="3">
<Value>reportSubTitle</Value>
</Value>
<Value name="4">
<Value>patName</Value>
</Value>
<Value name="5">
<Value>sex</Value>
</Value>
<Value name="6">
<Value>age</Value>
</Value>
<Value name="7">
<Value>regNo</Value>
</Value>
<Value name="8">
<Value>admDept</Value>
</Value>
<Value name="9">
<Value>wardDesc</Value>
</Value>
<Value name="10">
<Value>bedCode</Value>
</Value>
<Value name="11">
<Value>studyId</Value>
</Value>
<Value name="12">
<Value>diagnosis</Value>
</Value>
<Value name="13">
<Value>examDept</Value>
</Value>
<Value name="14">
<Value>itemCode</Value>
</Value>
<Value name="15">
<Value>itemDesc</Value>
</Value>
<Value name="16">
<Value>examDescEx</Value>
</Value>
<Value name="17">
<Value>resultDescEx</Value>
</Value>
<Value name="18">
<Value>memoEx</Value>
</Value>
<Value name="19">
<Value>seeDescEx</Value>
</Value>
<Value name="20">
<Value>reportDate</Value>
</Value>
<Value name="21">
<Value>reportDoc</Value>
</Value>
<Value name="22">
<Value>verifyDate</Value>
</Value>
<Value name="23">
<Value>verifyDoc</Value>
</Value>
<Value name="24">
<Value>reportURL</Value>
</Value>
<Value name="25">
<Value>imageURL</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.RisReportD</DataLocation>
<DefaultData>RisReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.RisReportD</IdLocation>
<IndexLocation>^DWR.MSG.RisReportI</IndexLocation>
<StreamLocation>^DWR.MSG.RisReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
