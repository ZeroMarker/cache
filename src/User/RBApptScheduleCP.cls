/// RB Appointment Schedule CP
Class User.RBApptScheduleCP Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptScheduleCP, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ASCPChildSub [ IdKey, PrimaryKey, Unique ];

/// RB_ApptSchedule Parent Reference
Relationship ASCPParRef As RBApptSchedule [ Cardinality = parent, Inverse = ChildRBApptScheduleCP, Required, SqlFieldName = ASCP_ParRef ];

/// Child sub
Property ASCPChildSub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ASCP",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ASCP_ChildSub ];

/// Des Ref Care Prov
Property ASCPCareProvDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = ASCP_CareProv_DR ];

/// Actual arrival time
Property ASCPActualArrivalTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ASCP_ActualArrivalTime ];

/// CareProvRole
Property ASCPCareProvRole As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ASCP_CareProvRole ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBApptScheduleCP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptScheduleCP","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBApptScheduleCP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptScheduleCP","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBApptScheduleCP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptScheduleCP","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBApptScheduleCP).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptScheduleCP","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBApptScheduleCP).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptScheduleCP","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ASCP_ActualArrivalTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASCP_CareProvRole">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASCP_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>ASCP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ASCP"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ASCP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCareProv">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ASCP_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ASCP_CP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ASCP_CareProv_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASCP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ASCP_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptScheduleCPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
