/// Resource Booking Config (RBCF,8068)
Class User.CFRB Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_RB, StorageStrategy = SQLStorage ]
{

/// Default Resource Load per session
Property RBCFDefaultResLoad As %Float(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 2, SqlFieldName = RBCF_DefaultResLoad ];

/// No of day for each schedule generation
Property RBCFNoDayGenSchedule As %Float(MAXVAL = 9999, MINVAL = 1) [ SqlColumnNumber = 3, SqlFieldName = RBCF_NoDayGenSchedule ];

/// Description
Property RBCFDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = RBCF_Description ];

/// Last Update Date
Property RBCFUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = RBCF_UpdateDate ];

/// Last Update Time
Property RBCFUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = RBCF_UpdateTime ];

/// Last Update User
Property RBCFUpdateUserDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 7, SqlFieldName = RBCF_UpdateUser_DR ];

/// Enter Appt for the Pass
Property RBCFEnterPassAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = RBCF_EnterPassAppt ];

/// Default Appt Type
Property RBCFDefaultApptTypeDR As RBCApptType [ SqlColumnNumber = 9, SqlFieldName = RBCF_DefaultApptType_DR ];

/// Registration Retrieve Appt (# days from now)
Property RBCFRegRetriveAppt As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 10, SqlFieldName = RBCF_RegRetriveAppt ];

/// Allow Overbooking of Appointments
Property RBCFAllowOverBooking As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = RBCF_AllowOverBooking ];

/// Default Report for Transfers
Property RBCFTransferReport As %String(DISPLAYLIST = ",None,Detail,Summary", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",N,D,S") [ SqlColumnNumber = 12, SqlFieldName = RBCF_TransferReport ];

/// Use Standard Resource Booking
Property RBCFComplexBooking As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = {Yes}, SqlColumnNumber = 13, SqlFieldName = RBCF_ComplexBooking ];

/// Default Ins Type
Property RBCFDefaultInsType As ARCInsuranceType [ SqlColumnNumber = 14, SqlFieldName = RBCF_DefaultInsType ];

/// Restrict Services to order with serv grp
Property RBCFRestrictServices As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = RBCF_RestrictServices ];

/// Generate Date To
Property RBCFGenerateDateTo As %Date [ SqlColumnNumber = 16, SqlFieldName = RBCF_GenerateDateTo ];

/// Allow to OverBook Walk-ins
Property RBCFAllowOverBookWalkins As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = RBCF_AllowOverBookWalkins ];

/// Default Multiple Services Search
Property RBCFMultipleServicesSearch As %String(DISPLAYLIST = ",Same Time,Sequential,All Times", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",S,D,A") [ SqlColumnNumber = 18, SqlFieldName = RBCF_MultipleServicesSearch ];

/// Des Ref AuxInsType
Property RBCFDefAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 19, SqlFieldName = RBCF_DefAuxInsType_DR ];

/// Des Ref AppointMeth
Property RBCFAppointMethDR As RBCAppointMethod [ SqlColumnNumber = 20, SqlFieldName = RBCF_AppointMeth_DR ];

/// Check for the Same Payor for all services
Property RBCFCheckSamePayor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = RBCF_CheckSamePayor ];

/// Warning for Appointments for Same Service
Property RBCFWarningApptSameServ As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = RBCF_WarningApptSameServ ];

/// Use User Default Payor
Property RBCFUseUserDefPayor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = RBCF_UseUserDefPayor ];

/// Allow Book OverlapAppoint
Property RBCFAllowBookOverlapAppoint As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = RBCF_AllowBookOverlapAppoint ];

/// Des Ref RefHosp
Property RBCFRefHospDR As CTRefClin [ SqlColumnNumber = 25, SqlFieldName = RBCF_RefHosp_DR ];

/// Allow OverBooking if there are AvailSlots
Property RBCFAllowOverBookingAvailSlots As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = RBCF_AllowOverBookingAvailSlots ];

/// Restrict Payor Plan
Property RBCFRestrictPayorPlan As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = RBCF_RestrictPayorPlan ];

/// OrderBySlotOrQueue
Property RBCFOrderBySlotOrQueue As %String(DISPLAYLIST = ",Slot,Queue", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",S,Q") [ SqlColumnNumber = 28, SqlFieldName = RBCF_OrderBySlotOrQueue ];

/// Show Booked Appt
Property RBCFShowBookedAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = RBCF_ShowBookedAppt ];

/// Display Order Notes
Property RBCFDisplayOrderNotes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = RBCF_DisplayOrderNotes ];

/// Generate Lab Epis No
Property RBCFGenerateLabEpisNo As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = RBCF_GenerateLabEpisNo ];

/// Cancel Adm On Cancel Appt
Property RBCFCancelAdmOnCancelAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = RBCF_CancelAdmOnCancelAppt ];

/// Adm Date is Earliest of Appt Date
Property RBCFAdmDateEarliestApptDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = RBCF_AdmDateEarliestApptDate ];

/// Set Adm Date/Time to Appt Date/Time
Property RBCFSetAdmDateTimeToAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = RBCF_SetAdmDateTimeToAppt ];

/// Disable RT Creation on Appt
Property RBCFDisableRTCreationAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = RBCF_DisableRTCreationAppt ];

/// ShowBookingNotesMessage
Property RBCFShowBookingNotesMessage As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = RBCF_ShowBookingNotesMessage ];

/// Warning App Sel Same Date Loc Doc Service
Property RBCFWarningAppSameDateLocDocSer As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = RBCF_WarningAppSameDateLocDocService ];

/// Allow Overbooking in the Past
Property RBCFAllowOverbookingPast As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = RBCF_AllowOverbookingPast ];

/// Show Referral after Change Status
Property RBCFShowReferralAfterChangeStat As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = RBCF_ShowReferralAfterChangeStatus ];

/// Extend Referral Period
Property RBCFExtendReferralPeriod As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = RBCF_ExtendReferralPeriod ];

/// Max Weeks Irregular Schedule
Property RBCFMaxWeeksIrregSchedule As %Float [ SqlColumnNumber = 42, SqlFieldName = RBCF_MaxWeeksIrregSchedule ];

/// PercentIncrServDuration
Property RBCFPercentIncrServDuration As %Float [ SqlColumnNumber = 43, SqlFieldName = RBCF_PercentIncrServDuration ];

/// MaxPeriodCheckEpis
Property RBCFMaxPeriodCheckEpisNum As %Float [ SqlColumnNumber = 44, SqlFieldName = RBCF_MaxPeriodCheckEpisNum ];

/// MaxPeriodCheckEpis1
Property RBCFMaxPeriodCheckEpis1 As %String(DISPLAYLIST = ",Days,Months,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 45, SqlFieldName = RBCF_MaxPeriodCheckEpis1 ];

/// Des Ref OverBookReason when reverse pat dec
Property RBCFOverBookReasonDR As RBCReasonOverBook [ SqlColumnNumber = 46, SqlFieldName = RBCF_OverBookReason_DR ];

/// Status for Validation of 1st Appoint
Property RBCFStatValid1stAppoint As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = RBCF_StatValid1stAppoint ];

/// Default Resource from LastAppt
Property RBCFDefResourceLastAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = RBCF_DefResourceLastAppt ];

/// KeepLocAnResource
Property RBCFKeepLocAnResource As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = RBCF_KeepLocAnResource ];

/// Des Ref ReferralStatus
Property RBCFReferralStatusDR As PACReferralStatusReason [ SqlColumnNumber = 50, SqlFieldName = RBCF_ReferralStatus_DR ];

/// ReasonForCancel
Property RBCFReasonForCancelDR As RBCReasonForCancel [ SqlColumnNumber = 51, SqlFieldName = RBCF_ReasonForCancel_DR ];

/// Allow Transfer to Earlier AdmDate
Property RBCFAllowTransferEarlyAdmDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = RBCF_AllowTransferEarlyAdmDate ];

/// ConditionAutoEpAppt
Property RBCFConditionAutoEpAppt As %String(DISPLAYLIST = ",Location,Date/Location,Resource/Location,Responsible Unit,Date/Location/Resource", MAXLEN = 22, TRUNCATE = 1, VALUELIST = ",L,DL,RL,RU,DLR") [ SqlColumnNumber = 53, SqlFieldName = RBCF_ConditionAutoEpAppt ];

/// DischEpCancelFutureAppts
Property RBCFDischEpCancelFutureAppts As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = RBCF_DischEpCancelFutureAppts ];

/// Generate1stWeekOfCycle
Property RBCFGenerate1stWeekOfCycle As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = RBCF_Generate1stWeekOfCycle ];

/// GenerateOneAdmForDifEpGroups
Property RBCFGenerateOneAdmForDifEpGroup As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = RBCF_GenerateOneAdmForDifEpGroups ];

/// GenerateAdmOnOTRequest
Property RBCFGenerateAdmOnOTRequest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = RBCF_GenerateAdmOnOTRequest ];

/// WebNotMoveOnHoldOnSchGen
Property RBCFWebNotMoveOnHoldOnSchGen As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = RBCF_WebNotMoveOnHoldOnSchGen ];

/// GroupNoEpisodeCreation
Property RBCFGroupNoEpisodeCreation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 59, SqlFieldName = RBCF_GroupNoEpisodeCreation ];

/// DefaultPatientDetPayorPlan
Property RBCFDefaultPatientDetPayorPlan As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = RBCF_DefaultPatientDetPayorPlan ];

/// NoWarningOnApptCancel
Property RBCFNoWarningOnApptCancel As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = RBCF_NoWarningOnApptCancel ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFRB).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRB","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFRB).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRB","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFRB).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRB","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFRB).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRB","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRB","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFRB).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRB","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CF("RB",0))</SqlIdExpression>
<SQLMap name="DataMasterRBCF">
<Data name="RBCF_AdmDateEarliestApptDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="RBCF_AllowBookOverlapAppoint">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RBCF_AllowOverBookWalkins">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RBCF_AllowOverBooking">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RBCF_AllowOverBookingAvailSlots">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RBCF_AllowOverbookingPast">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="RBCF_AllowTransferEarlyAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="RBCF_AppointMeth_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RBCF_CancelAdmOnCancelAppt">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="RBCF_CheckSamePayor">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RBCF_ComplexBooking">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RBCF_ConditionAutoEpAppt">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="RBCF_DefAuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RBCF_DefResourceLastAppt">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="RBCF_DefaultApptType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RBCF_DefaultInsType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RBCF_DefaultPatientDetPayorPlan">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="RBCF_DefaultResLoad">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RBCF_Description">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RBCF_DisableRTCreationAppt">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="RBCF_DischEpCancelFutureAppts">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="RBCF_DisplayOrderNotes">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="RBCF_EnterPassAppt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RBCF_ExtendReferralPeriod">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="RBCF_Generate1stWeekOfCycle">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="RBCF_GenerateAdmOnOTRequest">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="RBCF_GenerateDateTo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RBCF_GenerateLabEpisNo">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="RBCF_GenerateOneAdmForDifEpGroups">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="RBCF_GroupNoEpisodeCreation">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="RBCF_KeepLocAnResource">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="RBCF_MaxPeriodCheckEpis1">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="RBCF_MaxPeriodCheckEpisNum">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="RBCF_MaxWeeksIrregSchedule">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="RBCF_MultipleServicesSearch">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RBCF_NoDayGenSchedule">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RBCF_NoWarningOnApptCancel">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="RBCF_OrderBySlotOrQueue">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="RBCF_OverBookReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="RBCF_PercentIncrServDuration">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="RBCF_ReasonForCancel_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="RBCF_RefHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RBCF_ReferralStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="RBCF_RegRetriveAppt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RBCF_RestrictPayorPlan">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="RBCF_RestrictServices">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RBCF_SetAdmDateTimeToAppt">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="RBCF_ShowBookedAppt">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="RBCF_ShowBookingNotesMessage">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="RBCF_ShowReferralAfterChangeStatus">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="RBCF_StatValid1stAppoint">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="RBCF_TransferReport">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RBCF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RBCF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RBCF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RBCF_UseUserDefPayor">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RBCF_WarningAppSameDateLocDocService">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="RBCF_WarningApptSameServ">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RBCF_WebNotMoveOnHoldOnSchGen">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RB"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RBCF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RBCF_RowId</SqlRowIdName>
<StreamLocation>^User.CFRBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
