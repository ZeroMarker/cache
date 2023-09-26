Class User.dhcjfbilladmreasonconfig Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADMCON_Rowid, SqlTableName = dhc_jfbilladmreasonconfig, StorageStrategy = SQLStorage ]
{

/// ADMCON_Code
Property ADMCONCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADMCON_Code ];

/// ADMCON_Desc
Property ADMCONDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADMCON_Desc ];

/// ADMCON_CreatDate
Property ADMCONCreatDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = ADMCON_CreatDate ];

/// ADMCON_CreatTime
Property ADMCONCreatTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = ADMCON_CreatTime ];

/// ADMCON_Val
Property ADMCONVal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ADMCON_Val ];

/// ADMCON_EndDate
Property ADMCONEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ADMCON_EndDate ];

/// ADMCON_Note1
Property ADMCONNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ADMCON_Note1 ];

/// ADMCON_Note2
Property ADMCONNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ADMCON_Note2 ];

/// ADMCON_Note3
Property ADMCONNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ADMCON_Note3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFBILLADMREACON)</SqlIdExpression>
<SQLMap name="Map1">
<Global>^DHCJFBILLADMREACON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ADMCON_Row</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADMCON_Val}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADMCON_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ADMCON_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADMCON_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADMCON_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADMCON_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADMCON_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADMCON_Note1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADMCON_Note2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADMCON_Note3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADMCON_Val">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCJFBILLADMREACON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADMCON_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ADMCON_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.dhcjfbilladmreasonconfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
