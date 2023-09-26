Class User.DHCCLMappingRecord Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLMR_RowId, SqlTableName = DHC_CL_MappingRecord, StorageStrategy = CacheStorage ]
{

Property CLMRCLCMSDr As User.DHCCLCMappingService [ SqlColumnNumber = 2, SqlFieldName = CLMR_CLCMS_Dr ];

Property CLMRRecordDr As %String [ SqlColumnNumber = 3, SqlFieldName = CLMR_Record_Dr ];

Property CLMRRecordNo As %String [ SqlColumnNumber = 4, SqlFieldName = CLMR_RecordNo ];

Property CLMRDesc As %String [ SqlColumnNumber = 5, SqlFieldName = CLMR_Desc ];

Property CLMRMappedNo As %String [ SqlColumnNumber = 6, SqlFieldName = CLMR_MappedNo ];

Property CLMRMappedDesc As %String [ SqlColumnNumber = 7, SqlFieldName = CLMR_MappedDesc ];

Property CLMRDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CLMR_Date ];

Property CLMRTime As %Time [ SqlColumnNumber = 9, SqlFieldName = CLMR_Time ];

Property CLMRUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = CLMR_UpdateDate ];

Property CLMRUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CLMR_UpdateTime ];

Index RecordDr On (CLMRCLCMSDr As Exact, CLMRRecordDr As Exact);

Index MappedNo On (CLMRCLCMSDr As Exact, CLMRMappedNo As Exact);

Storage CacheStorage
{
<Data name="DHCCLMappingRecordClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLMappingRecordDefaultData">
<Value name="1">
<Value>CLMRCLCMSDr</Value>
</Value>
<Value name="2">
<Value>CLMRRecordDr</Value>
</Value>
<Value name="3">
<Value>CLMRRecordNo</Value>
</Value>
<Value name="4">
<Value>CLMRDesc</Value>
</Value>
<Value name="5">
<Value>CLMRMappedNo</Value>
</Value>
<Value name="6">
<Value>CLMRMappedDesc</Value>
</Value>
<Value name="7">
<Value>CLMRDate</Value>
</Value>
<Value name="8">
<Value>CLMRTime</Value>
</Value>
<Value name="9">
<Value>CLMRUpdateDate</Value>
</Value>
<Value name="10">
<Value>CLMRUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCCLMappingRecord</DataLocation>
<DefaultData>DHCCLMappingRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLMappingRecord</IdLocation>
<IndexLocation>^DHCCLMappingRecord(0)</IndexLocation>
<StreamLocation>^User.DHCCLMappingRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
