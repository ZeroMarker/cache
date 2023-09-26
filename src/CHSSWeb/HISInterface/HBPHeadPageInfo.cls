Class CHSSWeb.HISInterface.HBPHeadPageInfo Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonRowId As %Integer;

Property Intime As %Date;

Property Doctor As %String(TRUNCATE = 1);

Property Nurse As %Integer;

Property StaffInput As %Integer;

Property DateOfInput As %Date;

Property DateOfUpdate As %Date;

Property DiagnoseUnit As %String(TRUNCATE = 1);

Property SmokeInfo As %String(TRUNCATE = 1);

Property DrinkInfo As %String(TRUNCATE = 1);

Property GymInfo As %String(TRUNCATE = 1);

Property DiseaseHistory As %String(TRUNCATE = 1);

Property Weight As %Float;

Property High As %Float;

Property BMI As %Float;

Property DangerousFactor As %String(TRUNCATE = 1);

Property HighPressure As %Numeric;

Property LowPressure As %Numeric;

Property UniteIll As %String(TRUNCATE = 1);

Property SelfCare As %Integer;

Property CaseDiscuss As %String(TRUNCATE = 1);

Property ReasonOfDisc As %String(TRUNCATE = 1);

Property ResultOfDisc As %String(TRUNCATE = 1);

Property Mof As %String(TRUNCATE = 1);

Property CheckOutWay As %String(TRUNCATE = 1);

Property DateOfCheck As %Date;

Property Checker As %String(TRUNCATE = 1);

Storage Default
{
<Data name="HBPHeadPageInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMI</Value>
</Value>
<Value name="3">
<Value>CaseDiscuss</Value>
</Value>
<Value name="4">
<Value>CheckOutWay</Value>
</Value>
<Value name="5">
<Value>Checker</Value>
</Value>
<Value name="6">
<Value>DangerousFactor</Value>
</Value>
<Value name="7">
<Value>DateOfCheck</Value>
</Value>
<Value name="8">
<Value>DateOfInput</Value>
</Value>
<Value name="9">
<Value>DateOfUpdate</Value>
</Value>
<Value name="10">
<Value>DiagnoseUnit</Value>
</Value>
<Value name="11">
<Value>DiseaseHistory</Value>
</Value>
<Value name="12">
<Value>Doctor</Value>
</Value>
<Value name="13">
<Value>DrinkInfo</Value>
</Value>
<Value name="14">
<Value>GymInfo</Value>
</Value>
<Value name="15">
<Value>High</Value>
</Value>
<Value name="16">
<Value>HighPressure</Value>
</Value>
<Value name="17">
<Value>Intime</Value>
</Value>
<Value name="18">
<Value>LowPressure</Value>
</Value>
<Value name="19">
<Value>Mof</Value>
</Value>
<Value name="20">
<Value>Nurse</Value>
</Value>
<Value name="21">
<Value>PersonRowId</Value>
</Value>
<Value name="22">
<Value>ReasonOfDisc</Value>
</Value>
<Value name="23">
<Value>ResultOfDisc</Value>
</Value>
<Value name="24">
<Value>SelfCare</Value>
</Value>
<Value name="25">
<Value>SmokeInfo</Value>
</Value>
<Value name="26">
<Value>StaffInput</Value>
</Value>
<Value name="27">
<Value>UniteIll</Value>
</Value>
<Value name="28">
<Value>Weight</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.HBPHeadPageI555D</DataLocation>
<DefaultData>HBPHeadPageInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.HBPHeadPageI555D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.HBPHeadPageI555I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.HBPHeadPageI555S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
