/// InterPeriod
Class dhc.bonus.inter.InterPeriod Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterPeriod_rowid, SqlTableName = InterPeriod, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InterPeriod_period
Property InterPeriodperiod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = InterPeriod_period ];

/// InterPeriod_periodType
Property InterPeriodperiodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterPeriod_periodType ];

/// InterPeriod_inLocSetDr
Property InterPeriodinLocSetDr As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 4, SqlFieldName = InterPeriod_inLocSetDr ];

/// InterPeriod_quote
Property InterPeriodquote As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterPeriod_quote ];

/// InterPeriod_startDate
Property InterPeriodstartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = InterPeriod_startDate ];

/// InterPeriod_endDate
Property InterPeriodendDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = InterPeriod_endDate ];

/// InterPeriod_remark
Property InterPeriodremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = InterPeriod_remark ];

/// InterPeriod_active
Property InterPeriodactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = InterPeriod_active ];

/// InterPeriod_corrType
Property InterPeriodcorrType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = InterPeriod_corrType ];

/// InterPeriod_period
Property InterPeriodYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = InterPeriod_year ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAINTERPERIOD(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InterPeriod_active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="InterPeriod_corrType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="InterPeriod_endDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InterPeriod_inLocSetDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InterPeriod_period">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InterPeriod_periodType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InterPeriod_quote">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InterPeriod_remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="InterPeriod_startDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InterPeriod_year">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^dhcbsInterPeriod</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InterPeriod_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InterPeriod_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocSet">
<Global>^dhcbsInterPeriod</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterPeriod_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterPeriod_inLocSetDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterPeriod_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPTPLocSet">
<Global>^dhcbsInterPeriod</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>InterPeriod_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PTPLocSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterPeriod_period}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterPeriod_periodType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InterPeriod_inLocSetDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{InterPeriod_rowid}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{InterPeriod_year}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.bonus.inter.InterPeriodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
