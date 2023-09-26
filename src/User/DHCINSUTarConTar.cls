Class User.DHCINSUTarConTar Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DITCT_Rowid, SqlTableName = DHC_INSUTarConTar, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DITCT_Tar_Dr
Property DITCTTarDr As User.DHCTarItem [ SqlColumnNumber = 2, SqlFieldName = DITCT_Tar_Dr ];

/// DITCT_TarCode
Property DITCTTarCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DITCT_TarCode ];

/// DITCT_TarCon_Dr
Property DITCTTarConDr As User.DHCTarItem [ SqlColumnNumber = 4, SqlFieldName = DITCT_TarCon_Dr ];

/// DITCT_TarConCode
Property DITCTTarConCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DITCT_TarConCode ];

/// DITCT_TarType
Property DITCTTarType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DITCT_TarType ];

/// DITCT_Zstr1
Property DITCTZstr1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DITCT_Zstr1 ];

/// DITCT_Zstr2
Property DITCTZstr2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DITCT_Zstr2 ];

/// DITCT_Zstr3
Property DITCTZstr3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DITCT_Zstr3 ];

/// DITCT_HospDr
Property DITCTHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DITCT_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCITCT)</SqlIdExpression>
<SQLMap name="DATAMasterMap">
<Data name="DITCT_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DITCT_TarCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DITCT_TarConCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DITCT_TarCon_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DITCT_TarType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DITCT_Tar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DITCT_Zstr1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DITCT_Zstr2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DITCT_Zstr3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCITCT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DITCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DITCT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofTarConDr">
<Global>^DHCITCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DITCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TarConDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DITCT_TarCon_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DITCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTarConDrHosp">
<Global>^DHCITCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DITCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DITCT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TarConDr"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DITCT_TarCon_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DITCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTarDr">
<Global>^DHCITCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DITCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TarDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DITCT_Tar_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DITCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTarDrHosp">
<Global>^DHCITCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DITCT_Rowidr</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DITCT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TarDr"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DITCT_Tar_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DITCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINSUTarConTarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
