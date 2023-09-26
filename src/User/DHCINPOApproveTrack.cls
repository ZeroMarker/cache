Class User.DHCINPOApproveTrack Extends (%Persistent, User.Abstract) [ SqlRowIdName = POIA_RowId, SqlTableName = DHC_INPO_ApproveTrack ]
{

/// POIA_INPOI_DR	订单明细ID
Property POIAINPOIDR As User.INPOItm [ SqlColumnNumber = 2, SqlFieldName = POIA_INPOI_DR ];

/// POIA_ApproveQty	到货验收数量
Property POIAApproveQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 3, SqlFieldName = POIA_ApproveQty ];

/// POIA_ApproveUser 验收人员
Property POIAApproveUser As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = POIA_ApproveUser ];

/// POIA_ApproveDate 验收日期
Property POIAApproveDate As %Date [ SqlColumnNumber = 5, SqlFieldName = POIA_ApproveDate ];

/// POIA_ApproveTime 验收时间
Property POIAApproveTime As %Date [ SqlColumnNumber = 6, SqlFieldName = POIA_ApproveTime ];

/// POIA_INCI_DR 库存项
Property POIAINCIDR As User.INCItm [ SqlColumnNumber = 7, SqlFieldName = POIA_INCI_DR ];

/// POIA_Uom_DR 单位
Property POIAUomDR As User.CTUOM [ SqlColumnNumber = 8, SqlFieldName = POIA_Uom_DR ];

/// 进价
Property POIARp As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 9, SqlFieldName = POIA_Rp ];

/// POIA_INGRFlag 入库标志
Property POIAINGRFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = POIA_INGRFlag ];

/// POIA_RecItm_DR	入库明细ID
Property POIARecItmDR As User.INGdRecItm [ SqlColumnNumber = 11, SqlFieldName = POIA_RecItm_DR ];

/// POIA_BatchNo 批号
Property POIABatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = POIA_BatchNo ];

/// POIA_ExpDate 效期
Property POIAExpDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = POIA_ExpDate ];

Index DHCINPOIDRIndex On POIAINPOIDR As Exact;

Storage Default
{
<Data name="DHCINPOApproveTrackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>POIAINPOIDR</Value>
</Value>
<Value name="3">
<Value>POIAApproveQty</Value>
</Value>
<Value name="4">
<Value>POIAApproveUser</Value>
</Value>
<Value name="5">
<Value>POIAApproveDate</Value>
</Value>
<Value name="6">
<Value>POIAApproveTime</Value>
</Value>
<Value name="7">
<Value>POIAINCIDR</Value>
</Value>
<Value name="8">
<Value>POIAUomDR</Value>
</Value>
<Value name="9">
<Value>POIARp</Value>
</Value>
<Value name="10">
<Value>POIAINGRFlag</Value>
</Value>
<Value name="11">
<Value>POIARecItmDR</Value>
</Value>
<Value name="12">
<Value>POIABatchNo</Value>
</Value>
<Value name="13">
<Value>POIAExpDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCINPOApproveTrackD</DataLocation>
<DefaultData>DHCINPOApproveTrackDefaultData</DefaultData>
<IdLocation>^User.DHCINPOApproveTrackD</IdLocation>
<IndexLocation>^User.DHCINPOApproveTrackI</IndexLocation>
<StreamLocation>^User.DHCINPOApproveTrackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
