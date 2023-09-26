Class User.DHCEQCHanZiEncoding Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = HZE_RowID, SqlTableName = DHC_EQCHanZiEncoding, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// HZE_ASCII
Property HZEASCII As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = HZE_ASCII ];

/// HZE_BiHuaShu
Property HZEBiHuaShu As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = HZE_BiHuaShu ];

/// HZE_HanZi
Property HZEHanZi As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = HZE_HanZi ];

/// HZE_InvalidFlag
Property HZEInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = HZE_InvalidFlag ];

/// HZE_PinYin
Property HZEPinYin As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = HZE_PinYin ];

/// HZE_PinYinNew
Property HZEPinYinNew As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = HZE_PinYinNew ];

/// HZE_PinYinZT
Property HZEPinYinZT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = HZE_PinYinZT ];

/// HZE_SiJiao
Property HZESiJiao As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = HZE_SiJiao ];

/// HZE_WuPi
Property HZEWuPi As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = HZE_WuPi ];

/// HZE_ZhengMa
Property HZEZhengMa As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = HZE_ZhengMa ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCHanZiEncoding",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HZE_ASCII">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HZE_BiHuaShu">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HZE_HanZi">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HZE_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HZE_PinYin">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HZE_PinYinNew">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HZE_PinYinZT">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HZE_SiJiao">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HZE_WuPi">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HZE_ZhengMa">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HZE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCHanZiEncoding"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{HZE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHanZi">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HZE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCHanZiEncoding"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"HanZi"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{HZE_HanZi}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{HZE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCHanZiEncodingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
