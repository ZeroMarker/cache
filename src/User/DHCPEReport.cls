Class User.DHCPEReport Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RPT_RowId, SqlTableName = DHC_PE_Report, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEReport";

Parameter EXTENTSIZE = 250;

Index RPTIADMDRUnqIdx1 On RPTIADMDR [ Unique ];

Relationship ChildDHCPEReportPrintRecords As User.DHCPEReportPrintRecords [ Cardinality = children, Inverse = RPRParRef ];

/// RPT_AduitDate
Property RPTAduitDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = RPT_AduitDate ];

/// RPT_AduitTime
Property RPTAduitTime As %Library.Time(FORMAT = 4) [ SqlColumnNumber = 14, SqlFieldName = RPT_AduitTime ];

/// RPT_AduitUser_DR
Property RPTAduitUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = RPT_AduitUser_DR ];

/// RPT_GADM_DR
Property RPTGADMDR As User.DHCPEGADM [ SqlColumnNumber = 11, SqlFieldName = RPT_GADM_DR ];

//Property RPTIADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RPT_IADM_DR ];

/// RPT_ADM_DR
Property RPTIADMDR As User.DHCPEIADM [ SqlColumnNumber = 2, SqlFieldName = RPT_IADM_DR ];

/// RPT_PrintDate
Property RPTPrintDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = RPT_PrintDate ];

/// RPT_PrintTime
Property RPTPrintTime As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 15, SqlFieldName = RPT_PrintTime ];

/// RPT_PrintFormat
Property RPTPrintFormat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RPT_PrintFormat ];

/// RPT_PrintUser_DR
Property RPTPrintUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = RPT_PrintUser_DR ];

/// RPT_SendDate
Property RPTSendDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 10, SqlFieldName = RPT_SendDate ];

/// RPT_SendTime
Property RPTSendTime As %Library.Time(FORMAT = 4) [ SqlColumnNumber = 17, SqlFieldName = RPT_SendTime ];

/// RPT_SendUser_DR
Property RPTSendUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = RPT_SendUser_DR ];

/// RPT_CompleteDate
Property RPTCompleteDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 13, SqlFieldName = RPT_CompleteDate ];

/// RPT_CompleteTime
Property RPTCompleteTime As %Library.Time(FORMAT = 4) [ SqlColumnNumber = 16, SqlFieldName = RPT_CompleteTime ];

/// RPT_CompleteUser_DR
Property RPTCompleteUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = RPT_CompleteUser_DR ];

/// RPT_Status
Property RPTStatus As %Library.String(DISPLAYLIST = ",NoAudit,Audited,Printed,Send,Complete", MAXLEN = 8, SELECTIVITY = "16.66667%", TRUNCATE = 1, VALUELIST = ",NA,A,P,S,C") [ SqlColumnNumber = 3, SqlFieldName = RPT_Status ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPERPT)</SqlIdExpression>
<SQLMap name="CompleteDateIndex">
<Global>^DHCPERPT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CompleteDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RPT_CompleteDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RPT_CompleteTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMasterDHCPERPT">
<Data name="RPT_AduitDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RPT_AduitTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RPT_AduitUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RPT_CompleteDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RPT_CompleteTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RPT_CompleteUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RPT_GADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RPT_IADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RPT_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RPT_PrintFormat">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RPT_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RPT_PrintUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RPT_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RPT_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RPT_SendUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RPT_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPERPT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RPT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RPT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGADM">
<Global>^DHCPERPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RPT_RowId</Field>
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
<Expression>{RPT_GADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIADM">
<Global>^DHCPERPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RPT_RowId</Field>
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
<Expression>{RPT_IADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrintDate">
<Global>^DHCPERPT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrintDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RPT_PrintDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RPT_PrintTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrintUser">
<Global>^DHCPERPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrintUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RPT_PrintUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="SendDateIndex">
<Global>^DHCPERPT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SendDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RPT_SendDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RPT_SendTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
