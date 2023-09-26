/// RT Master Volumes       (RTMAV,350)
Class User.RTMasVol Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RT_MasVol, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 6639;

Index RowIDBasedIDKeyIndex On RTMAVChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildRTMVTrans As RTMVTrans [ Cardinality = children, Inverse = RTMVTRTMAVParRef ];

Relationship ChildRTMasVolLocation As RTMasVolLocation [ Cardinality = children, Inverse = LOCParRef ];

Relationship ChildRTMasVolAdm As RTMasVolAdm [ Cardinality = children, Inverse = ADMParRef ];

/// Des Ref to RTMAS
Relationship RTMAVRTMASParRef As RTMaster [ Cardinality = parent, Inverse = ChildRTMasVol, Required, SqlFieldName = RTMAV_RTMAS_ParRef ];

/// RTMAV ChildSub
Property RTMAVChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^RT($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"RTMAV",0))}, Required, SqlColumnNumber = 2, SqlFieldName = RTMAV_ChildSub ];

/// RT Volume Description
Property RTMAVVolDesc As %String(COLLATION = "AlphaUp", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RTMAV_VolDesc ];

/// Process Status
Property RTMAVProcStatus As %String(DISPLAYLIST = ",Cross Out,Completed,Temporary,Process", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",X,H,T,P") [ SqlColumnNumber = 7, SqlFieldName = RTMAV_ProcStatus ];

/// Do Not Use - Not Relevent
Property RTMAVRequestDR As RTRequest [ SqlColumnNumber = 10, SqlFieldName = RTMAV_Request_DR ];

/// Active Flag
Property RTMAVActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 11, SqlFieldName = RTMAV_ActiveFlag ];

/// MRStatus
Property RTMAVMRStatus As %String(DISPLAYLIST = ",In,Out,Misplaced,Found,Transit", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",I,O,M,F,T") [ InitialExpression = "I", Required, SqlColumnNumber = 13, SqlFieldName = RTMAV_MRStatus ];

/// Expected Number of Use Day
Property RTMAVExpDays As %Float(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 14, SqlFieldName = RTMAV_ExpDays ];

/// Des Ref to RTCParts
Property RTMAVPartsDR As RTCMRecordParts [ SqlColumnNumber = 15, SqlFieldName = RTMAV_Parts_DR ];

/// Des Ref to CTLOC
Property RTMAVHomeLocDR As CTLoc [ SqlColumnNumber = 16, SqlFieldName = RTMAV_HomeLoc_DR ];

/// Des Ref to CTLOC
Property RTMAVCurrentLocDR As CTLoc [ SqlColumnNumber = 17, SqlFieldName = RTMAV_CurrentLoc_DR ];

/// Notes
Property RTMAVNotes As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 18, SqlFieldName = RTMAV_Notes, SqlListType = SUBNODE ];

/// Des Ref MRType_Vol
Property RTMAVMRTypeVolDR As RTCMRecordTypeVolumes [ SqlColumnNumber = 19, SqlFieldName = RTMAV_MRType_Vol_DR ];

/// Box Number
Property RTMAVBoxNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = RTMAV_BoxNumber ];

/// Des Ref PAADM
Property RTMAVPAADMDR As PAAdm [ SqlColumnNumber = 21, SqlFieldName = RTMAV_PAADM_DR ];

/// Volume Number
Property RTMAVVolumeNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = RTMAV_VolumeNumber ];

/// Des Ref Create Loc
Property RTMAVCreateLocDR As CTLoc [ SqlColumnNumber = 23, SqlFieldName = RTMAV_CreateLoc_DR ];

/// Date Created
Property RTMAVDateCreated As %Date [ SqlColumnNumber = 24, SqlFieldName = RTMAV_DateCreated ];

/// Time Created
Property RTMAVTimeCreated As %Time [ SqlColumnNumber = 25, SqlFieldName = RTMAV_TimeCreated ];

/// Created By User
Property RTMAVCreatedByUserDR As SSUser [ SqlColumnNumber = 26, SqlFieldName = RTMAV_CreatedByUser_DR ];

/// Date Arrived
Property RTMAVDateArrived As %Date [ SqlColumnNumber = 27, SqlFieldName = RTMAV_DateArrived ];

/// RollNumber
Property RTMAVRollNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = RTMAV_RollNumber ];

/// Position Number
Property RTMAVPositionNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = RTMAV_PositionNumber ];

/// Des Ref TempHomeLoc
Property RTMAVTempHomeLocDR As CTLoc [ SqlColumnNumber = 30, SqlFieldName = RTMAV_TempHomeLoc_DR ];

/// VolumeNumber1
Property RTMAVVolumeNumber1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = RTMAV_VolumeNumber1 ];

/// Date Issued
Property RTMAVDateIssued As %Date [ SqlColumnNumber = 32, SqlFieldName = RTMAV_DateIssued ];

/// DateToBeReturned
Property RTMAVDateToBeReturned As %Date [ SqlColumnNumber = 33, SqlFieldName = RTMAV_DateToBeReturned ];

/// Des Ref CancelReason
Property RTMAVCancelReasonDR As RTCReasonForCancel [ SqlColumnNumber = 34, SqlFieldName = RTMAV_CancelReason_DR ];

/// DateCancelled
Property RTMAVDateCancelled As %Date [ SqlColumnNumber = 35, SqlFieldName = RTMAV_DateCancelled ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RTMasVol).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMasVol","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RTMasVol).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMasVol","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RTMasVol).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMasVol","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RTMasVol).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMasVol","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RTMasVol).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RTMasVol","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6639</ExtentSize>
<Property name="RTMAVActiveFlag">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="RTMAVBoxNumber">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVCancelReasonDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVChildSub">
<Selectivity>7.6923%</Selectivity>
</Property>
<Property name="RTMAVCreateLocDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RTMAVCreatedByUserDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="RTMAVCurrentLocDR">
<Selectivity>3.3325%</Selectivity>
</Property>
<Property name="RTMAVDateArrived">
<Selectivity>4.1665%</Selectivity>
</Property>
<Property name="RTMAVDateCancelled">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVDateCreated">
<Selectivity>0.3065%</Selectivity>
</Property>
<Property name="RTMAVDateIssued">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RTMAVDateToBeReturned">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="RTMAVExpDays">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVHomeLocDR">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="RTMAVMRStatus">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="RTMAVMRTypeVolDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVNotes">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVPAADMDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="RTMAVPartsDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVPositionNumber">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVProcStatus">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="RTMAVRTMASParRef">
<Selectivity>0.0252%</Selectivity>
</Property>
<Property name="RTMAVRequestDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVRollNumber">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVTempHomeLocDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVTimeCreated">
<Selectivity>0.1477%</Selectivity>
</Property>
<Property name="RTMAVVolDesc">
<Selectivity>4.7619%</Selectivity>
</Property>
<Property name="RTMAVVolumeNumber">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="RTMAVVolumeNumber1">
<Selectivity>20.0000%</Selectivity>
</Property>
<SQLMap name="DataMasterRTMAV">
<Data name="RTMAV_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RTMAV_BoxNumber">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RTMAV_CancelReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RTMAV_CreateLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RTMAV_CreatedByUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RTMAV_CurrentLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RTMAV_DateArrived">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RTMAV_DateCancelled">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="RTMAV_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RTMAV_DateIssued">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RTMAV_DateToBeReturned">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RTMAV_ExpDays">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTMAV_HomeLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RTMAV_MRStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTMAV_MRType_Vol_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RTMAV_Notes">
<Node>"REM"</Node>
</Data>
<Data name="RTMAV_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RTMAV_Parts_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RTMAV_PositionNumber">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RTMAV_ProcStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTMAV_Request_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTMAV_RollNumber">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RTMAV_TempHomeLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RTMAV_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RTMAV_VolDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTMAV_VolumeNumber">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RTMAV_VolumeNumber1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Global>^RT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RTMAV_ChildSub</Field>
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
<Expression>{RTMAV_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RTMAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAV_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTMAV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCurrLoc">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RTMAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VolCurLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAV_CurrentLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTMAV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateArrived">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RTMAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateArrived"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAV_DateArrived}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTMAV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateArrived1">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RTMAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAV_CurrentLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTMAV_DateArrived}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RTMAV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateCancelled">
<Global>^RT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RTMAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateCancelled"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAV_DateCancelled}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTMAV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateIssued">
<Condition>{RTMAV_HomeLoc_DR}-{RTMAV_CurrentLoc_DR}</Condition>
<ConditionFields>RTMAV_DateIssued,RTMAV_CurrentLoc_DR,RTMAV_HomeLoc_DR</ConditionFields>
<Global>^RT</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RTMAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateIssued"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAV_DateIssued}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTMAV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateToReturn">
<Condition>{RTMAV_CurrentLoc_DR}-{RTMAV_HomeLoc_DR}</Condition>
<ConditionFields>RTMAV_DateToBeReturned,RTMAV_CurrentLoc_DR,RTMAV_HomeLoc_DR</ConditionFields>
<Global>^RT</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RTMAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateToReturn"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAV_DateToBeReturned}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTMAV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMisplaced">
<Condition>$p({RTMAV_MRStatus},$c(1))="M"</Condition>
<ConditionFields>RTMAV_MRStatus</ConditionFields>
<Global>^RT</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RT_Master.RTMAS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RTMAV_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MRStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RTMAV_MRStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RT_Master.RTMAS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RTMAV_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RTMAV_RowId</SqlRowIdName>
<StreamLocation>^User.RTMasVolS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
