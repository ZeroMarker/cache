Class User.DHCPEIADM Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IADM_RowId, SqlTableName = DHC_PE_IADM, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEIADM";

Parameter EXTENTSIZE = 250;

/// IADM_AddOrdItem
Property IADMAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = IADM_AddOrdItem ];

/// IADM_AddOrdItemAmount
Property IADMAddOrdItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 12, SqlFieldName = IADM_AddOrdItemAmount ];

/// IADM_AddOrdItemLimit
Property IADMAddOrdItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = IADM_AddOrdItemLimit ];

/// IADM_AddPhcItem
Property IADMAddPhcItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = IADM_AddPhcItem ];

/// IADM_AddPhcItemAmount
Property IADMAddPhcItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 15, SqlFieldName = IADM_AddPhcItemAmount ];

/// IADM_AddPhcItemLimit
Property IADMAddPhcItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = IADM_AddPhcItemLimit ];

/// IADM_AdmDate
Property IADMAdmDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = IADM_AdmDate ];

/// IADM_AdmTime
Property IADMAdmTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = IADM_AdmTime ];

/// IADM_AsCharged
Property IADMAsCharged As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = IADM_AsCharged ];

/// IADM_CRMADM
Property IADMCRMADM As User.DHCPEPreIADM [ SqlColumnNumber = 5, SqlFieldName = IADM_CRMADM ];

/// IADM_Diet
Property IADMDiet As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = IADM_Diet ];

/// IADM_DisChargedMode
Property IADMDisChargedMode As %Library.String(DISPLAYLIST = ",GDischarged,IDischarged", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",GD,ID") [ SqlColumnNumber = 17, SqlFieldName = IADM_DisChargedMode ];

/// IADM_GADM_DR
Property IADMGADMDR As User.DHCPEGADM [ SqlColumnNumber = 3, SqlFieldName = IADM_GADM_DR ];

/// IADM_GTeam_DR
Property IADMGTeamDR As User.DHCPEGTeam [ SqlColumnNumber = 4, SqlFieldName = IADM_GTeam_DR ];

/// IADM_IReportSend
Property IADMIReportSend As %Library.String(DISPLAYLIST = ",AsCharged,Discharged,GSend,ISend", MAXLEN = 10, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",AC,DC,GS,IS") [ SqlColumnNumber = 16, SqlFieldName = IADM_IReportSend ];

/// IADM_PAADM_DR
Property IADMPAADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = IADM_PAADM_DR ];

/// IADM_Remark
Property IADMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IADM_Remark ];

/// IADM_Status
Property IADMStatus As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IADM_Status ];

/// IADM_UpdateDate
Property IADMUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 21, SqlFieldName = IADM_UpdateDate ];

/// IADM_UpdateTime
Property IADMUpdateTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = IADM_UpdateTime ];

/// IADM_UpdateUser_DR
Property IADMUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = IADM_UpdateUser_DR ];

/// 【新加】体检科室（到达科室） 指向CT_Loc
Property IADMAdmLocDR As %String [ SqlColumnNumber = 23, SqlFieldName = IADM_AdmLocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEIADM)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEIADM">
<Data name="IADM_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IADM_AddOrdItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IADM_AddOrdItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IADM_AddPhcItem">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IADM_AddPhcItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IADM_AddPhcItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IADM_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IADM_AdmLocDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IADM_AdmTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IADM_AsCharged">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IADM_CRMADM">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IADM_Diet">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IADM_DisChargedMode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IADM_GADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IADM_GTeam_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IADM_IReportSend">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IADM_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IADM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IADM_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IADM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IADM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IADM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCPEIADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IADM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDateTime">
<Global>^DHCPEIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AdmDateTime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IADM_AdmDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IADM_AdmTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCRMADM">
<Global>^DHCPEIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CRMADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IADM_CRMADM}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGADMTeam">
<Global>^DHCPEIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IADM_RowId</Field>
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
<Expression>{IADM_GADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IADM_GTeam_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCPEIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IADM_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPEIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IADM_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEIADMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
