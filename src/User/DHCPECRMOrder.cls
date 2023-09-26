Class User.DHCPECRMOrder Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CRMO_RowId, SqlTableName = DHC_PE_CRMOrder, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPECRMOrder";

Parameter EXTENTSIZE = 250;

/// CRMO_ARPBL_DR
Property CRMOARPBLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CRMO_ARPBL_DR ];

/// CRMO_AddOrdItem
Property CRMOAddOrdItem As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CRMO_AddOrdItem ];

/// CRMO_BillStatus
Property CRMOBillStatus As %Library.String(DISPLAYLIST = ",NoPaid,OnCredit,Paid,PartPaid", MAXLEN = 8, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",NP,OC,P,PP") [ SqlColumnNumber = 5, SqlFieldName = CRMO_BillStatus ];

/// CRMO_CRMORI
Property CRMOCRMORI As %Library.String(COLLATION = "Exact", MAXLEN = 12, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CRMO_CRMORI ];

/// CRMO_FactAmount
Property CRMOFactAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 8, SqlFieldName = CRMO_FactAmount ];

/// CRMO_IADM_DR
Property CRMOIADMDR As User.DHCPEIADM [ SqlColumnNumber = 4, SqlFieldName = CRMO_IADM_DR ];

/// CRMO_OEORI_DR
Property CRMOOEORIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CRMO_OEORI_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPECRMO)</SqlIdExpression>
<SQLMap name="DataMasterDHCPECRMO">
<Data name="CRMO_ARPBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CRMO_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CRMO_BillStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CRMO_CRMORI">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CRMO_FactAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CRMO_IADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CRMO_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPECRMO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CRMO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CRMO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARPBL">
<Global>^DHCPECRMO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CRMO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARPBL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CRMO_ARPBL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CRMO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCRMORI">
<Global>^DHCPECRMO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CRMO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CRMORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CRMO_CRMORI}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CRMO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIADM">
<Global>^DHCPECRMO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CRMO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CRMO_IADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CRMO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCPECRMO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CRMO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CRMO_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CRMO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPECRMOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
