Class User.INSUDistrict Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDST_Rowid, SqlTableName = INSU_District, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INDST_DistrictCode
Property INDSTDistrictCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INDST_DistrictCode ];

/// INDST_DistrictDesc
Property INDSTDistrictDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INDST_DistrictDesc ];

/// INDST_IDate
Property INDSTIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = INDST_IDate ];

/// INDST_ITime
Property INDSTITime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = INDST_ITime ];

/// INDST_IUser
Property INDSTIUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INDST_IUser ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDST)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INDST_DistrictCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDST_DistrictDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDST_IDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDST_ITime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDST_IUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINDST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDST_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INDST_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofDistrictCode">
<Global>^DHCINDST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDST_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INDST_DistrictCode}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDST_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDistrictDesc">
<Global>^DHCINDST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDST_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INDST_DistrictDesc}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDST_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDistrictS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
