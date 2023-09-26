/// PA Waiting List Transaction(1480)
Class User.PAWaitingListTransaction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListTransaction, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TRANSChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_WaitingList Parent Reference
Relationship TRANSParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListTransaction, Required, SqlFieldName = TRANS_ParRef ];

/// Childsub
Property TRANSChildsub As %Float [ InitialExpression = {$i(^PAWL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TRANS",0))}, SqlColumnNumber = 2, SqlFieldName = TRANS_Childsub ];

/// Des Ref Wait List Type
Property TRANSWaitListTypeDR As PACWaitingListType [ SqlColumnNumber = 3, SqlFieldName = TRANS_WaitListType_DR ];

/// Des Ref Wait List Priority
Property TRANSWaitListPriorityDR As PACWaitingListPriority [ SqlColumnNumber = 4, SqlFieldName = TRANS_WaitListPriority_DR ];

/// Des Ref Surgeon
Property TRANSSurgeonDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = TRANS_Surgeon_DR ];

/// Date
Property TRANSDate As %Date [ SqlColumnNumber = 6, SqlFieldName = TRANS_Date ];

/// Time
Property TRANSTime As %Time [ SqlColumnNumber = 7, SqlFieldName = TRANS_Time ];

/// Des Ref User
Property TRANSUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = TRANS_User_DR ];

/// Des Ref Reason For Change
Property TRANSReasonForChangeDR As PACWaitListReasonForChange [ SqlColumnNumber = 9, SqlFieldName = TRANS_ReasonForChange_DR ];

/// Status
Property TRANSStatusDR As PACWaitingListStatus [ SqlColumnNumber = 10, SqlFieldName = TRANS_Status_DR ];

/// Process Flag (if changes are for future)
Property TRANSProcessFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = TRANS_ProcessFlag ];

/// Effective Date
Property TRANSDateEffective As %Date [ SqlColumnNumber = 12, SqlFieldName = TRANS_DateEffective ];

/// Des Ref ReasonNotAvail
Property TRANSReasonNotAvailDR As PACWLReasonNotAvail [ SqlColumnNumber = 13, SqlFieldName = TRANS_ReasonNotAvail_DR ];

/// TCI Status
Property TRANSTCIStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = TRANS_TCIStatus ];

/// Booking Number
Property TRANSBookingNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = TRANS_BookingNumber ];

/// Removal Desc
Property TRANSRemovalDesc As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = TRANS_RemovalDesc, SqlListType = SUBNODE ];

/// Priority Changed
Property TRANSPriorityChanged As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = TRANS_PriorityChanged ];

/// Est Length Of Stay
Property TRANSEstLengthOfStay As %Float [ SqlColumnNumber = 18, SqlFieldName = TRANS_EstLengthOfStay ];

/// Des Ref StatePPP
Property TRANSStatePPPDR As PACStatePPP [ SqlColumnNumber = 19, SqlFieldName = TRANS_StatePPP_DR ];

/// Des Ref Hospital
Property TRANSHospitalDR As CTHospital [ SqlColumnNumber = 20, SqlFieldName = TRANS_Hospital_DR ];

/// Des Ref AccomodationType
Property TRANSAccomodationTypeDR As PACAccomodationType [ SqlColumnNumber = 21, SqlFieldName = TRANS_AccomodationType_DR ];

/// Des Ref WLNotAvail
Property TRANSWLNotAvailDR As PAWaitingListNotAvailable [ SqlColumnNumber = 22, SqlFieldName = TRANS_WLNotAvail_DR ];

/// AdmVisitStatus
Property TRANSAdmVisitStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = TRANS_AdmVisitStatus ];

/// DateDelete
Property TRANSDateDelete As %Date [ SqlColumnNumber = 24, SqlFieldName = TRANS_DateDelete ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAWaitingListTransaction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListTransaction","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAWaitingListTransaction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListTransaction","OnAfterInsert")
 d Table^HL7Outbound("PAWaitingListTransaction",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAWaitingListTransaction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListTransaction","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAWaitingListTransaction).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListTransaction","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAWaitingListTransaction).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListTransaction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TRANS_AccomodationType_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TRANS_AdmVisitStatus">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TRANS_BookingNumber">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TRANS_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRANS_DateDelete">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TRANS_DateEffective">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TRANS_EstLengthOfStay">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TRANS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TRANS_PriorityChanged">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TRANS_ProcessFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TRANS_ReasonForChange_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRANS_ReasonNotAvail_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TRANS_RemovalDesc">
<Node>"REM"</Node>
</Data>
<Data name="TRANS_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TRANS_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TRANS_Surgeon_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRANS_TCIStatus">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TRANS_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRANS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRANS_WLNotAvail_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TRANS_WaitListPriority_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRANS_WaitListType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
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
<SQLMap name="IndexNotProcessed">
<Condition>$p({TRANS_ProcessFlag},$c(1))="N"</Condition>
<ConditionFields>TRANS_ProcessFlag</ConditionFields>
<Global>^PAWLi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TRANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Not-Proc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRANS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRANS_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingListTransactionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
