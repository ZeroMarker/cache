Class dhc.ca.cache.data.VouchDatasMDJ Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VouchDatasMDJ_rowid, SqlTableName = VouchDatasMDJ, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// VouchDatasMDJ_YearMonth
Property VouchDatasMDJYearMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VouchDatasMDJ_YearMonth ];

/// VouchDatasMDJ_Number
Property VouchDatasMDJNumber As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VouchDatasMDJ_Number ];

/// VouchDatasMDJ_date
Property VouchDatasMDJdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = VouchDatasMDJ_date ];

/// VouchDatasMDJ_abstract
Property VouchDatasMDJabstract As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = VouchDatasMDJ_abstract ];

/// VouchDatasMDJ_deptCode
Property VouchDatasMDJdeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = VouchDatasMDJ_deptCode ];

/// VouchDatasMDJ_deptName
Property VouchDatasMDJdeptName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VouchDatasMDJ_deptName ];

/// VouchDatasMDJ_subjCode
Property VouchDatasMDJsubjCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = VouchDatasMDJ_subjCode ];

/// VouchDatasMDJ_subjName
Property VouchDatasMDJsubjName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = VouchDatasMDJ_subjName ];

/// VouchDatasMDJ_debit
Property VouchDatasMDJdebit As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = VouchDatasMDJ_debit ];

/// VouchDatasMDJ_remark
Property VouchDatasMDJremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = VouchDatasMDJ_remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAVOUCHDATASMDJ(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="VouchDatasMDJ_Number">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VouchDatasMDJ_YearMonth">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VouchDatasMDJ_abstract">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VouchDatasMDJ_date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VouchDatasMDJ_debit">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VouchDatasMDJ_deptCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VouchDatasMDJ_deptName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VouchDatasMDJ_remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VouchDatasMDJ_subjCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VouchDatasMDJ_subjName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCAVOUCHDATASMDJ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VouchDatasMDJ_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{VouchDatasMDJ_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexYearMonth">
<Global>^DHCCAVOUCHDATASMDJ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VouchDatasMDJ_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"YearMonth"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VouchDatasMDJ_YearMonth}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VouchDatasMDJ_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.cache139E.VouchDatasMDJS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
