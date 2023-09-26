/// RB SesSchedServ Insurance(1427)
Class User.RBSesSchedServIns Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_SesSchedServ_Ins, StorageStrategy = SQLStorage ]
{

/// Childsub
Property INSChildsub As %Float [ InitialExpression = {$i(^RBSS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SER",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"INS",0))}, SqlColumnNumber = 2, SqlFieldName = INS_Childsub ];

/// Des Ref InsType
Property INSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = INS_InsType_DR ];

/// RB_SesSchedule_Services Parent Reference
Relationship INSParRef As RBSesScheduleServices [ Cardinality = parent, Inverse = ChildRBSesSchedServIns, Required, SqlFieldName = INS_ParRef ];

Index RowIDBasedIDKeyIndex On INSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBSesSchedServIns).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedServIns","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBSesSchedServIns).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedServIns","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBSesSchedServIns).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedServIns","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBSesSchedServIns).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedServIns","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBSesSchedServIns).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedServIns","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INS_InsType_DR">
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
<Field>RB_SesSchedule_Services.SER_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>INS_Childsub</Field>
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
<Expression>{RB_SesSchedule_Services.SER_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.RBSesSchedServInsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
