/// SS Audit fields(1586)
Class User.SSAuditFields Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_AuditFields, StorageStrategy = SQLStorage ]
{

/// Childsub
Property FLDChildsub As %Float [ InitialExpression = {$i(^AUDIT($p(%d(0),$c(1)),"FLD",0))}, SqlColumnNumber = 2, SqlFieldName = FLD_Childsub ];

/// Field Number
Property FLDFieldNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = FLD_FieldNumber ];

/// New Value
Property FLDNewValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = FLD_NewValue ];

/// Old Value
Property FLDOldValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = FLD_OldValue ];

/// SS_Audit Parent Reference
Relationship FLDParRef As SSAudit [ Cardinality = parent, Inverse = ChildSSAuditFields, Required, SqlFieldName = FLD_ParRef ];

Index RowIDBasedIDKeyIndex On FLDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1310;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSAuditFields).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditFields","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSAuditFields).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditFields","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSAuditFields).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditFields","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSAuditFields).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditFields","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSAuditFields).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAuditFields","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1310</ExtentSize>
<Property name="FLDChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDFieldNumber">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDNewValue">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDOldValue">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="FLD_FieldNumber">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FLD_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FLD_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^AUDIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_Audit.AUD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>FLD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_Audit.AUD_RowId}</Expression>
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
<StreamLocation>^User.SSAuditFieldsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
