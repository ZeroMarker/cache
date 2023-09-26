Class User.DHCBPCVascularAccess Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCVA_RowId, SqlTableName = DHC_BPC_VascularAccess, StorageStrategy = CacheStorage ]
{

//血管通路代码

Property BPCVACode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCVA_Code ];

//血管通路描述

Property BPCVADesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCVA_Desc ];

//科室

Property BPCVALocationDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPCVA_Location_Dr ];

Storage CacheStorage
{
<Data name="DHCBPCVascularAccessClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCVascularAccessDefaultData">
<Value name="1">
<Value>BPCVACode</Value>
</Value>
<Value name="2">
<Value>BPCVADesc</Value>
</Value>
<Value name="3">
<Value>BPCVALocationDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("VascularAccess")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("VascularAccess")</IdLocation>
<IndexLocation>^DHCBPC("VascularAccess",0)</IndexLocation>
<StreamLocation>^User.DHCBPCVascularAccessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
