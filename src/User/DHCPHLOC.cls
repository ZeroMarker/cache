Class User.DHCPHLOC Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHL_ROWID, SqlTableName = DHC_PHLOC, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHL_CTLOC_DR
Property PHLCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PHL_CTLOC_DR ];

/// PHL_PYFLAG
Property PHLPYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHL_PYFLAG ];

/// PHL_FYFLAG
Property PHLFYFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHL_FYFLAG ];

/// PHL_ARITHMET
Property PHLARITHMET As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHL_ARITHMET ];

/// PHL_TJFLAG
Property PHLTJFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHL_TJFLAG ];

/// PHL_MIXFLAG
Property PHLMIXFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHL_MIXFLAG ];

/// PHL_AuditFlag
Property PHLAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PHL_AuditFlag ];

/// PHL_OthLocRetflag
Property PHLOthLocRetflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PHL_OthLocRetflag ];

/// PHL_AutoAuditFlag
Property PHLAutoAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PHL_AutoAuditFlag ];

/// PHL_ReportFlag
Property PHLReportFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PHL_ReportFlag ];

/// PHL_SendMsgFlag
Property PHLSendMsgFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PHL_SendMsgFlag ];

/// PHL_SendFlag 发送数据标志
Property PHLSendFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHL_SendFlag ];

/// PHL_PrintFlag  分配打印机标志
Property PHLPrintFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHL_PrintFlag ];

/// PHL_WinTypeFlag  窗口分类标志
Property PHLWinTypeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHL_WinTypeFlag ];

/// PHL_DispMachine  发药机标志
Property PHLDispMachine As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PHL_DispMachine ];

/// PHL_Screen  屏幕显示标志
Property PHLScreenFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHL_ScreenFlag ];

/// PHL_ScreenPath  显示路径
Property PHLScreenPath As %Library.String [ SqlColumnNumber = 18, SqlFieldName = PHL_ScreenPath ];

/// PHL_PySureFlag  配药确认标志
Property PHLPySureFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PHL_PySureFlag ];

/// PHL_AutoPYFlag 自动打印配药单标志
Property PHLAutoPYFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PHL_AutoPYFlag ];

/// PHL_QueuePosition 
Property PHLQueuePosition As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PHL_QueuePosition ];

/// *********
/// 自动处方审核等待时间
Property PHLWaitAuditTime As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PHL_WaitAuditTime ];

/// 发药界面 叫号亮灯
Property PHLCallAsLightUp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = PHL_CallAsLightUp ];

/// 发药界面 发药灭灯
Property PHLDispAsLightDown As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = PHL_DispAsLightDown ];

/// 发药界面 查询亮灯/刷就诊卡亮灯
Property PHLQueryAsLightUp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = PHL_QueryAsLightUp ];

/// 发药叫号功能
Property PHLDispAsCall As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = PHL_DispAsCall ];

/// 叫号上屏
Property PHLCallAsUpScreen As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = PHL_CallAsUpScreen ];

/// 发药下屏
Property PHLDispAsDownScreen As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = PHL_DispAsDownScreen ];

/// 何时上屏
Property PHLUpScreenFlag As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PHL_UpScreenFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHLOC)</SqlIdExpression>
<SQLMap name="PHLINDEX">
<Global>^DHCPHLOCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHL_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHLOCMASTER">
<Data name="PHL_ARITHMET">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHL_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHL_AutoAuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHL_AutoPYFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHL_CallAsLightUp">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHL_CallAsUpScreen">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PHL_DispAsCall">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PHL_DispAsDownScreen">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PHL_DispAsLightDown">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHL_DispMachine">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHL_FYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHL_MIXFLAG">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHL_OthLocRetflag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHL_PYFLAG">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHL_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHL_PySureFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHL_QueryAsLightUp">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHL_QueuePosition">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHL_ReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHL_ScreenFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHL_ScreenPath">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHL_SendFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHL_SendMsgFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHL_TJFLAG">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHL_UpScreenFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PHL_WaitAuditTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHL_WinTypeFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCPHLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHL_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHL_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLOCS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHLOC)
	s oldI = +$g(^mdata("DHCPHLOC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHLOC = maxI
	s ^mdata("DHCPHLOC") = maxI
}

}
