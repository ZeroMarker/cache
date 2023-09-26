Class User.MATDeliverItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = MATDI_RowId, SqlTableName = MAT_DeliverItm ]
{

Relationship MATDIParRef As User.MATDeliver [ Cardinality = parent, Inverse = ChildMATDeliverItm, Required, SqlFieldName = MATDI_MATD_ParRef ];

Property MATDIChildSub As %Float [ SqlColumnNumber = 2, SqlFieldName = MATDI_ChildSub ];

/// 物流订单明细ID
Property MATDIINPOIDR As User.INPOItm [ SqlColumnNumber = 3, SqlFieldName = MATDI_INPOI_DR ];

/// 配送明细id
Property MATDIDetailSubId As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = MATDI_DetailSubId ];

Property MATDIINCIDR As User.INCItm [ SqlColumnNumber = 5, SqlFieldName = MATDI_INCI_DR ];

/// 验收数量(默认等于发货量)
Property MATDIQty As %Float [ SqlColumnNumber = 6, SqlFieldName = MATDI_Qty ];

/// 进价
Property MATDIRp As %Float [ SqlColumnNumber = 7, SqlFieldName = MATDI_Rp ];

/// 进价金额
Property MATDIRpAmt As %Float [ SqlColumnNumber = 8, SqlFieldName = MATDI_RpAmt ];

/// 单位
Property MATDICTUOMDR As User.CTUOM [ SqlColumnNumber = 9, SqlFieldName = MATDI_CTUOM_DR ];

/// 批号
Property MATDIBatchNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = MATDI_BatchNo ];

/// 效期
Property MATDIExpDate As %Date [ SqlColumnNumber = 11, SqlFieldName = MATDI_ExpDate ];

/// 生产日期
Property MATDIProduceDate As %Date [ SqlColumnNumber = 12, SqlFieldName = MATDI_ProduceDate ];

/// 原有发货量
Property MATDIDeliverQty As %Float [ SqlColumnNumber = 13, SqlFieldName = MATDI_DeliverQty ];

/// 唯一条码
Property MATDIBarCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 14, SqlFieldName = MATDI_BarCode ];

/// 自带条码
Property MATDIOriginalCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 15, SqlFieldName = MATDI_OriginalCode ];

/// 序列号
Property MATDISerialNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = MATDI_SerialNo ];

/// 售价
Property MATDISp As %Float [ SqlColumnNumber = 17, SqlFieldName = MATDI_Sp ];

/// 售价金额
Property MATDISpAmt As %Float [ SqlColumnNumber = 18, SqlFieldName = MATDI_SpAmt ];

/// 发票号
Property MATDIInvNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 19, SqlFieldName = MATDI_InvNo ];

/// 发票代码
Property MATDIInvCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 20, SqlFieldName = MATDI_InvCode ];

/// 发票日期
Property MATDIInvDate As %Date [ SqlColumnNumber = 21, SqlFieldName = MATDI_InvDate ];

/// 发票金额
Property MATDIInvAmt As %Float [ SqlColumnNumber = 22, SqlFieldName = MATDI_InvAmt ];

/// 备注
Property MATDIRemarks As %String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 23, SqlFieldName = MATDI_Remarks ];

Storage Default
{
<Data name="MATDeliverItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATDIChildSub</Value>
</Value>
<Value name="3">
<Value>MATDIINPOIDR</Value>
</Value>
<Value name="4">
<Value>MATDIDetailSubId</Value>
</Value>
<Value name="5">
<Value>MATDIINCIDR</Value>
</Value>
<Value name="6">
<Value>MATDIQty</Value>
</Value>
<Value name="7">
<Value>MATDIRp</Value>
</Value>
<Value name="8">
<Value>MATDIRpAmt</Value>
</Value>
<Value name="9">
<Value>MATDICTUOMDR</Value>
</Value>
<Value name="10">
<Value>MATDIBatchNo</Value>
</Value>
<Value name="11">
<Value>MATDIExpDate</Value>
</Value>
<Value name="12">
<Value>MATDIProduceDate</Value>
</Value>
<Value name="13">
<Value>MATDIDeliverQty</Value>
</Value>
<Value name="14">
<Value>MATDIBarCode</Value>
</Value>
<Value name="15">
<Value>MATDIOriginalCode</Value>
</Value>
<Value name="16">
<Value>MATDISerialNo</Value>
</Value>
<Value name="17">
<Value>MATDISp</Value>
</Value>
<Value name="18">
<Value>MATDISpAmt</Value>
</Value>
<Value name="19">
<Value>MATDIInvNo</Value>
</Value>
<Value name="20">
<Value>MATDIInvCode</Value>
</Value>
<Value name="21">
<Value>MATDIInvDate</Value>
</Value>
<Value name="22">
<Value>MATDIInvAmt</Value>
</Value>
<Value name="23">
<Value>MATDIRemarks</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Itm")</DataLocation>
<DefaultData>MATDeliverItmDefaultData</DefaultData>
<IdLocation>^User.MATDeliverC("Itm")</IdLocation>
<IndexLocation>^User.MATDeliverItmI</IndexLocation>
<SqlRowIdName>MATDI_RowId</SqlRowIdName>
<StreamLocation>^User.MATDeliverItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
