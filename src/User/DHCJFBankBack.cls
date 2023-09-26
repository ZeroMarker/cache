Class User.DHCJFBankBack Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = bback_rowid, SqlTableName = DHC_JFBankBack, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// bback_yjdetail_dr
Property bbackyjdetaildr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = bback_yjdetail_dr ];

/// bback_invprtzy_dr
Property bbackinvprtzydr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = bback_invprtzy_dr ];

/// bback_flag
Property bbackflag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = bback_flag ];

/// bback_backflag
Property bbackbackflag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = bback_backflag ];

/// bback_user
Property bbackuser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = bback_user ];

/// bback_backdate
Property bbackbackdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = bback_backdate ];

/// bback_backtime
Property bbackbacktime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = bback_backtime ];

/// bback_Original_dr
Property bbackOriginaldr As User.DHCJFBankBack [ SqlColumnNumber = 9, SqlFieldName = bback_Original_dr ];

/// bback_remain
Property bbackremain As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = bback_remain ];

/// bback_updatedate
Property bbackupdatedate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = bback_updatedate ];

/// bback_updatetime
Property bbackupdatetime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = bback_updatetime ];

/// bback_updateuser
Property bbackupdateuser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = bback_updateuser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFBankBack)</SqlIdExpression>
<SQLMap name="indexbackdate">
<Global>^DHCJFBankBack</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>bback_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Backdate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bback_backdate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{bback_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexbackflag">
<Global>^DHCJFBankBack</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>bback_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Backflag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bback_backflag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{bback_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexflag">
<Global>^DHCJFBankBack</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>bback_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"flag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bback_flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{bback_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexfprowid">
<Global>^DHCJFBankBack</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>bback_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Fprowid"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bback_invprtzy_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{bback_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexupdatedate">
<Global>^DHCJFBankBack</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>bback_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Updatedate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bback_updatedate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{bback_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCJFBankBack</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>bback_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"user"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bback_user}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{bback_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexyjrowid">
<Global>^DHCJFBankBack</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>bback_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Yjrowid"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{bback_yjdetail_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{bback_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="masterdhcjfbankback">
<Data name="bback_Original_dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="bback_backdate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="bback_backflag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="bback_backtime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="bback_flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="bback_invprtzy_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="bback_remain">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="bback_updatedate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="bback_updatetime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="bback_updateuser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="bback_user">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="bback_yjdetail_dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCJFBankBack</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>bback_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{bback_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCJFBankBackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
