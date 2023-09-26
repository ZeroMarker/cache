Class CHSSWeb.Report.PersonHealthRecordReportObj Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonRowId As %Integer;

Property PersonCode As %String(TRUNCATE = 1);

Property PersonName As %String(TRUNCATE = 1);

Property SexName As %String(TRUNCATE = 1);

Property Birth As %Date;

Property RelationHourseHoldName As %String(TRUNCATE = 1);

Property FamilyAddress As %String(TRUNCATE = 1);

Property LinkManPhone As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PersonHealthRecordReportObjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>changeFee</Value>
</Value>
<Value name="3">
<Value>changeRate</Value>
</Value>
<Value name="4">
<Value>curConstitute</Value>
</Value>
<Value name="5">
<Value>curFee</Value>
</Value>
<Value name="6">
<Value>itemName</Value>
</Value>
<Value name="7">
<Value>preConstitute</Value>
</Value>
<Value name="8">
<Value>preFee</Value>
</Value>
<Value name="9">
<Value>Birth</Value>
</Value>
<Value name="10">
<Value>FamilyAddress</Value>
</Value>
<Value name="11">
<Value>LinkManPhone</Value>
</Value>
<Value name="12">
<Value>PersonCode</Value>
</Value>
<Value name="13">
<Value>PersonName</Value>
</Value>
<Value name="14">
<Value>PersonRowId</Value>
</Value>
<Value name="15">
<Value>SexName</Value>
</Value>
<Value name="16">
<Value>RelationHourseHoldName</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Rep4F9.PersonHealthAC3D</DataLocation>
<DefaultData>PersonHealthRecordReportObjDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.Rep4F9.PersonHealthAC3D</IdLocation>
<IndexLocation>^CHSSWeb.Rep4F9.PersonHealthAC3I</IndexLocation>
<StreamLocation>^CHSSWeb.Rep4F9.PersonHealthAC3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
