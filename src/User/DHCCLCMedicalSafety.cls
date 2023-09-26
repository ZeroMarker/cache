Class User.DHCCLCMedicalSafety Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCMS_RowId, SqlTableName = DHC_CLC_MedicalSafety, StorageStrategy = CacheStorage ]
{

Property CLCMSCode As %String [ SqlColumnNumber = 2, SqlFieldName = CLCMS_Code ];

Property CLCMSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCMS_Desc ];

Property CLCMSType As %String [ SqlColumnNumber = 4, SqlFieldName = CLCMS_Type ];

Property CLCMSCtlocDr As %String [ SqlColumnNumber = 5, SqlFieldName = CLCMS_Ctloc_Dr ];

Index CTLOC On CLCMSCtlocDr As Exact;

Storage CacheStorage
{
<Data name="DHCCLCMedicalSafetyClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLCMedicalSafetyDefaultData">
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
<Value>CLCMSCtlocDr</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("MedicalSafety")</DataLocation>
<DefaultData>DHCCLCMedicalSafetyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("MedicalSafety")</IdLocation>
<IndexLocation>^DHCCLC("MedicalSafety",0)</IndexLocation>
<StreamLocation>^User.DHCCLCMedicalSafetyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
