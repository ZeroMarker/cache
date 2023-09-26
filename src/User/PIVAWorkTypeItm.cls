Class User.PIVAWorkTypeItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIVAWTI_Rowid, SqlTableName = PIVA_WorkTypeItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PIVAWTIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PIVAWTIParref As User.PIVAWorkType [ Cardinality = parent, Inverse = ChildPIVAWorkTypeItm, Required, SqlFieldName = PIVAWTI_Parref ];

Property PIVAWTIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PIVAWTI_ChildSub ];

/// PIVAWTI_ConfTab_Dr
Property PIVAWTIConfTabDr As User.PIVAConfigTable [ SqlColumnNumber = 3, SqlFieldName = PIVAWTI_ConfTab_Dr ];

/// PIVAWTI_Inst_Dr
Property PIVAWTIInstDr As User.PHCInstruc [ SqlColumnNumber = 4, SqlFieldName = PIVAWTI_Inst_Dr ];

/// PIVAWTI_Relation 
Property PIVAWTIRelation As %String(DISPLAYLIST = ",大于,小于", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",>,<") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = PIVAWTI_Relation ];

/// PIVAWTI_Liquid 
Property PIVAWTLiquid As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PIVAWTI_Liquid ];

Storage SQLStorage
{
<SQLMap name="DataMasterPIVAWTItm">
<Data name="PIVAWTI_ConfTab_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIVAWTI_Inst_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIVAWTI_Liquid">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIVAWTI_Relation">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PIVAWT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_WorkType.PIVAWT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PIVAWTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVA_WorkType.PIVAWT_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVAWTI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPCTInst">
<Global>^PIVAWTi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVA_WorkType.PIVAWT_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIVAWTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PCTInst"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIVAWTI_ConfTab_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVAWTI_Inst_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVA_WorkType.PIVAWT_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIVAWTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAWorkTypeItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
