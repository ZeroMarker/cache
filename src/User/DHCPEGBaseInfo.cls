Class User.DHCPEGBaseInfo Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GBI_RowId, SqlTableName = DHC_PE_GBaseInfo, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGBaseInfo";

Parameter EXTENTSIZE = 250;

Index GBIDescUnqIdx1 On GBIDesc [ Unique ];

/// GBI_Account
Property GBIAccount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = GBI_Account ];

/// GBI_Address
Property GBIAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GBI_Address ];

/// GBI_Bank
Property GBIBank As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = GBI_Bank ];

/// GBI_CRMNo
Property GBICRMNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = GBI_CRMNo ];

/// GBI_Code
Property GBICode As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GBI_Code ];

/// GBI_Desc
Property GBIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GBI_Desc ];

/// GBI_Email
Property GBIEmail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GBI_Email ];

/// GBI_FAX
Property GBIFAX As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = GBI_FAX ];

/// GBI_Linkman1
Property GBILinkman1 As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = GBI_Linkman1 ];

/// GBI_Linkman2
Property GBILinkman2 As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = GBI_Linkman2 ];

/// GBI_PAPMI_DR
Property GBIPAPMIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = GBI_PAPMI_DR ];

/// GBI_PostalCode
Property GBIPostalCode As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GBI_PostalCode ];

/// GBI_Principal
Property GBIPrincipal As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = GBI_Principal ];

/// GBI_Rebate
Property GBIRebate As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 15, SqlFieldName = GBI_Rebate ];

/// GBI_Tel1
Property GBITel1 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = GBI_Tel1 ];

/// GBI_Tel2
Property GBITel2 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = GBI_Tel2 ];

/// GBI_UpdateDate
Property GBIUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 16, SqlFieldName = GBI_UpdateDate ];

/// GBI_UpdateTime
Property GBIUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = GBI_UpdateTime ];

/// GBI_UpdateUser_DR
Property GBIUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = GBI_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEGBI)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEGBI">
<Data name="GBI_Account">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GBI_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GBI_Bank">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GBI_CRMNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="GBI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GBI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GBI_Email">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="GBI_FAX">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GBI_Linkman1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GBI_Linkman2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GBI_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="GBI_PostalCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GBI_Principal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GBI_Rebate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GBI_Tel1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GBI_Tel2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GBI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="GBI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="GBI_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCPEGBI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{GBI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCRMNo">
<Global>^DHCPEGBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CRMNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GBI_CRMNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPEGBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({GBI_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPEGBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({GBI_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDr">
<Global>^DHCPEGBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMIDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GBI_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGBaseInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
