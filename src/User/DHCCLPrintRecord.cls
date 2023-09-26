Class User.DHCCLPrintRecord Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLPR_RowId, SqlTableName = DHC_CL_PrintRecord, StorageStrategy = CacheStorage ]
{

Property CLPRDate As %Date [ SqlColumnNumber = 2, SqlFieldName = CLPR_Date ];

Property CLPRTime As %Time [ SqlColumnNumber = 3, SqlFieldName = CLPR_Time ];

Property CLPRADMDr As %String [ SqlColumnNumber = 4, SqlFieldName = CLPR_ADM_Dr ];

Property CLPROPADr As %String [ SqlColumnNumber = 5, SqlFieldName = CLPR_OPA_Dr ];

Property CLPRICUADr As %String [ SqlColumnNumber = 6, SqlFieldName = CLPR_ICUA_Dr ];

Property CLPRHDADr As %String [ SqlColumnNumber = 7, SqlFieldName = CLPR_HDA_Dr ];

Property CLPRTitle As %String [ SqlColumnNumber = 8, SqlFieldName = CLPR_Title ];

Property CLPRCTLOCDr As %String [ SqlColumnNumber = 9, SqlFieldName = CLPR_CTLOC_Dr ];

Property CLPRStatus As %String(DISPLAYLIST = ",Normal,Upload,Error", MAXLEN = 6, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",N,U,E") [ SqlColumnNumber = 10, SqlFieldName = CLPR_Status ];

Property CLPRNote As %String [ SqlColumnNumber = 11, SqlFieldName = CLPR_Note ];

Property CLPRCreateUserDr As %String [ SqlColumnNumber = 12, SqlFieldName = CLPR_CreateUser_Dr ];

Property CLPRDocumentStartDate As %Date [ SqlColumnNumber = 13, SqlFieldName = CLPR_DocumentStartDate ];

Property CLPRDocumentEndDate As %Date [ SqlColumnNumber = 14, SqlFieldName = CLPR_DocumentEndDate ];

Index Date On CLPRDate As Exact;

Index ADM On CLPRADMDr As Exact;

Index OPA On CLPROPADr As Exact;

Index ICUA On CLPRICUADr As Exact;

Storage CacheStorage
{
<Data name="DHCCLPrintRecordClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLPrintRecordDefaultData">
<Value name="1">
<Value>CLPRDate</Value>
</Value>
<Value name="2">
<Value>CLPRTime</Value>
</Value>
<Value name="3">
<Value>CLPRADMDr</Value>
</Value>
<Value name="4">
<Value>CLPROPADr</Value>
</Value>
<Value name="5">
<Value>CLPRICUADr</Value>
</Value>
<Value name="6">
<Value>CLPRHDADr</Value>
</Value>
<Value name="7">
<Value>CLPRTitle</Value>
</Value>
<Value name="8">
<Value>CLPRCTLOCDr</Value>
</Value>
<Value name="9">
<Value>CLPRStatus</Value>
</Value>
<Value name="10">
<Value>CLPRNote</Value>
</Value>
<Value name="11">
<Value>CLPRCreateUserDr</Value>
</Value>
<Value name="12">
<Value>CLPRDocumentStartDate</Value>
</Value>
<Value name="13">
<Value>CLPRDocumentEndDate</Value>
</Value>
</Data>
<DataLocation>^DHCCLPrintRecord</DataLocation>
<DefaultData>DHCCLPrintRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLPrintRecord</IdLocation>
<IndexLocation>^DHCCLPrintRecord(0)</IndexLocation>
<SqlRowIdName>CLPR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCLPrintRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
