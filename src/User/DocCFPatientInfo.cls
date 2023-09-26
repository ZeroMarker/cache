Class User.DocCFPatientInfo Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = DocCFPatientInfo ]
{

Index DisplayItem On DisplayItem;

Index DisplayNum On DisplayNum;

Property DisplayItem As %String(TRUNCATE = 1);

Property Code As %String(MAXLEN = 10000, TRUNCATE = 1);

Property DisplayNum As %Integer;

Property ExecuteCode As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Style As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Link As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Operator As %String(TRUNCATE = 1);

Property OprDate As %String(TRUNCATE = 1);

Property IsActive As %String(TRUNCATE = 1);

Property AdmType As %String(TRUNCATE = 1);

Property HospDr As User.CTHospital;

Storage Default
{
<Data name="DocCFPatientInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DisplayItem</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>DisplayNum</Value>
</Value>
<Value name="5">
<Value>ExecuteCode</Value>
</Value>
<Value name="6">
<Value>Style</Value>
</Value>
<Value name="7">
<Value>Link</Value>
</Value>
<Value name="8">
<Value>Operator</Value>
</Value>
<Value name="9">
<Value>OprDate</Value>
</Value>
<Value name="10">
<Value>IsActive</Value>
</Value>
<Value name="11">
<Value>AdmType</Value>
</Value>
<Value name="12">
<Value>HospDr</Value>
</Value>
</Data>
<DataLocation>^User.DocCFPatientInfoD</DataLocation>
<DefaultData>DocCFPatientInfoDefaultData</DefaultData>
<IdLocation>^User.DocCFPatientInfoD</IdLocation>
<IndexLocation>^User.DocCFPatientInfoI</IndexLocation>
<StreamLocation>^User.DocCFPatientInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
