Class User.PIVAOrderLinkItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POLI_RowID, SqlTableName = PIVA_OrderLinkItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On POLIChildsub [ IdKey, PrimaryKey, Unique ];

/// PIVA_OrderLink Parent Reference
Relationship POLIPOLParRef As User.PIVAOrderLink [ Cardinality = parent, Inverse = ChildPIVAOrderLinkItm, Required, SqlFieldName = POLI_POL_ParRef ];

/// POLI_Childsub
Property POLIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = POLI_Childsub ];

/// POLI_Arcim_Dr
Property POLIArcimDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = POLI_Arcim_Dr ];

/// POLI_PHCPivaCat_Dr
Property POLIPHCPivaCatDr As %Library.String(COLLATION = "EXACT") [ SqlColumnNumber = 4, SqlFieldName = POLI_PHCPivaCat_Dr ];

/// POLI_PivaCatRelation
Property POLIPivaCatRelation As %Library.String(DISPLAYLIST = ",AND,OR", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 5, SqlFieldName = POLI_PivaCatRelation ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterPOLI">
<Data name="POLI_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POLI_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POLI_PHCPivaCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="POLI_POL_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POLI_PivaCatRelation">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^POLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_OrderLink.POL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>POLI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PIVA_OrderLink.POL_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"G"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{POLI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArcim">
<Global>^POLI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVA_OrderLink.POL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>POLI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{POLI_Arcim_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PIVA_OrderLink.POL_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{POLI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPivaCat">
<Global>^POLI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVA_OrderLink.POL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>POLI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PIVACAT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{POLI_PHCPivaCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PIVA_OrderLink.POL_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{POLI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrderLinkItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
