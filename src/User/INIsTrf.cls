/// IN Issue/Transfer        (INIT,371)
Class User.INIsTrf Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_IsTrf, StorageStrategy = SQLStorage ]
{

Relationship ChildINIsTrfItm As INIsTrfItm [ Cardinality = children, Inverse = INITIINITParRef ];

/// Des Ref to SSUSR
Property INITSSUSRDR As SSUser [ Required, SqlColumnNumber = 2, SqlFieldName = INIT_SSUSR_DR ];

/// Issue/Transfer Date
Property INITDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 3, SqlFieldName = INIT_Date ];

/// Des Ref to CTLOC
Property INITFrLocDR As CTLoc [ Required, SqlColumnNumber = 5, SqlFieldName = INIT_FrLoc_DR ];

/// Remarks
Property INITRemarks As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INIT_Remarks, SqlListType = subnode ];

/// Des Ref to INRQ
Property INITINRQDR As INRequest [ SqlColumnNumber = 8, SqlFieldName = INIT_INRQ_DR ];

/// Issue/Transfer Reference No
Property INITNo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 9, SqlFieldName = INIT_No ];

/// Transaction Type (T-Iss/trf, W- ward Stk)
Property INITType As %String(COLLATION = "AlphaUp", MAXLEN = 1, TRUNCATE = 1) [ InitialExpression = "T", Required, SqlColumnNumber = 11, SqlFieldName = INIT_Type ];

/// Des Ref to CTLOC
Property INITToLocDR As CTLoc [ SqlColumnNumber = 12, SqlFieldName = INIT_ToLoc_DR ];

/// Transfer Time
Property INITTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 13, SqlFieldName = INIT_Time ];

/// Acknowledge date
Property INITAckDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 14, SqlFieldName = INIT_AckDate ];

/// Acknowledge Time
Property INITAckTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 15, SqlFieldName = INIT_AckTime ];

/// Acknowledge by
Property INITAckUserDR As SSUser [ SqlColumnNumber = 16, SqlFieldName = INIT_AckUser_DR ];

/// UserCompleted
Property INITUserCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = INIT_UserCompleted ];

/// Acknowledgement Completed
Property INITAcknowCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = INIT_AcknowCompleted ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INIsTrf).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsTrf","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INIsTrf).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsTrf","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INIsTrf).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsTrf","OnBeforeDelete")
 d VALDEL^at371
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INIsTrf).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsTrf","OnBeforeUpdate")
 d PRFILINS^at371
 d VALUPD^at371
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsTrf","OnBeforeInsert")
 d VALINS^at371
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INIsTrf).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsTrf","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INIT(0))</SqlIdExpression>
<SQLMap name="DataMasterINIT">
<Data name="INIT_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INIT_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INIT_AckUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INIT_AcknowCompleted">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INIT_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INIT_FrLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INIT_INRQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INIT_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INIT_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INIT_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INIT_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INIT_ToLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INIT_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INIT_UserCompleted">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^INIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINITAckDate">
<Global>^INIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AckDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INIT_AckDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITDate">
<Global>^INIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TrfDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INIT_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITFrLoc">
<Global>^INIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FrLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INIT_FrLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITNo">
<Global>^INIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
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
<Expression>$$ALPHAUP({INIT_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTo">
<Global>^INIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocTo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIT_ToLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIT_FrLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequest">
<Global>^INIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIT_INRQ_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INIT_RowId</SqlRowIdName>
<StreamLocation>^User.INIsTrfS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
