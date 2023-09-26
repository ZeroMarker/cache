Class User.DHCDocPilotProCare Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPC_RowId, SqlTableName = DHC_DocPilotProCare, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProject Parent Reference
Relationship PPCPPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProCare, Required, SqlFieldName = PPC_PPP_ParRef ];

/// PPC_ChildSub
Property PPCChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPC(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPC_ChildSub ];

/// PPC_Doctor_Dr
Property PPCDoctorDr As User.CTCareProv [ SqlColumnNumber = 3, SqlFieldName = PPC_Doctor_Dr ];

/// PPC_CurGroup_Dr
Property PPCCurGroupDr As User.SSGroup [ SqlColumnNumber = 4, SqlFieldName = PPC_CurGroup_Dr ];

/// PPC_Level
Property PPCLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPC_Level ];

/// PPC_State
Property PPCState As %Library.String(DISPLAYLIST = ",Normal,Abort,Strike", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S") [ SqlColumnNumber = 6, SqlFieldName = PPC_State ];

/// PPC_StartDate
Property PPCStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PPC_StartDate ];

/// PPC_EndDate
Property PPCEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PPC_EndDate ];

/// PPC_JoinUser_Dr
Property PPCJoinUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PPC_JoinUser_Dr ];

/// PPC_Note1
Property PPCNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PPC_Note1 ];

/// PPC_Note2
Property PPCNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PPC_Note2 ];

/// 是否联系人
Property PPCContactFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PPC_ContactFlag ];

/// 项目联系人电话
Property PPCContactTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PPC_ContactTel ];

/// 所属主要研究者
Property PPCUserDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PPC_User_Dr ];

/// 主要研究者标志
Property PPCStartUserFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = PPC_StartUserFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPC_ContactFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPC_ContactTel">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPC_CurGroup_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPC_Doctor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPC_JoinUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPC_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPC_Note1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPC_Note2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPC_StartUserFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPC_State">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCDocPPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PPC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexJoinUserDr">
<Global>^DHCDocPPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"JoinUserDr"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPC_JoinUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
