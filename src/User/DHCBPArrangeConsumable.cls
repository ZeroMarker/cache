Class User.DHCBPArrangeConsumable Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPAC_RowId, SqlTableName = DHC_BP_ArrangeConsumable, StorageStrategy = CacheStorage ]
{

Property BPACBPArrangeDr As User.DHCBPArrange [ SqlColumnNumber = 2, SqlFieldName = BPAC_BPArrange_Dr ];

Property BPACBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 3, SqlFieldName = BPAC_BPCConsumable_Dr ];

//主要，附加，替换

Property BPACType As %String(DISPLAYLIST = ",Main,Additional,Replaced", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",M,A,R") [ SqlColumnNumber = 4, SqlFieldName = BPAC_Type ];

Property BPACAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = BPAC_Amount ];

Property BPACNote As %String [ SqlColumnNumber = 6, SqlFieldName = BPAC_Note ];

//是否废弃

Property BPACIfAbandon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = BPAC_IfAbandon ];

//操作日期

Property BPACOperationDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BPAC_OperationDate ];

//操作时间

Property BPACOperationTime As %Time [ SqlColumnNumber = 9, SqlFieldName = BPAC_OperationTime ];

Index Arrange On BPACBPArrangeDr As Exact;

Storage CacheStorage
{
<Data name="DHCBPArrangeConsumableClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPArrangeConsumableData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPACBPArrangeDr</Value>
</Value>
<Value name="2">
<Value>BPACBPCConsumableDr</Value>
</Value>
<Value name="3">
<Value>BPACType</Value>
</Value>
<Value name="4">
<Value>BPACAmount</Value>
</Value>
<Value name="5">
<Value>BPACNote</Value>
</Value>
<Value name="6">
<Value>BPACIfAbandon</Value>
</Value>
<Value name="7">
<Value>BPACOperationDate</Value>
</Value>
<Value name="8">
<Value>BPACOperationTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPArrangeConsumable</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPArrangeConsumable</IdLocation>
<IndexLocation>^DHCBPArrangeConsumable(0)</IndexLocation>
<StreamLocation>^DHCBPArrangeConsumableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
