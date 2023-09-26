/// RB SesSchedule Services(1426)
Class User.RBSesScheduleServices Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_SesSchedule_Services, StorageStrategy = SQLStorage ]
{

Relationship ChildRBSesSchedServIns As RBSesSchedServIns [ Cardinality = children, Inverse = INSParRef ];

/// Childsub
Property SERChildsub As %Float [ InitialExpression = {$i(^RBSS($p(%d(0),"||"),$p(%d(0),"||",2),"SER",0))}, SqlColumnNumber = 2, SqlFieldName = SER_Childsub ];

/// RB_SesSchedule Parent Reference
Relationship SERParRef As RBSesSchedule [ Cardinality = parent, Inverse = ChildRBSesScheduleServices, Required, SqlFieldName = SER_ParRef ];

/// Des Ref RBC_Service
Property SERRBCServiceDR As RBCServices [ SqlColumnNumber = 3, SqlFieldName = SER_RBC_Service_DR ];

Index RowIDBasedIDKeyIndex On SERChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBSesScheduleServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesScheduleServices","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBSesScheduleServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesScheduleServices","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBSesScheduleServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesScheduleServices","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBSesScheduleServices).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesScheduleServices","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBSesScheduleServices).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesScheduleServices","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SER_RBC_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBSS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_SesSchedule.RBSS_JobId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RB_SesSchedule.RBSS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_SesSchedule.RBSS_JobId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_SesSchedule.RBSS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SER_RowId</SqlRowIdName>
<StreamLocation>^User.RBSesScheduleServicesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
