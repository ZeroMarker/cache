/// PersonScheduleItem(2783)
Class User.PAPersonScheduleItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonScheduleItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPersonScheduleItemOrd As PAPersonScheduleItemOrd [ Cardinality = children, Inverse = ORDParRef ];

/// PA_PersonSchedule Parent Reference
Relationship ITMParRef As PAPersonSchedule [ Cardinality = parent, Inverse = ChildPAPersonScheduleItem, Required, SqlFieldName = ITM_ParRef ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"SCH",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Des Ref Hospital
Property ITMHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = ITM_Hospital_DR ];

/// Des Ref CTLOC
Property ITMCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = ITM_CTLOC_DR ];

/// Des Ref Resource
Property ITMResourceDR As RBResource [ SqlColumnNumber = 5, SqlFieldName = ITM_Resource_DR ];

/// Des Ref Service
Property ITMServiceDR As RBCServices [ SqlColumnNumber = 6, SqlFieldName = ITM_Service_DR ];

/// Des Ref SessType
Property ITMSessTypeDR As RBCSessionType [ SqlColumnNumber = 7, SqlFieldName = ITM_SessType_DR ];

/// Des Ref ConsCateg
Property ITMConsCategDR As OECConsultCateg [ SqlColumnNumber = 8, SqlFieldName = ITM_ConsCateg_DR ];

/// Des Ref WaitListType
Property ITMWaitListTypeDR As PACWaitingListType [ SqlColumnNumber = 9, SqlFieldName = ITM_WaitListType_DR ];

/// Des Ref WaitListPrior
Property ITMWaitListPriorDR As PACWaitingListPriority [ SqlColumnNumber = 10, SqlFieldName = ITM_WaitListPrior_DR ];

/// Des Ref WaitListStat
Property ITMWaitListStatDR As PACWaitingListStatus [ SqlColumnNumber = 11, SqlFieldName = ITM_WaitListStat_DR ];

/// Des Ref CTLOC
Property ITMWLLocDR As CTLoc [ SqlColumnNumber = 12, SqlFieldName = ITM_WLLoc_DR ];

/// Des Ref Hospital
Property ITMWLHospitalDR As CTHospital [ SqlColumnNumber = 13, SqlFieldName = ITM_WLHospital_DR ];

/// Des Ref CareProv
Property ITMWLCareProvDR As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = ITM_WLCareProv_DR ];

/// ApptOffset
Property ITMApptOffset As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ITM_ApptOffset ];

/// ApptOffsetUnit
Property ITMApptOffsetUnit As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ITM_ApptOffsetUnit ];

/// Des Ref WaitList
Property ITMWaitListDR As PAWaitingList [ SqlColumnNumber = 17, SqlFieldName = ITM_WaitList_DR ];

/// Des Ref Appoint
Property ITMAppointDR As RBAppointment [ SqlColumnNumber = 18, SqlFieldName = ITM_Appoint_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPersonScheduleItem).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItem","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPersonScheduleItem).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItem","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPersonScheduleItem).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItem","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPersonScheduleItem).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItem","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPersonScheduleItem).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItem","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItem","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="ITM_Appoint_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ITM_ApptOffset">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ITM_ApptOffsetUnit">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ITM_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_ConsCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ITM_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_SessType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITM_WLCareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ITM_WLHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ITM_WLLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ITM_WaitListPrior_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ITM_WaitListStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ITM_WaitListType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ITM_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PersonSchedule.SCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_PersonSchedule.SCH_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonScheduleItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
