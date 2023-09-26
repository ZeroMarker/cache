Class User.DHCDisLocUserLinkItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LinkItm_RowId, SqlTableName = DHC_DisLocUserLinkItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LUChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表id LU_ParRef
Relationship LUParRef As DHCDisLocUser [ Cardinality = parent, Inverse = ChildDHCDISLOCUSER, Required, SqlFieldName = LU_ParRef ];

/// 子表sub LU_ChildSub	
Property LUChildSub As %Numeric [ InitialExpression = {$i(^DHCDISLOCUSER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"LinkItm",0))}, SqlColumnNumber = 2, SqlFieldName = LU_ChildSub ];

/// 可配送项目 LU_Item_Dr
Property LUItemDr As User.DHCDisLocItem [ SqlColumnNumber = 3, SqlFieldName = LU_Item_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISLU)</SqlIdExpression>
<SQLMap name="Map1">
<Data name="LU_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LU_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LU_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISLU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DisLocUser.LU_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LU_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DisLocUser.LU_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkItm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LU_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisLocUserLinkItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
