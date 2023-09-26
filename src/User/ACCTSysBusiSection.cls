Class User.ACCTSysBusiSection Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_SysBusiSection ]
{

/// des ref to ACCTSysBusiPhase
Property AcctSysBusiPhaseDr As ACCTSysBusiPhase [ SqlFieldName = ACCT_SysBusiPhase_Dr ];

Property SecId As %Integer [ Required, SqlFieldName = sec_id ];

Property SecName As %String(MAXLEN = 40) [ Required, SqlFieldName = sec_name ];

Index PKACCTSysBusiSection On (AcctSysBusiPhaseDr, SecId) [ Unique ];

Storage Default
{
<Data name="ACCTSysBusiSectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctSysBusiPhaseDr</Value>
</Value>
<Value name="3">
<Value>SecId</Value>
</Value>
<Value name="4">
<Value>SecName</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSysBusiSectionD</DataLocation>
<DefaultData>ACCTSysBusiSectionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSysBusiSectionD</IdLocation>
<IndexLocation>^User.ACCTSysBusiSectionI</IndexLocation>
<StreamLocation>^User.ACCTSysBusiSectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
