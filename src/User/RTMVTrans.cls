/// RT Master Volumes Trans (RTMVT,353)
Class User.RTMVTrans Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RT_MVTrans, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RTMVTChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to RTMAV
Relationship RTMVTRTMAVParRef As RTMasVol [ Cardinality = parent, Inverse = ChildRTMVTrans, Required, SqlFieldName = RTMVT_RTMAV_ParRef ];

/// RTMVT Childsub (Newkey)
Property RTMVTChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$$DEF02^at353($s($d(initvalue):initvalue,1:%d(0)))}, Required, SqlColumnNumber = 2, SqlFieldName = RTMVT_ChildSub ];

/// Des Ref to SSUSR
Property RTMVTUserIdFromDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 3, SqlFieldName = RTMVT_UserIdFrom_DR ];

/// Transaction Type
Property RTMVTType As %String(DISPLAYLIST = ",Move In,Move Out,Transfer In,Transfer Out,Issued,Misplaced,Found,Acknowledged,Received,Returned,Cancel Issue,Cancel Transfer,Cancel Misplaced,Cancel Received,Cancel Returned,Cancel Found,Cancel Move,Cancel Acknowledge,Cancel Request,Relocate,Archive,Merged Into,Accepted Merge,History", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",MI,MO,TI,TO,I,M,F,A,H,R,CI,CT,CS,CH,CR,CF,CM,CA,CQ,L,ARC,MERG,MERGAC,HIS") [ Required, SqlColumnNumber = 4, SqlFieldName = RTMVT_Type ];

/// Des Ref to RTREV
Property RTMVTReqVolDR As RTReqVol [ SqlColumnNumber = 5, SqlFieldName = RTMVT_ReqVol_DR ];

/// Transaction Date
Property RTMVTDate As %Date [ SqlColumnNumber = 6, SqlFieldName = RTMVT_Date ];

/// Transaction Time
Property RTMVTTime As %Time [ SqlColumnNumber = 7, SqlFieldName = RTMVT_Time ];

/// Des Ref to SSU
Property RTMVTUserIdToDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = RTMVT_UserIdTo_DR ];

/// Des Ref to CTLOC
Property RTMVTLocFromDR As CTLoc [ SqlColumnNumber = 11, SqlFieldName = RTMVT_LocFrom_DR ];

/// Des Ref to CTLOC
Property RTMVTLocToDR As CTLoc [ SqlColumnNumber = 12, SqlFieldName = RTMVT_LocTo_DR ];

/// Des Ref to CTCP
Property RTMVTDoctorDR As CTCareProv [ SqlColumnNumber = 13, SqlFieldName = RTMVT_Doctor_DR ];

/// Des Ref ReasonForMove
Property RTMVTReasonForMoveDR As RTCReasonMove [ SqlColumnNumber = 14, SqlFieldName = RTMVT_ReasonForMove_DR ];

/// Des Ref RTMAVMerge
Property RTMVTRTMAVMergeDR As RTMasVol [ SqlColumnNumber = 15, SqlFieldName = RTMVT_RTMAVMerge_DR ];

/// BatchID
Property RTMVTBatchID As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = RTMVT_BatchID ];

/// Comments
Property RTMVTComments As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 17, SqlFieldName = RTMVT_Comments, SqlListType = SUBNODE ];

/// ContactPerson
Property RTMVTContactPerson As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = RTMVT_ContactPerson ];

/// Extension
Property RTMVTExtension As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = RTMVT_Extension ];

/// ReqTelNo
Property RTMVTReqTelNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = RTMVT_ReqTelNo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTMVTrans).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMVTrans","OnAfterDelete")

 d Table^HL7Outbound("RTMVTrans",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTMVTrans).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMVTrans","OnAfterInsert")

 d Table^HL7Outbound("RTMVTrans",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTMVTrans).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMVTrans","OnAfterUpdate")

 d Table^HL7Outbound("RTMVTrans",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTMVTrans).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMVTrans","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTMVTrans).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMVTrans","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterRTMVT">
<Data name="RTMVT_BatchID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RTMVT_Comments">
<Node>"REM"</Node>
</Data>
<Data name="RTMVT_ContactPerson">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RTMVT_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTMVT_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RTMVT_Extension">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RTMVT_LocFrom_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RTMVT_LocTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RTMVT_RTMAVMerge_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RTMVT_ReasonForMove_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RTMVT_ReqTelNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RTMVT_ReqVol_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTMVT_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTMVT_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTMVT_UserIdFrom_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTMVT_UserIdTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^RT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RT_MasVol.RTMAV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>RTMVT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RTMAV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RT_MasVol.RTMAV_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"RTMVT"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RTMVT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBatchId">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RT_MasVol.RTMAV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RTMVT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BatchID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({RTMVT_BatchID})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RT_MasVol.RTMAV_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RTMVT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRTREVDR">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RT_MasVol.RTMAV_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>RTMVT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RTREV"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RTMVT_ReqVol_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RT_MasVol.RTMAV_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RTMVT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RTMVT_RowId</SqlRowIdName>
<StreamLocation>^User.RTMVTransS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
