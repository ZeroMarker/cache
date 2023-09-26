Class User.DHCCLCDiagCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = DHC_CLC_DiagCat, StorageStrategy = CacheStorage ]
{

Property CLCDCCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCDC_Code ];

Property CLCDCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCDC_Desc ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 4, SqlFieldName = CLCDC_DataAttribution ];

Storage CacheStorage
{
<Data name="DHCCLCDiagCatClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCDiagCatDefaultData">
<Value name="1">
<Value>CLCDCCode</Value>
</Value>
<Value name="2">
<Value>CLCDCDesc</Value>
</Value>
<Value name="3">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("DiagCat")</DataLocation>
<DefaultData>DHCCLCDiagCatDefaultData1</DefaultData>
<IdLocation>^DHCCLC("DiagCat")</IdLocation>
<IndexLocation>^DHCCLC("DiagCat",0)</IndexLocation>
<StreamLocation>^User.DHCCLCDiagCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
