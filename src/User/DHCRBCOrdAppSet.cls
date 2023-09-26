Class User.DHCRBCOrdAppSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOS_Rowid, SqlTableName = DHCRBC_OrdAppSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DOS_ArcItem_DR
Property DOSArcItemDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DOS_ArcItem_DR ];

/// DOS_ItemCat_DR
Property DOSItemCatDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DOS_ItemCat_DR ];

/// DOS_AppShape_DR
Property DOSAppShapeDR As User.DHCRBCApplicationShape [ SqlColumnNumber = 4, SqlFieldName = DOS_AppShape_DR ];

/// DOS_OrdCategory_DR
Property DOSOrdCategoryDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DOS_OrdCategory_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCApp("OrdAppSet"))</SqlIdExpression>
<SQLMap name="CategoryIndex">
<Global>^DHCRBCAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DOS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Category"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOS_OrdCategory_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMastermap">
<Data name="DOS_AppShape_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DOS_ArcItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOS_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOS_OrdCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBCApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DOS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OrdAppSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ItmCatIndex">
<Global>^DHCRBCAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DOS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOS_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ItmMastIndex">
<Global>^DHCRBCAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DOS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOS_ArcItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCOrdAppSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
