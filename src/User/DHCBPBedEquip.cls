Class User.DHCBPBedEquip Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPBE_RowId, SqlTableName = DHC_BP_BedEquip ]
{

Index Bed On BPBEBedDr;

Property BPBEBedDr As User.DHCBPCBed [ SqlColumnNumber = 2, SqlFieldName = BPBE_Bed_Dr ];

Property BPBEBPCEquipDr As User.DHCBPCEquip [ SqlColumnNumber = 3, SqlFieldName = BPBE_BPCEquip_Dr ];

Property BPBETcpipAddress As %String [ SqlColumnNumber = 4, SqlFieldName = BPBE_TcpipAddress ];

Property BPBEPort As %String [ SqlColumnNumber = 5, SqlFieldName = BPBE_Port ];

// 连接设备类型

Property BPBECollectTypeDr As User.DHCANCCollectType [ SqlColumnNumber = 6, SqlFieldName = BPBE_CollectType_Dr ];

Property BPBEDefaultInterval As %Float [ SqlColumnNumber = 7, SqlFieldName = BPBE_DefaultInterval ];

Property BPBEEditTcpipAddress As %String [ SqlColumnNumber = 8, SqlFieldName = BPBE_EditTcpipAddress ];

// 是否连接

Property BPBEIfConnected As %Boolean [ SqlColumnNumber = 9, SqlFieldName = BPBE_IfConnected ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 10, SqlFieldName = BPBE_DataAttribution ];

Storage Default
{
<Data name="DHCBPBedEquipClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPBedEquipDefaultData">
<Value name="1">
<Value>BPBEBedDr</Value>
</Value>
<Value name="2">
<Value>BPBEBPCEquipDr</Value>
</Value>
<Value name="3">
<Value>BPBETcpipAddress</Value>
</Value>
<Value name="4">
<Value>BPBEPort</Value>
</Value>
<Value name="5">
<Value>BPBECollectTypeDr</Value>
</Value>
<Value name="6">
<Value>BPBEDefaultInterval</Value>
</Value>
<Value name="7">
<Value>BPBEEditTcpipAddress</Value>
</Value>
<Value name="8">
<Value>BPBEIfConnected</Value>
</Value>
<Value name="9">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBPBedEquip</DataLocation>
<DefaultData>DHCBPBedEquipDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPBedEquip</IdLocation>
<IndexLocation>^DHCBPBedEquip(0)</IndexLocation>
<StreamLocation>^User.DHCBPBedEquipS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
