/// Local Tariff BaseInfo
Class User.DHCTaritemBaseUpdInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UBI_RowId, SqlTableName = DHC_TaritemBaseUpdInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCTaritemBaseUpdDetail As User.DHCTaritemBaseUpdDetail [ Cardinality = children, Inverse = UBDUBIParRef ];

/// DHC_TarItem Parent Reference
Property UBITariDr As User.DHCTarItem [ Required, SqlColumnNumber = 2, SqlFieldName = UBI_Tari_Dr ];

/// UBI_AvailDate	生效日期
Property UBIAvailDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = UBI_AvailDate ];

/// UBI_AvailTime	生效时间
Property UBIAvailTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = UBI_AvailTime ];

/// UBI_ExpirationDate	失效日期
Property UBIExpirationDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = UBI_ExpirationDate ];

/// UBI_ExpirationTime	失效时间
Property UBIExpirationTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = UBI_ExpirationTime ];

/// UBI_UpdDate		修改日期
Property UBIUpdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = UBI_UpdDate ];

/// UBI_UpdTime		修改时间
Property UBIUpdTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = UBI_UpdTime ];

/// UBI_UpdUser		修改人
Property UBIUpdUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = UBI_UpdUser ];

/// UBI_Hospital_Dr
Property UBIHospitalDr As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UBI_Hospital_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTARIUBI)</SqlIdExpression>
<SQLMap name="TariIndex">
<Global>^DHCTARIUBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UBI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TARI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{UBI_Tari_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{UBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="UBIMaster">
<Data name="UBI_AvailDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UBI_AvailTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UBI_ExpirationDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UBI_ExpirationTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UBI_Hospital_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UBI_Tari_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UBI_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UBI_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UBI_UpdUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCTARIUBI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{UBI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCTaritemBaseUpdInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
