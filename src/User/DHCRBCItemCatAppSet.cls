Class User.DHCRBCItemCatAppSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DICAS_Rowid, SqlTableName = DHCRBC_ItemCatAppSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Reference
Property DICASItemCatDR As User.ARCItemCat [ SqlColumnNumber = 2, SqlFieldName = DICAS_ItemCat_DR ];

/// Reference
Property DICASAppShapeDR As User.DHCRBCApplicationShape [ SqlColumnNumber = 3, SqlFieldName = DICAS_AppShape_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCApp("ItmCat"))</SqlIdExpression>
<SQLMap name="IndexofItemCat">
<Global>^DHCRBCAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DICAS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DICAS_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DICAS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="DICAS_AppShape_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DICAS_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DICAS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DICAS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemCatAppSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
