Class User.DHCDisGoodsReqItm Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = REQ_RowID, SqlTableName = DHC_DisGoodsReqItm, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On REQChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表id REQ_ParRef_Dr	
Relationship REQParRefDr As User.DHCDisGoodsRequest [ Cardinality = parent, Inverse = ChildDHCDISGOODSREQUEST, Required, SqlFieldName = REQ_ParRef_Dr ];

/// 子表sub REQ_ChildSub	
Property REQChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = REQ_ChildSub ];

/// 项目ID REQ_Item		
Property REQItem As User.DHCDisLocItem [ SqlColumnNumber = 3, SqlFieldName = REQ_Item ];

/// 去向 REQ_ExeLoc_Dr
Property REQExeLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = REQ_ExeLoc_Dr ];

/// 数量 REQ_Qty
Property REQQty As %Library.Numeric [ SqlColumnNumber = 5, SqlFieldName = REQ_Qty ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISGOODSREQITM)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="REQ_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REQ_ExeLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REQ_Item">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REQ_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDISGRE</Global>
<Subscript name="1">
<Expression>{DHC_DisGoodsRequest.REQ_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisGoodsReqItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
