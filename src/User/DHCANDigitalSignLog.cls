Class User.DHCANDigitalSignLog Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANDSL_RowId, SqlTableName = DHC_AN_DigitalSignLog, StorageStrategy = CacheStorage ]
{

Index OPADocCode On (ANDSLOPADr As Exact, ANDSLDocumentCode As Exact);

Property ANDSLSignDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANDSL_Sign_Dr ];

Property ANDSLUserDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANDSL_User_Dr ];

Property ANDSLADMDr As %String [ SqlColumnNumber = 4, SqlFieldName = ANDSL_ADM_Dr ];

Property ANDSLOPADr As %String [ SqlColumnNumber = 5, SqlFieldName = ANDSL_OPA_Dr ];

Property ANDSLDocumentCode As %String [ SqlColumnNumber = 6, SqlFieldName = ANDSL_DocumentCode ];

Property ANDSLContentHash As %String [ SqlColumnNumber = 7, SqlFieldName = ANDSL_ContentHash ];

Property ANDSLIsValid As %Boolean [ SqlColumnNumber = 8, SqlFieldName = ANDSL_IsValid ];

Storage CacheStorage
{
<Data name="DHCANDigitalSignLogClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANDigitalSignLogData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>ANDSLSignDr</Value>
</Value>
<Value name="2">
<Value>ANDSLUserDr</Value>
</Value>
<Value name="3">
<Value>ANDSLADMDr</Value>
</Value>
<Value name="4">
<Value>ANDSLOPADr</Value>
</Value>
<Value name="5">
<Value>ANDSLDocumentCode</Value>
</Value>
<Value name="6">
<Value>ANDSLContentHash</Value>
</Value>
<Value name="7">
<Value>ANDSLIsValid</Value>
</Value>
</Data>
<DataLocation>^DHCANDigitalSignLog</DataLocation>
<IdLocation>^DHCANDigitalSignLog</IdLocation>
<IndexLocation>^DHCANDigitalSignLog(0)</IndexLocation>
<StreamLocation>^User.DHCANDigitalSignLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
