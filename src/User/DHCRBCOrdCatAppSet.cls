Class User.DHCRBCOrdCatAppSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOCAS_Rowid, SqlTableName = DHCRBC_OrdCatAppSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Reference
Property DOCASOrdCategoryDR As User.OECOrderCategory [ SqlColumnNumber = 2, SqlFieldName = DOCAS_OrdCategory_DR ];

/// Reference
Property DOCASAppShapeDR As User.DHCRBCApplicationShape [ SqlColumnNumber = 3, SqlFieldName = DOCAS_AppShape_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCApp("OrdCat"))</SqlIdExpression>
<SQLMap name="IndexofOrdCategory">
<Global>^DHCRBCAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DOCAS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOCAS_OrdCategory_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOCAS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="DOCAS_AppShape_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOCAS_OrdCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DOCAS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DOCAS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCOrdCatAppSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
