Class User.DHCInvInfoItm Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_InvInfoItm ]
{

Index RowIDBasedIDKeyIndex On INVIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship INVIParRef As User.DHCInvInfo [ Cardinality = parent, Inverse = ChildDHCInvInfoItm, Required, SqlFieldName = INVI_ParRef ];

Property INVIChildSub As %Library.Float [ InitialExpression = {$i(^DHCInvInfo($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = INVI_ChildSub ];

/// 入库单(退货单)子表RowId
Property INVIINGRIDR As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 3, SqlFieldName = INVI_INGRI_DR ];

/// 发票金额
Property INVIAmt As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = INVI_Amt ];

/// 类型(G-入库,R-退货)
Property INVIType As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Receive,Return", MAXLEN = 7, SELECTIVITY = "33.3333%", VALUELIST = ",G,R") [ SqlColumnNumber = 5, SqlFieldName = INVI_Type ];

Storage Default
{
<Data name="DHCInvInfoItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>INVIINGRIDR</Value>
</Value>
<Value name="3">
<Value>INVIAmt</Value>
</Value>
<Value name="4">
<Value>INVIType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCInvInfoItm")</DataLocation>
<DefaultData>DHCInvInfoItmDefaultData</DefaultData>
<IdLocation>^User.DHCInvInfoC("ChildDHCInvInfoItm")</IdLocation>
<IndexLocation>^User.DHCInvInfoItmI</IndexLocation>
<StreamLocation>^User.DHCInvInfoItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
