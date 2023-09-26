Class User.DHCInMatRetInclb Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_InMatRetInclb ]
{

Index RowIDBasedIDKeyIndex On IRELBChildSub [ IdKey, PrimaryKey, Unique ];

Relationship IRELBParRef As User.DHCInMatRetItm [ Cardinality = parent, Inverse = ChildDHCInMatRetInclb, Required, SqlFieldName = IRELB_ParRef ];

Property IRELBChildSub As %Library.Float [ InitialExpression = {$i(^User.DHCInMatRet($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"I",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"L",0))}, SqlColumnNumber = 2, SqlFieldName = IRELB_ChildSub ];

/// 批次
Property IRELBINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = IRELB_INCLB_DR ];

/// 批次打包表
Property IRELBDSPIDR As User.DHCOEDispBatch [ SqlColumnNumber = 4, SqlFieldName = IRELB_DSPI_DR ];

/// 数量
Property IRELBQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = IRELB_Qty ];

/// 售价
Property IRELBSp As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = IRELB_Sp ];

/// 售价金额
Property IRELBSpAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = IRELB_SpAmt ];

/// 发放批次表id
Property IRELBMatDspDR As User.DHCInMatDispInclb [ SqlColumnNumber = 8, SqlFieldName = IRELB_MatDsp_DR ];

Storage Default
{
<Data name="DHCInMatRetInclbDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRELBINCLBDR</Value>
</Value>
<Value name="3">
<Value>IRELBDSPIDR</Value>
</Value>
<Value name="4">
<Value>IRELBQty</Value>
</Value>
<Value name="5">
<Value>IRELBSp</Value>
</Value>
<Value name="6">
<Value>IRELBSpAmt</Value>
</Value>
<Value name="7">
<Value>IRELBMatDspDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCInMatRetInclb")</DataLocation>
<DefaultData>DHCInMatRetInclbDefaultData</DefaultData>
<IdLocation>^User.DHCInMatRetItmC("ChildDHCInMatRetInclb")</IdLocation>
<IndexLocation>^User.DHCInMatRetInclbI</IndexLocation>
<StreamLocation>^User.DHCInMatRetInclbS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
