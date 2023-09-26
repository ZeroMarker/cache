/// SS Audit Trail Fields(1728)
Class User.SSAuditTrailFields Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_AuditTrailFields, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On FLDChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_AuditTrail Parent Reference
Relationship FLDParRef As SSAuditTrail [ Cardinality = parent, Inverse = ChildSSAuditTrailFields, Required, SqlFieldName = FLD_ParRef ];

/// Childsub
Property FLDChildsub As %Float [ InitialExpression = {$i(^AUD($p(%d(0),$c(1)),"FLD",0))}, SqlColumnNumber = 2, SqlFieldName = FLD_Childsub ];

/// Field No
Property FLDFieldNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = FLD_FieldNo ];

/// Old Value
Property FLDOldValue As %String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = FLD_OldValue ];

/// New Value
Property FLDValue As %String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlComputeCode = { s {FLD_Value}=$$CO5^at1728({FLD_RowId})
}, SqlComputed, SqlFieldName = FLD_Value, Transient ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSAuditTrailFields).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrailFields","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSAuditTrailFields).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrailFields","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSAuditTrailFields).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrailFields","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSAuditTrailFields).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrailFields","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSAuditTrailFields).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrailFields","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="FLD_FieldNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FLD_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^AUD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_AuditTrail.AUD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>FLD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_AuditTrail.AUD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FLD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FLD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FLD_RowId</SqlRowIdName>
<StreamLocation>^User.SSAuditTrailFieldsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
