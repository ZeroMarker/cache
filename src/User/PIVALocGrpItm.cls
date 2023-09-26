Class User.PIVALocGrpItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PLGI_RowID, SqlTableName = PIVA_LocGrpItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PLGIChildsub [ IdKey, PrimaryKey, Unique ];

/// PIVA_LocGrp Parent Reference
Relationship PLGIPLGParRef As User.PIVALocGrp [ Cardinality = parent, Inverse = ChildPIVALocGrpItm, Required, SqlFieldName = PLGI_PLG_ParRef ];

/// PLGI_Childsub
Property PLGIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PLGI_Childsub ];

/// PLGI_Loc_Dr
Property PLGILocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PLGI_Loc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterPLGR">
<Data name="PLGI_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLGI_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLGI_PLG_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PLGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_LocGrp.PLG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PLGI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PIVA_LocGrp.PLG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PLGI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVALocGrpItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
