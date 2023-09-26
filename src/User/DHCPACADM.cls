Class User.DHCPACADM Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAC_RowId, SqlTableName = DHC_PACADM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PAC_SocialStatus_dr
Property PACSocialStatusDr As User.CTSocialStatus [ SqlColumnNumber = 2, SqlFieldName = PAC_SocialStatus_Dr ];

/// PAC_AdmReason_Dr
Property PACAdmReasonDr As User.PACAdmReason [ SqlColumnNumber = 3, SqlFieldName = PAC_AdmReason_Dr ];

/// PAC_StartDate
Property PACStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PAC_StartDate ];

/// PAC_EndDate
Property PACEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PAC_EndDate ];

/// PAC_Hosp_Dr
Property PACHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = PAC_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACADM)</SqlIdExpression>
<SQLMap name="IndexAdmReason">
<Global>^DHCPACADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmReason"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSocial">
<Global>^DHCPACADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Social"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_SocialStatus_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCPACADM">
<Data name="PAC_AdmReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAC_SocialStatus_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPACADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PAC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPACADMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
