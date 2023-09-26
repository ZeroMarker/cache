/// RB Appointment Schedule   (AS,8044)
Class User.RBApptSchedule Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptSchedule, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ASChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildRBApptScheduleCP As RBApptScheduleCP [ Cardinality = children, Inverse = ASCPParRef ];

Relationship ChildRBAppointment As RBAppointment [ Cardinality = children, Inverse = APPTASParRef ];

Relationship ChildRBApptScheduleTR As User.RBApptScheduleTR [ Cardinality = children, Inverse = ASTRParRef ];

/// RB_Resource Parent Reference
Relationship ASRESParRef As RBResource [ Cardinality = parent, Inverse = ChildRBApptSchedule, Required, SqlFieldName = AS_RES_ParRef ];

/// Child Sub (New Key)
Property ASChildSub As %Float [ InitialExpression = {$i(^RBAS(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = AS_ChildSub ];

/// Appointment Date
Property ASDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = AS_Date ];

/// Session
Property ASSession As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = AS_Session ];

/// Session Start Time
Property ASSessStartTime As %Time [ Required, SqlColumnNumber = 5, SqlFieldName = AS_SessStartTime ];

/// Session End Time
Property ASSessEndTime As %Time [ Required, SqlColumnNumber = 6, SqlFieldName = AS_SessEndTime ];

/// No Appt per session , MINVAL = 0
Property ASNoApptSession As %Float(MAXVAL = 200000) [ Required, SqlColumnNumber = 7, SqlFieldName = AS_NoApptSession ];

/// Load Level 
Property ASLoad As %Float(MINVAL = 0) [ Required, SqlColumnNumber = 8, SqlFieldName = AS_Load ];

/// Availability (0-empty load, 1-full load)
Property ASAvailability As %Float(MAXVAL = 1, MINVAL = 0) [ SqlColumnNumber = 9, SqlComputeCode = { i +{AS_Load}=0 s {AS_Availability}="" q
 s {AS_Availability}=$s({AS_Load}:({AS_Load}-{AS_NumPatIn})/{AS_Load},1:"")
}, SqlComputed, SqlFieldName = AS_Availability, Transient ];

/// Number of patient came in
Property ASNumPatIn As %Float(MAXVAL = 999, MINVAL = 0) [ InitialExpression = 0, Required, SqlColumnNumber = 10, SqlFieldName = AS_NumPatIn ];

/// Number of patient complete visit
Property ASNumPatOut As %Float(MAXVAL = 999, MINVAL = 0) [ InitialExpression = 0, Required, SqlColumnNumber = 11, SqlFieldName = AS_NumPatOut ];

/// Remarks
Property ASRemarks As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = AS_Remarks, SqlListType = SUBNODE ];

/// Appointment Slot
Property ASSlot As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = AS_Slot ];

/// Queue Number start count
Property ASQueueNoCount As %String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = AS_QueueNoCount ];

/// Number of slots booked/arrived/complete
Property ASBookedSlots As %Float [ SqlColumnNumber = 17, SqlFieldName = AS_BookedSlots ];

/// Des Ref RBEffDateSession
Property ASRBEffDateSessionDR As RBResEffDateSession [ SqlColumnNumber = 18, SqlFieldName = AS_RBEffDateSession_DR ];

/// IrregularFlag
Property ASIrregularFlag As %String(DISPLAYLIST = ",Sqeeze slot,Added Slot", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",S,A") [ SqlColumnNumber = 19, SqlFieldName = AS_IrregularFlag ];

/// Des Ref SessionType
Property ASSessionTypeDR As RBCSessionType [ SqlColumnNumber = 20, SqlFieldName = AS_SessionType_DR ];

/// Actual session date
Property ASActualDate As %Date [ SqlColumnNumber = 21, SqlFieldName = AS_ActualDate ];

/// Actual session start time
Property ASActualStartTime As %Time [ SqlColumnNumber = 22, SqlFieldName = AS_ActualStartTime ];

/// Actual session end time
Property ASActualEndTime As %Time [ SqlColumnNumber = 23, SqlFieldName = AS_ActualEndTime ];

/// Des ref RBC_ReasonForVariance
Property ASReasonForDelayDR As RBCReasonForVariance [ SqlColumnNumber = 24, SqlFieldName = AS_ReasonForDelay_DR ];

/// DR RBC_ReasonForVariance
Property ASReasonForOvertimeDR As RBCReasonForVariance [ SqlColumnNumber = 25, SqlFieldName = AS_ReasonForOvertime_DR ];

/// GenerationDate
Property ASGenerationDate As %Date [ SqlColumnNumber = 26, SqlFieldName = AS_GenerationDate ];

/// GenerationTime
Property ASGenerationTime As %Time [ SqlColumnNumber = 27, SqlFieldName = AS_GenerationTime ];

/// Des Ref LastUpdateUser
Property ASLastUpdateUserDR As SSUser [ SqlColumnNumber = 28, SqlFieldName = AS_LastUpdateUser_DR ];

/// LastUpdateDate
Property ASLastUpdateDate As %Date [ SqlColumnNumber = 29, SqlFieldName = AS_LastUpdateDate ];

/// LastUpdateTime
Property ASLastUpdateTime As %Time [ SqlColumnNumber = 30, SqlFieldName = AS_LastUpdateTime ];

/// NotAvailableSlot
Property ASNotAvailableSlot As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = AS_NotAvailableSlot ];

/// Des Ref OPDRoom
Property ASOPDRoomDR As PACOPDRooms [ SqlColumnNumber = 32, SqlFieldName = AS_OPDRoom_DR ];

/// Day Clinic Options
Property ASDayClinicOptions As %String(DISPLAYLIST = ",Single c/p clinic,Dual c/p clinic,Sequential c/p clinic", MAXLEN = 21, TRUNCATE = 1, VALUELIST = ",SI,DU,SE") [ SqlColumnNumber = 33, SqlFieldName = AS_DayClinicOptions ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 ;处理扩展表字段与索引
 d ##Class(User.RBApptSchedule).OnTriggerCustom($g(%d(1)),"TAfterIns")
 d ##Class(User.RBApptSchedule).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchedule","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 ;处理扩展表字段与索引
 d ##Class(User.RBApptSchedule).OnTriggerCustom($g(%d(1)),"TAfterUpd")
 d ##Class(User.RBApptSchedule).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchedule","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 ;处理扩展表字段与索引
 d ##Class(User.RBApptSchedule).OnTriggerCustom($g(%d(1)),"TBeforeDel")
 d ##Class(User.RBApptSchedule).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchedule","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBApptSchedule).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchedule","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchedule","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBApptSchedule).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchedule","OnAfterDelete")
}

ClassMethod OnTriggerCustom(rowid As %String, type As %String) As %Status
{
	s $zt="OnTriggerCustomErr"
	;s ^tmpgry("OnTriggerCustom")=rowid_","_type
	;m ^tmpgry("OnTriggerCustom","e")=%e
	;m ^tmpgry("OnTriggerCustom","d")=%d
	s rtn=1
	s ExtObj=##class(User.DHCRBApptSchedule).%OpenId(rowid)
	if $ISOBJECT(ExtObj) {
		if type="TAfterIns" {
			s ASDate=%d(3)
			if ASDate'=ExtObj.ASDate {
				s ExtObj.ASDate=ASDate
				s sc=ExtObj.%Save()
				if $$$ISERR(sc) {
					s rtn=0
				}
			}
		}
		if type="TAfterUpd" {
			s ASDate=%d(3)
			if ASDate'=ExtObj.ASDate {
				s ExtObj.ASDate=ASDate
				s sc=ExtObj.%Save()
				if $$$ISERR(sc) {
					s rtn=0
				}
			}
		}
		if type="TBeforeDel" {
			s ASDate=ExtObj.ASDate
			s RoomDR=ExtObj.ASRoomDRGetObjectId()
			s TimeRangeDR=ExtObj.ASTimeRangeDRGetObjectId()
			;s ^tmpgry("OnTriggerCustom","TAfterDel")=ASDate_","_RoomDR_","_TimeRangeDR
			;User.RBApptSchedule删除后,User.DHCRBApptSchedule自然就打不开对象了,需在此处理扩展表的索引
			if RoomDR'="" k ^RBAS(0,"DateRoom",ASDate,RoomDR,+rowid,$P(rowid,"||",2))
			if TimeRangeDR'="" k ^RBAS(+rowid,0,"DateTR",ASDate,TimeRangeDR,$P(rowid,"||",2))
		}
	}
	
	Q rtn
OnTriggerCustomErr
	;s ^tmpgry("OnTriggerCustom","Error")=$zerror
	Q 0
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMasterAS">
<Data name="AS_ActualDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AS_ActualEndTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AS_ActualStartTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AS_BookedSlots">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AS_DayClinicOptions">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AS_GenerationDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AS_GenerationTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AS_IrregularFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AS_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AS_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AS_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AS_Load">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AS_NoApptSession">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AS_NotAvailableSlot">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AS_NumPatIn">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AS_NumPatOut">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AS_OPDRoom_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AS_QueueNoCount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AS_RBEffDateSession_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AS_ReasonForDelay_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AS_ReasonForOvertime_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AS_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AS_SessEndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AS_SessStartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AS_Session">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AS_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AS_Slot">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>AS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999999999999</StopValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexASDate">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdded">
<Condition>{AS_IrregularFlag}["A"</Condition>
<ConditionFields>AS_Date,AS_SessStartTime,AS_IrregularFlag</ConditionFields>
<Global>^RBAS</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Add"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AS_SessStartTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"DateSTime"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AS_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AS_SessStartTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateSess">
<Condition>1</Condition>
<Global>^RBAS</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateSess"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AS_RBEffDateSession_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AS_SessStartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AS_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptScheduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
