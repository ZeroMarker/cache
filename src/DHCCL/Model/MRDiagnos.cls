Class DHCCL.Model.MRDiagnos Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = MRDiagnos ]
{

Property MRAdm As DHCCL.Model.MRAdm [ Required, SqlColumnNumber = 2 ];

Property ICDCode As DHCCL.Config.Diagnosis [ SqlColumnNumber = 3 ];

Property Doctor As DHCCL.Config.CareProvider [ SqlColumnNumber = 4 ];

Property Description As %String [ SqlColumnNumber = 5 ];

Property DiagnosDate As %Date [ SqlColumnNumber = 6 ];

Property DiagnosTime As %Time [ SqlColumnNumber = 7 ];

Property Status As %String [ SqlColumnNumber = 8 ];

Property MainDiagnos As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

Property ExternalID As %String [ SqlColumnNumber = 10 ];

Index Adm On MRAdm;

Index Ext On ExternalID;

Storage Default
{
<Data name="MRDiagnosDefaultData">
<Value name="1">
<Value>MRAdm</Value>
</Value>
<Value name="2">
<Value>ICDCode</Value>
</Value>
<Value name="3">
<Value>Doctor</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>DiagnosDate</Value>
</Value>
<Value name="6">
<Value>DiagnosTime</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>MainDiagnos</Value>
</Value>
<Value name="9">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.MRDiagnosD</DataLocation>
<DefaultData>MRDiagnosDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.MRDiagnosD</IdLocation>
<IndexLocation>^DHCCL.Model.MRDiagnosI</IndexLocation>
<StreamLocation>^DHCCL.Model.MRDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
