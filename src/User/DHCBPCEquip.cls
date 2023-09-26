Class User.DHCBPCEquip Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCE_RowId, SqlTableName = DHC_BPC_Equip, StorageStrategy = CacheStorage ]
{

Index BPCEquipModel On BPCEBPCEquipModelDr As Exact;

Index Code On BPCECode As Exact;

Property BPCEBPCEquipModelDr As User.DHCBPCEquipModel [ SqlColumnNumber = 2, SqlFieldName = BPCE_BPCEquipModel_Dr ];

Property BPCECode As %String [ SqlColumnNumber = 3, SqlFieldName = BPCE_Code ];

Property BPCEDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BPCE_Desc ];

Property BPCENo As %String [ SqlColumnNumber = 5, SqlFieldName = BPCE_No ];

Property BPCEFromDate As %Date [ SqlColumnNumber = 6, SqlFieldName = BPCE_FromDate ];

Property BPCEToDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BPCE_ToDate ];

Property BPCEStatus As %String(DISPLAYLIST = ",Using,Spare,Scrap", MAXLEN = 7, SELECTIVITY = "33.3333%", VALUELIST = ",US,SP,SC") [ SqlColumnNumber = 8, SqlFieldName = BPCE_Status ];

Property BPCENote As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BPCE_Note ];

Property BPCESoftwareVersion As %String [ SqlColumnNumber = 10, SqlFieldName = BPCE_SoftwareVersion ];

Property BPCEPart As %String(DISPLAYLIST = ",HD,HDF", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",HD,HDF") [ SqlColumnNumber = 11, SqlFieldName = BPCE_Part ];

Property BPCEInstallDate As %Date [ SqlColumnNumber = 12, SqlFieldName = BPCE_InstallDate ];

Property BPCETotalWorkingHour As %Float [ SqlColumnNumber = 13, SqlFieldName = BPCE_TotalWorkingHour ];

Property BPCEPurchaseDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BPCE_PurchaseDate ];

Property BPCEPurchaseAmount As %Float [ SqlColumnNumber = 15, SqlFieldName = BPCE_PurchaseAmount ];

Property BPCEWarrantyYear As %Float [ SqlColumnNumber = 16, SqlFieldName = BPCE_WarrantyYear ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 17, SqlFieldName = BPCE_DataAttribution ];

Storage CacheStorage
{
<Data name="DHCBPCEquipClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DHCBPCEquipDefaultData">
<Value name="1">
<Value>BPCEBPCEquipModelDr</Value>
</Value>
<Value name="2">
<Value>BPCECode</Value>
</Value>
<Value name="3">
<Value>BPCEDesc</Value>
</Value>
<Value name="4">
<Value>BPCENo</Value>
</Value>
<Value name="5">
<Value>BPCEFromDate</Value>
</Value>
<Value name="6">
<Value>BPCEToDate</Value>
</Value>
<Value name="7">
<Value>BPCEStatus</Value>
</Value>
<Value name="8">
<Value>BPCENote</Value>
</Value>
<Value name="9">
<Value>BPCESoftwareVersion</Value>
</Value>
<Value name="10">
<Value>BPCEPart</Value>
</Value>
<Value name="11">
<Value>BPCEInstallDate</Value>
</Value>
<Value name="12">
<Value>BPCETotalWorkingHour</Value>
</Value>
<Value name="13">
<Value>BPCEPurchaseDate</Value>
</Value>
<Value name="14">
<Value>BPCEPurchaseAmount</Value>
</Value>
<Value name="15">
<Value>BPCEWarrantyYear</Value>
</Value>
<Value name="16">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Equip")</DataLocation>
<DefaultData>DHCBPCEquipDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("Equip")</IdLocation>
<IndexLocation>^DHCBPC("Equip",0)</IndexLocation>
<StreamLocation>^User.DHCBPCEquipS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
