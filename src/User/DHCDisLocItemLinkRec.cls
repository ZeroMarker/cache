Class User.DHCDisLocItemLinkRec Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LRE_RowID, SqlTableName = DHC_DisLocItemLinkRec, StorageStrategy = SQLStorage ]
{

// 关联字典id	

Property LREItemDr As User.DHCDisLocItem [ SqlColumnNumber = 2, SqlFieldName = LRE_Item_Dr ];

// 可配送科室

Property LRELocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = LRE_Loc_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISLRE)</SqlIdExpression>
<SQLMap name="IndexItem">
<Global>^DHCDISLRE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LRE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRE_Item_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LRE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="LRE_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LRE_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDISLRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LRE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LRE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisLocItemLinkRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
