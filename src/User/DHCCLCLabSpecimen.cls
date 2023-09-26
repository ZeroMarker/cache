Class User.DHCCLCLabSpecimen Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCLST_RowId, SqlTableName = DHC_CLC_LabSpecimen, StorageStrategy = CacheStorage ]
{

Property CLCLSTCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCLST_Code ];

Property CLCLSTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCLST_Desc ];

Storage CacheStorage
{
<Data name="DHCCLCLabSpecimenClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCLabSpecimenDefaultData">
<Value name="1">
<Value>CLCLSTCode</Value>
</Value>
<Value name="2">
<Value>CLCLSTDesc</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("LabSpecimen")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("LabSpecimen")</IdLocation>
<IndexLocation>^DHCCLC("LabSpecimen",0)</IndexLocation>
<StreamLocation>^User.DHCCLCLabSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
