Class User.DHCCLCBodySite Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCBS_RowId, SqlTableName = DHCCLC_BodySite, StorageStrategy = CacheStorage ]
{

Property CLCBSCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCBS_Code ];

Property CLCBSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCBS_Desc ];

Property CLCBSLocDr As %String [ SqlColumnNumber = 4, SqlFieldName = CLCBS_Loc_Dr ];

Index Loc On CLCBSLocDr As Exact;

Storage CacheStorage
{
<Data name="DHCCLCBodySiteClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCBodySiteDefaultData">
<Value name="1">
<Value>CLCBSCode</Value>
</Value>
<Value name="2">
<Value>CLCBSDesc</Value>
</Value>
<Value name="3">
<Value>CLCBSLocDr</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("BodySite")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("BodySite")</IdLocation>
<IndexLocation>^DHCCLC("BodySite",0)</IndexLocation>
<StreamLocation>^User.DHCCLCBodySiteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
