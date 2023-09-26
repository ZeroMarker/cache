Class User.DHCVISNKLed Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_VIS_NKLed, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Contents
Property Contents As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// GroupNo
Property GroupNo As %Library.Float [ SqlColumnNumber = 3 ];

/// IndexNo
Property IndexNo As %Library.Float [ SqlColumnNumber = 4 ];

/// StartDate
Property StartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5 ];

/// StartTime
Property StartTime As %Library.Time [ SqlColumnNumber = 6 ];

/// EndDate
Property EndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7 ];

/// EndTime
Property EndTime As %Library.Time [ SqlColumnNumber = 8 ];

/// InsertDate
Property InsertDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9 ];

/// InsertTime
Property InsertTime As %Library.Time [ SqlColumnNumber = 10 ];

/// InsertUser
Property InsertUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISNKLed)</SqlIdExpression>
<SQLMap name="IndexEndDateGroup">
<Global>^DHCVISNKLedi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EndDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GroupNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroupNo">
<Global>^DHCVISNKLedi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GroupNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="Contents">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GroupNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IndexNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="InsertUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCVISNKLed</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCVISNKLedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
