Class dhc.ca.cache.data.jsptodhDatas Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = jsptodhDatas_rowid, SqlTableName = jsptodhDatas, StorageStrategy = SQLStorage ]
{

/// JSPID
Property JSPID As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = jsptodhDatas_JSPID ];

/// STRDATE
Property STRDATE As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = jsptodhDatas_STRDATE ];

/// INTVOUCHERNO
Property INTVOUCHERNO As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = jsptodhDatas_INTVOUCHERNO ];

/// STRACCOUNTCODE
Property STRACCOUNTCODE As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = jsptodhDatas_STRACCOUNTCODE ];

/// STRACCOUNTNAME
Property STRACCOUNTNAME As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = jsptodhDatas_STRACCOUNTNAME ];

/// STRDEPARTMENTCODE
Property STRDEPARTMENTCODE As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = jsptodhDatas_STRDEPARTMENTCODE ];

/// STRDEPARTMENTNAME
Property STRDEPARTMENTNAME As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = jsptodhDatas_STRDEPARTMENTNAME ];

/// DBLAMOUNT
Property DBLAMOUNT As %Library.Double [ SqlColumnNumber = 9, SqlFieldName = jsptodhDatas_DBLAMOUNT ];

/// DATASOURCE
Property DATASOURCE As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = jsptodhDatas_DATASOURCE ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCCAJSPTODHDATAS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="jsptodhDatas_DATASOURCE">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="jsptodhDatas_DBLAMOUNT">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="jsptodhDatas_INTVOUCHERNO">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="jsptodhDatas_JSPID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="jsptodhDatas_STRACCOUNTCODE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="jsptodhDatas_STRACCOUNTNAME">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="jsptodhDatas_STRDATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="jsptodhDatas_STRDEPARTMENTCODE">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="jsptodhDatas_STRDEPARTMENTNAME">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCCAJSPTODHDATAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>jsptodhDatas_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{jsptodhDatas_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSTRDATE">
<Global>^DHCCAJSPTODHDATAS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>jsptodhDatas_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STRDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{jsptodhDatas_STRDATE}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{jsptodhDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.cache.jsptodhDatasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
