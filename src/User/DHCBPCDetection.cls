Class User.DHCBPCDetection Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BPC_Detection, StorageStrategy = CacheStorage ]
{

Index Specimen On BPCDSpecimenDr;

Property BPCDCode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCD_Code ];

Property BPCDDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCD_Desc ];

Property BPCDType As %String [ SqlColumnNumber = 4, SqlFieldName = BPCD_Type ];

Property BPCDSpecimenDr As User.DHCBPCSpecimen [ SqlColumnNumber = 5, SqlFieldName = BPCD_Specimen_Dr ];

Property BPCDMinQty As %Float [ SqlColumnNumber = 6, SqlFieldName = BPCD_MinQty ];

Property BPCDMaxQty As %Float [ SqlColumnNumber = 7, SqlFieldName = BPCD_MaxQty ];

Property BPCDUomDr As %String [ SqlColumnNumber = 8, SqlFieldName = BPCD_Uom_Dr ];

Property BPCDDetectIntervalDay As %Float [ SqlColumnNumber = 9, SqlFieldName = BPCD_DetectIntervalDay ];

Storage CacheStorage
{
<Data name="DHCBPCDetectionClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCDetectionData">
<Value name="1">
<Value>BPCDCode</Value>
</Value>
<Value name="2">
<Value>BPCDDesc</Value>
</Value>
<Value name="3">
<Value>BPCDType</Value>
</Value>
<Value name="4">
<Value>BPCDSpecimenDr</Value>
</Value>
<Value name="5">
<Value>BPCDMinQty</Value>
</Value>
<Value name="6">
<Value>BPCDMaxQty</Value>
</Value>
<Value name="7">
<Value>BPCDUomDr</Value>
</Value>
<Value name="8">
<Value>BPCDDetectIntervalDay</Value>
</Value>
</Data>
<DataLocation>^DHCBPC("Detection")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPC("Detection")</IdLocation>
<IndexLocation>^DHCBPC("Detection",0)</IndexLocation>
<StreamLocation>^User.DHCBPCDetectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
