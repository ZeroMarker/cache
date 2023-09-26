Class User.DHCInMatDispInclb Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_InMatDispInclb, StorageStrategy = Storage ]
{

Index RowIDBasedIDKeyIndex On IDSLBChildSub [ IdKey, PrimaryKey, Unique ];

Relationship IDSLBParRef As User.DHCInMatDispItm [ Cardinality = parent, Inverse = ChildDHCInMatDispInclb, Required, SqlFieldName = IDSLB_ParRef ];

Property IDSLBChildSub As %Library.Float [ InitialExpression = {$i(^User.DHCInMatDisp($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"I",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"L",0))}, SqlColumnNumber = 2, SqlFieldName = IDSLB_ChildSub ];

/// 批次
Property IDSLBINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = IDSLB_INCLB_DR ];

/// 批次打包表
Property IDSLBDSPIDR As User.DHCOEDispBatch [ SqlColumnNumber = 4, SqlFieldName = IDSLB_DSPI_DR ];

/// 数量
Property IDSLBQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = IDSLB_Qty ];

/// 售价
Property IDSLBSp As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = IDSLB_Sp ];

/// 售价金额
Property IDSLBSpAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = IDSLB_SpAmt ];

/// 退回数量
Property IDSLBRetQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = IDSLB_RetQty ];

Storage Storage
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDSLBINCLBDR</Value>
</Value>
<Value name="3">
<Value>IDSLBDSPIDR</Value>
</Value>
<Value name="4">
<Value>IDSLBQty</Value>
</Value>
<Value name="5">
<Value>IDSLBSp</Value>
</Value>
<Value name="6">
<Value>IDSLBSpAmt</Value>
</Value>
<Value name="7">
<Value>IDSLBRetQty</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCInMatDispInclb")</DataLocation>
<IdLocation>^User.DHCInMatDispItmC("ChildDHCInMatDispInclb")</IdLocation>
<IndexLocation>^User.DHCInMatDispInclbI</IndexLocation>
<Internal>1</Internal>
<StreamLocation>^User.DHCInMatDispInclbS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
