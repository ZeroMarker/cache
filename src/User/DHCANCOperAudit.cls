Class User.DHCANCOperAudit Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANCOA_RowId, SqlTableName = DHC_ANC_OperAudit, StorageStrategy = CacheStorage ]
{

Property ANCOAAppCtcpDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANCOA_AppCtcp_Dr ];

Property ANCOAAppDeptDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANCOA_AppDept_Dr ];

Property ANCOAAppDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ANCOA_AppDate ];

Property ANCOAAppTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ANCOA_AppTime ];

Property ANCOAAppNote As %String [ SqlColumnNumber = 6, SqlFieldName = ANCOA_AppNote ];

Property ANCOAStatus As %String(DISPLAYLIST = ",Apply,Cancel,Finish,Decline", VALUELIST = ",A,C,F,D") [ SqlColumnNumber = 7, SqlFieldName = ANCOA_Status ];

Property ANCOAAuditCtcpDr As %String [ SqlColumnNumber = 8, SqlFieldName = ANCOA_AuditCtcp_Dr ];

Property ANCOAAuditDeptDr As %String [ SqlColumnNumber = 9, SqlFieldName = ANCOA_AuditDept_Dr ];

Property ANCOAAuditDate As %Date [ SqlColumnNumber = 10, SqlFieldName = ANCOA_AuditDate ];

Property ANCOAAuditTime As %Time [ SqlColumnNumber = 11, SqlFieldName = ANCOA_AuditTime ];

Property ANCOAAuditNote As %String [ SqlColumnNumber = 12, SqlFieldName = ANCOA_AuditNote ];

Property ANCOAOperCode As %String [ SqlColumnNumber = 13, SqlFieldName = ANCOA_OperCode ];

Property ANCOAOperDesc As %String [ SqlColumnNumber = 14, SqlFieldName = ANCOA_OperDesc ];

Property ANCOAOperClassDr As %String [ SqlColumnNumber = 15, SqlFieldName = ANCOA_OperClass_Dr ];

Property ANCOAOperBladeDr As %String [ SqlColumnNumber = 16, SqlFieldName = ANCOA_OperBlade_Dr ];

Property ANCOAOperICD10 As %String [ SqlColumnNumber = 17, SqlFieldName = ANCOA_OperICD10 ];

Property ANCOAOperIType As %String(DISPLAYLIST = ",Normal,Diagnosis,Therapy,Intervention", VALUELIST = ",N,D,T,I") [ SqlColumnNumber = 18, SqlFieldName = ANCOA_OperIType ];

Property ANCOAOperIAlias As %String [ SqlColumnNumber = 19, SqlFieldName = ANCOA_OperIAlias ];

Property ANCOADaySurgery As %Boolean [ SqlColumnNumber = 20, SqlFieldName = ANCOA_DaySurgery ];

Property ANCOABodySiteDr As %String [ SqlColumnNumber = 21, SqlFieldName = ANCOA_BodySite_Dr ];

Property ANCOAPositionDr As %String [ SqlColumnNumber = 22, SqlFieldName = ANCOA_Position_Dr ];

Property ANCOADeclineReason As %String [ SqlColumnNumber = 23, SqlFieldName = ANCOA_DeclineReason ];

Property ANCOAPassReason As %String [ SqlColumnNumber = 24, SqlFieldName = ANCOA_PassReason ];

Storage CacheStorage
{
<Data name="DHCANCOperAuditDefaultData">
<Value name="1">
<Value>ANCOAAppCtcpDr</Value>
</Value>
<Value name="2">
<Value>ANCOAAppDeptDr</Value>
</Value>
<Value name="3">
<Value>ANCOAAppDate</Value>
</Value>
<Value name="4">
<Value>ANCOAAppTime</Value>
</Value>
<Value name="5">
<Value>ANCOAAppNote</Value>
</Value>
<Value name="6">
<Value>ANCOAStatus</Value>
</Value>
<Value name="7">
<Value>ANCOAAuditCtcpDr</Value>
</Value>
<Value name="8">
<Value>ANCOAAuditDeptDr</Value>
</Value>
<Value name="9">
<Value>ANCOAAuditDate</Value>
</Value>
<Value name="10">
<Value>ANCOAAuditTime</Value>
</Value>
<Value name="11">
<Value>ANCOAAuditNote</Value>
</Value>
<Value name="12">
<Value>ANCOAOperCode</Value>
</Value>
<Value name="13">
<Value>ANCOAOperDesc</Value>
</Value>
<Value name="14">
<Value>ANCOAOperClassDr</Value>
</Value>
<Value name="15">
<Value>ANCOAOperBladeDr</Value>
</Value>
<Value name="16">
<Value>ANCOAOperICD10</Value>
</Value>
<Value name="17">
<Value>ANCOAOperIType</Value>
</Value>
<Value name="18">
<Value>ANCOAOperIAlias</Value>
</Value>
<Value name="19">
<Value>ANCOADaySurgery</Value>
</Value>
<Value name="20">
<Value>ANCOABodySiteDr</Value>
</Value>
<Value name="21">
<Value>ANCOAPositionDr</Value>
</Value>
<Value name="22">
<Value>ANCOADeclineReason</Value>
</Value>
<Value name="23">
<Value>ANCOAPassReason</Value>
</Value>
<Value name="24">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.DHCANCOperAuditD</DataLocation>
<DefaultData>DHCANCOperAuditDefaultData</DefaultData>
<IdLocation>^User.DHCANCOperAuditD</IdLocation>
<IndexLocation>^User.DHCANCOperAuditI</IndexLocation>
<StreamLocation>^User.DHCANCOperAuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index Date On ANCOAAppDate As Exact;

Index OperDesc On ANCOAOperDesc As Upper;

}
