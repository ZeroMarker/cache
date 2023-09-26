Class User.DHCDocTextDicData Extends %Persistent [ SqlTableName = DHCDoc_TextDicData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

/// TEXTDIC_Code
Property TEXTDICCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TEXTDIC_Code ];

/// TEXTDIC_Desc
Property TEXTDICDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TEXTDIC_Desc ];

/// TEXTDIC_Type
Property TEXTDICType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TEXTDIC_Type ];

/// TEXTDIC_Active
Property TEXTDICActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = TEXTDIC_Active ];

/// TEXTDIC_DateFrom
Property TEXTDICDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = TEXTDIC_DateFrom ];

/// TEXTDIC_DateTo
Property TEXTDICDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = TEXTDIC_DateTo ];

/// 对照代码
Property TEXTDICStrCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TEXTDIC_StrCode ];

/// 是否外部到His对照
Property TEXTDICHisFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = TEXTDIC_HisFlag ];

/// 外部机构代码
Property TEXTDICExtOrgDr As User.DHCDocCTExtDataExtOrg [ SqlColumnNumber = 10, SqlFieldName = TEXTDIC_ExtOrg_Dr ];

/// 对照描述
Property TEXTDICStrDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TEXTDIC_StrDesc ];

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SqlIdExpression>$i(^DHCDocTEXTDIC(0))</SqlIdExpression>
<SQLMap name="DataMastermap">
<Data name="TEXTDIC_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TEXTDIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TEXTDIC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TEXTDIC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TEXTDIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TEXTDIC_ExtOrg_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TEXTDIC_HisFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TEXTDIC_StrCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TEXTDIC_StrDesc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TEXTDIC_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocTEXTDIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TEXTDIC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{TEXTDIC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="TypeCodeIndex">
<Global>^DHCDocTEXTDIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>TEXTDIC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EOTC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TEXTDIC_ExtOrg_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TEXTDIC_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TEXTDIC_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TEXTDIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="TypeIndex">
<Global>^DHCDocTEXTDIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TEXTDIC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TEXTDIC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TEXTDIC_Active}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TEXTDIC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TEXTDIC_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCDocTextDicDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
