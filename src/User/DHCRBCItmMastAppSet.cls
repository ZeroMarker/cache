Class User.DHCRBCItmMastAppSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIMAS_Rowid, SqlTableName = DHCRBC_ItmMastAppSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Reference
Property DIMASArcItemDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DIMAS_ArcItem_DR ];

/// reference
Property DIMASAppShapeDR As User.DHCRBCApplicationShape [ SqlColumnNumber = 3, SqlFieldName = DIMAS_AppShape_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCApp("ItmMast"))</SqlIdExpression>
<SQLMap name="IndexofArcItem">
<Global>^DHCRBCAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DIMAS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIMAS_ArcItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIMAS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="DIMAS_AppShape_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIMAS_ArcItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIMAS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIMAS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItmMastAppSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
