Class User.DHCBPTreatment Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BP_Treatment, StorageStrategy = CacheStorage ]
{

Index BPA On BPTBPADr As Exact;

Property BPTBPADr As User.DHCBPArrange [ SqlColumnNumber = 2, SqlFieldName = BPT_BPA_Dr ];

Property BPTBPCTDr As User.DHCBPCTreatment [ SqlColumnNumber = 3, SqlFieldName = BPT_BPCT_Dr ];

Property BPTDate As %Date [ SqlColumnNumber = 4, SqlFieldName = BPT_Date ];

Property BPTTime As %Time [ SqlColumnNumber = 5, SqlFieldName = BPT_Time ];

Property BPTSymptom As %String(MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = BPT_Symptom ];

Property BPTTreatment As %String(MAXLEN = 200) [ SqlColumnNumber = 7, SqlFieldName = BPT_Treatment ];

Property BPTStatus As %String(DISPLAYLIST = ",Normal,Cancel", VALUELIST = ",N,C") [ SqlColumnNumber = 8, SqlFieldName = BPT_Status ];

Property BPTUpdateUserDr As %String [ SqlColumnNumber = 9, SqlFieldName = BPT_UpdateUser_Dr ];

Property BPTUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = BPT_UpdateDate ];

Property BPTUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = BPT_UpdateTime ];

Property BPTAdjustmentReason As %String(MAXLEN = 200) [ SqlColumnNumber = 12, SqlFieldName = BPT_AdjustmentReason ];

Storage CacheStorage
{
<Data name="DHCBPTreatmentClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPTreatmentDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPTBPADr</Value>
</Value>
<Value name="2">
<Value>BPTBPCTDr</Value>
</Value>
<Value name="3">
<Value>BPTDate</Value>
</Value>
<Value name="4">
<Value>BPTTime</Value>
</Value>
<Value name="5">
<Value>BPTSymptom</Value>
</Value>
<Value name="6">
<Value>BPTTreatment</Value>
</Value>
<Value name="7">
<Value>BPTStatus</Value>
</Value>
<Value name="8">
<Value>BPTUpdateUserDr</Value>
</Value>
<Value name="9">
<Value>BPTUpdateDate</Value>
</Value>
<Value name="10">
<Value>BPTUpdateTime</Value>
</Value>
<Value name="11">
<Value>BPTAdjustmentReason</Value>
</Value>
</Data>
<DataLocation>^DHCBPTreatment</DataLocation>
<IdLocation>^DHCBPTreatment</IdLocation>
<IndexLocation>^DHCBPTreatment(0)</IndexLocation>
<SqlRowIdName>BPT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBPTreatmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
