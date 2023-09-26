Class User.DHCBPEquipMaintain Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPEM_RowId, SqlTableName = DHC_BP_EquipMaintain, StorageStrategy = CacheStorage ]
{

Index EquipDate On (BPEMBPCEquipDr As Exact, BPEMStartDate As Exact);

Index Date On BPEMStartDate As Exact;

Property BPEMBPCEquipDr As User.DHCBPCEquip [ SqlColumnNumber = 2, SqlFieldName = BPEM_BPCEquip_Dr ];

//设备部件，可为空

Property BPEMBPCEquipPart As %String [ SqlColumnNumber = 3, SqlFieldName = BPEM_BPCEquipPart ];

Property BPEMType As %String(DISPLAYLIST = ",Clean,Maintain,Repair", MAXLEN = 8, SELECTIVITY = "25%", VALUELIST = ",C,M,R") [ SqlColumnNumber = 4, SqlFieldName = BPEM_Type ];

Property BPEMPartType As %String(DISPLAYLIST = ",Clean,Maintain,Repair,Replace", MAXLEN = 8, SELECTIVITY = "25%", VALUELIST = ",C,M,R,P") [ SqlColumnNumber = 5, SqlFieldName = BPEM_PartType ];

Property BPEMStartDate As %Date [ SqlColumnNumber = 6, SqlFieldName = BPEM_StartDate ];

Property BPEMStartTime As %Time [ SqlColumnNumber = 7, SqlFieldName = BPEM_StartTime ];

Property BPEMEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BPEM_EndDate ];

Property BPEMEndTime As %Time [ SqlColumnNumber = 9, SqlFieldName = BPEM_EndTime ];

//维护记录

Property BPEMNote As %String(MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = BPEM_Note ];

Property BPEMExpense As %Float [ SqlColumnNumber = 12, SqlFieldName = BPEM_Expense ];

Property BPEMUpdateUserDr As %String [ SqlColumnNumber = 13, SqlFieldName = BPEM_UpdateUser_Dr ];

Property BPEMUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BPEM_UpdateDate ];

Property BPEMUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = BPEM_UpdateTime ];

Storage CacheStorage
{
<Data name="DHCBPEquipMaintainClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPEquipMaintainDefaultData">
<Value name="1">
<Value>BPEMBPCEquipDr</Value>
</Value>
<Value name="2">
<Value>BPEMBPCEquipPart</Value>
</Value>
<Value name="3">
<Value>BPEMType</Value>
</Value>
<Value name="4">
<Value>BPEMPartType</Value>
</Value>
<Value name="5">
<Value>BPEMStartDate</Value>
</Value>
<Value name="6">
<Value>BPEMStartTime</Value>
</Value>
<Value name="7">
<Value>BPEMEndDate</Value>
</Value>
<Value name="8">
<Value>BPEMEndTime</Value>
</Value>
<Value name="9">
<Value>BPEMNote</Value>
</Value>
<Value name="10">
<Value>BPEMExpense</Value>
</Value>
<Value name="11">
<Value>BPEMUpdateUserDr</Value>
</Value>
<Value name="12">
<Value>BPEMUpdateDate</Value>
</Value>
<Value name="13">
<Value>BPEMUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPEquipMaintain</DataLocation>
<DefaultData>DHCBPEquipMaintainDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPEquipMaintain</IdLocation>
<IndexLocation>^DHCBPEquipMaintain(0)</IndexLocation>
<StreamLocation>^User.DHCBPEquipMaintainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
