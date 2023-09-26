Class CHSS.PatientActivate Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = PatientRowId, SqlTableName = PatientActivate ]
{

Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

//最近使用时间

Property PersonCode As %String(MAXLEN = 30, TRUNCATE = 1);

Property PatientCode As %String(MAXLEN = 50, TRUNCATE = 1);

Property PatientName As %String(MAXLEN = 50, TRUNCATE = 1);

Property SpellCode As %String(MAXLEN = 20, TRUNCATE = 1);

Property Sex As %Integer;

Property RegisterDate As %Date;

Property Remark As %String(MAXLEN = 60, TRUNCATE = 1);

Property bValidFlag As %String(MAXLEN = 5, TRUNCATE = 1);

Property NearUseDate As %Date;

Index PersonRowIdParrefIndex On PersonRowId;

Storage Default
{
<Data name="PatientActivateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NearUseDate</Value>
</Value>
<Value name="3">
<Value>PatientCode</Value>
</Value>
<Value name="4">
<Value>PatientName</Value>
</Value>
<Value name="5">
<Value>PatientRowId</Value>
</Value>
<Value name="6">
<Value>PersonCode</Value>
</Value>
<Value name="7">
<Value>PersonRowId</Value>
</Value>
<Value name="8">
<Value>RegisterDate</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>Sex</Value>
</Value>
<Value name="11">
<Value>SpellCode</Value>
</Value>
<Value name="12">
<Value>bValidFlag</Value>
</Value>
</Data>
<DataLocation>^CHSS.PatientActivateD</DataLocation>
<DefaultData>PatientActivateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PatientActivateD</IdLocation>
<IndexLocation>^CHSS.PatientActivateI</IndexLocation>
<StreamLocation>^CHSS.PatientActivateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
