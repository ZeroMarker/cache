Class User.DHCBPSchemeEquipRunPara Extends %Persistent [ ProcedureBlock, SqlRowIdName = BPSERP_RowId, SqlTableName = DHC_BP_SchemeEquipRunPara, StorageStrategy = CacheStorage ]
{

Relationship BPSERPParref As User.DHCBPScheme [ Cardinality = parent, Inverse = ChildDHCBPSchemeEquipRunPara, SqlFieldName = BPSERP_Parref ];

Property BPSERPBPCERPDr As User.DHCBPCEquipRunPara [ SqlColumnNumber = 2, SqlFieldName = BPSERP_BPCERP_Dr ];

Property BPSERPMinValue As %Float [ SqlColumnNumber = 3, SqlFieldName = BPSERP_MinValue ];

Property BPSERPMaxValue As %Float [ SqlColumnNumber = 4, SqlFieldName = BPSERP_MaxValue ];

Property BPSERPValue As %Float [ SqlColumnNumber = 5, SqlFieldName = BPSERP_Value ];

//是否废弃

Property BPSERPIfAbandon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = BPSERP_IfAbandon ];

//操作日期

Property BPSERPOperationDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BPSERP_OperationDate ];

//操作时间

Property BPSERPOperationTime As %Time [ SqlColumnNumber = 8, SqlFieldName = BPSERP_OperationTime ];

Storage CacheStorage
{
<Data name="SchemeEquipRunParaClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="SchemeEquipRunParaDefaultData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPSERPBPCERPDr</Value>
</Value>
<Value name="2">
<Value>BPSERPMinValue</Value>
</Value>
<Value name="3">
<Value>BPSERPMaxValue</Value>
</Value>
<Value name="4">
<Value>BPSERPValue</Value>
</Value>
<Value name="5">
<Value>BPSERPIfAbandon</Value>
</Value>
<Value name="6">
<Value>BPSERPOperationDate</Value>
</Value>
<Value name="7">
<Value>BPSERPOperationTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ERP")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ERP")</IdLocation>
<IndexLocation>{%%PARENT}("ERP",0)</IndexLocation>
<StreamLocation>^User.DHCBPSchemeEquipRunParaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
