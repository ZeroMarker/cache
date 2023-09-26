Class User.DHCCLCMedicalSpecialty Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCMS_RowId, SqlTableName = DHC_CLC_MedicalSpecialty, StorageStrategy = CacheStorage ]
{

Property CLCMSCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCMS_Code ];

Property CLCMSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCMS_Desc ];

Storage CacheStorage
{
<Data name="MedicalSpecialtyClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="MedicalSpecialtyDefaultData">
<Value name="1">
<Value>CLCMSCode</Value>
</Value>
<Value name="2">
<Value>CLCMSDesc</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("MedicalSpecialty")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("MedicalSpecialty")</IdLocation>
<IndexLocation>^DHCCLC("MedicalSpecialty",0)</IndexLocation>
<StreamLocation>^User.DHCCLCMedicalSpecialtyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
