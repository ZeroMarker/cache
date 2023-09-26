/// InterPerson
Class dhc.pa.inter.InterPerson Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterPerson_rowid, SqlTableName = InterPerson, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InterPerson_ssUserDr
Property InterPersonssUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = InterPerson_ssUserDr ];

/// InterPerson_code
Property InterPersoncode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterPerson_code ];

/// InterPerson_name
Property InterPersonname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InterPerson_name ];

/// InterPerson_inLocSetDr
Property InterPersoninLocSetDr As dhc.pa.inter.InterLocSet [ SqlColumnNumber = 5, SqlFieldName = InterPerson_inLocSetDr ];

/// InterPerson_remark
Property InterPersonremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InterPerson_remark ];

/// InterPerson_active
Property InterPersonactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = InterPerson_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAINTERPERSON(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InterPerson_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InterPerson_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InterPerson_inLocSetDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InterPerson_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InterPerson_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InterPerson_ssUserDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPAINTERPERSON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InterPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InterPerson_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAINTERPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterPerson_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserCodeLocSet">
<Global>^DHCCJXPAINTERPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>InterPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserCodeLocSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterPerson_ssUserDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterPerson_inLocSetDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InterPerson_code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{InterPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexssUser">
<Global>^DHCCJXPAINTERPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ssUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterPerson_ssUserDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.InterPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
