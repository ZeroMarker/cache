Class User.DHCInMatDispItm Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_InMatDispItm ]
{

Index RowIDBasedIDKeyIndex On IDSIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship IDSIParRef As User.DHCInMatDisp [ Cardinality = parent, Inverse = ChildDHCInMatDispItm, Required, SqlFieldName = IDSI_ParRef ];

Relationship ChildDHCInMatDispInclb As User.DHCInMatDispInclb [ Cardinality = children, Inverse = IDSLBParRef ];

Property IDSIChildSub As %Library.Float [ InitialExpression = {$i(^User.DHCInMatDisp($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = IDSI_ChildSub ];

/// 就诊id
Property IDSIADMDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = IDSI_ADM_DR ];

/// 就诊科室id
Property IDSIADMLOCDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = IDSI_ADMLOC_DR ];

/// 医嘱id
Property IDSIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 5, SqlFieldName = IDSI_OEORI_DR ];

/// 打包表id
Property IDSIDSPDR As User.DHCOEDispensing [ SqlColumnNumber = 6, SqlFieldName = IDSI_DSP_DR ];

/// 床号
Property IDSIBedNo As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = IDSI_BedNo ];

/// 使用日期
Property IDSIDoseDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = IDSI_DoseDate ];

/// 医嘱状态
Property IDSIOriStatus As User.OEOrdStatus [ SqlColumnNumber = 9, SqlFieldName = IDSI_OriStatus ];

/// 库存项id
Property IDSIINCIDR As User.INCItm [ SqlColumnNumber = 10, SqlFieldName = IDSI_INCI_DR ];

/// 数量
Property IDSIQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = IDSI_Qty ];

/// 售价
Property IDSISp As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = IDSI_Sp ];

/// 售价金额
Property IDSISpAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = IDSI_SpAmt ];

/// 退回数量
Property IDSIRetQty As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = IDSI_RetQty ];

Index DHCInMatDispItmAdmIndex On IDSIADMDR As Exact;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDSIADMDR</Value>
</Value>
<Value name="3">
<Value>IDSIADMLOCDR</Value>
</Value>
<Value name="4">
<Value>IDSIOEORIDR</Value>
</Value>
<Value name="5">
<Value>IDSIDSPDR</Value>
</Value>
<Value name="6">
<Value>IDSIBedNo</Value>
</Value>
<Value name="7">
<Value>IDSIDoseDate</Value>
</Value>
<Value name="8">
<Value>IDSIOriStatus</Value>
</Value>
<Value name="9">
<Value>IDSIINCIDR</Value>
</Value>
<Value name="10">
<Value>IDSIQty</Value>
</Value>
<Value name="11">
<Value>IDSISp</Value>
</Value>
<Value name="12">
<Value>IDSISpAmt</Value>
</Value>
<Value name="13">
<Value>IDSIRetQty</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCInMatDispItm")</DataLocation>
<DefaultData>DHCInMatDispItmDefaultData</DefaultData>
<IdLocation>^User.DHCInMatDispC("ChildDHCInMatDispItm")</IdLocation>
<IndexLocation>^User.DHCInMatDispItmI</IndexLocation>
<StreamLocation>^User.DHCInMatDispItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
