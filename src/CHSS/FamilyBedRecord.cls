Class CHSS.FamilyBedRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = FaBedRowId, SqlTableName = FamilyBedRecord ]
{

//个人档案主键

Property PersonRowId As CHSS.PersonHealthRecordMain;

//记录时间

Property DateOfRecord As %Date;

//性别

Property SexDR As User.CTSex;

//姓名

Property PersonName As %String;

//出生日期

Property Birth As %Date;

//患者地址

Property Address As %String;

//患者电话

Property PatientPhone As %String;

//联系人姓名

Property LinkManName As %String;

//联系人电话

Property LinkManPhone As %String;

//建床日期

Property BedCreateDate As %Date;

//建床原因

Property BedCreateReason As %String;

//症状

Property Symptom As %String;

//家庭病床状态

Property BedStatus As %String;

//家庭病床类型

Property FaBedType As CHSS.DictFaBedType;

//责任医师

Property Doctor As %String;

//责任护士

Property Nurse As %String;

//建床人员

Property Register As %String;

Storage Default
{
<Data name="FamilyBedRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Address</Value>
</Value>
<Value name="3">
<Value>BedCreateDate</Value>
</Value>
<Value name="4">
<Value>BedCreateReason</Value>
</Value>
<Value name="5">
<Value>BedStatus</Value>
</Value>
<Value name="6">
<Value>Birth</Value>
</Value>
<Value name="7">
<Value>DateOfRecord</Value>
</Value>
<Value name="8">
<Value>Doctor</Value>
</Value>
<Value name="9">
<Value>FaBedType</Value>
</Value>
<Value name="10">
<Value>LinkManName</Value>
</Value>
<Value name="11">
<Value>LinkManPhone</Value>
</Value>
<Value name="12">
<Value>Nurse</Value>
</Value>
<Value name="13">
<Value>PatientPhone</Value>
</Value>
<Value name="14">
<Value>PersonName</Value>
</Value>
<Value name="15">
<Value>PersonRowId</Value>
</Value>
<Value name="16">
<Value>Register</Value>
</Value>
<Value name="17">
<Value>SexDR</Value>
</Value>
<Value name="18">
<Value>Symptom</Value>
</Value>
</Data>
<DataLocation>^CHSS.FamilyBedRecordD</DataLocation>
<DefaultData>FamilyBedRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.FamilyBedRecordD</IdLocation>
<IndexLocation>^CHSS.FamilyBedRecordI</IndexLocation>
<StreamLocation>^CHSS.FamilyBedRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
