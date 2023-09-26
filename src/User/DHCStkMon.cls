Class User.DHCStkMon Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCSM_Rowid, SqlTableName = DHC_StkMon, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCStkMonReport As User.DHCStkMonReport [ Cardinality = children, Inverse = SMRSMParref ];

/// DHCSM_Month
Property DHCSMMonth As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCSM_Month ];

/// DHCSM_CTLOC_DR
Property DHCSMCTLOCDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DHCSM_CTLOC_DR ];

/// DHCSM_FromDate
Property DHCSMFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCSM_FromDate ];

/// DHCSM_ToDate
Property DHCSMToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCSM_ToDate ];

/// DHCSM_CreatedDate
Property DHCSMCreatedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCSM_CreatedDate ];

/// DHCSM_CreatedUser_DR
Property DHCSMCreatedUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DHCSM_CreatedUser_DR ];

/// DHCSM_FromTime
Property DHCSMFromTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = DHCSM_FromTime ];

/// DHCSM_ToTime
Property DHCSMToTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DHCSM_ToTime ];

/// DHCSM_CreateTime
Property DHCSMCreatedTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCSM_CreatedTime ];

/// DHCSM_StkMonNo  - 月报号
Property DHCSMStkMonNo As %Library.String [ SqlColumnNumber = 11, SqlFieldName = DHCSM_StkMonNo ];

/// DHCSM_AcctVoucherCode - 凭证号
Property DHCSMAcctVoucherCode As %Library.String [ SqlColumnNumber = 12, SqlFieldName = DHCSM_AcctVoucherCode ];

/// DHCSM_AcctVoucherDate - 凭证日期
Property DHCSMAcctVoucherDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = DHCSM_AcctVoucherDate ];

/// DHCSM_AcctVoucherStatus  - 凭证处理状态
Property DHCSMAcctVoucherStatus As %Library.String(DISPLAYLIST = ",Done,Sent,Accepted,Passed,Returned", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",D,S,A,P,R") [ SqlColumnNumber = 14, SqlFieldName = DHCSM_AcctVoucherStatus ];

/// DHCSM_PdfFile  - Pdf文件名称
Property DHCSMPdfFile As %Library.String [ SqlColumnNumber = 15, SqlFieldName = DHCSM_PdfFile ];

/// DHCSM_AcctVoucherUser_DR
Property DHCSMAcctVoucherUserDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = DHCSM_AcctVoucherUser_DR ];

/// DHCSM_AcctVoucherCode_Rec - 凭证号(入库)
Property DHCSMAcctVoucherCodeRec As %Library.String [ SqlColumnNumber = 17, SqlFieldName = DHCSM_AcctVoucherCode_Rec ];

/// DHCSM_AcctVoucherDate_Rec - 凭证日期(入库)
Property DHCSMAcctVoucherDateRec As %Library.Date [ SqlColumnNumber = 18, SqlFieldName = DHCSM_AcctVoucherDate_Rec ];

/// DHCSM_AcctVoucherStatus_Rec  - 凭证处理状态(入库)
Property DHCSMAcctVoucherStatusRec As %Library.String(DISPLAYLIST = ",Done,Sent,Accepted,Passed,Returned", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",D,S,A,P,R") [ SqlColumnNumber = 19, SqlFieldName = DHCSM_AcctVoucherStatus_Rec ];

/// DHCSM_PdfFile_Rec  - Pdf文件名称(入库)
Property DHCSMPdfFileRec As %Library.String [ SqlColumnNumber = 20, SqlFieldName = DHCSM_PdfFile_Rec ];

/// DHCSM_AcctVoucherUser_DR_Rec  凭证(入库)
Property DHCSMAcctVoucherUserDRRec As User.SSUser [ SqlColumnNumber = 21, SqlFieldName = DHCSM_AcctVoucherUser_DR_Rec ];

/// DHCSM_Type - 报表类型(日报,月报,季报,年报)
Property DHCSMType As %Library.String(DISPLAYLIST = ",Daily,Monthly,Quarter,Annual", MAXLEN = 7, SELECTIVITY = "20.0000%", VALUELIST = ",D,M,Q,A") [ SqlColumnNumber = 22, SqlFieldName = DHCSM_Type ];

/// DHCSM_AcctVoucherCode_Disp - 凭证号(发药)
Property DHCSMAcctVoucherCodeDisp As %Library.String [ SqlColumnNumber = 23, SqlFieldName = DHCSM_AcctVoucherCode_Disp ];

/// DHCSM_AcctVoucherDate_Disp - 凭证日期(发药)
Property DHCSMAcctVoucherDateDisp As %Library.Date [ SqlColumnNumber = 24, SqlFieldName = DHCSM_AcctVoucherDate_Disp ];

/// DHCSM_AcctVoucherStatus_Disp  - 凭证处理状态(发药)
Property DHCSMAcctVoucherStatusDisp As %Library.String(DISPLAYLIST = ",Done,Sent,Accepted,Passed,Returned", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",D,S,A,P,R") [ SqlColumnNumber = 25, SqlFieldName = DHCSM_AcctVoucherStatus_Disp ];

/// DHCSM_PdfFile_Disp  - Pdf文件名称(发药)
Property DHCSMPdfFileDisp As %Library.String [ SqlColumnNumber = 26, SqlFieldName = DHCSM_PdfFile_Disp ];

/// DHCSM_AcctVoucherUser_DR_Disp  凭证人(发药)
Property DHCSMAcctVoucherUserDRDisp As User.SSUser [ SqlColumnNumber = 27, SqlFieldName = DHCSM_AcctVoucherUser_DR_Disp ];

/// DHCSM_StkType  - 月报类型
Property DHCSMStkType As %Library.String [ SqlColumnNumber = 28, SqlFieldName = DHCSM_StkType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSM)</SqlIdExpression>
<SQLMap name="DataMasterDHCSM">
<Data name="DHCSM_AcctVoucherCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCSM_AcctVoucherCode_Disp">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCSM_AcctVoucherCode_Rec">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCSM_AcctVoucherDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCSM_AcctVoucherDate_Disp">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCSM_AcctVoucherDate_Rec">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCSM_AcctVoucherStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCSM_AcctVoucherStatus_Disp">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHCSM_AcctVoucherStatus_Rec">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCSM_AcctVoucherUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCSM_AcctVoucherUser_DR_Disp">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHCSM_AcctVoucherUser_DR_Rec">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCSM_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCSM_CreatedDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCSM_CreatedTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCSM_CreatedUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCSM_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCSM_FromTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCSM_Month">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCSM_PdfFile">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCSM_PdfFile_Disp">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHCSM_PdfFile_Rec">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCSM_StkMonNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCSM_StkType">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHCSM_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCSM_ToTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCSM_Type">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^DHCSM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCSM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCSM_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCSM_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCSM_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCSM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMonthLoc">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCSM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSM_Month}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCSM_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCSM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStkMonNo">
<Global>^DHCSM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCSM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SMNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSM_StkMonNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCSM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeLoc">
<Global>^DHCSM</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCSM_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSM_StkType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCSM_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCSM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeMonLoc">
<Global>^DHCSM</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCSM_Row</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TML"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCSM_StkType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCSM_Month}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCSM_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCSM_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkMonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSM)
	s oldI = +$g(^mdata("DHCSTKMON"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSM = maxI
	s ^mdata("DHCSTKMON") = maxI
}

}
