Class User.DHCBPArrangeEquipRunPara Extends %Persistent [ ProcedureBlock, SqlRowIdName = BPAERP_RowId, SqlTableName = DHC_BP_ArrangeEquipRunPara, StorageStrategy = CacheStorage ]
{

Relationship BPAERPParref As User.DHCBPArrange [ Cardinality = parent, Inverse = ChildDHCBPArrangeEquipRunPara, SqlFieldName = BPAERP_Parref ];

Property BPAERPBPCERPDr As User.DHCBPCEquipRunPara [ SqlColumnNumber = 2, SqlFieldName = BPAERP_BPCERP_Dr ];

Property BPAERPMinValue As %Float [ SqlColumnNumber = 3, SqlFieldName = BPAERP_MinValue ];

Property BPAERPMaxValue As %Float [ SqlColumnNumber = 4, SqlFieldName = BPAERP_MaxValue ];

Property BPAERPValue As %Float [ SqlColumnNumber = 5, SqlFieldName = BPAERP_Value ];

//是否废弃

Property BPAERPIfAbandon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = BPAERP_IfAbandon ];

//操作日期

Property BPAERPOperationDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BPAERP_OperationDate ];

//操作时间

Property BPAERPOperationTime As %Time [ SqlColumnNumber = 8, SqlFieldName = BPAERP_OperationTime ];

Storage CacheStorage
{
<Data name="BPArrangeEquipRunParaClassName">
<Subscript>0</Subscript>
</Data>
<Data name="BPArrangeEquipRunParaData">
<Attribute>%%CLASSNAME</Attribute>
<Value name="1">
<Value>BPAERPBPCERPDr</Value>
</Value>
<Value name="2">
<Value>BPAERPMinValue</Value>
</Value>
<Value name="3">
<Value>BPAERPMaxValue</Value>
</Value>
<Value name="4">
<Value>BPAERPValue</Value>
</Value>
<Value name="5">
<Value>BPAERPIfAbandon</Value>
</Value>
<Value name="6">
<Value>BPAERPOperationDate</Value>
</Value>
<Value name="7">
<Value>BPAERPOperationTime</Value>
</Value>
</Data>
<Data name="DHCBPArrangeEquipRunParaDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ERP")</DataLocation>
<DefaultData>DHCBPArrangeEquipRunParaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ERP")</IdLocation>
<IndexLocation>{%%PARENT}("ERP",0)</IndexLocation>
<StreamLocation>^User.DHCBPArrangeEquipRunParaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
