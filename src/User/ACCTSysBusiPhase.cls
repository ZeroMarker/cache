Class User.ACCTSysBusiPhase Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_SysBusiPhase ]
{

/// des ref to ACCTSysFun
Property AcctSysBusiTypeDr As ACCTSysBusiType [ SqlFieldName = ACCT_SysBusiType_Dr ];

Property PhaseCode As %Integer [ Required, SqlFieldName = phase_code ];

Property PhaseName As %String(MAXLEN = 40) [ Required, SqlFieldName = phase_name ];

Property WhileSql As %String(MAXLEN = 200) [ Required, SqlFieldName = while_sql ];

Property ConfirmValue As %Integer [ SqlFieldName = confirm_value ];

Property IsSec As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ InitialExpression = 0, Required, SqlFieldName = is_sec ];

Index PKACCTSysBusiPhase On (AcctSysBusiTypeDr, PhaseCode) [ Unique ];

Storage Default
{
<Data name="ACCTSysBusiPhaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcctSysBusiTypeDr</Value>
</Value>
<Value name="3">
<Value>ConfirmValue</Value>
</Value>
<Value name="4">
<Value>IsSec</Value>
</Value>
<Value name="5">
<Value>PhaseId</Value>
</Value>
<Value name="6">
<Value>PhaseName</Value>
</Value>
<Value name="7">
<Value>WhileSql</Value>
</Value>
<Value name="8">
<Value>PhaseCode</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSysBusiPhaseD</DataLocation>
<DefaultData>ACCTSysBusiPhaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSysBusiPhaseD</IdLocation>
<IndexLocation>^User.ACCTSysBusiPhaseI</IndexLocation>
<StreamLocation>^User.ACCTSysBusiPhaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
