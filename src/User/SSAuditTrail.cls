/// SS Audit Trail(1727)
Class User.SSAuditTrail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_AuditTrail, StorageStrategy = SQLStorage ]
{

Relationship ChildSSAuditTrailFields As SSAuditTrailFields [ Cardinality = children, Inverse = FLDParRef ];

/// Table Name
Property AUDTable As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = AUD_Table ];

/// Record RowId
Property AUDTableRowId As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AUD_TableRowId ];

/// Action
Property AUDAction As %String(DISPLAYLIST = ",Insert,Update,Delete", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",I,U,D") [ SqlColumnNumber = 4, SqlFieldName = AUD_Action ];

/// Date
Property AUDDate As %Date [ SqlColumnNumber = 5, SqlFieldName = AUD_Date ];

/// Time
Property AUDTime As %Time [ SqlColumnNumber = 6, SqlFieldName = AUD_Time ];

/// Des Ref User
Property AUDUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = AUD_User_DR ];

/// Cache User
Property AUDCacheUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = AUD_CacheUser ];

/// Des Ref LogonLocation
Property AUDLogonLocationDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = AUD_LogonLocation_DR ];

/// Des Ref PAPMI
Property AUDPAPMIDR As PAPatMas [ SqlColumnNumber = 10, SqlFieldName = AUD_PAPMI_DR ];

/// Des Ref Group
Property AUDGroupDR As SSGroup [ SqlColumnNumber = 11, SqlFieldName = AUD_Group_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSAuditTrail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrail","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSAuditTrail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrail","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSAuditTrail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrail","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSAuditTrail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrail","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSAuditTrail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSAuditTrail","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^AUD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AUD_Action">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AUD_CacheUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AUD_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AUD_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AUD_LogonLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AUD_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AUD_Table">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUD_TableRowId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AUD_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AUD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^AUD</Global>
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
<SQLMap name="IndexDate">
<Global>^AUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AUD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AUD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^AUD</Global>
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
<Expression>"LocDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AUD_LogonLocation_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUD_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDate">
<Global>^AUD</Global>
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
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AUD_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUD_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTableDate">
<Global>^AUD</Global>
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
<Expression>"TableDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AUD_Table})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUD_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTableRowId">
<Global>^AUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
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
<Expression>$$ALPHAUP({AUD_Table})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUD_TableRowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUD_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AUD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^AUD</Global>
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
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AUD_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AUD_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AUD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AUD_RowId</SqlRowIdName>
<StreamLocation>^User.SSAuditTrailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
