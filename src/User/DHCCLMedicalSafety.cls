Class User.DHCCLMedicalSafety Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLMS_RowId, SqlTableName = DHC_CL_MedicalSafety, StorageStrategy = CacheStorage ]
{

Index Date On CLMSDate As Exact;

Index ADM On CLMSADMDr As Exact;

Index OPA On CLMSOPADr As Exact;

Index ICUA On CLMSICUADr As Exact;

Index BPA On CLMSBPADr;

Property CLMSDate As %Date [ SqlColumnNumber = 2, SqlFieldName = CLMS_Date ];

Property CLMSTime As %Time [ SqlColumnNumber = 3, SqlFieldName = CLMS_Time ];

Property CLMSADMDr As %String [ SqlColumnNumber = 4, SqlFieldName = CLMS_ADM_Dr ];

Property CLMSOPADr As %String [ SqlColumnNumber = 5, SqlFieldName = CLMS_OPA_Dr ];

Property CLMSICUADr As %String [ SqlColumnNumber = 6, SqlFieldName = CLMS_ICUA_Dr ];

Property CLMSBPADr As %String [ SqlColumnNumber = 7, SqlFieldName = CLMS_BPA_Dr ];

Property CLMSCLCMSDr As User.DHCCLCMedicalSafety [ SqlColumnNumber = 8, SqlFieldName = CLMS_CLCMS_Dr ];

Property CLMSCTLOCDr As %String [ SqlColumnNumber = 9, SqlFieldName = CLMS_CTLOC_Dr ];

Property CLMSStatus As %String(DISPLAYLIST = ",Normal,Audit", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 10, SqlFieldName = CLMS_Status ];

Property CLMSNote As %String [ SqlColumnNumber = 11, SqlFieldName = CLMS_Note ];

Property CLMSEffect As %String [ SqlColumnNumber = 12, SqlFieldName = CLMS_Effect ];

Property CLMSCreateUserDr As %String [ SqlColumnNumber = 13, SqlFieldName = CLMS_CreateUser_Dr ];

Property CLMSCreateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = CLMS_CreateDate ];

Property CLMSCreateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = CLMS_CreateTime ];

Storage CacheStorage
{
<Data name="DHCCLMedicalSafetyClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLMedicalSafetyDefaultData">
<Value name="1">
<Value>CLMSDate</Value>
</Value>
<Value name="2">
<Value>CLMSTime</Value>
</Value>
<Value name="3">
<Value>CLMSADMDr</Value>
</Value>
<Value name="4">
<Value>CLMSOPADr</Value>
</Value>
<Value name="5">
<Value>CLMSICUADr</Value>
</Value>
<Value name="6">
<Value>CLMSBPADr</Value>
</Value>
<Value name="7">
<Value>CLMSCLCMSDr</Value>
</Value>
<Value name="8">
<Value>CLMSCTLOCDr</Value>
</Value>
<Value name="9">
<Value>CLMSStatus</Value>
</Value>
<Value name="10">
<Value>CLMSNote</Value>
</Value>
<Value name="11">
<Value>CLMSEffect</Value>
</Value>
<Value name="12">
<Value>CLMSCreateUserDr</Value>
</Value>
<Value name="13">
<Value>CLMSCreateDate</Value>
</Value>
<Value name="14">
<Value>CLMSCreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCCLMedicalSafety</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLMedicalSafety</IdLocation>
<IndexLocation>^DHCCLMedicalSafety(0)</IndexLocation>
<SqlTableNumber>1</SqlTableNumber>
<StreamLocation>^User.DHCCLMedicalSafetyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
