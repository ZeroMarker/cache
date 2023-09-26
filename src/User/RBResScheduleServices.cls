/// RB ResSchedServices(1428)
Class User.RBResScheduleServices Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResSchedule_Services, StorageStrategy = SQLStorage ]
{

Relationship ChildRBResSchedServIns As RBResSchedServIns [ Cardinality = children, Inverse = INSParRef ];

/// SER_ARCIM_ARCOS
Property SERARCIMARCOS As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlComputeCode = { s {SER_ARCIM_ARCOS}=$$CO09^at1428({SER_RBC_Service_DR})
}, SqlComputed, SqlFieldName = SER_ARCIM_ARCOS, Transient ];

/// Des Ref CTLOC
Property SERCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlComputeCode = { s {SER_CTLOC_DR}=$$CO04^at1428({SER_ParRef})
}, SqlComputed, SqlFieldName = SER_CTLOC_DR, Transient ];

/// Childsub
Property SERChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"RS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SER",0))}, SqlColumnNumber = 2, SqlFieldName = SER_Childsub ];

/// Day Of Week
Property SERDayOfWeek As %Float [ SqlColumnNumber = 6, SqlComputeCode = { s {SER_DayOfWeek}=$$CO06^at1428({SER_ParRef})
}, SqlComputed, SqlFieldName = SER_DayOfWeek, Transient ];

/// Desc
Property SERDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlComputeCode = { s {SER_Desc}=$$CO08^at1428({SER_RBC_Service_DR})
}, SqlComputed, SqlFieldName = SER_Desc, Transient ];

/// RB_ResSchedule Parent Reference
Relationship SERParRef As RBResSchedule [ Cardinality = parent, Inverse = ChildRBResScheduleServices, Required, SqlFieldName = SER_ParRef ];

/// Des Ref RBC_Service
Property SERRBCServiceDR As RBCServices [ SqlColumnNumber = 3, SqlFieldName = SER_RBC_Service_DR ];

/// Des Ref Resource
Property SERResourceDR As RBResource [ SqlColumnNumber = 5, SqlComputeCode = { s {SER_Resource_DR}=$$CO05^at1428({SER_ParRef})
}, SqlComputed, SqlFieldName = SER_Resource_DR, Transient ];

/// StartTime
Property SERStartTime As %Time [ SqlColumnNumber = 7, SqlComputeCode = { s {SER_StartTime}=$$CO07^at1428({SER_ParRef})
}, SqlComputed, SqlFieldName = SER_StartTime, Transient ];

Index RowIDBasedIDKeyIndex On SERChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResScheduleServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResScheduleServices","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResScheduleServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResScheduleServices","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResScheduleServices).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResScheduleServices","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResScheduleServices).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResScheduleServices","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResScheduleServices).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResScheduleServices","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SER_RBC_Service_DR">
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
<Field>SER_Childsub</Field>
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
<Expression>{SER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOCServD">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>RB_ResSchedule.RS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocSERD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SER_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SER_RBC_Service_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResSchedule.RS_ChildSub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTLOCService">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_ResSchedule.RS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocSER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_ARCIM_ARCOS}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_ResSchedule.RS_ChildSub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDayOfWeek">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>RB_ResSchedule.RS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DOW"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_DayOfWeek}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_ARCIM_ARCOS}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SER_StartTime}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResSchedule.RS_ChildSub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResourceServD">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>RB_ResSchedule.RS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ResSERD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SER_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SER_RBC_Service_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResSchedule.RS_ChildSub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResourceService">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RB_ResSchedule.RS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ResSER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SER_ARCIM_ARCOS}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_ResSchedule.RS_ChildSub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RB_ResSchedule.RS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_ARCIM_ARCOS}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResSchedule.RS_ChildSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SER_RowId</SqlRowIdName>
<StreamLocation>^User.RBResScheduleServicesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
