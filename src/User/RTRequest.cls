/// RT Request              (RTREQ,346)
Class User.RTRequest Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RT_Request, StorageStrategy = SQLStorage ]
{

Relationship ChildRTReqVol As RTReqVol [ Cardinality = children, Inverse = RTREVRTREQParRef ];

/// RTREQ Row ID
Property RTREQRowId As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ InitialExpression = {$i(^RTREQ(0))}, Required, SqlFieldName = RTREQ_RowId ];

/// Des Ref to RTMAS
Property RTREQMRNoDR As RTMaster [ Required, SqlColumnNumber = 2, SqlFieldName = RTREQ_MRNo_DR ];

/// Des Ref to SSUSR
Property RTREQRespUserDR As SSUser [ SqlColumnNumber = 3, SqlFieldName = RTREQ_RespUser_DR ];

/// Des Ref to CTLOC
Property RTREQRespLocDR As CTLoc [ Required, SqlColumnNumber = 4, SqlFieldName = RTREQ_RespLoc_DR ];

/// Request Reason
Property RTREQReqReasonDR As RTCReasonRequest [ SqlColumnNumber = 5, SqlFieldName = RTREQ_ReqReason_DR ];

/// Des Ref to SSUSR
Property RTREQReqUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = RTREQ_ReqUser_DR ];

/// Des Ref to CTLOC
Property RTREQReqLocDR As CTLoc [ Required, SqlColumnNumber = 7, SqlFieldName = RTREQ_ReqLoc_DR ];

/// Request Telephone Number
Property RTREQReqTelNo As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = RTREQ_ReqTelNo ];

/// Transcation Date
Property RTREQTransDate As %Date [ Required, SqlColumnNumber = 9, SqlFieldName = RTREQ_TransDate ];

/// Transaction Time
Property RTREQTransTime As %Time [ SqlColumnNumber = 10, SqlFieldName = RTREQ_TransTime ];

/// Request Status
Property RTREQStatus As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ InitialExpression = "B", Required, SqlColumnNumber = 14, SqlFieldName = RTREQ_Status ];

/// Request Date
Property RTREQDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 15, SqlFieldName = RTREQ_Date ];

/// Request Time
Property RTREQTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 16, SqlFieldName = RTREQ_Time ];

/// Matching field
Property RTREQMatchRTREVDR As RTReqVol [ SqlColumnNumber = 18, SqlComputeCode = { i $G(XFUNC("MATCH","RTREQ"))="" s {RTREQ_MatchRTREV_DR}="" q
 i {RTREQ_MRNo_DR}="" s {RTREQ_MatchRTREV_DR}="" q
 s {RTREQ_MatchRTREV_DR}=$$CO18^at346({RTREQ_RowId})
}, SqlComputed, SqlFieldName = RTREQ_MatchRTREV_DR, Transient ];

/// Des Ref to CTPCP
Property RTREQDoctorDR As CTCareProv [ SqlColumnNumber = 19, SqlFieldName = RTREQ_Doctor_DR ];

/// Des Ref Appt
Property RTREQApptDR As RBAppointment [ SqlColumnNumber = 20, SqlFieldName = RTREQ_Appt_DR ];

/// Des Ref PAADM
Property RTREQPAADMDR As PAAdm [ SqlColumnNumber = 21, SqlFieldName = RTREQ_PAADM_DR ];

/// Pager No
Property RTREQPagerNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = RTREQ_PagerNo ];

/// Comments
Property RTREQComments As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 23, SqlFieldName = RTREQ_Comments, SqlListType = SUBNODE ];

/// Acknowledge requests
Property RTREQAckRequest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = RTREQ_AckRequest ];

/// Pulling Date
Property RTREQPullingDate As %Date [ SqlColumnNumber = 25, SqlFieldName = RTREQ_PullingDate ];

/// Contact Person
Property RTREQContactPerson As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = RTREQ_ContactPerson ];

/// Patient Attending
Property RTREQPatientAttending As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = RTREQ_PatientAttending ];

/// BatchID
Property RTREQBatchID As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = RTREQ_BatchID ];

/// Des Ref Session
Property RTREQSessionDR As RBResEffDateSession [ SqlColumnNumber = 29, SqlFieldName = RTREQ_Session_DR ];

/// Automatic
Property RTREQAutomatic As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = RTREQ_Automatic ];

/// ReqTelExt
Property RTREQReqTelExt As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = RTREQ_ReqTelExt ];

/// Des Ref LastUpdateUser
Property RTREQLastUpdateUserDR As SSUser [ SqlColumnNumber = 32, SqlFieldName = RTREQ_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property RTREQLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 33, SqlFieldName = RTREQ_LastUpdateHospital_DR ];

Index RowIDBasedIDKeyIndex On RTREQRowId [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTRequest).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTRequest","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTRequest).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTRequest","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTRequest).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTRequest","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTRequest).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTRequest","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTRequest).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTRequest","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RTREQ(0))</SqlIdExpression>
<SQLMap name="DataMasterRTREQ">
<Data name="RTREQ_AckRequest">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RTREQ_Appt_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RTREQ_Automatic">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RTREQ_BatchID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RTREQ_Comments">
<Node>"REM"</Node>
</Data>
<Data name="RTREQ_ContactPerson">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RTREQ_Date">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RTREQ_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RTREQ_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="RTREQ_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RTREQ_MRNo_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTREQ_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RTREQ_PagerNo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RTREQ_PatientAttending">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RTREQ_PullingDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RTREQ_ReqLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RTREQ_ReqReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTREQ_ReqTelExt">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RTREQ_ReqTelNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RTREQ_ReqUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTREQ_RespLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTREQ_RespUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTREQ_Session_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RTREQ_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RTREQ_Time">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RTREQ_TransDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RTREQ_TransTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^RTREQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RTREQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RTREQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTREQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREQ_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppt">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTREQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREQ_Appt_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBatchId">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTREQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Batch"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({RTREQ_BatchID})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTREQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREQ_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPullDate">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTREQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PullDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREQ_PullingDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransDate">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RTREQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TransDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREQ_TransDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RTREQ_RowId</SqlRowIdName>
<StreamLocation>^User.RTRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
