/// RB Operating Room(1331)
Class User.RBOperatingRoom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperatingRoom, StorageStrategy = SQLStorage ]
{

Relationship ChildRBOperatingRoomSpecEquip As RBOperatingRoomSpecEquip [ Cardinality = children, Inverse = EQParRef ];

Relationship ChildRBOperRoomSurgeonAssistant As RBOperRoomSurgeonAssistant [ Cardinality = children, Inverse = SURGParREf ];

Relationship ChildRBOperRoomAnestAssistant As RBOperRoomAnestAssistant [ Cardinality = children, Inverse = ANParRef ];

Relationship ChildRBOperRoomNurse As RBOperRoomNurse [ Cardinality = children, Inverse = NURParRef ];

Relationship ChildRBOperTransactions As RBOperTransactions [ Cardinality = children, Inverse = TRANSParRef ];

Relationship ChildRBOperRoomScrubNurse As RBOperRoomScrubNurse [ Cardinality = children, Inverse = SCRUBParRef ];

Relationship ChildRBOperRoomChanges As RBOperRoomChanges [ Cardinality = children, Inverse = CHParRef ];

Relationship ChildRBOperRoomSecProc As RBOperRoomSecProc [ Cardinality = children, Inverse = SPRParRef ];

Relationship ChildRBOperRoomAdditionalStaff As RBOperRoomAdditionalStaff [ Cardinality = children, Inverse = RBOPASParRef ];

/// Date of Operation
Property RBOPDateOper As %Date [ SqlColumnNumber = 2, SqlFieldName = RBOP_DateOper ];

/// Time of Operation
Property RBOPTimeOper As %Time [ SqlColumnNumber = 3, SqlFieldName = RBOP_TimeOper ];

/// Date of Booking
Property RBOPDateBook As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 4, SqlFieldName = RBOP_DateBook ];

/// Des Ref to Resource
Property RBOPResourceDR As RBResource [ SqlColumnNumber = 5, SqlFieldName = RBOP_Resource_DR ];

/// Des Ref to CTCP
Property RBOPBookDoctorDR As CTCareProv [ SqlColumnNumber = 6, SqlFieldName = RBOP_BookDoctor_DR ];

/// Des Ref to CTCP
Property RBOPSurgeonDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = RBOP_Surgeon_DR ];

/// Des Ref to MRCICDx
Property RBOPPreopDiagnDR As MRCICDDx [ SqlColumnNumber = 8, SqlFieldName = RBOP_PreopDiagn_DR ];

/// Des Ref to ORC_Operation
Property RBOPOperationDR As ORCOperation [ SqlColumnNumber = 9, SqlFieldName = RBOP_Operation_DR ];

/// Des Ref ORC_Priority
Property RBOPPriorityDR As ORCRoomBookPriority [ SqlColumnNumber = 10, SqlFieldName = RBOP_Priority_DR ];

/// Des Ref to PAADM
Property RBOPPAADMDR As PAAdm [ SqlColumnNumber = 11, SqlFieldName = RBOP_PAADM_DR ];

/// Remarks
Property RBOPRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = RBOP_Remarks, SqlListType = subnode ];

/// Status
Property RBOPStatus As %String(DISPLAYLIST = ",Booked,Cancelled,Closed,Confirmed,Postponed,Done,Requested,Arrived", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",B,X,CL,C,P,D,R,A") [ SqlColumnNumber = 13, SqlFieldName = RBOP_Status ];

/// Time of Surgery
Property RBOPTimeSurgery As %Time [ SqlColumnNumber = 14, SqlFieldName = RBOP_TimeSurgery ];

/// Des Ref AnaestMethod
Property RBOPAnaestMethodDR As ORCAnaestMethod [ SqlColumnNumber = 15, SqlFieldName = RBOP_AnaestMethod_DR ];

/// Arrived
Property RBOPArrived As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = RBOP_Arrived ];

/// Sequence No
Property RBOPSequenceNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = RBOP_SequenceNo ];

/// Estimated Time
Property RBOPEstimatedTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = RBOP_EstimatedTime ];

/// Des Ref Wait List
Property RBOPWaitListDR As PAWaitingList [ SqlColumnNumber = 19, SqlFieldName = RBOP_WaitList_DR ];

/// Update Date
Property RBOPUpdateDate As %Date [ SqlColumnNumber = 20, SqlFieldName = RBOP_UpdateDate ];

/// Update Time
Property RBOPUpdateTime As %Time [ SqlColumnNumber = 21, SqlFieldName = RBOP_UpdateTime ];

/// Preop Date
Property RBOPPreopDate As %Date [ SqlColumnNumber = 22, SqlFieldName = RBOP_PreopDate ];

/// Preop Test Done
Property RBOPPreopTestDone As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = RBOP_PreopTestDone ];

/// Day Surgery
Property RBOPDaySurgery As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = RBOP_DaySurgery ];

/// Des Ref OperDepartment
Property RBOPOperDepartmentDR As CTLoc [ SqlColumnNumber = 25, SqlFieldName = RBOP_OperDepartment_DR ];

/// Des Ref Person
Property RBOPPersonDR As PAPerson [ SqlColumnNumber = 26, SqlFieldName = RBOP_Person_DR ];

/// Biopsy Need
Property RBOPBiopsyNeed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = RBOP_BiopsyNeed ];

/// Des Ref CTCP
Property RBOPAnaesthetistDR As CTCareProv [ SqlColumnNumber = 28, SqlFieldName = RBOP_Anaesthetist_DR ];

/// Des Ref ReasonSuspend
Property RBOPReasonSuspendDR As ORCReasonForSuspend [ SqlColumnNumber = 29, SqlFieldName = RBOP_ReasonSuspend_DR ];

/// Des REf Appoint
Property RBOPAppointDR As RBAppointment [ SqlColumnNumber = 30, SqlFieldName = RBOP_Appoint_DR ];

/// Cancel Reason
Property RBOPCancelReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = RBOP_CancelReason ];

/// Des Ref LastUpdateHospital
Property RBOPLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 32, SqlFieldName = RBOP_LastUpdateHospital_DR ];

/// RequestedDateOper
Property RBOPRequestedDateOper As %Date [ SqlColumnNumber = 33, SqlFieldName = RBOP_RequestedDateOper ];

/// RequestedTimeOper
Property RBOPRequestedTimeOper As %Time [ SqlColumnNumber = 34, SqlFieldName = RBOP_RequestedTimeOper ];

/// Des Ref StatePPP
Property RBOPStatePPPDR As PACStatePPP [ SqlColumnNumber = 35, SqlFieldName = RBOP_StatePPP_DR ];

/// Procedure
Property RBOPProcedure As %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = RBOP_Procedure ];

/// ProcsOpers
Property RBOPProcsOpers As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = RBOP_ProcsOpers, SqlListType = subnode ];

/// Last Update User
Property RBOPUpdateUser As SSUser [ SqlColumnNumber = 38, SqlFieldName = RBOP_UpdateUser ];

/// Infect
Property RBOPInfect As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = RBOP_Infect ];

/// Endoscopy
Property RBOPEndoscopy As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = RBOP_Endoscopy ];

/// Des Ref OEC_BodySite
Property RBOPBodySiteDR As OECBodySite [ SqlColumnNumber = 41, SqlFieldName = RBOP_BodySite_DR ];

/// Blood Required
Property RBOPBloodRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = RBOP_BloodRequired ];

/// Autologous Transfusion Required
Property RBOPAutologousTransfusion As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = RBOP_AutologousTransfusion ];

/// Date Arrived
Property RBOPDateArrived As %Date [ SqlColumnNumber = 44, SqlFieldName = RBOP_DateArrived ];

/// Time Arrived
Property RBOPTimeArrived As %Time [ SqlColumnNumber = 45, SqlFieldName = RBOP_TimeArrived ];

/// Booking Type
Property RBOPBookingType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 46, SqlFieldName = RBOP_BookingType ];

/// EpisodeType
Property RBOPEpisodeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = RBOP_EpisodeType ];

/// Des Ref ReasonReturn
Property RBOPReasonReturnDR As ORCReasonForReturn [ SqlColumnNumber = 48, SqlFieldName = RBOP_ReasonReturn_DR ];

/// ProcedureStartTime
Property RBOPProcedureStartTime As %Time [ SqlColumnNumber = 49, SqlFieldName = RBOP_ProcedureStartTime ];

/// ProcedureEndTime
Property RBOPProcedureEndTime As %Time [ SqlColumnNumber = 50, SqlFieldName = RBOP_ProcedureEndTime ];

/// Des Ref RefDep
Property RBOPRefDepDR As CTLoc [ SqlColumnNumber = 51, SqlFieldName = RBOP_RefDep_DR ];

/// ApproxTimeOper
Property RBOPApproxTimeOper As %Time [ SqlColumnNumber = 52, SqlFieldName = RBOP_ApproxTimeOper ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBOperatingRoom).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoom","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBOperatingRoom).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoom","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBOperatingRoom).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoom","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBOperatingRoom).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoom","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoom","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBOperatingRoom).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoom","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBOP(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RBOP_AnaestMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RBOP_Anaesthetist_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="RBOP_Appoint_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="RBOP_ApproxTimeOper">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="RBOP_Arrived">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RBOP_AutologousTransfusion">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="RBOP_BiopsyNeed">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RBOP_BloodRequired">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="RBOP_BodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="RBOP_BookDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RBOP_BookingType">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="RBOP_CancelReason">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="RBOP_DateArrived">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="RBOP_DateBook">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RBOP_DateOper">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RBOP_DaySurgery">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RBOP_Endoscopy">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="RBOP_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="RBOP_EstimatedTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RBOP_Infect">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="RBOP_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="RBOP_OperDepartment_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RBOP_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RBOP_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RBOP_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RBOP_PreopDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RBOP_PreopDiagn_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RBOP_PreopTestDone">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RBOP_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RBOP_Procedure">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="RBOP_ProcedureEndTime">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="RBOP_ProcedureStartTime">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="RBOP_ProcsOpers">
<Node>"REMP"</Node>
</Data>
<Data name="RBOP_ReasonReturn_DR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="RBOP_ReasonSuspend_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="RBOP_RefDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="RBOP_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="RBOP_RequestedDateOper">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="RBOP_RequestedTimeOper">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="RBOP_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RBOP_SequenceNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RBOP_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="RBOP_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RBOP_Surgeon_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RBOP_TimeArrived">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="RBOP_TimeOper">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RBOP_TimeSurgery">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RBOP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RBOP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RBOP_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="RBOP_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^RBOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RBOP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAnest">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AnaestDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_Anaesthetist_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBOP_DateOper}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{RBOP_TimeOper}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTime">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_DateOper}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{RBOP_TimeOper}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOperDep">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OperDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_OperDepartment_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBOP_DateOper}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{RBOP_TimeOper}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADMDateTime">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBOP_DateOper}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{RBOP_TimeOper}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_Person_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResourceDateTime">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_Resource_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBOP_DateOper}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{RBOP_TimeOper}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBOP_DateOper}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{RBOP_TimeOper}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurg">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SurgDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_Surgeon_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBOP_DateOper}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{RBOP_TimeOper}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexresDateTimeSeq">
<Global>^RBOP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RBOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResDateTimeSeq"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBOP_Resource_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBOP_DateOper}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{RBOP_TimeOper}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBOP_SequenceNo}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RBOP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RBOP_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperatingRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
