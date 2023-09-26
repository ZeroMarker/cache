Class User.DHCMRDiagnosMaster Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MASTERRowid, SqlTableName = DHC_MRDiagnosMaster, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCDIADESC
Property DHCDIADESC As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// DHCDIAINDEX
Property DHCDIAINDEX As %Library.Float [ SqlColumnNumber = 5 ];

/// DHCDIALOC
Property DHCDIALOC As User.CTLoc [ SqlColumnNumber = 3 ];

/// DHCDIAUSER
Property DHCDIAUSER As User.SSUser [ SqlColumnNumber = 4 ];

/// DHCDIAHospDr
Property DHCDIAHospDr As User.CTHospital [ SqlColumnNumber = 6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDIAMAS)</SqlIdExpression>
<SQLMap name="DHCDIALOCINDEX">
<Global>^DHCDIAMAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MASTERRowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCDIALOC}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCDIAINDEX}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MASTERRowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCDIAUSERINDEX">
<Global>^DHCDIAMAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MASTERRowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCDIAUSER}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCDIAHospDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCDIAINDEX}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MASTERRowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DHCMRDiagnosMasterDATA">
<Data name="DHCDIADESC">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCDIAHospDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCDIAINDEX">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCDIALOC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCDIAUSER">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MASTERRowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDIAMAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MASTERRowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MASTERRowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMRDiagnosMasterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
