Class User.DHCPEGGeneralSummarize Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GGS_RowId, SqlTableName = DHC_PE_GGeneralSummarize, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGGeneralSummarize";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEGGSDiagnosis As User.DHCPEGGSDiagnosis [ Cardinality = children, Inverse = GGSDParRef ];

/// GGS_GADM_DR
Property GGSGADMDR As User.DHCPEGADM [ SqlColumnNumber = 2, SqlFieldName = GGS_GADM_DR ];

/// GGS_Summarize
Property GGSSummarize As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GGS_Summarize ];

/// GGS_UpdateDate
Property GGSUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = GGS_UpdateDate ];

/// GGS_UpdateUser_DR
Property GGSUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = GGS_UpdateUser_DR ];

/// GGS_UpdateTime
Property GGSUpdateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = GGS_UpdateTime ];

/// GGS_AuditUser_DR
Property GGSAuditUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = GGS_AuditUser_DR ];

/// GGS_AuditDate
Property GGSAuditDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = GGS_AuditDate ];

/// GGS_AuditTime
Property GGSAuditTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = GGS_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEGGS)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEGGS">
<Data name="GGS_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GGS_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GGS_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GGS_GADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GGS_Summarize">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GGS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GGS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GGS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPEGGS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GGS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{GGS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDateTime">
<Global>^DHCPEGGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GGS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditDateTime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GGS_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GGS_AuditTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GGS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuditUser">
<Global>^DHCPEGGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GGS_RowId</Field>
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
<Expression>{GGS_AuditUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GGS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGADM">
<Global>^DHCPEGGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GGS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GGS_GADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GGS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGGeneralSummarizeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
