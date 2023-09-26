/// RB ResSchedServIns(1429)
Class User.RBResSchedServIns Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResSchedServ_Ins, StorageStrategy = SQLStorage ]
{

/// Childsub
Property INSChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p(%d(0),"||"),"RS",$p(%d(0),"||",2),"SER",$p(%d(0),"||",3),"INS",0))}, SqlColumnNumber = 2, SqlFieldName = INS_Childsub ];

/// Des Ref InsType
Property INSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = INS_InsType_DR ];

/// RB_ResSchedule_Services Parent Reference
Relationship INSParRef As RBResScheduleServices [ Cardinality = parent, Inverse = ChildRBResSchedServIns, Required, SqlFieldName = INS_ParRef ];

Index RowIDBasedIDKeyIndex On INSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResSchedServIns).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedServIns","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResSchedServIns).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedServIns","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResSchedServIns).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedServIns","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResSchedServIns).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedServIns","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResSchedServIns).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedServIns","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResSchedule.RS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResSchedule_Services.SER_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResSchedule.RS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResSchedule_Services.SER_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.RBResSchedServInsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
