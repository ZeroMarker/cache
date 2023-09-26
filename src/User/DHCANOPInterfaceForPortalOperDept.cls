Class User.DHCANOPInterfaceForPortalOperDept Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "AllOperatingRoom";

Property operRoomId As %String(TRUNCATE = 1);

//手术科室名称

Property operRoomName As %String(TRUNCATE = 1);

//当日安排手术间数

Property operUsedNum As %String(TRUNCATE = 1);

//当日空闲手术间数

Property operVacancyNum As %String(TRUNCATE = 1);

//当日已完成手术台数

Property operCompletedNum As %String(TRUNCATE = 1);

//当日已完成手术台数

Property operUnfinishedNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCANOPInterfaceForPortalOperDeptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>operId</Value>
</Value>
<Value name="3">
<Value>operState</Value>
</Value>
<Value name="4">
<Value>name</Value>
</Value>
<Value name="5">
<Value>age</Value>
</Value>
<Value name="6">
<Value>sex</Value>
</Value>
<Value name="7">
<Value>bedNo</Value>
</Value>
<Value name="8">
<Value>medicalNo</Value>
</Value>
<Value name="9">
<Value>diagnosis</Value>
</Value>
<Value name="10">
<Value>operName</Value>
</Value>
<Value name="11">
<Value>operDep</Value>
</Value>
<Value name="12">
<Value>surgeonName</Value>
</Value>
<Value name="13">
<Value>firstAssistantName</Value>
</Value>
<Value name="14">
<Value>secondAssistantName</Value>
</Value>
<Value name="15">
<Value>anesthesiaName</Value>
</Value>
<Value name="16">
<Value>nurseName</Value>
</Value>
<Value name="17">
<Value>appointTime</Value>
</Value>
<Value name="18">
<Value>startTime</Value>
</Value>
<Value name="19">
<Value>endTime</Value>
</Value>
<Value name="20">
<Value>OpDate</Value>
</Value>
<Value name="21">
<Value>type</Value>
</Value>
<Value name="22">
<Value>operTotalNum</Value>
</Value>
<Value name="23">
<Value>operNum</Value>
</Value>
<Value name="24">
<Value>operRoomId</Value>
</Value>
<Value name="25">
<Value>operRoomDesc</Value>
</Value>
<Value name="26">
<Value>operRoomName</Value>
</Value>
<Value name="27">
<Value>operUsedNum</Value>
</Value>
<Value name="28">
<Value>operVacancyNum</Value>
</Value>
<Value name="29">
<Value>operCompletedNum</Value>
</Value>
<Value name="30">
<Value>operUnfinishedNum</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPInteDE41D</DataLocation>
<DefaultData>DHCANOPInterfaceForPortalOperDeptDefaultData</DefaultData>
<IdLocation>^User.DHCANOPInteDE41D</IdLocation>
<IndexLocation>^User.DHCANOPInteDE41I</IndexLocation>
<StreamLocation>^User.DHCANOPInteDE41S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
