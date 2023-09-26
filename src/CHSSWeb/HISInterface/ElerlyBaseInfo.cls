Class CHSSWeb.HISInterface.ElerlyBaseInfo Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonRowId As %String(TRUNCATE = 1);

Property ElerlyGrade As %String(TRUNCATE = 1);

Property LifeSupport As %String(TRUNCATE = 1);

Property Nursing As %String(TRUNCATE = 1);

Property Eyesight As %String(TRUNCATE = 1);

Property ToothDeformity As %String(TRUNCATE = 1);

Property Informant As %String(TRUNCATE = 1);

Property Inquirer As %String(TRUNCATE = 1);

Property Recorder As %String(TRUNCATE = 1);

Property DateOfSign As %Date;

Property DateOfInquire As %Date;

Property DateOfRecord As %Date;

Storage Default
{
<Data name="ElerlyBaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfInquire</Value>
</Value>
<Value name="3">
<Value>DateOfRecord</Value>
</Value>
<Value name="4">
<Value>DateOfSign</Value>
</Value>
<Value name="5">
<Value>ElerlyGrade</Value>
</Value>
<Value name="6">
<Value>Eyesight</Value>
</Value>
<Value name="7">
<Value>Informant</Value>
</Value>
<Value name="8">
<Value>Inquirer</Value>
</Value>
<Value name="9">
<Value>LifeSupport</Value>
</Value>
<Value name="10">
<Value>Nursing</Value>
</Value>
<Value name="11">
<Value>PersonRowId</Value>
</Value>
<Value name="12">
<Value>Recorder</Value>
</Value>
<Value name="13">
<Value>ToothDeformity</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HISI6F2.ElerlyBaseInfoD</DataLocation>
<DefaultData>ElerlyBaseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HISI6F2.ElerlyBaseInfoD</IdLocation>
<IndexLocation>^CHSSWeb.HISI6F2.ElerlyBaseInfoI</IndexLocation>
<StreamLocation>^CHSSWeb.HISI6F2.ElerlyBaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
