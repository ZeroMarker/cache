Class User.DHCDocPilotProPat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPP_RowId, SqlTableName = DHC_DocPilotProPat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProject Parent Reference
Relationship PPPPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProPat, Required, SqlFieldName = PPP_PP_ParRef ];

Relationship ChildDHCDocPilotProPatAdm As User.DHCDocPilotProPatAdm [ Cardinality = children, Inverse = PPPAPPPParRef ];

/// PPP_ChildSub
Property PPPChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPP(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPP_ChildSub ];

/// PPP_Papmi_Dr
Property PPPPapmiDr As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = PPP_Papmi_Dr ];

/// PPP_VisitStatus
Property PPPVisitStatus As %Library.String(DISPLAYLIST = ",Normal,Cancel,Over,Revoke,Transfer", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",N,C,O,R,T") [ SqlColumnNumber = 4, SqlFieldName = PPP_VisitStatus ];

/// PPP_CreateDoctor_Dr
Property PPPCreateDoctorDr As User.CTCareProv [ SqlColumnNumber = 5, SqlFieldName = PPP_CreateDoctor_Dr ];

/// PPP_CreateDepartment_Dr
Property PPPCreateDepartmentDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PPP_CreateDepartment_Dr ];

/// PPP_CreateUser_Dr
Property PPPCreateUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PPP_CreateUser_Dr ];

/// PPP_CreateDate
Property PPPCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PPP_CreateDate ];

/// PPP_CreateTime
Property PPPCreateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PPP_CreateTime ];

/// PPP_CancelUserDr
Property PPPCancelUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PPP_CancelUser_Dr ];

/// PPP_CancelDate
Property PPPCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PPP_CancelDate ];

/// PPP_PatientLimit
Property PPPPatientLimit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PPP_PatientLimit ];

/// PPP_ReMark
Property PPPReMark As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PPP_ReMark ];

/// PPP_Note1
Property PPPCancelReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PPP_CancelReason ];

/// PPP_AgreementDate
Property PPPAgreementDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = PPP_AgreementDate ];

/// PPP_ExitDate
Property PPPExitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = PPP_ExitDate ];

/// PPP_Note4
Property PPPNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PPP_Note4 ];

/// PPP_Note5
Property PPPNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PPP_Note5 ];

/// PPP_ScreenNo
Property PPPScreenNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PPP_ScreenNo ];

/// PPP_Stage
Property PPPStage As User.DHCDocPilotProStage [ SqlColumnNumber = 20, SqlFieldName = PPP_Stage ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPP_AgreementDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPP_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPP_CancelReason">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPP_CancelUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PPP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPP_CreateDepartment_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPP_CreateDoctor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPP_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPP_ExitDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPP_Note4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PPP_Note5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PPP_Papmi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPP_PatientLimit">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPP_ReMark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPP_ScreenNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PPP_Stage">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PPP_VisitStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocPPP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PPP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxStage">
<Global>^DHCDocPPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Stage"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPP_Stage}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PPP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxStagePapmiDr">
<Global>^DHCDocPPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"StagePapmiDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPP_Stage}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PPP_Papmi_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PPP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCDocPPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPP_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDepartmentDr">
<Global>^DHCDocPPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CreateDepartmentDr"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PPP_CreateDepartment_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDocDepart">
<Global>^DHCDocPPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DocDr"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPP_CreateDoctor_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"Depart"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPP_CreateDepartment_Dr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{PPP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDoctorDr">
<Global>^DHCDocPPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CreateDoctorDr"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PPP_CreateDoctor_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PPP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNote5">
<Global>^DHCDocPPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"Note5"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PPP_Note5}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmiDr">
<Global>^DHCDocPPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"PapmiDr"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPP_Papmi_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProPatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
