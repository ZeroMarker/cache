Class User.DHCRBCallQueue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRCQ_CallQueue, SqlTableName = DHCRB_CallQueue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRCQ_PatId
Property DRCQPatId As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRCQ_PatId ];

/// DRCQ_Name
Property DRCQName As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRCQ_Name ];

/// DRCQ_Sex
Property DRCQSex As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRCQ_Sex ];

/// DRCQ_StudyNo
Property DRCQStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DRCQ_StudyNo ];

/// DRCQ_RegDate
Property DRCQRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DRCQ_RegDate ];

/// DRCQ_LocDr
Property DRCQLocDr As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DRCQ_LocDr ];

/// DRCQ_LocIndex
Property DRCQLocIndex As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DRCQ_LocIndex ];

/// DRCQ_EqDr
Property DRCQEqDr As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DRCQ_EqDr ];

/// DRCQ_EqIndex
Property DRCQEqIndex As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DRCQ_EqIndex ];

/// DRCQ_RoomDr
Property DRCQRoomDr As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DRCQ_RoomDr ];

/// DRCQ_RoomIndex
Property DRCQRoomIndex As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = DRCQ_RoomIndex ];

/// DRCQ_Status
Property DRCQStatus As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DRCQ_Status ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("CallQueue",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DRCQ_EqDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRCQ_EqIndex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRCQ_LocDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRCQ_LocIndex">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRCQ_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRCQ_PatId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRCQ_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRCQ_RoomDr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRCQ_RoomIndex">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRCQ_Sex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRCQ_Status">
<Delimiter>"^"</Delimiter>
<Node>"Status"</Node>
<Piece>1</Piece>
</Data>
<Data name="DRCQ_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRCQ_CallQueue</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CallQueue"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCQ_CallQueue}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateGroup">
<Global>^DHCRBCallQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRCQ_CallQueue</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DateGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCQ_RegDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCQ_EqDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRCQ_EqIndex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRCQ_CallQueue}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCRBCallQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRCQ_CallQueue</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCQ_RegDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCQ_LocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRCQ_LocIndex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRCQ_CallQueue}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateRoom">
<Global>^DHCRBCallQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRCQ_CallQueue</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DateRoom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCQ_RegDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCQ_RoomDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRCQ_RoomIndex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRCQ_CallQueue}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBCallQueuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRCQ_CallQueue</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCQ_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRCQ_CallQueue}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCallQueueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
