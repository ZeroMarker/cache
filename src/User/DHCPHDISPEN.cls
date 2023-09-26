Class User.DHCPHDISPEN Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHD_ROWID, SqlTableName = DHC_PHDISPEN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHDISITEM As User.DHCPHDISITEM [ Cardinality = children, Inverse = PHDIPHDPARREF ];

/// PHD_ARRCP_DR
Property PHDPRTDR As User.DHCINVPRT [ SqlColumnNumber = 2, SqlFieldName = PHD_PRT_DR ];

/// PHD_PAPMI_DR
Property PHDPAPMIDR As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = PHD_PAPMI_DR ];

/// PHD_PYDATE
Property PHDPYDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHD_PYDATE ];

/// PHD_PYTIME
Property PHDPYTIME As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PHD_PYTIME ];

/// PHD_FYDATE
Property PHDFYDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PHD_FYDATE ];

/// PHD_FYTIME
Property PHDFYTIME As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PHD_FYTIME ];

/// PHD_ARCPDATE
Property PHDPRTDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PHD_PRTDATE ];

/// PHD_PHP_PYDR
Property PHDPHPPYDR As User.DHCPHPERSON [ SqlColumnNumber = 9, SqlFieldName = PHD_PHP_PYDR ];

/// PHD_PHP_FYDR
Property PHDPHPFYDR As User.DHCPHPERSON [ SqlColumnNumber = 10, SqlFieldName = PHD_PHP_FYDR ];

/// PHD_MONTH
Property PHDMONTH As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PHD_MONTH ];

/// PHD_SERIALNO
Property PHDSERIALNO As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PHD_SERIALNO ];

/// PHD_PYFLAG
Property PHDPYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHD_PYFLAG ];

/// PHD_FYFLAG
Property PHDFYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHD_FYFLAG ];

/// PHD_PHL_DR
Property PHDPHLDR As User.DHCPHLOC [ SqlColumnNumber = 15, SqlFieldName = PHD_PHL_DR ];

/// PHD_PHW_DR
Property PHDPHWDR As User.DHCPHWINDOW [ SqlColumnNumber = 16, SqlFieldName = PHD_PHW_DR ];

/// PHD_PRINTFLAG
Property PHDPRINTFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHD_PRINTFLAG ];

/// PHD_CFFLAG
Property PHDCFFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PHD_CFFLAG ];

/// PHD_NOUSE
Property PHDNOUSE As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PHD_NOUSE ];

/// PHD_PHP_CXDR
Property PHDPHPCXDR As User.DHCPHPERSON [ SqlColumnNumber = 20, SqlFieldName = PHD_PHP_CXDR ];

/// PHD_CXDATE
Property PHDCXDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = PHD_CXDATE ];

/// PHD_CXTIME
Property PHDCXTIME As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = PHD_CXTIME ];

/// PHD_RETFLAG
Property PHDRETFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PHD_RETFLAG ];

/// PHD_PHP_PYDR2
Property PHDPHPPYDR2 As User.DHCPHPERSON [ SqlColumnNumber = 24, SqlFieldName = PHD_PHP_PYDR2 ];

/// PHD_MIXFLAG
Property PHDMIXFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PHD_MIXFLAG ];

/// phd_paadm_dr
Property phdpaadmdr As User.PAAdm [ SqlColumnNumber = 26, SqlFieldName = phd_paadm_dr ];

/// phd_patype
Property phdpattype As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = phd_pattype ];

/// PHD_Prescno
Property PHDPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PHD_PrescNo ];

/// PHD_Owe_Dr
Property PHDOWEDR As User.DHCPHOweList [ SqlColumnNumber = 29, SqlFieldName = PHD_OWE_DR ];

/// PHD_PYCKDATE
Property PHDPYCKDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = PHD_PYCKDATE ];

/// PHD_PYCKTIME
Property PHDPYCKTIME As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = PHD_PYCKTIME ];

/// PHD_PYEDDATE
Property PHDPYEDDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = PHD_PYEDDATE ];

/// PHD_PYEDTIME
Property PHDPYEDTIME As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = PHD_PYEDTIME ];

/// PHD_CheckUser_Dr
Property PHDCheckUserDr As User.SSUser [ SqlColumnNumber = 34, SqlFieldName = PHD_CheckUser_Dr ];

/// 打印次数
Property PHDPrintNum As %Library.Integer [ SqlColumnNumber = 35, SqlFieldName = PHD_PrintNum ];

/// PHD_GetMedPerName
Property PHDGetMedPerName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PHD_GetMedPerName ];

/// PHD_GetMedPerCardNo
Property PHDGetMedPerCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = PHD_GetMedPerCardNo ];

/// 发送发药机次数
Property PHDPHSendMedNum As %Library.Integer [ SqlColumnNumber = 38, SqlFieldName = PHD_PHSendMedNum ];

/// 发药数据来源
Property PHDDataSource As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = PHD_DataSource ];

/// 电子标签
Property PHDPIETDr As User.PHAINCETag [ SqlColumnNumber = 40, SqlFieldName = PHD_PIET_Dr ];

/// 贵重药打印标记
Property PHDFineHerbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = PHD_FineHerbFlag ];

/// 配发状态
Property PHDStatus As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = PHD_Status ];

/// 药框编号
Property PHDBASKET As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = PHD_BASKET ];

/// 明细品种数草药味数
Property PHDItmCounts As %Library.Integer [ SqlColumnNumber = 44, SqlFieldName = PHD_ItmCounts ];

/// 可退药标志
Property PHDAgreeRetFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = PHD_AgreeRetFlag ];

/// 可退药操作人
Property PHDAgreeRetUserDr As User.SSUser [ SqlColumnNumber = 46, SqlFieldName = PHD_AgreeRetUser_Dr ];

/// 可退药日期
Property PHDAgreeRetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 47, SqlFieldName = PHD_AgreeRetDate ];

/// 可退药时间
Property PHDAgreeRetTime As %Library.Time [ SqlColumnNumber = 48, SqlFieldName = PHD_AgreeRetTime ];

/// 可退药备注
Property PHDAgreeRetRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = PHD_AgreeRetRemark ];

/// 代煎人
Property PHDDefeatedUser As User.SSUser [ SqlColumnNumber = 50, SqlFieldName = PHD_DefeatedUser ];

/// 发药备注
Property PHDDspRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = PHD_DspRemark ];

/// PHD_CESFlag
Property PHDCESFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = PHD_CESFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHDISP)</SqlIdExpression>
<SQLMap name="IndexETag">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ETag"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHD_PIET_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatFyDate">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PATFYDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHD_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PHD_FYDATE}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatPyDate">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PATPYDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHD_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PHD_PYDATE}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhlPydtFyflag">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PhlPydtFyflag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHD_FYFLAG}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHD_PHL_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHD_PHW_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHD_PYDATE}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PHD_PYTIME}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescno">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHD_PrescNo}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPyEdDate">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PYEDDATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHD_PYEDDATE}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHD_PHL_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPyFine">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PyFine"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHD_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHD_FineHerbFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHD_PYDATE}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHD_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHD_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHD_PYDATE}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHDINDEX">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHD_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHDMASTER">
<Data name="PHD_AgreeRetDate">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>20</Piece>
</Data>
<Data name="PHD_AgreeRetFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>18</Piece>
</Data>
<Data name="PHD_AgreeRetRemark">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>22</Piece>
</Data>
<Data name="PHD_AgreeRetTime">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>21</Piece>
</Data>
<Data name="PHD_AgreeRetUser_Dr">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>19</Piece>
</Data>
<Data name="PHD_BASKET">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>16</Piece>
</Data>
<Data name="PHD_CESFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>25</Piece>
</Data>
<Data name="PHD_CFFLAG">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="PHD_CXDATE">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="PHD_CXTIME">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="PHD_CheckUser_Dr">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="PHD_DataSource">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>12</Piece>
</Data>
<Data name="PHD_DefeatedUser">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>23</Piece>
</Data>
<Data name="PHD_DspRemark">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>24</Piece>
</Data>
<Data name="PHD_FYDATE">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHD_FYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHD_FYTIME">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHD_FineHerbFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>14</Piece>
</Data>
<Data name="PHD_GetMedPerCardNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="PHD_GetMedPerName">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>9</Piece>
</Data>
<Data name="PHD_ItmCounts">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>17</Piece>
</Data>
<Data name="PHD_MIXFLAG">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="PHD_MONTH">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHD_NOUSE">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="PHD_OWE_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="PHD_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHD_PHL_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="PHD_PHP_CXDR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="PHD_PHP_FYDR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="PHD_PHP_PYDR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="PHD_PHP_PYDR2">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="PHD_PHSendMedNum">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>11</Piece>
</Data>
<Data name="PHD_PHW_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="PHD_PIET_Dr">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>13</Piece>
</Data>
<Data name="PHD_PRINTFLAG">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="PHD_PRTDATE">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHD_PRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHD_PYCKDATE">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="PHD_PYCKTIME">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="PHD_PYDATE">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="PHD_PYEDDATE">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="PHD_PYEDTIME">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="PHD_PYFLAG">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="PHD_PYTIME">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="PHD_PrescNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="PHD_PrintNum">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="PHD_RETFLAG">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="PHD_SERIALNO">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="PHD_Status">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>15</Piece>
</Data>
<Data name="phd_paadm_dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="phd_pattype">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Global>^DHCPHDISP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="phdindexdate">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHD_PYDATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHD_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phdindexfydate">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"FYDATE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHD_FYDATE}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHD_PHL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phdindexprt">
<Global>^DHCPHDISPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHD_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PRT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHD_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHD_PRT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHD_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDISPENS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHDISP)
	s oldI = +$g(^mdata("DHCPHDISPEN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHDISP = maxI
	s ^mdata("DHCPHDISPEN") = maxI
}

}
