Class User.DHCBPCInquiry Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPCI_RowId, SqlTableName = DHC_BPC_Inquiry, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCBPCInquiryItem As User.DHCBPCInquiryItem [ Cardinality = children, Inverse = BPCIIParref ];

Index Ctloc On BPCICtlocDr As Exact;

Index TypeUser On (BPCIType As Exact, BPCIUpdateUserDr As Plus);

Property BPCICode As %String [ SqlColumnNumber = 2, SqlFieldName = BPCI_Code ];

Property BPCIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = BPCI_Desc ];

Property BPCICtlocDr As %String [ SqlColumnNumber = 4, SqlFieldName = BPCI_Ctloc_Dr ];

Property BPCIStatus As %String(DISPLAYLIST = ",Initial,Search,Finish", MAXLEN = 7, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",I,S,F") [ SqlColumnNumber = 5, SqlFieldName = BPCI_Status ];

Property BPCIType As %String(DISPLAYLIST = ",All,Location,User,SelfDefine,DataDefine", MAXLEN = 10, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",A,L,U,S,D") [ SqlColumnNumber = 6, SqlFieldName = BPCI_Type ];

Property BPCISearchLevel As %String [ SqlColumnNumber = 7, SqlFieldName = BPCI_SearchLevel ];

Property BPCIBpaCount As %Float [ SqlColumnNumber = 8, SqlFieldName = BPCI_BpaCount ];

Property BPCIResultCount As %Float [ SqlColumnNumber = 9, SqlFieldName = BPCI_ResultCount ];

Property BPCIIsByDate As %Boolean [ SqlColumnNumber = 10, SqlFieldName = BPCI_IsByDate ];

/// 暂时未用
Property BPCIDataType As %String(DISPLAYLIST = ",Patient,MultiPatient,Location,Summary,CRF", MAXLEN = 12, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",P,M,L,S,C") [ SqlColumnNumber = 11, SqlFieldName = BPCI_DataType ];

/// 检索类型
Property BPCIDateTimeType As %String(DISPLAYLIST = ",Patient,CurPatient,Arrange,Detection", MAXLEN = 10, SELECTIVITY = "20%", TRUNCATE = 1, VALUELIST = ",P,CP,A,D") [ SqlColumnNumber = 12, SqlFieldName = BPCI_DateTimeType ];

Property BPCIUpdateUserDr As %String [ SqlColumnNumber = 13, SqlFieldName = BPCI_UpdateUser_Dr ];

Property BPCIUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BPCI_UpdateDate ];

Property BPCIUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = BPCI_UpdateTime ];

/// 汇总类型(病人、安排、用户、班次)
Property BPCIClassifyCode As %String(DISPLAYLIST = ",Patient,Arrange,User,SeqNo", MAXLEN = 12, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",P,A,U,S") [ SqlColumnNumber = 16, SqlFieldName = BPCI_ClassifyCode ];

/// 数据归属
Property DataAttribution As User.DHCBPCDataAttribution [ SqlColumnNumber = 17, SqlFieldName = BPCI_DataAttribution ];

Storage CacheStorage
{
<Data name="DHCBPCInquiryClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPCInquiryDefaultData">
<Value name="1">
<Value>BPCICode</Value>
</Value>
<Value name="2">
<Value>BPCIDesc</Value>
</Value>
<Value name="3">
<Value>BPCICtlocDr</Value>
</Value>
<Value name="4">
<Value>BPCIStatus</Value>
</Value>
<Value name="5">
<Value>BPCIType</Value>
</Value>
<Value name="6">
<Value>BPCISearchLevel</Value>
</Value>
<Value name="7">
<Value>BPCIBpaCount</Value>
</Value>
<Value name="8">
<Value>BPCIResultCount</Value>
</Value>
<Value name="9">
<Value>BPCIIsByDate</Value>
</Value>
<Value name="10">
<Value>BPCIDataType</Value>
</Value>
<Value name="11">
<Value>BPCIDateTimeType</Value>
</Value>
<Value name="12">
<Value>BPCIUpdateUserDr</Value>
</Value>
<Value name="13">
<Value>BPCIUpdateDate</Value>
</Value>
<Value name="14">
<Value>BPCIUpdateTime</Value>
</Value>
<Value name="15">
<Value>BPCIClassifyCode</Value>
</Value>
<Value name="16">
<Value>DataAttribution</Value>
</Value>
</Data>
<DataLocation>^DHCBPCInquiry</DataLocation>
<DefaultData>DHCBPCInquiryDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPCInquiry</IdLocation>
<IndexLocation>^DHCBPCInquiry(0)</IndexLocation>
<StreamLocation>^User.DHCBPCInquiryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
