Class User.DHCBPDiagnos Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BP_Diagnos, StorageStrategy = CacheStorage ]
{

Index BPPReg On BPDBPPRDr As Exact;

Property BPDBPPRDr As User.DHCBPPatRegister [ Required, SqlColumnNumber = 2, SqlFieldName = BPD_BPPR_Dr ];

Property BPDICDDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPD_ICD_Dr ];

Property BPDDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BPD_Desc ];

Property BPDType As %String(DISPLAYLIST = ",Main,Sub,Other", MAXLEN = 5, SELECTIVITY = "25%", VALUELIST = ",M,S,O") [ SqlColumnNumber = 5, SqlFieldName = BPD_Type ];

Property BPDCtcpDr As %String [ SqlColumnNumber = 6, SqlFieldName = BPD_Ctcp_Dr ];

Property BPDDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BPD_Date ];

Property BPDTime As %Time [ SqlColumnNumber = 8, SqlFieldName = BPD_Time ];

Property BPDIfAbandon As %String [ SqlColumnNumber = 9, SqlFieldName = BPD_IfAbandon ];

Storage CacheStorage
{
<Data name="DHCBPDiagnosClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPDiagnosDefaultData">
<Value name="1">
<Value>BPDBPPRDr</Value>
</Value>
<Value name="2">
<Value>BPDICDDr</Value>
</Value>
<Value name="3">
<Value>BPDDesc</Value>
</Value>
<Value name="4">
<Value>BPDType</Value>
</Value>
<Value name="5">
<Value>BPDCtcpDr</Value>
</Value>
<Value name="6">
<Value>BPDDate</Value>
</Value>
<Value name="7">
<Value>BPDTime</Value>
</Value>
<Value name="8">
<Value>BPDIfAbandon</Value>
</Value>
</Data>
<DataLocation>^DHCBPDiagnos</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPDiagnos</IdLocation>
<IndexLocation>^DHCBPDiagnos(0)</IndexLocation>
<StreamLocation>^User.DHCBPDiagnosS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
