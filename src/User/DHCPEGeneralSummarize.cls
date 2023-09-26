Class User.DHCPEGeneralSummarize Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GS_RowId, SqlTableName = DHC_PE_GeneralSummarize, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGeneralSummarize";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEGSDiagnosis As User.DHCPEGSDiagnosis [ Cardinality = children, Inverse = GSDParRef ];

Relationship ChildDHCPEGSResult As User.DHCPEGSResult [ Cardinality = children, Inverse = GSRParRef ];

/// GS_AuditDate
Property GSAuditDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = GS_AuditDate ];

/// GS_AuditTime
Property GSAuditTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = GS_AuditTime ];

/// GS_AuditUser_DR
Property GSAuditUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = GS_AuditUser_DR ];

/// GS_IADM_DR
Property GSIADMDR As User.DHCPEIADM [ SqlColumnNumber = 2, SqlFieldName = GS_IADM_DR ];

/// GS_Summarize
Property GSSummarize As list Of %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GS_Summarize, SqlListDelimiter = "$C(0)", SqlListType = DELIMITED ];

/// GS_UpdateDate
Property GSUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = GS_UpdateDate ];

/// GS_UpdateTime
Property GSUpdateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = GS_UpdateTime ];

/// GS_UpdateUser_DR
Property GSUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = GS_UpdateUser_DR ];

/// GS_PAADM
Property GSPAADM As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = GS_PAADM ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEGS)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEGS">
<Data name="GS_AuditDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="GS_AuditTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="GS_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="GS_IADM_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="GS_PAADM">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="GS_Summarize">
<Delimiter>"^"</Delimiter>
<Node>"S"</Node>
<Piece>1</Piece>
</Data>
<Data name="GS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="GS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="GS_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Global>^DHCPEGS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{GS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDateTime">
<Global>^DHCPEGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GS_RowId</Field>
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
<Expression>{GS_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GS_AuditTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIADM">
<Global>^DHCPEGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GS_RowId</Field>
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
<Expression>{GS_IADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCPEGS</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GS_PAADM}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGeneralSummarizeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
