Class User.dhcjfyjrefreason Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = yjrrea_rowid, SqlTableName = dhc_jfyjrefreason, StorageStrategy = SQLStorage ]
{

/// yjrrea_code
Property yjrreacode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = yjrrea_code ];

/// yjrrea_desc
Property yjrreadesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = yjrrea_desc ];

/// yjrrea_date
Property yjrreastdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = yjrrea_stdate ];

/// yjrrea_enddate
Property yjrreaenddate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = yjrrea_enddate ];

/// yjrrea_flag
Property yjrreaflag As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = yjrrea_flag ];

/// yjrrea_hosp_dr
Property yjrreahospdr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = yjrrea_hosp_dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFYJRREASON)</SqlIdExpression>
<SQLMap name="indexcode">
<Global>^DHCJFYJRREASON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>yjrrea_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{yjrrea_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{yjrrea_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdesc">
<Global>^DHCJFYJRREASON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>yjrrea_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{yjrrea_desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{yjrrea_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexflag">
<Global>^DHCJFYJRREASON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>yjrrea_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"flag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{yjrrea_flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{yjrrea_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexstdate">
<Global>^DHCJFYJRREASON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>yjrrea_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"stdate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{yjrrea_stdate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{yjrrea_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="master">
<Data name="yjrrea_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="yjrrea_desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="yjrrea_enddate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="yjrrea_flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="yjrrea_hosp_dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="yjrrea_stdate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCJFYJRREASON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>yjrrea_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{yjrrea_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.dhcjfyjrefreasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
