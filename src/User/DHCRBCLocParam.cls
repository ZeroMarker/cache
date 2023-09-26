Class User.DHCRBCLocParam Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLP_RowID, SqlTableName = DHCRBC_LocParam, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DLP_BRSystemSDate
Property DLPBRSystemSDate As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DLP_BRSystemSDate ];

/// DLP_BRSystemEDate
Property DLPBRSystemEDate As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DLP_BRSystemEDate ];

/// DLP_PrintAutoVerify
Property DLPPrintAutoVerify As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DLP_PrintAutoVerify ];

/// DLP_PrintAutoIssue
Property DLPPrintAutoIssue As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DLP_PrintAutoIssue ];

/// DLP_VerifyAutoIssue
Property DLPVerifyAutoIssue As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DLP_VerifyAutoIssue ];

/// DLP_VerifyNeedsPWD
Property DLPVerifyNeedsPWD As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DLP_VerifyNeedsPWD ];

/// DLP_Loc_DR
Property DLPLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = DLP_Loc_DR ];

/// DLP_Server_DR
Property DLPServerDR As User.DHCRBCServer [ SqlColumnNumber = 9, SqlFieldName = DLP_Server_DR ];

/// DLP_AutoDowndload
Property DLPAutoDowndload As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DLP_AutoDowndload ];

/// DLP_PrintBookedTemplate
Property DLPPrintBookedTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DLP_PrintBookedTemplate ];

/// DLP_PrintRegTemplate
Property DLPPrintRegTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DLP_PrintRegTemplate ];

/// DLP_PrintRegListTemplate
Property DLPPrintRegListTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DLP_PrintRegListTemplate ];

/// DLP_SendDate
Property DLPSendDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DLP_SendDate ];

/// DLP_ChargeSign
Property DLPChargeSign As %Library.String(COLLATION = "Exact", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DLP_ChargeSign ];

/// DLP_ModifyInDays
Property DLPModifyInDays As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DLP_ModifyInDays ];

/// DLP_WarningAfterHours
Property DLPWarningAfterHours As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DLP_WarningAfterHours ];

/// DLP_WarningAfterInput
Property DLPWarningAfterInput As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DLP_WarningAfterInput ];

/// DLP_AutoSendInHours
Property DLPAutoSendInHours As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DLP_AutoSendInHours ];

/// DLP_WarningAfterHoursE
Property DLPWarningAfterHoursE As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DLP_WarningAfterHoursE ];

/// DLP_WarningAfterInputE
Property DLPWarningAfterInputE As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DLP_WarningAfterInputE ];

/// DLP_SendToRIS4
Property DLPSendToRIS4 As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DLP_SendToRIS4 ];

/// DLP_StudyInfoToRIS4
Property DLPStudyInfoToRIS4 As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DLP_StudyInfoToRIS4 ];

/// DLP_BookUseType
Property DLPBookUseType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DLP_BookUseType ];

/// DLP_UseAutoBooked
Property DLPUseAutoBooked As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DLP_UseAutoBooked ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("LocParam"))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DLP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLP_Loc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DLP_AutoDowndload">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DLP_AutoSendInHours">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DLP_BRSystemEDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DLP_BRSystemSDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLP_BookUseType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DLP_ChargeSign">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DLP_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLP_ModifyInDays">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DLP_PrintAutoIssue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLP_PrintAutoVerify">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLP_PrintBookedTemplate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DLP_PrintRegListTemplate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DLP_PrintRegTemplate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DLP_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DLP_SendToRIS4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DLP_Server_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DLP_StudyInfoToRIS4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DLP_UseAutoBooked">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DLP_VerifyAutoIssue">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DLP_VerifyNeedsPWD">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DLP_WarningAfterHours">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DLP_WarningAfterHoursE">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DLP_WarningAfterInput">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DLP_WarningAfterInputE">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DLP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocParam"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCLocParamS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
