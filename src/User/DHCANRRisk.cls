Class User.DHCANRRisk Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANRR_RowId, SqlTableName = DHC_ANR_Risk, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCANRCheck As User.DHCANRCheck [ Cardinality = children, Inverse = ANRCParref ];

Relationship ChildDHCANROperComplication As User.DHCANROperComplication [ Cardinality = children, Inverse = ANROCParref ];

Property ANRRAdmDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANRR_Adm_Dr ];

Property ANRROpaDr As User.DHCANOPArrange [ SqlColumnNumber = 3, SqlFieldName = ANRR_Opa_Dr ];

Property ANRRCtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = ANRR_Ctloc_Dr ];

Property ANRRDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ANRR_Date ];

Property ANRRTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ANRR_Time ];

Property ANRRStatus As %String(DISPLAYLIST = ",Initial,Assess,Check,Audit,UnAudit,Delete,Finish", MAXLEN = 12, SELECTIVITY = "12.5%", VALUELIST = ",I,S,C,A,U,D,F") [ SqlColumnNumber = 7, SqlFieldName = ANRR_Status ];

Property ANRROperationDr As %String [ SqlColumnNumber = 8, SqlFieldName = ANRR_Operation_Dr ];

Property ANRROperDiffcultyDr As %String [ SqlColumnNumber = 9, SqlFieldName = ANRR_OperDiffculty_Dr ];

Property ANRRAsaDr As %String [ SqlColumnNumber = 10, SqlFieldName = ANRR_Asa_Dr ];

Property ANRRAnrcrcDr As User.DHCANRCRiskClass [ SqlColumnNumber = 11, SqlFieldName = ANRR_Anrcrc_Dr ];

Property ANRRAnrcmcDr As User.DHCANRCManageClass [ SqlColumnNumber = 12, SqlFieldName = ANRR_Anrcmc_Dr ];

Property ANRRCreateCtcpDr As %String [ SqlFieldName = ANRR_CreateCtcp_Dr ];

Property ANRRCreateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ANRR_CreateDate ];

Property ANRRCreateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ANRR_CreateTime ];

Property ANRRCheckCtcpDr As %String [ SqlColumnNumber = 15, SqlFieldName = ANRR_CheckCtcp_Dr ];

Property ANRRCheckDate As %Date [ SqlColumnNumber = 16, SqlFieldName = ANRR_CheckDate ];

Property ANRRCheckTime As %Time [ SqlColumnNumber = 17, SqlFieldName = ANRR_CheckTime ];

Property ANRRAuditCtcpDr As %String [ SqlColumnNumber = 18, SqlFieldName = ANRR_AuditCtcp_Dr ];

Property ANRRAuditDate As %Date [ SqlColumnNumber = 19, SqlFieldName = ANRR_AuditDate ];

Property ANRRAuditTime As %Time [ SqlColumnNumber = 20, SqlFieldName = ANRR_AuditTime ];

Property ANRROpType As %String(DISPLAYLIST = ",B,R,E", MAXLEN = 12, SELECTIVITY = "25%", VALUELIST = ",B,R,E") [ SqlColumnNumber = 21, SqlFieldName = ANRR_OpType ];

Index Adm On ANRRAdmDr As Exact;

Index Opa On ANRROpaDr As Exact;

Index Date On ANRRDate As Exact;

Storage CacheStorage
{
<Data name="DHCANRRiskClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANRRiskDefaultData">
<Value name="1">
<Value>ANRRAdmDr</Value>
</Value>
<Value name="2">
<Value>ANRROpaDr</Value>
</Value>
<Value name="3">
<Value>ANRRCtlocDr</Value>
</Value>
<Value name="4">
<Value>ANRRDate</Value>
</Value>
<Value name="5">
<Value>ANRRTime</Value>
</Value>
<Value name="6">
<Value>ANRRStatus</Value>
</Value>
<Value name="7">
<Value>ANRROperationDr</Value>
</Value>
<Value name="8">
<Value>ANRROperDiffcultyDr</Value>
</Value>
<Value name="9">
<Value>ANRRAsaDr</Value>
</Value>
<Value name="10">
<Value>ANRRAnrcrcDr</Value>
</Value>
<Value name="11">
<Value>ANRRAnrcmcDr</Value>
</Value>
<Value name="12">
<Value>ANRRCreateCtcpDr</Value>
</Value>
<Value name="13">
<Value>ANRRCreateDate</Value>
</Value>
<Value name="14">
<Value>ANRRCreateTime</Value>
</Value>
<Value name="15">
<Value>ANRRCheckCtcpDr</Value>
</Value>
<Value name="16">
<Value>ANRRCheckDate</Value>
</Value>
<Value name="17">
<Value>ANRRCheckTime</Value>
</Value>
<Value name="18">
<Value>ANRRAuditCtcpDr</Value>
</Value>
<Value name="19">
<Value>ANRRAuditDate</Value>
</Value>
<Value name="20">
<Value>ANRRAuditTime</Value>
</Value>
<Value name="21">
<Value>ANRROpType</Value>
</Value>
</Data>
<DataLocation>^DHCANRRisk</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANRRisk</IdLocation>
<IndexLocation>^DHCANRRisk(0)</IndexLocation>
<StreamLocation>^User.DHCANRRiskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
