Class User.INSUTarItemDetails Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INTIMD_Rowid, SqlTableName = INSU_TarItemDetails, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INTIMD_INTIMDr
Property INTIMDINTIMDr As User.INSUTarItems [ SqlColumnNumber = 2, SqlFieldName = INTIMD_INTIMDr ];

/// INTIMD_DicType
Property INTIMDDicType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INTIMD_DicType ];

/// INTIMD_DisCode
Property INTIMDDisCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INTIMD_DisCode ];

/// INTIMD_DisDesc
Property INTIMDDisDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INTIMD_DisDesc ];

/// INTIMD_DicCode
Property INTIMDDicCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INTIMD_DicCode ];

/// INTIMD_DicDesc
Property INTIMDDicDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INTIMD_DicDesc ];

/// INTIMD_XString1
Property INTIMDXString1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INTIMD_XString1 ];

/// INTIMD_XString2
Property INTIMDXString2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INTIMD_XString2 ];

/// INTIMD_XString3
Property INTIMDXString3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INTIMD_XString3 ];

/// INTIMD_XString4
Property INTIMDXString4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INTIMD_XString4 ];

/// INTIMD_XString5
Property INTIMDXString5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INTIMD_XString5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINTIMD)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INTIMD_DicCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INTIMD_DicDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INTIMD_DicType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTIMD_DisCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INTIMD_DisDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INTIMD_INTIMDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INTIMD_XString1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INTIMD_XString2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INTIMD_XString3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INTIMD_XString4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INTIMD_XString5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCINTIMD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INTIMD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INTIMD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofINTIMDrTypeCode">
<Global>^DHCINTIMD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTIMD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INTIMD_INTIMDr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTIMD_DicType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTIMD_DisCode}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTIMD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUTarItemDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
