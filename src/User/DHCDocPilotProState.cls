/// PilotProjectState Change
Class User.DHCDocPilotProState Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPS_RowId, SqlTableName = DHC_DocPilotProState, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProject Parent Reference
Relationship PPSPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProState, Required, SqlFieldName = PPS_PP_ParRef ];

/// Child Sub (New Key)
Property PPSChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPS(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPS_ChildSub ];

/// PPS_CurState
Property PPSCurState As %Library.String(DISPLAYLIST = ",Normal,Abort,Strike,Verify,UnApproved,InApprove,Finish,Hang,Break,Didnotpass,Public", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S,V,U,I,F,H,B,D,P") [ SqlColumnNumber = 3, SqlFieldName = PPS_CurState ];

/// PPS_UpdateUser_Dr
Property PPSUpdateUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PPS_UpdateUser_Dr ];

/// PPS_UpdateDate
Property PPSUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PPS_UpdateDate ];

/// PPS_UpdateTime
Property PPSUpdateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PPS_UpdateTime ];

/// PPS_Remark
Property PPSRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPS_Remark ];

/// PPS_Note1
Property PPSNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PPS_Note1 ];

/// PPS_Note2
Property PPSNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PPS_Note2 ];

/// PPS_UpdateReason
Property PPSUpdateReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PPS_UpdateReason ];

/// PPS_AuthUser_Dr
Property PPSAuthUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PPS_AuthUser_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPS_AuthUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPS_CurState">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPS_Note1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPS_Note2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPS_UpdateReason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPS_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocPPS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PPS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCDocPPS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPS_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProStateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
