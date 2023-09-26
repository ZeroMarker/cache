Class User.DHCCAbFeeCheck Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHCCAbFeeCheck, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property abndr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = abndr ];

Property adm As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = adm ];

Property wardid As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = wardid ];

Property sureuser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = sureuser ];

Property suredate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = suredate ];

Property suretime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = suretime ];

Property sureflag As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = sureflag ];

Property mem As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = mem ];

Property other As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = other ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAbFeeCheck)</SqlIdExpression>
<SQLMap name="indexadm">
<Global>^DHCCAbFeeCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{abndr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexmain">
<Data name="abndr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="adm">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="mem">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="other">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="suredate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="sureflag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="suretime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="sureuser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="wardid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCAbFeeCheck</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexsuredate">
<Global>^DHCCAbFeeCheck</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUREDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{suredate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCAbFeeCheckS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
