Class dhc.ca.cache.data.AccountMonths Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccountMonths_rowid, SqlTableName = AccountMonths, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildAccPeriods As dhc.ca.cache.data.AccPeriods [ Cardinality = children, Inverse = AccPeriodsparRef ];

/// AccountMonths_code
Property AccountMonthscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AccountMonths_code ];

/// AccountMonths_name
Property AccountMonthsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AccountMonths_name ];

/// AccountMonths_desc
Property AccountMonthsdesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AccountMonths_desc ];

/// AccountMonths_start
Property AccountMonthsstart As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AccountMonths_start ];

/// AccountMonths_end
Property AccountMonthsend As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = AccountMonths_end ];

/// AccountMonths_dataFinish
Property AccountMonthsdataFinish As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = AccountMonths_dataFinish ];

/// AccountMonths_treatFinish
Property AccountMonthstreatFinish As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = AccountMonths_treatFinish ];

/// AccountMonths_tieOff
Property AccountMonthstieOff As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = AccountMonths_tieOff ];

/// AccountMonths_remark
Property AccountMonthsremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AccountMonths_remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAACCOUNTMONTHS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="AccountMonths_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccountMonths_dataFinish">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccountMonths_desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccountMonths_end">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccountMonths_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccountMonths_remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccountMonths_start">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccountMonths_tieOff">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccountMonths_treatFinish">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCCAACCOUNTMONTHS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AccountMonths_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AccountMonths_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAACCOUNTMONTHS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AccountMonths_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AccountMonths_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccountMonths_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDataFinish">
<Global>^DHCCAACCOUNTMONTHS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AccountMonths_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DataFinish"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AccountMonths_dataFinish}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccountMonths_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCAACCOUNTMONTHS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AccountMonths_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AccountMonths_desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccountMonths_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAACCOUNTMONTHS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AccountMonths_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AccountMonths_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccountMonths_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTieOff">
<Global>^DHCCAACCOUNTMONTHS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AccountMonths_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TieOff"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AccountMonths_tieOff}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccountMonths_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTreatFinish">
<Global>^DHCCAACCOUNTMONTHS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AccountMonths_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TreatFinish"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AccountMonths_treatFinish}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccountMonths_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.AccountMonthsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
