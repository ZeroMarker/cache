Class dhc.pa.data.PaEmailDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PaEmailDetail_Rowid, SqlTableName = PaEmailDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PaEmailDetail_FromUserDr
Property PaEmailDetailFromUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PaEmailDetail_FromUserDr ];

/// PaEmailDetail_FromEmail
Property PaEmailDetailFromEmail As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PaEmailDetail_FromEmail ];

/// PaEmailDetail_ToUserDr
Property PaEmailDetailToUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PaEmailDetail_ToUserDr ];

/// PaEmailDetail_ToEmail
Property PaEmailDetailToEmail As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PaEmailDetail_ToEmail ];

/// PaEmailDetail_Title
Property PaEmailDetailTitle As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PaEmailDetail_Title ];

/// PaEmailDetail_EmailType
Property PaEmailDetailEmailType As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PaEmailDetail_EmailType ];

/// PaEmailDetail_IsWithFile
Property PaEmailDetailIsWithFile As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PaEmailDetail_IsWithFile ];

/// PaEmailDetail_FileName
Property PaEmailDetailFileName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PaEmailDetail_FileName ];

/// PaEmailDetail_FileContent
Property PaEmailDetailFileContent As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PaEmailDetail_FileContent ];

/// PaEmailDetail_Date
Property PaEmailDetailDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PaEmailDetail_Date ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAPAEMAILDETAIL(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="PaEmailDetail_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PaEmailDetail_EmailType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PaEmailDetail_FileContent">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PaEmailDetail_FileName">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PaEmailDetail_FromEmail">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PaEmailDetail_FromUserDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PaEmailDetail_IsWithFile">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PaEmailDetail_Title">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PaEmailDetail_ToEmail">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PaEmailDetail_ToUserDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPAPAEMAILDETAIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PaEmailDetail_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PaEmailDetail_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.PaEmailDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
