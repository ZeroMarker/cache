Class User.DHCMedDBDSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MDBDS_Rowid, SqlTableName = DHC_MedDBDSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MDBDSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedDeathBDetail Parent Reference
Relationship MDBDSParRef As User.DHCMedDeathBDetail [ Cardinality = parent, Inverse = ChildDHCMedDBDSub, Required, SqlFieldName = MDBDS_ParRef ];

/// MDBDS_ChildSub
Property MDBDSChildSub As %Library.Float [ InitialExpression = {$i(^DHCMDBD($p(%d(0),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MDBDS_ChildSub ];

/// MDBDS_SetLoc
Property MDBDSSetLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MDBDS_SetLoc ];

/// MDBDS_SetUsr
Property MDBDSSetUsr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MDBDS_SetUsr ];

/// MDBDS_GetLoc
Property MDBDSGetLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MDBDS_GetLoc ];

/// MDBDS_GetUsr
Property MDBDSGetUsr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MDBDS_GetUsr ];

/// MDBDS_Date
Property MDBDSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MDBDS_Date ];

/// MDBDS_Time
Property MDBDSTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MDBDS_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MDBDS_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MDBDS_GetLoc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MDBDS_GetUsr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MDBDS_SetLoc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MDBDS_SetUsr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MDBDS_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMDBD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedDeathBDetail.MDBD_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MDBDS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedDeathBDetail.MDBD_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBDS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateGetLoc">
<Global>^DHCMDBD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_MedDeathBDetail.MDBD_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>MDBDS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SubDateLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MDBDS_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MDBDS_GetLoc}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_MedDeathBDetail.MDBD_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MDBDS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedDBDSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
