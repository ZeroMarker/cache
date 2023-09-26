Class User.DHCCLMappingLog Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLML_RowId, SqlTableName = DHC_CL_MappingLog, StorageStrategy = CacheStorage ]
{

Property CLMLCLCMSDr As User.DHCCLCMappingService [ SqlColumnNumber = 2, SqlFieldName = CLML_CLCMS_Dr ];

Property CLMLDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CLML_Date ];

Property CLMLTime As %Time [ SqlColumnNumber = 4, SqlFieldName = CLML_Time ];

Property CLMLDesc As %String [ SqlColumnNumber = 5, SqlFieldName = CLML_Desc ];

Property CLMLSequence As %String [ SqlColumnNumber = 6, SqlFieldName = CLML_Sequence ];

Property CLMLContent As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CLML_Content ];

Property CLMLStatus As %String(DISPLAYLIST = ",ExternalError,Error,Warning,Success", VALUELIST = ",X,E,W,S") [ SqlColumnNumber = 8, SqlFieldName = CLML_Status ];

Property CLMLUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CLML_UpdateDate ];

Property CLMLUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CLML_UpdateTime ];

Index Date On (CLMLDate As Exact, CLMLCLCMSDr As Exact);

Index Status On (CLMLStatus As Exact, CLMLCLCMSDr As Exact);

Storage CacheStorage
{
<Data name="DHCCLMappingLogClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLMappingLogDefaultData">
<Value name="1">
<Value>CLMLCLCMSDr</Value>
</Value>
<Value name="2">
<Value>CLMLDate</Value>
</Value>
<Value name="3">
<Value>CLMLTime</Value>
</Value>
<Value name="4">
<Value>CLMLDesc</Value>
</Value>
<Value name="5">
<Value>CLMLSequence</Value>
</Value>
<Value name="6">
<Value>CLMLContent</Value>
</Value>
<Value name="7">
<Value>CLMLStatus</Value>
</Value>
<Value name="8">
<Value>CLMLUpdateDate</Value>
</Value>
<Value name="9">
<Value>CLMLUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCCLMappingLog</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLMappingLog</IdLocation>
<IndexLocation>^DHCCLMappingLog(0)</IndexLocation>
<StreamLocation>^User.DHCCLMappingLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
