Class User.DHCPEResult Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RLT_RowId, SqlTableName = DHC_PE_Result, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEResult";

Parameter EXTENTSIZE = 250;

/// RLT_ADM_DR User.PAAdm
Property RLTADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RLT_ADM_DR ];

/// RLT_ARCIM_DR
Property RLTARCIMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RLT_ARCIM_DR ];

/// RLT_Advice
Property RLTAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RLT_Advice ];

/// RLT_Normal
Property RLTNormal As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 8, SqlFieldName = RLT_Normal ];

/// RLT_OD_DR
Property RLTODDR As User.DHCPEOrderDetail [ SqlColumnNumber = 4, SqlFieldName = RLT_OD_DR ];

/// RLT_OEORI_DR
Property RLTOEORIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = RLT_OEORI_DR ];

/// RLT_Result
Property RLTResult As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RLT_Result ];

/// RLT_TemplateDesc
Property RLTTemplateDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = RLT_TemplateDesc ];

/// RLT_UpdateDate
Property RLTUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = RLT_UpdateDate ];

/// RLT_UpdateTime
Property RLTUpdateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = RLT_UpdateTime ];

/// RLT_User_DR
Property RLTUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RLT_User_DR ];

/// RLT_HighRiskFlag
Property RLTHighRiskFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = RLT_HighRiskFlag ];

/// RLT_FollowUpFlag  随访标记  协和
Property RLTFollowUpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = RLT_FollowUpFlag ];

/// RLT_ShowSort  随访标记  协和
Property RLTShowSort As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = RLT_ShowSort ];

/// RLT_RecordUser_DR
Property RLTRecordUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = RLT_RecordUser_DR ];

/// 【新增】RLT_ResultUser_DR 替换 RLT_User_DR
Property RLTResultUserDR As User.DHCPESSUser [ SqlColumnNumber = 18, SqlFieldName = RLT_ResultUser_DR ];

/// 【新增】RLT_ReportUser_DR 报告人
Property RLTReportUserDR As User.DHCPESSUser [ SqlColumnNumber = 19, SqlFieldName = RLT_ReportUser_DR ];

/// 【新增】RLT_AuditUser_DR 审核人
Property RLTAuditUserDR As User.DHCPESSUser [ SqlColumnNumber = 20, SqlFieldName = RLT_AuditUser_DR ];

/// 【新增】RLT_ReportDate 报告日期
Property RLTReportDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = RLT_ReportDate ];

/// 【新增】RLT_ReportTime 报告时间
Property RLTReportTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = RLT_ReportTime ];

/// 【新增】RLT_AuditDate 审核日期
Property RLTAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = RLT_AuditDate ];

/// 【新增】RLT_AuditTime 审核时间
Property RLTAuditTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = RLT_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPERLT)</SqlIdExpression>
<SQLMap name="DataMasterDHCPERLT">
<Data name="RLT_ADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RLT_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RLT_Advice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RLT_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RLT_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RLT_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RLT_FollowUpFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RLT_HighRiskFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RLT_Normal">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RLT_OD_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RLT_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RLT_RecordUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RLT_ReportDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RLT_ReportTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RLT_ReportUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RLT_Result">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RLT_ResultUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RLT_ShowSort">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RLT_TemplateDesc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RLT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RLT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RLT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPERLT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RLT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfDateUser">
<Global>^DHCPERLT</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateUserNew"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RLT_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLT_ResultUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RLT_OEORI_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexADMOD">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADMOD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RLT_ADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RLT_OEORI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RLT_OD_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RLT_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateADM">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RLT_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLT_ADM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateOrder">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RLT_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLT_OEORI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateUser">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RLT_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLT_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RLT_OEORI_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHighRiskAdm">
<Global>^DHCPERLT</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HighRiskFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RLT_HighRiskFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RLT_ADM_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHighRiskDate">
<Global>^DHCPERLT</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HighRiskFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RLT_HighRiskFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLT_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RLT_ADM_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RLT_RowId</Field>
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
<Expression>{RLT_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdSort">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdSort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RLT_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLT_ShowSort}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RLT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RLT_ADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADMOD">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RLT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM_OD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RLT_ADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RLT_OD_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCPERLT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RLT_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
