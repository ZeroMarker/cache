Class User.DHCBPEquipRun Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPER_RowId, SqlTableName = DHC_BP_EquipRun, StorageStrategy = CacheStorage ]
{

Index EquipDate On (BPERBPCEquipDr As Exact, BPERStartDate As Exact);

Index Date On BPERStartDate As Exact;

Property BPERBPCEquipDr As User.DHCBPCEquip [ SqlColumnNumber = 2, SqlFieldName = BPER_BPCEquip_Dr ];

Property BPERStartDate As %Date [ SqlColumnNumber = 3, SqlFieldName = BPER_StartDate ];

Property BPERStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = BPER_StartTime ];

Property BPEREndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = BPER_EndDate ];

Property BPEREndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = BPER_EndTime ];

//运行记录

Property BPERNote As %String(MAXLEN = 200) [ SqlColumnNumber = 7, SqlFieldName = BPER_Note ];

Property BPERUpdateUserDr As %String [ SqlColumnNumber = 8, SqlFieldName = BPER_UpdateUser_Dr ];

Property BPERUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = BPER_UpdateDate ];

Property BPERUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = BPER_UpdateTime ];

Storage CacheStorage
{
<Data name="DHCBPEquipRunClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPEquipRunDefaultData">
<Value name="1">
<Value>BPERBPCEquipDr</Value>
</Value>
<Value name="2">
<Value>BPERStartDate</Value>
</Value>
<Value name="3">
<Value>BPERStartTime</Value>
</Value>
<Value name="4">
<Value>BPEREndDate</Value>
</Value>
<Value name="5">
<Value>BPEREndTime</Value>
</Value>
<Value name="6">
<Value>BPERNote</Value>
</Value>
<Value name="7">
<Value>BPERUpdateUserDr</Value>
</Value>
<Value name="8">
<Value>BPERUpdateDate</Value>
</Value>
<Value name="9">
<Value>BPERUpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPEquipRun</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPEquipRun</IdLocation>
<IndexLocation>^DHCBPEquipRun(0)</IndexLocation>
<StreamLocation>^User.DHCBPEquipRunS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
