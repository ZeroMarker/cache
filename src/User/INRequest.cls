/// IN Request Trf/Iss       (INRQ,283)
Class User.INRequest Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = IN_Request, StorageStrategy = SQLStorage ]
{

Relationship ChildINReqItm As INReqItm [ Cardinality = children, Inverse = INRQIINRQParRef ];

/// Request Reference Number
Property INRQNo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ InitialExpression = "0", Required, SqlColumnNumber = 2, SqlFieldName = INRQ_No ];

/// Des Ref to CTLOC
Property INRQRecLocDR As CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = INRQ_RecLoc_DR ];

/// Des Ref to SSUSR
Property INRQSSUSRDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = INRQ_SSUSR_DR ];

/// Status (C)lose,(O)pen,(X)cancel
Property INRQStatus As %String(DISPLAYLIST = ",Close,Open,Cancel", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",C,O,X") [ InitialExpression = "Open", SqlColumnNumber = 6, SqlFieldName = INRQ_Status ];

/// Date When Request Made
Property INRQDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 7, SqlFieldName = INRQ_Date ];

/// Des Ref to CTLOC
Property INRQReqLocDR As CTLoc [ Required, SqlColumnNumber = 9, SqlFieldName = INRQ_ReqLoc_DR ];

/// Request Time
Property INRQTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 10, SqlFieldName = INRQ_Time ];

/// Remarks
Property INRQRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = INRQ_Remarks, SqlListType = SUBNODE ];

/// User Completed
Property INRQUserCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = INRQ_UserCompleted ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INRequest).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INRequest","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INRequest).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INRequest","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INRequest).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INRequest","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INRequest).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INRequest","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INRequest","OnBeforeInsert")
 ;d PRFILINS^at283
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INRequest).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INRequest","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INRQ(0))</SqlIdExpression>
<SQLMap name="DataMasterINRQ">
<Data name="INRQ_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INRQ_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INRQ_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INRQ_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INRQ_ReqLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INRQ_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INRQ_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INRQ_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INRQ_UserCompleted">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^INRQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INRQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINRQDate">
<Global>^INRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRQ_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINRQNo">
<Global>^INRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INRQ_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINRQRecLocDR">
<Global>^INRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RecLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRQ_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINRQReqLocDR">
<Global>^INRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ReqLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRQ_ReqLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INRQ_RowId</SqlRowIdName>
<StreamLocation>^User.INRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
