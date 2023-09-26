Class User.DHCBPSchemeConsumable Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPSC_RowId, SqlTableName = DHC_BP_SchemeConsumable, StorageStrategy = CacheStorage ]
{

Property BPSCBPArrangeSchemeDr As User.DHCBPArrangeScheme [ SqlColumnNumber = 2, SqlFieldName = BPSC_BPArrangeScheme_Dr ];

Property BPSCBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 3, SqlFieldName = BPSC_BPCConsumable_Dr ];

//主要，附加，替换

Property BPSCType As %String(DISPLAYLIST = ",Main,Additional,Replaced", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",M,A,R") [ SqlColumnNumber = 4, SqlFieldName = BPSC_Type ];

Property BPSCAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = BPSC_Amount ];

Property BPSCNote As %String [ SqlColumnNumber = 6, SqlFieldName = BPSC_Note ];

//是否废弃

Property BPSCIfAbandon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = BPSC_IfAbandon ];

//操作日期

Property BPSCOperationDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BPSC_OperationDate ];

//操作时间

Property BPSCOperationTime As %Time [ SqlColumnNumber = 9, SqlFieldName = BPSC_OperationTime ];

Index ArrangeScheme On BPSCBPArrangeSchemeDr As Exact;

Storage CacheStorage
{
<Data name="BPSchemeConsumableClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="BPSchemeConsumableData">
<Value name="1">
<Value>BPSCBPArrangeSchemeDr</Value>
</Value>
<Value name="2">
<Value>BPSCBPCConsumableDr</Value>
</Value>
<Value name="3">
<Value>BPSCType</Value>
</Value>
<Value name="4">
<Value>BPSCAmount</Value>
</Value>
<Value name="5">
<Value>BPSCNote</Value>
</Value>
<Value name="6">
<Value>BPSCIfAbandon</Value>
</Value>
<Value name="7">
<Value>BPSCOperationDate</Value>
</Value>
<Value name="8">
<Value>BPSCOperationTime</Value>
</Value>
</Data>
<DataLocation>^DHCBPSchemeConsumable</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPSchemeConsumable</IdLocation>
<IndexLocation>^DHCBPSchemeConsumable(0)</IndexLocation>
<StreamLocation>^DHCBPSchemeConsumableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
