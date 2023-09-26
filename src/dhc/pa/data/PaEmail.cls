/// PaEmail
Class dhc.pa.data.PaEmail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PaEmail_Rowid, SqlTableName = PaEmail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PaEmail_UserDr
Property PaEmailUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PaEmail_UserDr ];

/// PaEmail_Order
Property PaEmailOrder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PaEmail_Order ];

/// PaEmail_EmailName
Property PaEmailEmailName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PaEmail_EmailName ];

/// PaEmail_Password
Property PaEmailPassword As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PaEmail_Password ];

/// PaEmail_Smtp
Property PaEmailSmtp As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PaEmail_Smtp ];

/// PaEmail_Active
Property PaEmailActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PaEmail_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAPAEMAIL(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="PaEmail_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PaEmail_EmailName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PaEmail_Order">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PaEmail_Password">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PaEmail_Smtp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PaEmail_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPAPAEMAIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PaEmail_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PaEmail_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUserEmail">
<Global>^DHCCJXPAPAEMAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PaEmail_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserEmail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PaEmail_UserDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PaEmail_EmailName}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PaEmail_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.PaEmailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
