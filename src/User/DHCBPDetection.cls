Class User.DHCBPDetection Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPD_RowId, SqlTableName = DHC_BP_Detection, StorageStrategy = CacheStorage ]
{

Index Date On BPDDate As Exact;

Index DetectionDate On (BPDBPCDetectionDr As Exact, BPDDate As Exact);

Property BPDBPCDetectionDr As User.DHCBPCDetection [ SqlColumnNumber = 2, SqlFieldName = BPD_BPCDetection_Dr ];

Property BPDBPCEquipDr As User.DHCBPCEquip [ SqlColumnNumber = 3, SqlFieldName = BPD_BPCEquip_Dr ];

Property BPDDate As %Date [ SqlColumnNumber = 4, SqlFieldName = BPD_Date ];

Property BPDTime As %Time [ SqlColumnNumber = 5, SqlFieldName = BPD_Time ];

Property BPDSpecimenNo As %String [ SqlColumnNumber = 6, SqlFieldName = BPD_SpecimenNo ];

Property BPDNote As %String(MAXLEN = 200) [ SqlColumnNumber = 7, SqlFieldName = BPD_Note ];

Property BPDUpdateUserDr As %String [ SqlColumnNumber = 8, SqlFieldName = BPD_UpdateUser_Dr ];

Property BPDUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = BPD_UpdateDate ];

Property BPDUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = BPD_UpdateTime ];

Property BPDIsQualified As %Float [ SqlColumnNumber = 11, SqlFieldName = BPD_IsQualified ];

Property BPDBatchSeqNo As %String [ SqlColumnNumber = 12, SqlFieldName = BPD_BatchSeqNo ];

Storage CacheStorage
{
<Data name="DHCBPDetectionClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPDetectionDefaultData">
<Value name="1">
<Value>BPDBPCDetectionDr</Value>
</Value>
<Value name="2">
<Value>BPDBPCEquipDr</Value>
</Value>
<Value name="3">
<Value>BPDDate</Value>
</Value>
<Value name="4">
<Value>BPDTime</Value>
</Value>
<Value name="5">
<Value>BPDSpecimenNo</Value>
</Value>
<Value name="6">
<Value>BPDNote</Value>
</Value>
<Value name="7">
<Value>BPDUpdateUserDr</Value>
</Value>
<Value name="8">
<Value>BPDUpdateDate</Value>
</Value>
<Value name="9">
<Value>BPDUpdateTime</Value>
</Value>
<Value name="10">
<Value>BPDIsQualified</Value>
</Value>
<Value name="11">
<Value>BPDBatchSeqNo</Value>
</Value>
</Data>
<DataLocation>^DHCBPDetection</DataLocation>
<DefaultData>DHCBPDetectionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPDetection</IdLocation>
<IndexLocation>^DHCBPDetection(0)</IndexLocation>
<StreamLocation>^User.DHCBPDetectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
