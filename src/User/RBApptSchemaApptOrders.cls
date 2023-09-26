/// ApptSchemaApptOrders(2776)
Class User.RBApptSchemaApptOrders Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptSchemaApptOrders, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ORDChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_ApptSchemaAppt Parent Reference
Relationship ORDParRef As RBApptSchemaAppt [ Cardinality = parent, Inverse = ChildRBApptSchemaApptOrders, Required, SqlFieldName = ORD_ParRef ];

/// Childsub
Property ORDChildsub As %Float [ InitialExpression = {$i(^RB("SCH",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"AP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ORD",0))}, SqlColumnNumber = 2, SqlFieldName = ORD_Childsub ];

/// Des Ref ARCIM
Property ORDARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ORD_ARCIM_DR ];

/// Des Ref ARCOS
Property ORDARCOSDR As ARCOrdSets [ SqlColumnNumber = 4, SqlFieldName = ORD_ARCOS_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBApptSchemaApptOrders).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaApptOrders","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBApptSchemaApptOrders).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaApptOrders","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBApptSchemaApptOrders).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaApptOrders","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBApptSchemaApptOrders).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaApptOrders","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBApptSchemaApptOrders).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaApptOrders","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaApptOrders","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="ORD_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORD_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_ApptSchema.SCH_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchemaAppt.AP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ORD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchema.SCH_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchemaAppt.AP_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ORD"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ORD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_ApptSchema.SCH_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchemaAppt.AP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>ORD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchema.SCH_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchemaAppt.AP_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ORD"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ORD_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ORD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_ApptSchema.SCH_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchemaAppt.AP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>ORD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchema.SCH_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchemaAppt.AP_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ORD"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ORD_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ORD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ORD_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptSchemaApptOrdersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
