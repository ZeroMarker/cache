Class User.DHCPEGADM Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GADM_RowId, SqlTableName = DHC_PE_GADM, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGADM";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEGTeam As User.DHCPEGTeam [ Cardinality = children, Inverse = GTParRef ];

/// GADM_AddOrdItem
Property GADMAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = GADM_AddOrdItem ];

/// GADM_AddOrdItemAmount
Property GADMAddOrdItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 11, SqlFieldName = GADM_AddOrdItemAmount ];

/// GADM_AddOrdItemLimit
Property GADMAddOrdItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = GADM_AddOrdItemLimit ];

/// GADM_AddPhcItem
Property GADMAddPhcItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = GADM_AddPhcItem ];

/// GADM_AddPhcItemAmount
Property GADMAddPhcItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 14, SqlFieldName = GADM_AddPhcItemAmount ];

/// GADM_AddPhcItemLimit
Property GADMAddPhcItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = GADM_AddPhcItemLimit ];

/// GADM_AdmDate
Property GADMAdmDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = GADM_AdmDate ];

/// GADM_AdmTime
Property GADMAdmTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = GADM_AdmTime ];

/// GADM_AsCharged
Property GADMAsCharged As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = GADM_AsCharged ];

/// GADM_CRMGADM
Property GADMCRMGADM As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GADM_CRMGADM ];

/// GADM_DelegateADM_DR
Property GADMDelegateADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = GADM_DelegateADM_DR ];

/// GADM_DisChargedMode
Property GADMDisChargedMode As %Library.String(DISPLAYLIST = ",GDischarged,IDischarged", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",GD,ID") [ SqlColumnNumber = 17, SqlFieldName = GADM_DisChargedMode ];

/// GADM_GBI_DR
Property GADMGBIDR As User.DHCPEGBaseInfo [ SqlColumnNumber = 2, SqlFieldName = GADM_GBI_DR ];

/// GADM_GReportSend
Property GADMGReportSend As %Library.String(DISPLAYLIST = ",AsCharged,Discharged", MAXLEN = 10, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",AC,DC") [ SqlColumnNumber = 15, SqlFieldName = GADM_GReportSend ];

/// GADM_IReportSend
Property GADMIReportSend As %Library.String(DISPLAYLIST = ",GSend,ISend", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",GS,IS") [ SqlColumnNumber = 16, SqlFieldName = GADM_IReportSend ];

/// GADM_Remark
Property GADMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = GADM_Remark ];

/// GADM_Status
Property GADMStatus As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = GADM_Status ];

/// GADM_UpdateDate
Property GADMUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 20, SqlFieldName = GADM_UpdateDate ];

/// GADM_UpdateTime
Property GADMUpdateTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = GADM_UpdateTime ];

/// GADM_UpdateUser_DR
Property GADMUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = GADM_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEGADM)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEGADM">
<Data name="GADM_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GADM_AddOrdItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GADM_AddOrdItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GADM_AddPhcItem">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GADM_AddPhcItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GADM_AddPhcItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GADM_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GADM_AdmTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GADM_AsCharged">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GADM_CRMGADM">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GADM_DelegateADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GADM_DisChargedMode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="GADM_GBI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GADM_GReportSend">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="GADM_IReportSend">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="GADM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="GADM_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GADM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="GADM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="GADM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCPEGADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{GADM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDateTime">
<Global>^DHCPEGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>GADM_RowId</Field>
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
<Expression>{GADM_AdmDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GADM_AdmTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCRMGADM">
<Global>^DHCPEGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CRMGADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GADM_CRMGADM}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDelegateADM">
<Global>^DHCPEGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DelegateADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GADM_DelegateADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGBI">
<Global>^DHCPEGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GBI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GADM_GBI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPEGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GADM_RowId</Field>
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
<Expression>{GADM_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{GADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGADMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
