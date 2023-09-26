/// RB Resource            (RBRES,8038)
Class User.RBResource Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_Resource, StorageStrategy = SQLStorage ]
{

Relationship ChildRBResEffDate As RBResEffDate [ Cardinality = children, Inverse = DATEParRef ];

Relationship ChildRBResSchedule As RBResSchedule [ Cardinality = children, Inverse = RSRESParRef ];

Relationship ChildRBApptSchedule As RBApptSchedule [ Cardinality = children, Inverse = ASRESParRef ];

/// RES RowID
Property RESRowId As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ InitialExpression = {$i(^RB("RES",0))}, Required, SqlFieldName = RES_RowId ];

/// Des Ref To CTLOC
Property RESCTLOCDR As CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = RES_CTLOC_DR ];

/// Des Ref to CT_CareProvider
Property RESCTPCPDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = RES_CTPCP_DR ];

/// Des Ref to Equipment
Property RESEQDR As RBCEquipment [ SqlColumnNumber = 5, SqlFieldName = RES_EQ_DR ];

/// Code
Property RESCode As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlComputeCode = { s {RES_Code}=$$CO07^at8038a({RES_CTPCP_DR},{RES_EQ_DR})
}, SqlComputed, SqlFieldName = RES_Code, Transient ];

/// Description of the Resource
Property RESDesc As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = RES_Desc ];

/// Start date of last schedule generation
Property RESLastSchedSDate As %Date [ SqlColumnNumber = 9, SqlFieldName = RES_LastSchedSDate ];

/// End Date of last schedule generation
Property RESLastSchedEDate As %Date [ SqlColumnNumber = 10, SqlFieldName = RES_LastSchedEDate ];

/// Availability of resource-doctor load (1-free)
Property RESAvailability As %Float(MAXVAL = 1, MINVAL = -1) [ SqlColumnNumber = 11, SqlComputeCode = { s {RES_Availability}=$S(+{RES_CurrLoadLimit}=0:-1,1:({RES_CurrLoadLimit}-{RES_CurrNumPatIn})/{RES_CurrLoadLimit})
}, SqlComputed, SqlFieldName = RES_Availability, Transient ];

/// Number of patient come into current session
Property RESCurrNumPatIn As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 12, SqlComputeCode = { s {RES_CurrNumPatIn}=$P({RES_CurrSessSummary},"^",1)
}, SqlComputed, SqlFieldName = RES_CurrNumPatIn, Transient ];

/// Summary of Current sess (load,PatIn,PatOut)
Property RESCurrSessSummary As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlComputeCode = { s {RES_CurrSessSummary}=""
}, SqlComputed, SqlFieldName = RES_CurrSessSummary, Transient ];

/// Number of patient discharge in curr session
Property RESCurrNumPatOut As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 14, SqlComputeCode = { s {RES_CurrNumPatOut}=$P({RES_CurrSessSummary},"^",2)
}, SqlComputed, SqlFieldName = RES_CurrNumPatOut, Transient ];

/// Load limit of current session
Property RESCurrLoadLimit As %Float(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 15, SqlComputeCode = { s {RES_CurrLoadLimit}=$P({RES_CurrSessSummary},"^",3)
}, SqlComputed, SqlFieldName = RES_CurrLoadLimit, Transient ];

/// Len of the queue
Property RESQueueLen As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 16, SqlComputeCode = { N QLEN
 S QLEN=$p({RES_CurrSessSummary},"^",5)
 I (QLEN="")&({RES_Availability}=-1) S QLEN=999
 S {RES_QueueLen}=QLEN
}, SqlComputed, SqlFieldName = RES_QueueLen, Transient ];

/// Des Ref to RB_ApptSchedule (current session)
Property RESCurrSessionDR As RBApptSchedule [ SqlColumnNumber = 17, SqlComputeCode = { s {RES_CurrSession_DR}=$p({RES_CurrSessSummary},"^",4)
}, SqlComputed, SqlFieldName = RES_CurrSession_DR, Transient ];

/// Curr Session Number of Pending Appointment
Property RESCurrPendAppt As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 18, SqlComputeCode = { s {RES_CurrPendAppt}=$P({RES_CurrSessSummary},"^",6)
}, SqlComputed, SqlFieldName = RES_CurrPendAppt, Transient ];

/// Resource Type
Property RESType As %String(DISPLAYLIST = ",Care Provider,Equipment", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",Care Provider,Equipment") [ SqlColumnNumber = 19, SqlComputeCode = { s {RES_Type}=$S({RES_EQ_DR}="":"Care Provider",1:"Equipment")
}, SqlComputed, SqlFieldName = RES_Type, Transient ];

/// Is Schedule Required
Property RESScheduleRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 20, SqlFieldName = RES_ScheduleRequired ];

/// MR Request
Property RESMRRequest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = RES_MRRequest ];

/// Oper Booking Method
Property RESOperBookingMethod As %String(DISPLAYLIST = ",By Time,By Sequence,By Priority", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",T,S,P") [ SqlColumnNumber = 22, SqlFieldName = RES_OperBookingMethod ];

/// Schedule For This Hospital
Property RESScheduleForThisHospital As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = RES_ScheduleForThisHospital ];

/// Des Ref RefHosp
Property RESRefHospDR As CTRefClin [ SqlColumnNumber = 24, SqlFieldName = RES_RefHosp_DR ];

/// Des REf CTLOC
Property RESRoomDR As CTLoc [ SqlColumnNumber = 25, SqlFieldName = RES_Room_DR ];

/// Allocated Schedule
Property RESAllocatedSchedule As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = RES_AllocatedSchedule ];

/// Date on Hold
Property RESDateHold As %Date [ SqlColumnNumber = 27, SqlFieldName = RES_DateHold ];

/// Show In Oper theatre WorkBench
Property RESShowInOperWB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = RES_ShowInOperWB ];

/// Days OT Closed
Property RESDaysOTClosed As %Float [ SqlColumnNumber = 29, SqlFieldName = RES_DaysOTClosed ];

/// Des Ref OperTheatreType
Property RESOperTheatreTypeDR As ORCOperTheatreType [ SqlColumnNumber = 30, SqlFieldName = RES_OperTheatreType_DR ];

/// Active
Property RESActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = RES_Active ];

/// Date To
Property RESDateTo As %Date [ SqlColumnNumber = 32, SqlFieldName = RES_DateTo ];

/// Admitting Rights
Property RESAdmittingRights As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = RES_AdmittingRights ];

/// IgnorePubHol
Property RESIgnorePubHol As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = RES_IgnorePubHol ];

/// Date Active From
Property RESDateActiveFrom As %Date [ SqlColumnNumber = 35, SqlFieldName = RES_DateActiveFrom ];

/// Date Active To
Property RESDateActiveTo As %Date [ SqlColumnNumber = 36, SqlFieldName = RES_DateActiveTo ];

/// CPClinicOptions
Property RESCPClinicOptions As %String(DISPLAYLIST = ",Single c/p clinic,Dual c/p clinic,Sequential c/p clinic", MAXLEN = 21, TRUNCATE = 1, VALUELIST = ",SI,DU,SE") [ SqlColumnNumber = 37, SqlFieldName = RES_CPClinicOptions ];

/// CPLocationNo
Property RESCPLocationNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = RES_CPLocationNo ];

Index RowIDBasedIDKeyIndex On RESRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBResource).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResource","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBResource).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResource","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBResource).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResource","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBResource).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResource","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResource","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBResource).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResource","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RB("RES",0))</SqlIdExpression>
<SQLMap name="DataMasterRES">
<Data name="RES_Active">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RES_AdmittingRights">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RES_AllocatedSchedule">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RES_CPClinicOptions">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RES_CPLocationNo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RES_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RES_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RES_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RES_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RES_DateHold">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RES_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RES_DaysOTClosed">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RES_Desc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RES_EQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RES_IgnorePubHol">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RES_LastSchedEDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RES_LastSchedSDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RES_MRRequest">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RES_OperBookingMethod">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RES_OperTheatreType_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RES_RefHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RES_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RES_ScheduleForThisHospital">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RES_ScheduleRequired">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RES_ShowInOperWB">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RES_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RES_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOCDR">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RES_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RES_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RES_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTPCPDR">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RES_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CTPCP"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RES_CTPCP_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RES_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RES_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RES_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RES_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({RES_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RES_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEQDR">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RES_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RES_EQ_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RES_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RES_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RES_RowId</SqlRowIdName>
<StreamLocation>^User.RBResourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
