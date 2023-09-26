/// Deription: 毒麻药品销毁子表
Class User.PHAINNarcDestroyItm Extends %Persistent [ SqlRowIdName = PINDI_RowId, SqlTableName = PHAIN_NarcDestroyItm ]
{

/// 索引
Index OEORE On PINDIOEOREDR As Exact;

Index INSPI On PINDIINSPIDR As Exact;

/// ===============
/// 指向父表
Relationship PINDIParRef As User.PHAINNarcDestroy [ Cardinality = parent, Inverse = ChildPHAINNarcDestroyItm, SqlFieldName = PINDI_ParRef ];

/// 执行记录ID
Property PINDIOEOREDR As User.OEOrdExec [ SqlColumnNumber = 2, SqlFieldName = PINDI_OEORE_DR ];

/// 报损明细ID
Property PINDIINSPIDR As User.DHCINSpItm [ SqlColumnNumber = 3, SqlFieldName = PINDI_INSPI_DR ];

/// 销毁数量 (空安瓿/废贴数量)
Property PINDIQty As %Float [ SqlColumnNumber = 4, SqlFieldName = PINDI_Qty ];

/// 销毁数量 (液体量)
Property PINDIFluidQty As %Float [ SqlColumnNumber = 5, SqlFieldName = PINDI_FluidQty ];

/// 销毁批号
Property PINDIBatchNo As %String [ SqlColumnNumber = 6, SqlFieldName = PINDI_BatchNo ];

/// 销毁单位 (空安瓿/废贴单位)
Property PINDIUomDR As User.CTUOM [ SqlColumnNumber = 7, SqlFieldName = PINDI_Uom_DR ];

/// 销毁单位 (液体单位)
Property PINDIFluidUomDR As User.CTUOM [ SqlColumnNumber = 8, SqlFieldName = PINDI_FluidUom_DR ];

/// 批次ID (预留)
Property PINDIINCIBDR As User.INCItmBat [ SqlColumnNumber = 9, SqlFieldName = PINDI_INCIB_DR ];

Storage Default
{
<Data name="PHAINNarcDestroyItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PINDIOEOREDR</Value>
</Value>
<Value name="3">
<Value>PINDIINSPIDR</Value>
</Value>
<Value name="4">
<Value>PINDIQty</Value>
</Value>
<Value name="5">
<Value>PINDIFluidQty</Value>
</Value>
<Value name="6">
<Value>PINDIBatchNo</Value>
</Value>
<Value name="7">
<Value>PINDIUomDR</Value>
</Value>
<Value name="8">
<Value>PINDIFluidUomDR</Value>
</Value>
<Value name="9">
<Value>PINDIINCIBDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>PHAINNarcDestroyItmDefaultData</DefaultData>
<IdLocation>{%%PARENT}("I")</IdLocation>
<IndexLocation>^BS.PHA.IN.NarcDestroyI</IndexLocation>
<StreamLocation>^User.PHAINNarcDestroyItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
