Class User.DHCJFUPAdmArrears Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UPAA_rowid, SqlTableName = DHC_JFUPAdmArrears, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UPAA_adm_dr
Property UPAAadmdr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = UPAA_adm_dr ];

/// UPAA_date
Property UPAAdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = UPAA_date ];

/// UPAA_time
Property UPAAtime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = UPAA_time ];

/// UPAA_user
Property UPAAuser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = UPAA_user ];

/// UPAA_flag
Property UPAAflag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UPAA_flag ];

/// UPAA_Comment1
Property UPAAComment1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = UPAA_Comment1 ];

/// UPAA_Comment2
Property UPAAComment2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = UPAA_Comment2 ];

/// UPAA_Comment3
Property UPAAComment3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = UPAA_Comment3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFUPAdmArrears)</SqlIdExpression>
<SQLMap name="indexadm">
<Global>^DHCJFUPAdmArrears</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPAA_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPAA_adm_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPAA_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexcomment1">
<Global>^DHCJFUPAdmArrears</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPAA_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COM1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPAA_Comment1}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPAA_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexcomment2">
<Global>^DHCJFUPAdmArrears</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPAA_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COM2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPAA_Comment2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPAA_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexcomment3">
<Global>^DHCJFUPAdmArrears</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPAA_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COM3"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPAA_Comment3}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPAA_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexdate">
<Global>^DHCJFUPAdmArrears</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPAA_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPAA_date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPAA_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexflag">
<Global>^DHCJFUPAdmArrears</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPAA_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Flag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPAA_flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPAA_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCJFUPAdmArrears</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UPAA_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UPAA_user}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UPAA_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterDHCJFUPAdmArrears">
<Data name="UPAA_Comment1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UPAA_Comment2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UPAA_Comment3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UPAA_adm_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UPAA_date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UPAA_flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UPAA_time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UPAA_user">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCJFUPAdmArrears</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UPAA_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UPAA_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFUPAdmArrearsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
