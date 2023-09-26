/// RT Request Volumes      (RTREV,354)
Class User.RTReqVol Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RT_ReqVol, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RTREVChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to RTREQ
Relationship RTREVRTREQParRef As RTRequest [ Cardinality = parent, Inverse = ChildRTReqVol, Required, SqlFieldName = RTREV_RTREQ_ParRef ];

/// Request Volume ChildSub
Property RTREVChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^RTREQ($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"RTREV",0))}, SqlColumnNumber = 2, SqlFieldName = RTREV_ChildSub ];

/// Priority (Order of Transfer List)
Property RTREVPriority As %Float(MAXVAL = 99, MINVAL = 0) [ SqlColumnNumber = 3, SqlFieldName = RTREV_Priority ];

/// Request Volume Status
Property RTREVStatus As %String(DISPLAYLIST = ",Acknowledged,Cross Out,Returned,Transfered,Moved,History,Issued,Misplaced,Request", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",A,X,R,T,M,H,I,S,B") [ InitialExpression = "Request", Required, SqlColumnNumber = 4, SqlFieldName = RTREV_Status ];

/// Des Ref to RTMAV
Property RTREVMasVolDR As RTMasVol [ SqlColumnNumber = 5, SqlFieldName = RTREV_MasVol_DR ];

/// Due Date
Property RTREVDueDate As %Date [ SqlColumnNumber = 6, SqlFieldName = RTREV_DueDate ];

/// Length Of Use
Property RTREVLengthOfUse As %Float(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 7, SqlComputeCode = { s {RTREV_LengthOfUse}=$$CO07^at354({RTREV_RTREQ_ParRef})
}, SqlComputed, SqlFieldName = RTREV_LengthOfUse, Transient ];

/// Des Ref to RTMAV
Property RTREVxMasVolDR As RTMasVol [ SqlColumnNumber = 8, SqlFieldName = RTREV_xMasVol_DR ];

/// Issue By : MR (O)ffice/(M)ovement/(T)ransfer
Property RTREVIssBy As %String(DISPLAYLIST = ",Office,Movement,Transfer", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",O,M,T") [ SqlColumnNumber = 9, SqlFieldName = RTREV_IssBy ];

/// Original Status before Misplace
Property RTREVxStatus As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = RTREV_xStatus ];

/// Last Transaction
Property RTREVLastRTMVTDR As RTMVTrans [ SqlColumnNumber = 11, SqlComputeCode = { i $G(XFUNC("MATCH","RTREV"))="" s {RTREV_LastRTMVT_DR}="" q
 N RTMVTcs
 S RTMVTcs=$O(^[XCONF("DIR"),XCONF("SYS")]RT("RTREV",{RTREV_RowId},+{RTREV_MasVol_DR},$P({RTREV_MasVol_DR},"||",2),""),-1)
 I +RTMVTcs'=0 s {RTREV_LastRTMVT_DR}={RTREV_MasVol_DR}_"||"_RTMVTcs
 I +RTMVTcs=0 s {RTREV_LastRTMVT_DR}=""
}, SqlComputed, SqlFieldName = RTREV_LastRTMVT_DR, Transient ];

/// Next Req Volume (pass by Trf & Move)
Property RTREVNextRTREVDR As RTReqVol [ SqlColumnNumber = 12, SqlComputeCode = { i ($G(XFUNC("MATCH","RTREV"))="")!(({RTREV_Status}'="M")&({RTREV_Status}'="T")) s {RTREV_NextRTREV_DR}="" q
 N MVT
 S MVT={RTREV_LastRTMVT_DR}
 S {RTREV_NextRTREV_DR}=$P($G(^[XCONF("DIR"),XCONF("SYS")]RT(+MVT,"RTMAV",$P(MVT,"||",2),"RTMVT",($P(MVT,"||",3)+1))),"^",3)
}, SqlComputed, SqlFieldName = RTREV_NextRTREV_DR, Transient ];

/// Request Date Computed
Property RTREVDateComputed As %Date [ SqlColumnNumber = 13, SqlComputeCode = { s {RTREV_DateComputed}=$p($g(^RTREQ(+{RTREV_RTREQ_ParRef})),"^",11)
}, SqlComputed, SqlFieldName = RTREV_DateComputed, Transient ];

/// Home Loc
Property RTREVHomeLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlComputeCode = { s {RTREV_HomeLoc}=$$CO14^at354({RTREV_MasVol_DR},{RTREV_ReturnLoc_DR},{RTREV_ShowInHomeLoc})
}, SqlComputed, SqlFieldName = RTREV_HomeLoc, Transient ];

/// Time Computed
Property RTREVTimeComputed As %Time [ SqlColumnNumber = 15, SqlComputeCode = { s {RTREV_TimeComputed}=$p($g(^RTREQ(+{RTREV_RTREQ_ParRef})),"^",12)
}, SqlComputed, SqlFieldName = RTREV_TimeComputed, Transient ];

/// Resp Loc(Calculate)
Property RTREVRespLoc As CTLoc [ SqlColumnNumber = 16, SqlComputeCode = { s {RTREV_RespLoc}=$$CO16^at354({RTREV_RTREQ_ParRef})
}, SqlComputed, SqlFieldName = RTREV_RespLoc, Transient ];

/// Des Ref RTMAS
Property RTREVRTMASDR As RTMaster [ SqlColumnNumber = 17, SqlComputeCode = { s {RTREV_RTMAS_DR}=$p({RTREV_MasVol_DR},"||")
}, SqlComputed, SqlFieldName = RTREV_RTMAS_DR, Transient ];

/// Return Location for record
Property RTREVReturnLocDR As CTLoc [ SqlColumnNumber = 18, SqlFieldName = RTREV_ReturnLoc_DR ];

/// Des Ref Doctor
Property RTREVDoctorDR As CTCareProv [ SqlColumnNumber = 19, SqlFieldName = RTREV_Doctor_DR ];

/// Des Ref CTLOC
Property RTREVViewLocDR As CTLoc [ SqlColumnNumber = 20, SqlFieldName = RTREV_ViewLoc_DR ];

/// Show In Home Loc
Property RTREVShowInHomeLoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = RTREV_ShowInHomeLoc ];

/// Des Ref ReasonForCancel
Property RTREVReasonForCancelDR As RTCReasonForCancel [ SqlColumnNumber = 22, SqlFieldName = RTREV_ReasonForCancel_DR ];

/// AckRequest
Property RTREVAckRequest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = RTREV_AckRequest ];

/// MRReturnDate
Property RTREVMRReturnDate As %Date [ SqlColumnNumber = 24, SqlFieldName = RTREV_MRReturnDate ];

Method RTREVDateComputedGet() As %Library.String
{
}

Method RTREVHomeLocGet() As %Library.String
{
}

Method RTREVTimeComputedGet() As %Library.String
{
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTReqVol).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTReqVol","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTReqVol).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTReqVol","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTReqVol).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTReqVol","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTReqVol).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTReqVol","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTReqVol).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTReqVol","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterRTREQ">
<Data name="RTREV_AckRequest">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RTREV_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RTREV_DueDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTREV_IssBy">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RTREV_LengthOfUse">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTREV_MRReturnDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RTREV_MasVol_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTREV_Priority">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTREV_ReasonForCancel_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RTREV_ReturnLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RTREV_ShowInHomeLoc">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RTREV_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTREV_ViewLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RTREV_xMasVol_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RTREV_xStatus">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^RTREQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RT_Request.RTREQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RTREV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RT_Request.RTREQ_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RTREV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RTREV_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDoctorStatus">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RT_Request.RTREQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RTREV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DocStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{RTREV_Doctor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREV_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RT_Request.RTREQ_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RTREV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDueDate">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RT_Request.RTREQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RTREV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DueDate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RTREV_DueDate}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RT_Request.RTREQ_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RTREV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMasVolDR">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>RT_Request.RTREQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>RTREV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REV_MV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREV_RTMAS_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREV_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTREV_DateComputed}</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{RTREV_Priority}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RTREV_TimeComputed}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RT_Request.RTREQ_RowId}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{RTREV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRespLoc">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RT_Request.RTREQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RTREV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RespLocStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREV_RespLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREV_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RT_Request.RTREQ_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RTREV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusDatePrior">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>RT_Request.RTREQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>RTREV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREV_HomeLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREV_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTREV_DateComputed}</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{RTREV_Priority}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RTREV_TimeComputed}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RT_Request.RTREQ_RowId}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{RTREV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexViewLoc">
<Global>^RTREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>RT_Request.RTREQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>RTREV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTREV_ViewLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTREV_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTREV_DateComputed}</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{RTREV_Priority}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RTREV_TimeComputed}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RT_Request.RTREQ_RowId}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{RTREV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RTREV_RowId</SqlRowIdName>
<StreamLocation>^User.RTReqVolS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
