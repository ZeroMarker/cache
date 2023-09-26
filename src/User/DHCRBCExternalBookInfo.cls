Class User.DHCRBCExternalBookInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DEB_RowID, SqlTableName = DHCRBC_ExternalBookInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DEB_Loc_DR
Property DEBLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DEB_Loc_DR ];

/// DEB_OrdRowid
Property DEBOrdRowid As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DEB_OrdRowid ];

/// DEB_ResourceCode
Property DEBResourceCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DEB_ResourceCode ];

/// DEB_ResourceDesc
Property DEBResourceDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DEB_ResourceDesc ];

/// DEB_BookDate
Property DEBBookDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DEB_BookDate ];

/// DEB_BookTime
Property DEBBookTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DEB_BookTime ];

/// DEB_Operater
Property DEBOperater As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DEB_Operater ];

/// DEB_Date
Property DEBDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DEB_Date ];

/// DEB_Time
Property DEBTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DEB_Time ];

/// DEB_Note
Property DEBNote As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DEB_Note ];

/// DEB_Note1
Property DEBNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DEB_Note1 ];

/// DEB_StudyNo
Property DEBStudyNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DEB_StudyNo ];

/// DEB_PositionCode
Property DEBPositionCode As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DEB_PositionCode ];

/// DEB_PositionDesc
Property DEBPositionDesc As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DEB_PositionDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCExternalBookInfo)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCRBCExternalBookInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DEB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEB_BookDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEB_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdItemID">
<Global>^DHCRBCExternalBookInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DEB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OrdItemID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEB_OrdRowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrderPosition">
<Global>^DHCRBCExternalBookInfoi</Global>
<Subscript name="1">
<Expression>"OrderBody"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEB_OrdRowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEB_PositionCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyNo">
<Global>^DHCRBCExternalBookInfoi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DEB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STUDYNO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEB_StudyNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DEB_BookDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEB_BookTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DEB_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DEB_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEB_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DEB_Note1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DEB_Operater">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DEB_OrdRowid">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEB_PositionCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DEB_PositionDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DEB_ResourceCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DEB_ResourceDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DEB_StudyNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DEB_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCRBCExternalBookInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DEB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCExternalBookInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
