Class User.PIVAOrdGrpItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POGI_RowID, SqlTableName = PIVA_OrdGrpItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On POGIChildSub [ IdKey, PrimaryKey, Unique ];

/// PIVA_OrdGrp Parent Reference
Relationship POGIPOGParref As User.PIVAOrdGrp [ Cardinality = parent, Inverse = ChildPIVAOrdGrpItm, Required, SqlFieldName = POGI_POG_Parref ];

/// POGI_ChildSub
Property POGIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = POGI_ChildSub ];

/// POGI_DSP_Dr
Property POGIDSPDr As User.DHCOEDispensing [ SqlColumnNumber = 3, SqlFieldName = POGI_DSP_Dr ];

/// POGI_PIVAReq_Dr
Property POGIPIVAReqDr As User.PIVADispRequest [ SqlColumnNumber = 4, SqlFieldName = POGI_PIVAReq_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="POGI_DSP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POGI_PIVAReq_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PIVA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>POGI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PIVA_OrdGrp.POG_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDSP">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVA_OrdGrp.POG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>POGI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POGI_DSP_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVA_OrdGrp.POG_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POGI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrdGrpItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
