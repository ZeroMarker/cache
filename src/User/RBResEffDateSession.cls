/// RB Res Eff Date Session    (RBRD2)
Class User.RBResEffDateSession Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResEffDateSession, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SESSChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildRBResEffDateSessServices As RBResEffDateSessServices [ Cardinality = children, Inverse = SERParRef ];

Relationship ChildRBResEffDateSessLocation As RBResEffDateSessLocation [ Cardinality = children, Inverse = LOCParRef ];

Relationship ChildRBResEffDateSessInsurance As RBResEffDateSessInsurance [ Cardinality = children, Inverse = INSParRef ];

Relationship ChildRBResEffDateSessRefHospita As RBResEffDateSessRefHospital [ Cardinality = children, Inverse = RFCParREf ];

Relationship ChildRBResEffDateSessNotAvail As RBResEffDateSessNotAvail [ Cardinality = children, Inverse = NAParRef ];

Relationship ChildRBResEffDateSessRTMasVol As RBResEffDateSessRTMasVol [ Cardinality = children, Inverse = RTMAVParRef ];

Relationship ChildRBResEffDateSessPayorRestr As RBResEffDateSessPayorRestr [ Cardinality = children, Inverse = RESTRParRef ];

Relationship ChildRBResEffDateSessionVar As RBResEffDateSessionVar [ Cardinality = children, Inverse = VARParRef ];

Relationship ChildRBResEffDateSessionCP As RBResEffDateSessionCP [ Cardinality = children, Inverse = CPParRef ];

Relationship ChildRBResEffDateSessionTR As RBResEffDateSessionTR [ Cardinality = children, Inverse = STRParRef ];

/// RB_ResEffDate Parent Reference
Relationship SESSParRef As RBResEffDate [ Cardinality = parent, Inverse = ChildRBResEffDateSession, Required, SqlFieldName = SESS_ParRef ];

/// Childsub
Property SESSChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",0))}, SqlColumnNumber = 2, SqlFieldName = SESS_Childsub ];

/// Session Number
Property SESSSessionNo As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SESS_SessionNo ];

/// Session Time Start
Property SESSTimeStart As %Time [ SqlColumnNumber = 4, SqlFieldName = SESS_TimeStart ];

/// Session End Time
Property SESSTimeEnd As %Time [ SqlColumnNumber = 5, SqlFieldName = SESS_TimeEnd ];

/// Number of Slots/Session
Property SESSNoSlots As %Float [ SqlColumnNumber = 6, SqlFieldName = SESS_NoSlots ];

/// Slot Length in minutes
Property SESSSlotLength As %Float [ SqlColumnNumber = 7, SqlFieldName = SESS_SlotLength ];

/// Load Level
Property SESSLoad As %Float [ SqlColumnNumber = 8, SqlFieldName = SESS_Load ];

/// No of Appointments per Slot
Property SESSNoApptSlot As %Float [ SqlColumnNumber = 9, SqlFieldName = SESS_NoApptSlot ];

/// Des Ref Day of the week
Property SESSDOWDR As CTDayOfWeek [ SqlColumnNumber = 10, SqlFieldName = SESS_DOW_DR ];

/// Des Ref Session Type
Property SESSSessionTypeDR As RBCSessionType [ SqlColumnNumber = 11, SqlFieldName = SESS_SessionType_DR ];

/// Request MR
Property SESSRequestMR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = SESS_RequestMR ];

/// Patient Type
Property SESSPatientType As %String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,O,E,H") [ SqlColumnNumber = 13, SqlFieldName = SESS_PatientType ];

/// Date Book Until
Property SESSDateBookUntil As %Date [ SqlColumnNumber = 14, SqlFieldName = SESS_DateBookUntil ];

/// Schedule Generated Until
Property SESSScheduleGeneratedUntil As %Date [ SqlColumnNumber = 15, SqlFieldName = SESS_ScheduleGeneratedUntil ];

/// Number Overbook Allowed
Property SESSNoOverbookAllowed As %Float [ SqlColumnNumber = 16, SqlFieldName = SESS_NoOverbookAllowed ];

/// Schedule Start Date
Property SESSScheduleStartDate As %Date [ SqlColumnNumber = 17, SqlFieldName = SESS_ScheduleStartDate ];

/// Sched Gener Flag
Property SESSScheduleGenerFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = SESS_ScheduleGenerFlag ];

/// Des Ref Volume_DR
Property SESSMRVolumeDR As RTCMRecordTypeVolumes [ SqlColumnNumber = 19, SqlFieldName = SESS_MRVolume_DR ];

/// Restricted
Property SESSRestricted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = SESS_Restricted ];

/// Des Ref CTLOC
Property SESSRoomDR As CTLoc [ SqlColumnNumber = 21, SqlFieldName = SESS_Room_DR ];

/// Irregular Schedulle
Property SESSIrregularSchedulle As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = SESS_IrregularSchedulle ];

/// Number Of Weeks
Property SESSNumberOfWeeks As %Float [ SqlColumnNumber = 23, SqlFieldName = SESS_NumberOfWeeks ];

/// Week 1
Property SESSWeek1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = SESS_Week1 ];

/// Week 2
Property SESSWeek2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = SESS_Week2 ];

/// Week 3
Property SESSWeek3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = SESS_Week3 ];

/// Week 4
Property SESSWeek4 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = SESS_Week4 ];

/// Week 5
Property SESSWeek5 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = SESS_Week5 ];

/// Description
Property SESSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = SESS_Desc ];

/// Des Ref SignifFacility
Property SESSSignifFacilityDR As CTSignificantFacility [ SqlColumnNumber = 30, SqlFieldName = SESS_SignifFacility_DR ];

/// Last Week
Property SESSLastWeek As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = SESS_LastWeek ];

/// Ignore Pub Hol
Property SESSIgnorePubHol As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = SESS_IgnorePubHol ];

/// Des Ref Clinic
Property SESSClinicDR As CTLoc [ SqlColumnNumber = 33, SqlFieldName = SESS_Clinic_DR ];

/// ProcedureClinic
Property SESSProcedureClinic As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = SESS_ProcedureClinic ];

/// LastGenFromDate
Property SESSLastGenFromDate As %Date [ SqlColumnNumber = 35, SqlFieldName = SESS_LastGenFromDate ];

/// Auto Gen End Date
Property SESSAutoGenEndDate As %Date [ SqlColumnNumber = 36, SqlFieldName = SESS_AutoGenEndDate ];

/// Des Ref ClinicGroup
Property SESSClinicGroupDR As RBCClinicGroup [ SqlColumnNumber = 37, SqlFieldName = SESS_ClinicGroup_DR ];

/// ScheduleGeneratedFrom
Property SESSScheduleGeneratedFrom As %Date [ SqlColumnNumber = 38, SqlFieldName = SESS_ScheduleGeneratedFrom ];

/// number of Days to ignore Dep Restr
Property SESSDaysDepRestr As %Float [ SqlColumnNumber = 39, SqlFieldName = SESS_DaysDepRestr ];

/// OBSettings
Property SESSOBSettings As %String(DISPLAYLIST = ",SESSION,SLOT", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",SES,SL") [ SqlColumnNumber = 40, SqlFieldName = SESS_OBSettings ];

/// Des Ref WeeklyCycle
Property SESSWeeklyCycleDR As RBCWeeklyCycle [ SqlColumnNumber = 41, SqlFieldName = SESS_WeeklyCycle_DR ];

/// CPClinicOptions
Property SESSCPClinicOptions As %String(DISPLAYLIST = ",Single c/p clinic,Dual c/p clinic,Sequential c/p clinic", MAXLEN = 21, TRUNCATE = 1, VALUELIST = ",SI,DU,SE") [ SqlColumnNumber = 42, SqlFieldName = SESS_CPClinicOptions ];

/// holi template flag
Property SESSHolidayWeek As %String [ SqlColumnNumber = 43, SqlFieldName = SESS_HolidayWeek ];

/// Des Ref ClinicGroup
Property SESSClinicGroupDRStr As %String [ SqlColumnNumber = 44, SqlFieldName = SESS_ClinicGroupDR_Str ];

/// Des Ref ClinicGroup
Property SESSNoLimitLoadFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = SESS_NoLimitLoadFlag ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSession).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSession","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSession).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSession","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSession).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSession","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResEffDateSession).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSession","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResEffDateSession).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSession","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSession","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>1312</ExtentSize>
<Property name="SESSAutoGenEndDate">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="SESSCPClinicOptions">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SESSChildsub">
<Selectivity>5.8738%</Selectivity>
</Property>
<Property name="SESSClinicDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="SESSClinicGroupDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="SESSDOWDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="SESSDateBookUntil">
<Selectivity>2.5336%</Selectivity>
</Property>
<Property name="SESSDaysDepRestr">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="SESSDesc">
<Selectivity>7.6910%</Selectivity>
</Property>
<Property name="SESSIgnorePubHol">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSIrregularSchedulle">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSLastGenFromDate">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="SESSLastWeek">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSLoad">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="SESSMRVolumeDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="SESSNoApptSlot">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="SESSNoOverbookAllowed">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SESSNoSlots">
<Selectivity>3.6359%</Selectivity>
</Property>
<Property name="SESSNumberOfWeeks">
<Selectivity>99.9994%</Selectivity>
</Property>
<Property name="SESSOBSettings">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSParRef">
<Selectivity>0.5155%</Selectivity>
</Property>
<Property name="SESSPatientType">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="SESSProcedureClinic">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSRequestMR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSRestricted">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSRoomDR">
<Selectivity>4.5145%</Selectivity>
</Property>
<Property name="SESSScheduleGenerFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSScheduleGeneratedFrom">
<Selectivity>3.9484%</Selectivity>
</Property>
<Property name="SESSScheduleGeneratedUntil">
<Selectivity>0.6174%</Selectivity>
</Property>
<Property name="SESSScheduleStartDate">
<Selectivity>1.1138%</Selectivity>
</Property>
<Property name="SESSSessionNo">
<Selectivity>16.6666%</Selectivity>
</Property>
<Property name="SESSSessionTypeDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="SESSSignifFacilityDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="SESSSlotLength">
<Selectivity>9.9999%</Selectivity>
</Property>
<Property name="SESSTimeEnd">
<Selectivity>3.1207%</Selectivity>
</Property>
<Property name="SESSTimeStart">
<Selectivity>3.9484%</Selectivity>
</Property>
<Property name="SESSWeek1">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSWeek2">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSWeek3">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSWeek4">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSWeek5">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SESSWeeklyCycleDR">
<Selectivity>99.9994%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SESS_AutoGenEndDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="SESS_CPClinicOptions">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="SESS_ClinicGroupDR_Str">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SESS_ClinicGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="SESS_Clinic_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SESS_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SESS_DateBookUntil">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SESS_DaysDepRestr">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="SESS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SESS_HolidayWeek">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="SESS_IgnorePubHol">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SESS_IrregularSchedulle">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SESS_LastGenFromDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SESS_LastWeek">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SESS_Load">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SESS_MRVolume_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SESS_NoApptSlot">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SESS_NoLimitLoadFlag">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SESS_NoOverbookAllowed">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SESS_NoSlots">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SESS_NumberOfWeeks">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SESS_OBSettings">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="SESS_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SESS_ProcedureClinic">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SESS_RequestMR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SESS_Restricted">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SESS_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SESS_ScheduleGenerFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SESS_ScheduleGeneratedFrom">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="SESS_ScheduleGeneratedUntil">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SESS_ScheduleStartDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SESS_SessionNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SESS_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SESS_SignifFacility_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SESS_SlotLength">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SESS_TimeEnd">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SESS_TimeStart">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SESS_Week1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SESS_Week2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SESS_Week3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SESS_Week4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SESS_Week5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SESS_WeeklyCycle_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SESS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SESS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSESSRoom">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>SESS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SESSRoom"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SESS_Room_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SESS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSessDesc">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>SESS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SESSDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SESS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SESS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SESS_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
