Class User.DHCPEStationSummarize Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SS_RowId, SqlTableName = DHC_PE_StationSummarize, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEStationSummarize";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPESSDiagnosis As User.DHCPESSDiagnosis [ Cardinality = children, Inverse = SSDParRef ];

Relationship ChildDHCPESSResult As User.DHCPESSResult [ Cardinality = children, Inverse = SSRParRef ];

/// SS_IADM_DR
Property SSIADMDR As User.DHCPEIADM [ SqlColumnNumber = 2, SqlFieldName = SS_IADM_DR ];

/// SS_ST_DR
Property SSSTDR As User.DHCPEStation [ SqlColumnNumber = 3, SqlFieldName = SS_ST_DR ];

/// SS_Summarize
Property SSSummarize As list Of %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SS_Summarize, SqlListDelimiter = "$C(0)", SqlListType = DELIMITED ];

/// SS_UpdateDate
Property SSUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = SS_UpdateDate ];

/// SS_UpdateUser_DR
Property SSUpdateUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = SS_UpdateUser_DR ];

/// SS_AduitUser_DR
Property SSAduitUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = SS_AduitUser_DR ];

/// SS_AduitDate
Property SSAduitDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = SS_AduitDate ];

/// SS_Status
Property SSStatus As %Library.String(DISPLAYLIST = ",StationAudit,GeneralAudit,NoAudit", MAXLEN = 12, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",SA,GA,NA") [ InitialExpression = "NA", SqlColumnNumber = 9, SqlFieldName = SS_Status ];

/// SS_PAADM
Property SSPAADM As %Library.String [ SqlColumnNumber = 10, SqlFieldName = SS_PAADM ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPESS)</SqlIdExpression>
<SQLMap name="DataMasterDHCPESS">
<Data name="SS_AduitDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="SS_AduitUser_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="SS_IADM_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="SS_PAADM">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="SS_ST_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="SS_Status">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="SS_Summarize">
<Delimiter>"^"</Delimiter>
<Node>"S"</Node>
<Piece>1</Piece>
</Data>
<Data name="SS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="SS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Global>^DHCPESS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCPESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SS_AduitDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuditUser">
<Global>^DHCPESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SS_AduitUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIADM">
<Global>^DHCPESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SS_RowId</Field>
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
<Expression>{SS_IADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SS_ST_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCPESS</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SS_PAADM}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_ST_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEStationSummarizeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
