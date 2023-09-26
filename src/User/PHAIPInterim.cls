Class User.PHAIPInterim Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PII_RowID, SqlTableName = PHAIP_Interim, StorageStrategy = SQLStorage ]
{

Relationship ChildPHAIPInterimItm As User.PHAIPInterimItm [ Cardinality = children, Inverse = PIIIPIIParRef ];

Property PIIPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PII_PrescNo ];

Property PIIPrescType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PII_PrescType ];

Property PIIStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = PII_Status ];

Property PIIStartPyFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = PII_StartPyFlag ];

Property PIIPriorFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = PII_PriorFlag ];

Property PIIDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = PII_Date ];

Property PIITime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PII_Time ];

Property PIICommonUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PII_CommonUser_DR ];

Property PIIValuableUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PII_ValuableUser_DR ];

Property PIIPrintFlag As %String(DISPLAYLIST = ",Yes,No,Print", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N,P") [ InitialExpression = "N", SqlColumnNumber = 11, SqlFieldName = PII_PrintFlag ];

Property PIIPriceFlag As %String(DISPLAYLIST = ",Yes,No,Print", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N,P") [ InitialExpression = "N", SqlColumnNumber = 12, SqlFieldName = PII_PriceFlag ];

Property PIIOutFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 13, SqlFieldName = PII_OutFlag ];

Property PIIPhaDR As User.DHCPHACollected [ SqlColumnNumber = 14, SqlFieldName = PII_Pha_DR ];

Property PIIPhaLocDR As User.CTLoc [ SqlColumnNumber = 15, SqlFieldName = PII_PhaLoc_DR ];

Property PIICancelFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 16, SqlFieldName = PII_CancelFlag ];

Property PIIAdmLocDR As User.CTLoc [ SqlColumnNumber = 17, SqlFieldName = PII_AdmLoc_DR ];

Property PIIAdmDR As User.PAAdm [ SqlColumnNumber = 18, SqlFieldName = PII_Adm_DR ];

Property PIIBed As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 19, SqlFieldName = PII_Bed ];

Property PIIPrintDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = PII_PrintDate ];

Property PIIPrintTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = PII_PrintTime ];

Property PIIEmergencyFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 22, SqlFieldName = PII_EmergencyFlag ];

Property PIIAllowFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 23, SqlFieldName = PII_AllowFlag ];

Property PIICheckUserDR As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = PII_CheckUser_DR ];

Property PIICheckDate As %Library.Date [ SqlColumnNumber = 25, SqlFieldName = PII_CheckDate ];

Property PIICheckTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = PII_CheckTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.PHA.IP.Interim)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PII_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PII_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PII_AllowFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PII_Bed">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PII_CancelFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PII_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PII_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PII_CheckUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PII_CommonUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PII_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PII_EmergencyFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PII_OutFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PII_PhaLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PII_Pha_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PII_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PII_PrescType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PII_PriceFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PII_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PII_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PII_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PII_PriorFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PII_StartPyFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PII_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PII_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PII_ValuableUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^BS.PHA.IP.Interim</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PII_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCommonUser">
<Global>^BS.PHA.IP.Interim</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CommonUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PII_CommonUser_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PII_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PII_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^BS.PHA.IP.Interim</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PII_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PII_PhaLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^BS.PHA.IP.Interim</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PII_PrescNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPyFine">
<Global>^BS.PHA.IP.Interim</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PyFine"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PII_PhaLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PII_PriceFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PII_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPyPrint">
<Global>^BS.PHA.IP.Interim</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PyPrint"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PII_PhaLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PII_PrintFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PII_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStart">
<Global>^BS.PHA.IP.Interim</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"START"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PII_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PII_PhaLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PII_StartPyFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexValuableUser">
<Global>^BS.PHA.IP.Interim</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ValuableUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PII_ValuableUser_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PII_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PII_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PII_RowID</SqlRowIdName>
<StreamLocation>^User.PHAIPInterimS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^BS.PHA.IP.Interim)
	s oldI = +$g(^mdata("^BS.PHA.IP.Interim"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^BS.PHA.IP.Interim = maxI
	s ^mdata("^BS.PHA.IP.Interim") = maxI
}

}
