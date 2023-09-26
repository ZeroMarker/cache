Class User.DHCLisReLocArcim Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LRA_Rowid, SqlTableName = DHC_LisReLocArcim, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LRA_CTLOC_Dr
Property LRACTLOCDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = LRA_CTLOC_Dr ];

/// LRA_ARCIM_Dr
Property LRAARCIMDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = LRA_ARCIM_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLRA)</SqlIdExpression>
<SQLMap name="IndexByCTLOC">
<Global>^DHCLRAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LRA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{LRA_CTLOC_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LRA_ARCIM_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{LRA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataMap">
<Data name="LRA_ARCIM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LRA_CTLOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LRA_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLRA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LRA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LRA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLisReLocArcimS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
