Class User.DHCRBSaveBookLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSBL_RowID, SqlTableName = DHCRB_SaveBookLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSBL_USER_DR
Property DSBLUSERDR As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = DSBL_USER_DR ];

/// DSBL_IP
Property DSBLIP As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DSBL_IP ];

/// DSBL_OperateDate
Property DSBLOperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DSBL_OperateDate ];

/// DSBL_OperateTime
Property DSBLOperateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DSBL_OperateTime ];

/// DSBL_OEordItem_DR
Property DSBLOEordItemDR As User.OEOrdItem [ SqlColumnNumber = 6, SqlFieldName = DSBL_OEordItem_DR ];

/// DSBL_StudyNo
Property DSBLStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DSBL_StudyNo ];

/// DSBL_BookDate
Property DSBLBookDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DSBL_BookDate ];

/// DSBL_StartTime
Property DSBLStartTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DSBL_StartTime ];

/// DSBL_EndTime
Property DSBLEndTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DSBL_EndTime ];

/// DSBL_Status
Property DSBLStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DSBL_Status ];

/// DSBL_EQ
Property DSBLEQ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DSBL_EQ ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBSaveBookLog)</SqlIdExpression>
<SQLMap name="IndexOrdItemDR">
<Global>^DHCRBSaveBookLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSBL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OEORDITEM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSBL_OEordItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSBL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCRBSaveBookLogi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSBL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DSBL_USER_DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSBL_OperateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSBL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataMap">
<Data name="DSBL_BookDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DSBL_EQ">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DSBL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DSBL_IP">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSBL_OEordItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSBL_OperateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSBL_OperateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSBL_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSBL_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSBL_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSBL_USER_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBSaveBookLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSBL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DSBL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBSaveBookLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
