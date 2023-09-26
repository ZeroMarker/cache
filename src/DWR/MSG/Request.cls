Class DWR.MSG.Request Extends (%Persistent, %XML.Adaptor)
{

Property userCode As %String;

Property password As %String;

Property terminalId As %String;

Property padIP As %String;

Property departmentId As %String;

Property admId As %String;

Property startDate As %String;

Property endDate As %String;

Property orderState As %String;

Property labNo As %String;

Property studyId As %String;

Property netWorkType As %String;

Property itemCode As %String;

Property arcItemId As %String;

Property ordLabNo As %String;

Property groupId As %String;

Property tabId As %String;

Property subTabId As %String;

Property arcQty As %String;

Property recLocId As %String;

Property firstTimes As %String;

Property masterSeqNo As %String;

Property priorId As %String;

Property ordStartDate As %String;

Property ordStartTime As %String;

Property ordNote As %String;

Property doseQty As %String;

Property doseUomId As %String;

Property freqId As %String;

Property instrId As %String;

Property skinTest As %String;

Property skinActId As %String;

Property packQty As %String;

Property showIndex As %String;

Property diagCode As %String;

Property diagICDId As %String;

Property diagTypeId As %String;

Property diagStatId As %String;

Property diagNote As %String;

Property diagId As %String;

Property ordItemId As %String;

Property anntibId As %String;

Property eventSource As %String;

Storage Default
{
<Data name="RequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>userCode</Value>
</Value>
<Value name="3">
<Value>password</Value>
</Value>
<Value name="4">
<Value>terminalId</Value>
</Value>
<Value name="5">
<Value>padIP</Value>
</Value>
<Value name="6">
<Value>departmentId</Value>
</Value>
<Value name="7">
<Value>admId</Value>
</Value>
<Value name="8">
<Value>startDate</Value>
</Value>
<Value name="9">
<Value>endDate</Value>
</Value>
<Value name="10">
<Value>orderState</Value>
</Value>
<Value name="11">
<Value>labNo</Value>
</Value>
<Value name="12">
<Value>studyId</Value>
</Value>
<Value name="13">
<Value>netWorkType</Value>
</Value>
<Value name="14">
<Value>itemCode</Value>
</Value>
<Value name="15">
<Value>arcItemId</Value>
</Value>
<Value name="16">
<Value>ordLabNo</Value>
</Value>
<Value name="17">
<Value>groupId</Value>
</Value>
<Value name="18">
<Value>tabId</Value>
</Value>
<Value name="19">
<Value>subTabId</Value>
</Value>
<Value name="20">
<Value>arcQty</Value>
</Value>
<Value name="21">
<Value>recLocId</Value>
</Value>
<Value name="22">
<Value>firstTimes</Value>
</Value>
<Value name="23">
<Value>msterSeqNo</Value>
</Value>
<Value name="24">
<Value>priorId</Value>
</Value>
<Value name="25">
<Value>ordStartDate</Value>
</Value>
<Value name="26">
<Value>ordStartTime</Value>
</Value>
<Value name="27">
<Value>ordNote</Value>
</Value>
<Value name="28">
<Value>doseQty</Value>
</Value>
<Value name="29">
<Value>doseUomId</Value>
</Value>
<Value name="30">
<Value>freqId</Value>
</Value>
<Value name="31">
<Value>instrId</Value>
</Value>
<Value name="32">
<Value>skinTest</Value>
</Value>
<Value name="33">
<Value>skinActId</Value>
</Value>
<Value name="34">
<Value>packQty</Value>
</Value>
<Value name="35">
<Value>showIndex</Value>
</Value>
<Value name="36">
<Value>masterSeqNo</Value>
</Value>
<Value name="37">
<Value>diagCode</Value>
</Value>
<Value name="38">
<Value>diagICDId</Value>
</Value>
<Value name="39">
<Value>diagTypeDesc</Value>
</Value>
<Value name="40">
<Value>diagStatDesc</Value>
</Value>
<Value name="41">
<Value>diagNote</Value>
</Value>
<Value name="42">
<Value>diagId</Value>
</Value>
<Value name="43">
<Value>ordItemId</Value>
</Value>
<Value name="44">
<Value>diagTypeId</Value>
</Value>
<Value name="45">
<Value>diagStatId</Value>
</Value>
<Value name="46">
<Value>anntibId</Value>
</Value>
<Value name="47">
<Value>event</Value>
</Value>
<Value name="48">
<Value>eventSource</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.RequestD</DataLocation>
<DefaultData>RequestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.RequestD</IdLocation>
<IndexLocation>^DWR.MSG.RequestI</IndexLocation>
<StreamLocation>^DWR.MSG.RequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
