Class DWR.MSG.PatientInfo Extends (%Persistent, %XML.Adaptor)
{

Property admId As %String;

Property patName As %String;

Property patSex As %String;

Property wardDesc As %String;

Property bedCode As %String;

Property patNote As %String;

Property patId As %String;

Property patMedNo As %String;

Property patSexCode As %String;

Property patAge As %String;

Property wardId As %String;

Property departmentId As %String;

Property departmentName As %String;

Property mainDoctorId As %String;

Property mainDoctor As %String;

Property allergies As %String;

Property condition As %String;

Property conditionNum As %String;

Property careLevel As %String;

Property careLevelNum As %String;

Property bloodType As %String;

Property occupation As %String;

Property marital As %String;

Property inDate As %String;

Property inDays As %String;

Property patRegNo As %String;

Property roomNo As %String;

Property isMainDoc As %String;

Storage Default
{
<Data name="PatientInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>admId</Value>
</Value>
<Value name="3">
<Value>patName</Value>
</Value>
<Value name="4">
<Value>patSex</Value>
</Value>
<Value name="5">
<Value>wardDesc</Value>
</Value>
<Value name="6">
<Value>bedCode</Value>
</Value>
<Value name="7">
<Value>note</Value>
</Value>
<Value name="8">
<Value>patNote</Value>
</Value>
<Value name="9">
<Value>patId</Value>
</Value>
<Value name="10">
<Value>patNo</Value>
</Value>
<Value name="11">
<Value>patSexCode</Value>
</Value>
<Value name="12">
<Value>patAge</Value>
</Value>
<Value name="13">
<Value>wardId</Value>
</Value>
<Value name="14">
<Value>departmentId</Value>
</Value>
<Value name="15">
<Value>departmentName</Value>
</Value>
<Value name="16">
<Value>mainDoctorId</Value>
</Value>
<Value name="17">
<Value>mainDoctor</Value>
</Value>
<Value name="18">
<Value>allergies</Value>
</Value>
<Value name="19">
<Value>condition</Value>
</Value>
<Value name="20">
<Value>conditionNum</Value>
</Value>
<Value name="21">
<Value>careLevel</Value>
</Value>
<Value name="22">
<Value>careLevelNum</Value>
</Value>
<Value name="23">
<Value>bloodType</Value>
</Value>
<Value name="24">
<Value>occupation</Value>
</Value>
<Value name="25">
<Value>marital</Value>
</Value>
<Value name="26">
<Value>inDate</Value>
</Value>
<Value name="27">
<Value>inDays</Value>
</Value>
<Value name="28">
<Value>patMedNo</Value>
</Value>
<Value name="29">
<Value>patRegNo</Value>
</Value>
<Value name="30">
<Value>roomNo</Value>
</Value>
<Value name="31">
<Value>isMainDoc</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.PatientInfoD</DataLocation>
<DefaultData>PatientInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.PatientInfoD</IdLocation>
<IndexLocation>^DWR.MSG.PatientInfoI</IndexLocation>
<StreamLocation>^DWR.MSG.PatientInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
