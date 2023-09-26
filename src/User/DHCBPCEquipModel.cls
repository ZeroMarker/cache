Class User.DHCBPCEquipModel Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_EquipModel, StorageStrategy = CacheStorage ]
{

Property BPCEMCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCEM_Code ];

Property BPCEMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCEM_Desc ];

//缩写

Property BPCEMAbbreviation As %String [ SqlColumnNumber = 4, SqlFieldName = BPCEM_Abbreviation ];

//厂家

Property BPCEMBPCManufacturerDr As User.DHCBPCManufacturer [ SqlColumnNumber = 5, SqlFieldName = BPCEM_BPCManufacturer_Dr ];

//代理

Property BPCEMAgent As %String [ SqlColumnNumber = 6, SqlFieldName = BPCEM_Agent ];

//类型：水处理/血液净化

Property BPCEMType As %String(DISPLAYLIST = ",WaterTreatment,BloodPurification", MAXLEN = 17, SELECTIVITY = "33.3333%", VALUELIST = ",W,B") [ SqlColumnNumber = 7, SqlFieldName = BPCEM_Type ];

Property BPCEMNote As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BPCEM_Note ];

//能进行血滤

Property BPCEMCanFilter As %Boolean [ SqlColumnNumber = 10, SqlFieldName = BPCEM_CanFilter ];

Storage CacheStorage
{
<Data name="DHCBPCEquipModelClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCEquipModelDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPCEMCode</Value>
</Value>
<Value name="2">
<Value>BPCEMDesc</Value>
</Value>
<Value name="3">
<Value>BPCEMAbbreviation</Value>
</Value>
<Value name="4">
<Value>BPCEMBPCManufacturerDr</Value>
</Value>
<Value name="5">
<Value>BPCEMAgent</Value>
</Value>
<Value name="6">
<Value>BPCEMType</Value>
</Value>
<Value name="7">
<Value>BPCEMNote</Value>
</Value>
<Value name="8">
<Value>BPCEMCanFilter</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("EquipModel")</DataLocation>
<DefaultData>DHCBPCEquipModelDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("EquipModel")</IdLocation>
<IndexLocation>^DHCBPC("EquipModel")</IndexLocation>
<StreamLocation>^User.DHCBPCEquipModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
