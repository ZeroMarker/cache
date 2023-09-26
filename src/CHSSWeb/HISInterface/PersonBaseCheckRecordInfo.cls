Class CHSSWeb.HISInterface.PersonBaseCheckRecordInfo Extends %Persistent
{

Property YearCheckRowId As %String;

Property DateCheck As %Date;

Property CheckDoctor As %String;

Property Symptom As %String;

Property Temperature As %Float;

Property Breath As %Integer;

Property Pulse As %Integer;

Property nHighPressure As %Integer;

Property nLowPressure As %Integer;

Property Weight As %Float;

Property Height As %Float;

Property BMI As %Float;

Property WaistlineStern As %Float;

Property OlderCongnize As %String;

Property OlderCongnizeId As %Integer;

Property OlderCongnizeScore As %String;

Property OlderSensibility As %String;

Property OlderSensibilityId As %Integer;

Property OlderSensibilityScore As %String;

Property LiveQuality As %String;

Property Waist As %String;

Property Saddle As %String;

Storage Default
{
<Data name="PersonBaseCheckRecordInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMI</Value>
</Value>
<Value name="3">
<Value>Breath</Value>
</Value>
<Value name="4">
<Value>CheckDoctor</Value>
</Value>
<Value name="5">
<Value>DateCheck</Value>
</Value>
<Value name="6">
<Value>Height</Value>
</Value>
<Value name="7">
<Value>LiveQuality</Value>
</Value>
<Value name="8">
<Value>OlderCongnize</Value>
</Value>
<Value name="9">
<Value>OlderCongnizeId</Value>
</Value>
<Value name="10">
<Value>OlderCongnizeScore</Value>
</Value>
<Value name="11">
<Value>OlderSensibility</Value>
</Value>
<Value name="12">
<Value>OlderSensibilityId</Value>
</Value>
<Value name="13">
<Value>OlderSensibilityScore</Value>
</Value>
<Value name="14">
<Value>Pulse</Value>
</Value>
<Value name="15">
<Value>Saddle</Value>
</Value>
<Value name="16">
<Value>Symptom</Value>
</Value>
<Value name="17">
<Value>Temperature</Value>
</Value>
<Value name="18">
<Value>Waist</Value>
</Value>
<Value name="19">
<Value>WaistlineStern</Value>
</Value>
<Value name="20">
<Value>Weight</Value>
</Value>
<Value name="21">
<Value>YearCheckRowId</Value>
</Value>
<Value name="22">
<Value>nHighPressure</Value>
</Value>
<Value name="23">
<Value>nLowPressure</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonBaseCh9BBD</DataLocation>
<DefaultData>PersonBaseCheckRecordInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonBaseCh9BBD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonBaseCh9BBI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonBaseCh9BBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
