/// SS Audit(1585)
Class User.SSAudit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Audit, StorageStrategy = SQLStorage ]
{

/// Date
Property AUDDate As %Date [ SqlColumnNumber = 4, SqlFieldName = AUD_Date ];

/// Des Ref Reason
Property AUDReasonDR As PACReasonForChangePatData [ SqlColumnNumber = 7, SqlFieldName = AUD_Reason_DR ];

/// Table Name
Property AUDTableName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = AUD_TableName ];

/// Table RowId
Property AUDTableRowId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AUD_TableRowId ];

/// Time
Property AUDTime As %Time [ SqlColumnNumber = 5, SqlFieldName = AUD_Time ];

/// Des Ref User
Property AUDUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = AUD_User_DR ];

Relationship ChildSSAuditFields As SSAuditFields [ Cardinality = children, Inverse = FLDParRef ];

Parameter EXTENTSIZE = 333;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSAudit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAudit","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSAudit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAudit","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSAudit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAudit","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSAudit).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAudit","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSAudit).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAudit","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>333</ExtentSize>
<Property name="AUDDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUDReasonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUDTableName">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUDTableRowId">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUDTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="AUDUserDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^AUDIT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AUD_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AUD_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AUD_TableName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUD_TableRowId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AUD_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AUD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^AUDIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AUD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AUD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTableRowId">
<Global>^AUDIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AUD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TableRow"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AUD_TableName})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUD_TableRowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AUD_RowId</SqlRowIdName>
<StreamLocation>^User.SSAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
