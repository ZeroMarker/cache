/// Adm Transaction             (1320)
Class User.PAAdmTransaction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmTransaction, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 29854;

Index RowIDBasedIDKeyIndex On TRANSChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm Parent Reference
Relationship TRANSParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmTransaction, Required, SqlFieldName = TRANS_ParRef ];

/// Childsub
Property TRANSChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TRANS",0))}, SqlColumnNumber = 2, SqlFieldName = TRANS_Childsub ];

/// Start Date
Property TRANSStartDate As %Date [ SqlColumnNumber = 3, SqlFieldName = TRANS_StartDate ];

/// Start Time
Property TRANSStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = TRANS_StartTime ];

/// End Date
Property TRANSEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = TRANS_EndDate ];

/// End Time
Property TRANSEndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = TRANS_EndTime ];

/// Des Ref to CTCP
Property TRANSCTCPDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = TRANS_CTCP_DR ];

/// Des REf CTLOC
Property TRANSCTLOCDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = TRANS_CTLOC_DR ];

/// Des Ref to Room
Property TRANSRoomDR As PACRoom [ SqlColumnNumber = 9, SqlFieldName = TRANS_Room_DR ];

/// Des Ref to Ward
Property TRANSWardDR As PACWard [ SqlColumnNumber = 10, SqlFieldName = TRANS_Ward_DR ];

/// Des Ref Bed
Property TRANSBedDR As PACBed [ SqlColumnNumber = 11, SqlFieldName = TRANS_Bed_DR ];

/// Des Ref PAC RoomType
Property TRANSRoomTypeDR As PACRoomType [ SqlColumnNumber = 12, SqlFieldName = TRANS_RoomType_DR ];

/// Des Ref BedTransfer_Reason
Property TRANSReasonDR As PACBedTransferReason [ SqlColumnNumber = 13, SqlFieldName = TRANS_Reason_DR ];

/// Des Ref PACTransfReqStatus
Property TRANSStatusDR As PACTransfRequestStatus [ SqlColumnNumber = 14, SqlFieldName = TRANS_Status_DR ];

/// Main
Property TRANSMain As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = TRANS_Main ];

/// Update Date
Property TRANSUpdateDate As %Date [ SqlColumnNumber = 16, SqlFieldName = TRANS_UpdateDate ];

/// Update Time
Property TRANSUpdateTime As %Time [ SqlColumnNumber = 17, SqlFieldName = TRANS_UpdateTime ];

/// Des Ref UpdateUser
Property TRANSUpdateUserDR As SSUser [ SqlColumnNumber = 18, SqlFieldName = TRANS_UpdateUser_DR ];

/// Des Ref Resource
Property TRANSResourceDR As RBResource [ SqlColumnNumber = 19, SqlFieldName = TRANS_Resource_DR ];

/// Verified
Property TRANSVerified As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = TRANS_Verified ];

/// Des Ref TRANS_DRG_DR
Property TRANSDRGDR As MRCDRGCodes [ SqlColumnNumber = 21, SqlFieldName = TRANS_DRG_DR ];

/// Des Ref HRG
Property TRANSHRGDR As PACHRGCodes [ SqlColumnNumber = 22, SqlFieldName = TRANS_HRG_DR ];

/// Des Ref TransType
Property TRANSTransTypeDR As PACTransType [ SqlColumnNumber = 23, SqlFieldName = TRANS_TransType_DR ];

/// Date Accepted
Property TRANSDateAccepted As %Date [ SqlColumnNumber = 24, SqlFieldName = TRANS_DateAccepted ];

/// Time Accepted
Property TRANSTimeAccepted As %Time [ SqlColumnNumber = 25, SqlFieldName = TRANS_TimeAccepted ];

/// Des Ref OverrideRoomType
Property TRANSOverrideRoomTypeDR As PACRoomType [ SqlColumnNumber = 26, SqlFieldName = TRANS_OverrideRoomType_DR ];

/// Warned
Property TRANSWarned As %String(DISPLAYLIST = ",Edited after warning,Deleted after warning", MAXLEN = 21, TRUNCATE = 1, VALUELIST = ",E,D") [ SqlColumnNumber = 27, SqlFieldName = TRANS_Warned ];

/// Closure
Property TRANSClosure As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = TRANS_Closure ];

/// Des Ref UpdateUserHospital
Property TRANSUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 29, SqlFieldName = TRANS_UpdateUserHospital_DR ];

/// Des Ref CTLOC
Property TRANSDeptDR As CTLoc [ SqlColumnNumber = 30, SqlFieldName = TRANS_Dept_DR ];

/// TransferRemark
Property TRANSTransferRemark As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = TRANS_TransferRemark, SqlListType = SUBNODE ];

/// MoveMROnDischarge
Property TRANSMoveMROnDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = TRANS_MoveMROnDischarge ];

/// Des Ref AccomodationType
Property TRANSAccomodationTypeDR As PACAccomodationType [ SqlColumnNumber = 33, SqlFieldName = TRANS_AccomodationType_DR ];

/// Des Ref BedType
Property TRANSBedTypeDR As PACBedType [ SqlColumnNumber = 34, SqlFieldName = TRANS_BedType_DR ];

/// ReadyForBill
Property TRANSReadyForBill As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = TRANS_ReadyForBill ];

/// 转移床号
Property TRANSBedCode As %String [ SqlColumnNumber = 36, SqlFieldName = TRANS_BedCode ];

/// 主管护士
Property TRANSMianNurse As %String [ SqlColumnNumber = 37, SqlFieldName = TRANS_MianNurse ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmTransaction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmTransaction","OnAfterDelete")
 d Table^HL7Outbound("PAAdmTransaction",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmTransaction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmTransaction","OnAfterInsert")
 d Table^HL7Outbound("PAAdmTransaction",%d(1),"Insert")
 d ##class(web.PAAdmTransaction).UpdateBitmapIndex(%d(1))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmTransaction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmTransaction","OnAfterUpdate")
 d Table^HL7Outbound("PAAdmTransaction",%d(1),"Update")
 d ##class(web.PAAdmTransaction).UpdateBitmapIndex(%d(1))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmTransaction).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmTransaction","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmTransaction).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmTransaction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>29854</ExtentSize>
<Property name="TRANSAccomodationTypeDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="TRANSBedDR">
<Selectivity>1.3879%</Selectivity>
</Property>
<Property name="TRANSBedTypeDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="TRANSCTCPDR">
<Selectivity>1.3144%</Selectivity>
</Property>
<Property name="TRANSCTLOCDR">
<Selectivity>1.6947%</Selectivity>
</Property>
<Property name="TRANSChildsub">
<Selectivity>2.5641%</Selectivity>
</Property>
<Property name="TRANSClosure">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="TRANSDRGDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="TRANSDateAccepted">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="TRANSDeptDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="TRANSEndDate">
<Selectivity>0.5969%</Selectivity>
</Property>
<Property name="TRANSEndTime">
<Selectivity>0.4869%</Selectivity>
</Property>
<Property name="TRANSHRGDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="TRANSMain">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TRANSMoveMROnDischarge">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TRANSOverrideRoomTypeDR">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="TRANSParRef">
<Selectivity>0.0178%</Selectivity>
</Property>
<Property name="TRANSReadyForBill">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TRANSReasonDR">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="TRANSResourceDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="TRANSRoomDR">
<Selectivity>2.3256%</Selectivity>
</Property>
<Property name="TRANSRoomTypeDR">
<Selectivity>99.9992%</Selectivity>
</Property>
<Property name="TRANSStartDate">
<Selectivity>0.1348%</Selectivity>
</Property>
<Property name="TRANSStartTime">
<Selectivity>0.1222%</Selectivity>
</Property>
<Property name="TRANSStatusDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="TRANSTimeAccepted">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="TRANSTransTypeDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="TRANSTransferRemark">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="TRANSUpdateDate">
<Selectivity>0.3020%</Selectivity>
</Property>
<Property name="TRANSUpdateTime">
<Selectivity>0.0882%</Selectivity>
</Property>
<Property name="TRANSUpdateUserDR">
<Selectivity>3.3333%</Selectivity>
</Property>
<Property name="TRANSUpdateUserHospitalDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="TRANSVerified">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="TRANSWardDR">
<Selectivity>1.8517%</Selectivity>
</Property>
<Property name="TRANSWarned">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="TRANS_AccomodationType_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="TRANS_BedCode">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="TRANS_BedType_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="TRANS_Bed_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TRANS_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRANS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRANS_Closure">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="TRANS_DRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TRANS_DateAccepted">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="TRANS_Dept_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="TRANS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRANS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRANS_HRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TRANS_Main">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TRANS_MianNurse">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="TRANS_MoveMROnDischarge">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="TRANS_OverrideRoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="TRANS_ReadyForBill">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="TRANS_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TRANS_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TRANS_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TRANS_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRANS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRANS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRANS_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TRANS_TimeAccepted">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="TRANS_TransType_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TRANS_TransferRemark">
<Node>"REM"</Node>
</Data>
<Data name="TRANS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TRANS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TRANS_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="TRANS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TRANS_Verified">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TRANS_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TRANS_Warned">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRANS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateTime">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransDateTime"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANS_StartDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANS_StartTime}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Condition>$p($g(^PAC("REQST",+{TRANS_Status_DR})),"^")'="J"</Condition>
<ConditionFields>TRANS_CTCP_DR,TRANS_Status_DR</ConditionFields>
<Global>^PAADMi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransDoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANS_CTCP_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDoc1">
<Condition>$p($g(^PAC("REQST",+{TRANS_Status_DR})),"^")'="J"</Condition>
<ConditionFields>TRANS_CTCP_DR,TRANS_StartDate,TRANS_StartTime,TRANS_Status_DR</ConditionFields>
<Global>^PAADMi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransDoc1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANS_CTCP_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{TRANS_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{TRANS_StartTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEndDate">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransEndDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANS_EndDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransDateTime1">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransDateTime1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANS_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_StartTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransLoc">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANS_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Condition>{TRANS_Bed_DR}="",'{TRANS_EndDate}</Condition>
<ConditionFields>TRANS_EndDate,TRANS_Ward_DR,TRANS_Bed_DR</ConditionFields>
<Data name="TRANS_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADMi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransWard"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANS_Ward_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWarned">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransWarned"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANS_Warned}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextransbed">
<Condition>'{TRANS_EndDate}</Condition>
<ConditionFields>TRANS_Bed_DR,TRANS_EndDate</ConditionFields>
<Data name="TRANS_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADMi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TransBed"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRANS_Bed_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRANS_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmTransactionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
