/// Central Sterile Supplies(1126)
Class User.INCSR Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_CSR, StorageStrategy = SQLStorage ]
{

Relationship ChildINCSRItems As INCSRItems [ Cardinality = children, Inverse = CSRIParRef ];

/// Transaction No
Property INCSRNo As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ InitialExpression = "NEW", Required, SqlColumnNumber = 2, SqlFieldName = INCSR_No ];

/// Date of Transaction
Property INCSRDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 3, SqlFieldName = INCSR_Date ];

/// Time
Property INCSRTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 4, SqlFieldName = INCSR_Time ];

/// Des Ref to CTLOC(Laundry)
Property INCSRLaundryDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = INCSR_Laundry_DR ];

/// Des Ref to CTLOC(Ward)
Property INCSRWardDR As CTLoc [ InitialExpression = {$g(XCONF("DPUSR",4))}, SqlColumnNumber = 6, SqlFieldName = INCSR_Ward_DR ];

/// Des Ref to SSU
Property INCSRUserDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",1))}, Required, SqlColumnNumber = 7, SqlFieldName = INCSR_User_DR ];

/// Remarks
Property INCSRRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = INCSR_Remarks, SqlListType = subnode ];

/// Change Status
Property INCSRChangeStatus As %String(DISPLAYLIST = ",ChangeStatus,Transaction,Request", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",Y,N,R") [ SqlColumnNumber = 9, SqlFieldName = INCSR_ChangeStatus ];

/// Des Ref INCPriority
Property INCSRPriorityDR As INCSterilePriority [ SqlColumnNumber = 10, SqlFieldName = INCSR_Priority_DR ];

/// Des Ref to INCSR (CSR Request)
Property INCSRINCSRDR As INCSR [ SqlColumnNumber = 11, SqlFieldName = INCSR_INCSR_DR ];

/// Completed flag
Property INCSRCompleted As %String(DISPLAYLIST = ",Yes,No,Partially", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",Y,N,P") [ InitialExpression = "N", SqlColumnNumber = 12, SqlFieldName = INCSR_Completed ];

/// User Completed
Property INCSRUserCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = INCSR_UserCompleted ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INCSR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSR","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INCSR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSR","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INCSR).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSR","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INCSR).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSR","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSR","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INCSR).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSR","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INCSR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INCSR_ChangeStatus">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCSR_Completed">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCSR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCSR_INCSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCSR_Laundry_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCSR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCSR_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCSR_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INCSR_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCSR_UserCompleted">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCSR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCSR_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^INCSR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INCSR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ImdexRequest">
<Global>^INCSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Request"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCSR_INCSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^INCSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCSR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocFrom">
<Global>^INCSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocFrom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCSR_ChangeStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCSR_Laundry_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTo">
<Global>^INCSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INCSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocTo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCSR_ChangeStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCSR_Ward_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCSR_Laundry_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^INCSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCSR_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCSR_RowId</SqlRowIdName>
<StreamLocation>^User.INCSRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
