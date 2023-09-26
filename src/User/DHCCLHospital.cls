Class User.DHCCLHospital Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = HOSP_RowId, SqlTableName = DHC_CL_Hospital, StorageStrategy = CacheStorage ]
{

Property HOSPCode As %String [ SqlColumnNumber = 2, SqlFieldName = HOSP_Code ];

Property HOSPDesc As %String [ SqlColumnNumber = 3, SqlFieldName = HOSP_Desc ];

Storage CacheStorage
{
<Data name="DHCCLHospitalDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DataMaster">
<Value name="1">
<Value>HOSPCode</Value>
</Value>
<Value name="2">
<Value>HOSPDesc</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("Hospital")</DataLocation>
<DefaultData>DHCCLHospitalDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("Hospital")</IdLocation>
<IndexLocation>^DHCCLC("Hospital")</IndexLocation>
<SqlRowIdName>HOSP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCLHospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
