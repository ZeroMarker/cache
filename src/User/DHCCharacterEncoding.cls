/// GB18030汉字编码表
/// ZhanMingchao 2011-06-08
Class User.DHCCharacterEncoding Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_CharacterEncoding, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ASCIICODE
Property ASCIICODE As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// ChineseCharacter
Property HANZI As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// PinyinSP
Property PINYINSP As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Sijiao
Property SIJIAO As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Wubi
Property WUBI As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// Quwei
Property QUWEI As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// PINYIN
Property PINYIN As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// BIHUASHU
Property BIHUASHU As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// ZHENGMA
Property ZHENGMA As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCharacterEncoding)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="ASCIICODE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BIHUASHU">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HANZI">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PINYIN">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PINYINSP">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QUWEI">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SIJIAO">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WUBI">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ZHENGMA">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCCharacterEncoding</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofAscii">
<Global>^DHCCharacterEncoding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ASCII"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ASCIICODE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofHanzi">
<Global>^DHCCharacterEncoding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"HANZI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{HANZI}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPinyin">
<Global>^DHCCharacterEncoding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PINYIN"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PINYIN}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofQuwei">
<Global>^DHCCharacterEncoding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"QUWEI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{QUWEI}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSijiao">
<Global>^DHCCharacterEncoding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SIJIAO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SIJIAO}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofWubi">
<Global>^DHCCharacterEncoding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"WUBI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WUBI}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCharacterEncodingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
