/// EventTimesFacilitators(2317)
Class User.RBEventTimesFacilitators Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_EventTimesFacilitators, StorageStrategy = SQLStorage ]
{

/// Childsub
Property TFChildsub As %Float [ InitialExpression = {$i(^RBEV($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"TIME",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"TF",0))}, SqlColumnNumber = 2, SqlFieldName = TF_Childsub ];

/// Des Ref Facilitator
Property TFFacilitatorDR As RBEventCPFacilitator [ SqlColumnNumber = 3, SqlFieldName = TF_Facilitator_DR ];

/// RB_EventTimes Parent Reference
Relationship TFParRef As RBEventTimes [ Cardinality = parent, Inverse = ChildRBEventTimesFacilitators, Required, SqlFieldName = TF_ParRef ];

Index RowIDBasedIDKeyIndex On TFChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBEventTimesFacilitators).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimesFacilitators","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBEventTimesFacilitators).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimesFacilitators","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBEventTimesFacilitators).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimesFacilitators","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBEventTimesFacilitators).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimesFacilitators","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBEventTimesFacilitators).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimesFacilitators","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="TFChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="TFFacilitatorDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TFParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="TF_Facilitator_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBEV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Event.EV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RB_EventTimes.TIME_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>TF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Event.EV_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TIME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_EventTimes.TIME_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TF"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TF_RowId</SqlRowIdName>
<StreamLocation>^User.RBEventTimesFacilitatorsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
