Class User.DHCInMatRetItm Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_InMatRetItm ]
{

Index RowIDBasedIDKeyIndex On IREIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship IREIParRef As User.DHCInMatRet [ Cardinality = parent, Inverse = ChildDHCInMatRetItm, Required, SqlFieldName = IREI_ParRef ];

Relationship ChildDHCInMatRetInclb As User.DHCInMatRetInclb [ Cardinality = children, Inverse = IRELBParRef ];

Property IREIChildSub As %Library.Float [ InitialExpression = {$i(^User.DHCInMatRet($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = IREI_ChildSub ];

/// 就诊id
Property IREIADMDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = IREI_ADM_DR ];

/// 就诊科室id
Property IREIADMLOCDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = IREI_ADMLOC_DR ];

/// 医嘱id
Property IREIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 5, SqlFieldName = IREI_OEORI_DR ];

/// 打包表id
Property IREIDSPDR As User.DHCOEDispensing [ SqlColumnNumber = 6, SqlFieldName = IREI_DSP_DR ];

/// 库存项id
Property IREIINCIDR As User.INCItm [ SqlColumnNumber = 7, SqlFieldName = IREI_INCI_DR ];

/// 数量
Property IREIQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = IREI_Qty ];

/// 售价
Property IREISp As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = IREI_Sp ];

/// 售价金额
Property IREISpAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = IREI_SpAmt ];

/// 发放子表id
Property IREIMatDspDR As User.DHCInMatDispItm [ SqlColumnNumber = 11, SqlFieldName = IREI_MatDsp_DR ];

Storage Default
{
<Data name="DHCInMatRetItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREIADMDR</Value>
</Value>
<Value name="3">
<Value>IREIADMLOCDR</Value>
</Value>
<Value name="4">
<Value>IREIOEORIDR</Value>
</Value>
<Value name="5">
<Value>IREIDSPDR</Value>
</Value>
<Value name="6">
<Value>IREIINCIDR</Value>
</Value>
<Value name="7">
<Value>IREIQty</Value>
</Value>
<Value name="8">
<Value>IREISp</Value>
</Value>
<Value name="9">
<Value>IREISpAmt</Value>
</Value>
<Value name="10">
<Value>IREIMatDspDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCInMatRetItm")</DataLocation>
<DefaultData>DHCInMatRetItmDefaultData</DefaultData>
<IdLocation>^User.DHCInMatRetC("ChildDHCInMatRetItm")</IdLocation>
<IndexLocation>^User.DHCInMatRetItmI</IndexLocation>
<StreamLocation>^User.DHCInMatRetItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
