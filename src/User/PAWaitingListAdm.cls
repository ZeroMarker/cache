/// PA Waiting List Adm(2035)
Class User.PAWaitingListAdm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListAdm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADMChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_WaitingList Parent Reference
Relationship ADMParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListAdm, Required, SqlFieldName = ADM_ParRef ];

/// Childsub
Property ADMChildsub As %Float [ InitialExpression = {$i(^PAWL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ADM",0))}, SqlColumnNumber = 2, SqlFieldName = ADM_Childsub ];

/// Des Ref PAADM
Property ADMPAADMDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = ADM_PAADM_DR ];

/// Adm Date
Property ADMAdmDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ADM_AdmDate ];

/// Cancel Date
Property ADMCancelDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ADM_CancelDate ];

/// Cancel Time
Property ADMCancelTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ADM_CancelTime ];

/// Des Ref CancelReason
Property ADMCancelReasonDR As PACWLReasonNotAvail [ SqlColumnNumber = 7, SqlFieldName = ADM_CancelReason_DR ];

/// Time
Property ADMTime As %Time [ SqlColumnNumber = 8, SqlFieldName = ADM_Time ];

/// Confirmation
Property ADMConfirmation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ADM_Confirmation ];

/// Des Ref User
Property ADMUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = ADM_User_DR ];

/// Des Ref ReasonGroup
Property ADMReasonGroupDR As PACWLReasonGroup [ SqlColumnNumber = 11, SqlFieldName = ADM_ReasonGroup_DR ];

/// Comment
Property ADMComment As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ADM_Comment, SqlListType = subnode ];

/// Booking Number
Property ADMBookingNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ADM_BookingNumber ];

/// UpdateDate
Property ADMUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = ADM_UpdateDate ];

/// UpdateTime
Property ADMUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = ADM_UpdateTime ];

/// Operation Date
Property ADMOperDate As %Date [ SqlColumnNumber = 16, SqlFieldName = ADM_OperDate ];

/// Operation Time
Property ADMOperTime As %Time [ SqlColumnNumber = 17, SqlFieldName = ADM_OperTime ];

/// Des Ref Transport
Property ADMTransportDR As RBCAppointTransport [ SqlColumnNumber = 18, SqlFieldName = ADM_Transport_DR ];

/// BloodDonation
Property ADMBloodDonation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ADM_BloodDonation ];

/// Preop Date
Property ADMPreopDate As %Date [ SqlColumnNumber = 20, SqlFieldName = ADM_PreopDate ];

/// Preop Time
Property ADMPreopTime As %Time [ SqlColumnNumber = 21, SqlFieldName = ADM_PreopTime ];

/// Comments
Property ADMComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = ADM_Comments, SqlListType = subnode ];

/// Booking Date
Property ADMBookingDate As %Date [ SqlColumnNumber = 23, SqlFieldName = ADM_BookingDate ];

/// Interpreter Reqd
Property ADMInterpreterReqd As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = ADM_InterpreterReqd ];

/// Patient Interest
Property ADMPatInterest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = ADM_PatInterest ];

/// Cancel Comment
Property ADMCancelComment As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = ADM_CancelComment, SqlListType = subnode ];

/// Des Ref IntendedWard_DR
Property ADMIntendedWardDR As PACWard [ SqlColumnNumber = 27, SqlFieldName = ADM_IntendedWard_DR ];

/// ProcFreeText
Property ADMProcFreeText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = ADM_ProcFreeText, SqlListType = subnode ];

/// Des Ref IntendedBed
Property ADMIntendedBedDR As PACBed [ SqlColumnNumber = 29, SqlFieldName = ADM_IntendedBed_DR ];

/// Des Ref ParentWard
Property ADMParentWardDR As PACWard [ SqlColumnNumber = 30, SqlFieldName = ADM_ParentWard_DR ];

/// Comments Cancel Letter
Property ADMCommentsCancelLetter As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = ADM_CommentsCancelLetter, SqlListType = subnode ];

/// Des Ref UpdateUserHospital
Property ADMUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 32, SqlFieldName = ADM_UpdateUserHospital_DR ];

/// Blood Donation Date
Property ADMBloodDonationDate As %Date [ SqlColumnNumber = 33, SqlFieldName = ADM_BloodDonationDate ];

/// Des Ref AdmissionPoint
Property ADMAdmissionPointDR As PACAdmissionPoint [ SqlColumnNumber = 34, SqlFieldName = ADM_AdmissionPoint_DR ];

/// EstTheatreTime
Property ADMEstTheatreTime As %Float [ SqlColumnNumber = 35, SqlFieldName = ADM_EstTheatreTime ];

/// Confirmation By Date
Property ADMConfirmationByDate As %Date [ SqlColumnNumber = 36, SqlFieldName = ADM_ConfirmationByDate ];

/// Special Requirements
Property ADMSpecialRequirements As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = ADM_SpecialRequirements, SqlListType = subnode ];

/// LastAuditDate
Property ADMLastAuditDate As %Date [ SqlColumnNumber = 38, SqlFieldName = ADM_LastAuditDate ];

/// Audit Response Due Date
Property ADMAuditResponseDueDate As %Date [ SqlColumnNumber = 39, SqlFieldName = ADM_AuditResponseDueDate ];

/// Des Ref CTLOC
Property ADMTheatreTypeDR As CTLoc [ SqlColumnNumber = 40, SqlFieldName = ADM_TheatreType_DR ];

/// Visit Status
Property ADMVisitStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = ADM_VisitStatus ];

/// Flagged Patient
Property ADMFlaggedPatient As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = ADM_FlaggedPatient ];

/// Des Ref AdmPointLoc
Property ADMAdmPointLocDR As CTLoc [ SqlColumnNumber = 43, SqlFieldName = ADM_AdmPointLoc_DR ];

/// AdmBookingNumber
Property ADMAdmBookingNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = ADM_AdmBookingNumber ];

/// Des Ref AuthoriseUser
Property ADMAuthoriseUserDR As SSUser [ SqlColumnNumber = 45, SqlFieldName = ADM_AuthoriseUser_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAWaitingListAdm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListAdm","OnAfterInsert")
 d Table^HL7Outbound("PAWaitingListAdm",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAWaitingListAdm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListAdm","OnAfterUpdate")
 d Table^HL7Outbound("PAWaitingListAdm",%d(1),"Update")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAWaitingListAdm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListAdm","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAWaitingListAdm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListAdm","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListAdm","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAWaitingListAdm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListAdm","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADM_AdmBookingNumber">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ADM_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADM_AdmPointLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ADM_AdmissionPoint_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ADM_AuditResponseDueDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ADM_AuthoriseUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ADM_BloodDonation">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADM_BloodDonationDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ADM_BookingDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADM_BookingNumber">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADM_CancelComment">
<Node>"CANC"</Node>
</Data>
<Data name="ADM_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADM_CancelReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADM_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADM_Comment">
<Node>"RMK"</Node>
</Data>
<Data name="ADM_Comments">
<Node>"RMK1"</Node>
</Data>
<Data name="ADM_CommentsCancelLetter">
<Node>"CCL"</Node>
</Data>
<Data name="ADM_Confirmation">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADM_ConfirmationByDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ADM_EstTheatreTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ADM_FlaggedPatient">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ADM_IntendedBed_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ADM_IntendedWard_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ADM_InterpreterReqd">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ADM_LastAuditDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ADM_OperDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADM_OperTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADM_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADM_ParentWard_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ADM_PatInterest">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ADM_PreopDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADM_PreopTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADM_ProcFreeText">
<Node>"PROC"</Node>
</Data>
<Data name="ADM_ReasonGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADM_SpecialRequirements">
<Node>"SPREQ"</Node>
</Data>
<Data name="ADM_TheatreType_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ADM_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADM_Transport_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADM_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ADM_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADM_VisitStatus">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmdate">
<Condition>'{ADM_CancelDate}</Condition>
<ConditionFields>ADM_AdmDate,ADM_CancelDate</ConditionFields>
<Global>^PAWLi</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AdmDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADM_AdmDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADM_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCancel">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AdmCancel"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADM_AdmDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{ADM_CancelReason_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOperDate">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OperDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADM_OperDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADM_PAADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADM_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingListAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
