Class User.DHCCLCMappingService Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCMS_RowId, SqlTableName = DHC_CLC_MappingService, StorageStrategy = CacheStorage ]
{

Property CLCMSCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCMS_Code ];

Property CLCMSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCMS_Desc ];

Property CLCMSType As %String(DISPLAYLIST = ",View,WebService,CodeMapping,RecordMapping", VALUELIST = ",V,W,C,R") [ SqlColumnNumber = 4, SqlFieldName = CLCMS_Type ];

Property CLCMSUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CLCMS_UpdateDate ];

Property CLCMSUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = CLCMS_UpdateTime ];

Index Code On CLCMSCode As Exact;

Storage CacheStorage
{
<Data name="DHCCLCMappingServiceClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCMappingServiceDefaultData">
<Value name="1">
<Value>CLCMSCode</Value>
</Value>
<Value name="2">
<Value>CLCMSDesc</Value>
</Value>
<Value name="3">
<Value>CLCMSType</Value>
</Value>
<Value name="4">
<Value>CLCMSUpdateDate</Value>
</Value>
<Value name="5">
<Value>CLCMSUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("MappingService")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("MappingService")</IdLocation>
<IndexLocation>^DHCCLC("MappingService",0)</IndexLocation>
<SqlRowIdName>CLCMS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCLCMappingServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
