/// Admission Leave             (1045)
Class User.PAAdmLeave Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmLeave, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADMLChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm Parent Reference
Relationship ADMLParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmLeave, Required, SqlFieldName = ADML_ParRef ];

/// Childsub
Property ADMLChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LEA",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ADML_Childsub ];

/// Room Des Ref to PARoom
Property ADMLRoomDR As PACRoom [ SqlColumnNumber = 3, SqlFieldName = ADML_Room_DR ];

/// Going Out Date
Property ADMLGoingOutDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ADML_GoingOutDate ];

/// Going Out Time
Property ADMLGoingOutTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ADML_GoingOutTime ];

/// Expected Time of Return
Property ADMLExpectedTimeReturn As %Time [ SqlColumnNumber = 6, SqlFieldName = ADML_ExpectedTimeReturn ];

/// Expected Date of Return
Property ADMLExpectedDateReturn As %Date [ SqlColumnNumber = 7, SqlFieldName = ADML_ExpectedDateReturn ];

/// Reason Des Rrf to PACReas
Property ADMLReasonDR As PACReasonforLeave [ SqlColumnNumber = 8, SqlFieldName = ADML_Reason_DR ];

/// Doctor Approving Des Ref to CTCP
Property ADMLDoctorApproveDR As CTCareProv [ SqlColumnNumber = 9, SqlFieldName = ADML_DoctorApprove_DR ];

/// Nurse Des Ref to CTCP
Property ADMLNurseDR As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = ADML_Nurse_DR ];

/// Actual Date of Return
Property ADMLActualDateReturn As %Date [ SqlColumnNumber = 11, SqlFieldName = ADML_ActualDateReturn ];

/// Actual Time of Return
Property ADMLActualTimeReturn As %Time [ SqlColumnNumber = 12, SqlFieldName = ADML_ActualTimeReturn ];

/// Des Ref CTCP
Property ADMLNurseReturnDR As CTCareProv [ SqlColumnNumber = 13, SqlFieldName = ADML_NurseReturn_DR ];

/// Des Ref LeaveType
Property ADMLLeaveTypeDR As PACLeaveType [ SqlColumnNumber = 14, SqlFieldName = ADML_LeaveType_DR ];

/// Des Ref LeaveCategory
Property ADMLLeaveCategoryDR As PACLeaveCategory [ SqlColumnNumber = 15, SqlFieldName = ADML_LeaveCategory_DR ];

/// Des Ref TempAddress
Property ADMLTempAddressDR As PATempAddress [ SqlColumnNumber = 16, SqlFieldName = ADML_TempAddress_DR ];

/// UpdateDate
Property ADMLUpdateDate As %Date [ SqlColumnNumber = 17, SqlFieldName = ADML_UpdateDate ];

/// UpdateTime
Property ADMLUpdateTime As %Time [ SqlColumnNumber = 18, SqlFieldName = ADML_UpdateTime ];

/// Des Ref UpdateUser
Property ADMLUpdateUserDR As SSUser [ SqlColumnNumber = 19, SqlFieldName = ADML_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property ADMLUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 20, SqlFieldName = ADML_UpdateUserHospital_DR ];

/// Contract Patient Number
Property ADMLContractPatientNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = ADML_ContractPatientNumber ];

/// Des Ref ContractRole
Property ADMLContractRoleDR As PACContractRole [ SqlColumnNumber = 22, SqlFieldName = ADML_ContractRole_DR ];

/// Des Ref ContractType
Property ADMLContractTypeDR As PACContractType [ SqlColumnNumber = 23, SqlFieldName = ADML_ContractType_DR ];

/// Comments
Property ADMLComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = ADML_Comments, SqlListType = SUBNODE ];

/// Des Ref PAAdmContractedCare
Property ADMLPAAdmContractedCareDR As PAAdmContractedCare [ SqlColumnNumber = 25, SqlFieldName = ADML_PAAdmContractedCare_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmLeave).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmLeave","OnAfterDelete")
 d Table^HL7Outbound("PAAdmLeave",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmLeave).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmLeave","OnAfterInsert")
 d Table^HL7Outbound("PAAdmLeave",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmLeave).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmLeave","OnAfterUpdate")
 d Table^HL7Outbound("PAAdmLeave",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmLeave).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmLeave","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmLeave).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmLeave","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADML_ActualDateReturn">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADML_ActualTimeReturn">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADML_Comments">
<Node>"CMT"</Node>
</Data>
<Data name="ADML_ContractPatientNumber">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADML_ContractRole_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ADML_ContractType_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ADML_DoctorApprove_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADML_ExpectedDateReturn">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADML_ExpectedTimeReturn">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADML_GoingOutDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADML_GoingOutTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADML_LeaveCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADML_LeaveType_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADML_NurseReturn_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADML_Nurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADML_PAAdmContractedCare_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ADML_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADML_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADML_TempAddress_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADML_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADML_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADML_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADML_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADML_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LEA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADML_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGoingOutDate">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ADML_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LeaveDateFrom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADML_GoingOutDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADML_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReturnDate">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ADML_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LeaveDateTo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADML_ActualDateReturn}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADML_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADML_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmLeaveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
