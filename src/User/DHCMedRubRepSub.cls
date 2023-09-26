Class User.DHCMedRubRepSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MRPS_Rowid, SqlTableName = DHC_MedRubRepSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On MRPSChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_MedRubRep Parent Reference
Relationship MRPSParRef As User.DHCMedRubRep [ Cardinality = parent, Inverse = ChildDHCMedRubRepSub, Required, SqlFieldName = MRPS_ParRef ];

/// MRPS_ChildSub
Property MRPSChildSub As %Library.Float [ InitialExpression = {$i(^DHCMRB($p(%d(0),$c(1),1),"S",0))}, SqlColumnNumber = 2, SqlFieldName = MRPS_ChildSub ];

/// MRPS_Status
Property MRPSStatus As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MRPS_Status ];

/// dMRPS_Loc
Property MRPSAcceptUser As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = MRPS_AcceptUser ];

/// MRPS_User
Property MRPSUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = MRPS_User ];

/// MRPS_Date
Property MRPSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MRPS_Date ];

/// MRPS_Time
Property MRPSTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MRPS_Time ];

/// MRPS_Active
Property MRPSActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MRPS_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="MRPS_AcceptUser">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRPS_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRPS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRPS_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRPS_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRPS_User">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMRB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedRubRep.MRP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRPS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedRubRep.MRP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRPS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActiveDate">
<Global>^DHCMRB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_MedRubRep.MRP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>MRPS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ActiveDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRPS_Active}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRPS_Status}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRPS_Date}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHC_MedRubRep.MRP_RowID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{MRPS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCMRB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedRubRep.MRP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRPS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_MedRubRep.MRP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRPS_Active}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRPS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedRubRepSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
