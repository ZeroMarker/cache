/// Loc Borrow Pref(2174)
Class User.CTLocBorrowPref Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_LocBorrowPref, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property BORPRCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = BORPR_CTLOC_DR ];

/// Childsub
Property BORPRChildsub As %Float [ InitialExpression = {$i(^CTLOC($p(%d(0),$c(1)),"BORPR",0))}, SqlColumnNumber = 2, SqlFieldName = BORPR_Childsub ];

/// CT_Loc Parent Reference
Relationship BORPRParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocBorrowPref, Required, SqlFieldName = BORPR_ParRef ];

Index RowIDBasedIDKeyIndex On BORPRChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BORPR_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>BORPR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BORPR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BORPR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>BORPR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BORPR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BORPR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BORPR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BORPR_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocBorrowPrefS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
