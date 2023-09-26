/// 诊断
Class DHCCL.Config.Diagnosis Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Diagnosis ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ Required, SqlColumnNumber = 3 ];

Property ICDCode As %String [ SqlColumnNumber = 4 ];

Property ActiveDate As %Date [ SqlColumnNumber = 5 ];

Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

Property ExternalID As %String [ SqlColumnNumber = 7 ];

Index Code On Code [ Unique ];

Index ICD On ICDCode;

Index Ext On ExternalID;

Storage Default
{
<Data name="DiagnosisDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ICDCode</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.DiagnosisD</DataLocation>
<DefaultData>DiagnosisDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.DiagnosisD</IdLocation>
<IndexLocation>^DHCCL.Config.DiagnosisI</IndexLocation>
<StreamLocation>^DHCCL.Config.DiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
