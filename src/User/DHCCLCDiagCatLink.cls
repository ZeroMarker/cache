Class User.DHCCLCDiagCatLink Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = DHC_CLC_DiagCatLink, StorageStrategy = CacheStorage ]
{

Property CLCDCLICDDr As %String [ SqlColumnNumber = 2, SqlFieldName = CLCDCL_ICD_Dr ];

Property CLCDCLDiagCatDr As User.DHCCLCDiagCat [ SqlColumnNumber = 3, SqlFieldName = CLCDCL_DiagCat_Dr ];

Property CLCDCLICDDescAlias As %String [ SqlColumnNumber = 4, SqlFieldName = CLCDCL_ICDDescAlias ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 5, SqlFieldName = CLCDCL_DataAttribution ];

Index Cat On CLCDCLDiagCatDr As Exact;

Storage CacheStorage
{
<Data name="DHCCLCDiagCatLinkClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCDiagCatLinkDefaultData">
<Value name="1">
<Value>CLCDCLICDDr</Value>
</Value>
<Value name="2">
<Value>CLCDCLDiagCatDr</Value>
</Value>
<Value name="3">
<Value>CLCDCLICDDescAlias</Value>
</Value>
<Value name="4">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("DiagCatLink")</DataLocation>
<DefaultData>DHCCLCDiagCatLinkDefaultData1</DefaultData>
<IdLocation>^DHCCLC("DiagCatLink")</IdLocation>
<IndexLocation>^DHCCLC("DiagCatLink",0)</IndexLocation>
<StreamLocation>^User.DHCCLCDiagCatLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
