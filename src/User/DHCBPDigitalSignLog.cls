Class User.DHCBPDigitalSignLog Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPDSL_RowId, SqlTableName = DHC_BP_DigitalSignLog, StorageStrategy = CacheStorage ]
{

Index BPADocCode On (BPDSLBPADr As Exact, BPDSLDocumentCode As Exact);

Property BPDSLSignDr As %String [ SqlColumnNumber = 2, SqlFieldName = BPDSL_Sign_Dr ];

Property BPDSLUserDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPDSL_User_Dr ];

Property BPDSLADMDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPDSL_ADM_Dr ];

Property BPDSLBPADr As %String [ SqlColumnNumber = 5, SqlFieldName = BPDSL_BPA_Dr ];

Property BPDSLDocumentCode As %String [ SqlColumnNumber = 6, SqlFieldName = BPDSL_DocumentCode ];

Property BPDSLContentHash As %String [ SqlColumnNumber = 7, SqlFieldName = BPDSL_ContentHash ];

Property BPDSLIsValid As %Boolean [ SqlColumnNumber = 8, SqlFieldName = BPDSL_IsValid ];

Storage CacheStorage
{
<Data name="DHCBPDigitalSignLogClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPDigitalSignLogData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPDSLSignDr</Value>
</Value>
<Value name="2">
<Value>BPDSLUserDr</Value>
</Value>
<Value name="3">
<Value>BPDSLADMDr</Value>
</Value>
<Value name="4">
<Value>BPDSLBPADr</Value>
</Value>
<Value name="5">
<Value>BPDSLDocumentCode</Value>
</Value>
<Value name="6">
<Value>BPDSLContentHash</Value>
</Value>
<Value name="7">
<Value>BPDSLIsValid</Value>
</Value>
</Data>
<DataLocation>^DHCBPDigitalSignLog</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPDigitalSignLog</IdLocation>
<IndexLocation>^DHCBPDigitalSignLog(0)</IndexLocation>
<StreamLocation>^User.DHCBPDigitalSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
