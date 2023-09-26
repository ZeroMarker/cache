Class User.PIVAOrdGrp Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POG_RowId, SqlTableName = PIVA_OrdGrp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildPIVAOrdGrpItm As User.PIVAOrdGrpItm [ Cardinality = children, Inverse = POGIPOGParref ];

Relationship ChildPIVAOrdGrpState As User.PIVAOrdGrpState [ Cardinality = children, Inverse = POGSPOGParref ];

Relationship ChildPIVAOrdGrpOrder As User.PIVAOrdGrpOrder [ Cardinality = children, Inverse = POGOPOGParref ];

/// 打包表Id
Property POGOEORIDr As User.DHCOEDispensing [ SqlColumnNumber = 2, SqlFieldName = POG_OEORI_Dr ];

/// 对应打包表seqNo
Property POGGrpNo As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = POG_GrpNo ];

/// 批次名称
Property POGBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = POG_BatNo ];

/// 用药日期
Property POGOrdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = POG_OrdDate ];

/// 用药时间
Property POGOrdTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = POG_OrdTime ];

/// 配液流程状态
Property POGPSDr As User.PIVAState [ SqlColumnNumber = 7, SqlFieldName = POG_PS_Dr ];

/// 配液中心
Property POGCtlocDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = POG_Ctloc_Dr ];

/// 特殊状态
Property POGOper As %Library.String(DISPLAYLIST = ",Normal,Cancel,Refuse", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,C,R") [ SqlColumnNumber = 9, SqlFieldName = POG_Oper ];

/// 配液拒绝原因
Property POGPORDr As User.PIVAOperReason [ SqlColumnNumber = 10, SqlFieldName = POG_POR_Dr ];

/// 发药表Id
Property POGPHACDr As User.DHCPHACollected [ SqlColumnNumber = 11, SqlFieldName = POG_PHAC_Dr ];

/// 标签顺序
Property POGPNo As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = POG_PNo ];

/// 打印停止签人
Property POGCUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = POG_CUser_Dr ];

/// 停止签日期
Property POGCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = POG_CDate ];

/// 停止签时间
Property POGCTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = POG_CTime ];

/// 停止签记录
Property POGPCPDr As User.PIVACPrint [ SqlColumnNumber = 16, SqlFieldName = POG_PCP_Dr ];

/// 停止签单号
Property POGCPNo As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = POG_CPNo ];

/// 停止签打印状态
Property POGCPrintFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = POG_CPrintFlag ];

/// 门诊配液申请Id
Property POGReqDr As User.PIVADispRequest [ SqlColumnNumber = 19, SqlFieldName = POG_Req_Dr ];

/// 条码号
Property POGBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = POG_Barcode ];

/// POG_RetFlag
Property POGRetFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = POG_RetFlag ];

/// 配液拒绝复核人员
Property POGChkCUserDr As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = POG_ChkCUser_Dr ];

/// 配液拒绝复核日期
Property POGChkCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = POG_ChkCDate ];

/// 配液拒绝复核时间
Property POGChkCTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = POG_ChkCTime ];

/// 备注
Property POGRemarks As list Of %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = POG_Remarks, SqlListType = SUBNODE ];

/// 配置间
Property POGWorkType As User.PIVAWorkType [ SqlColumnNumber = 26, SqlFieldName = POG_WorkType ];

/// 排药核对人
Property POGUser30Dr As User.SSUser [ SqlColumnNumber = 27, SqlFieldName = POG_User30_Dr ];

/// 贴签核对人
Property POGUser40Dr As User.SSUser [ SqlColumnNumber = 28, SqlFieldName = POG_User40_Dr ];

/// 核对核对人
Property POGUser50Dr As User.SSUser [ SqlColumnNumber = 29, SqlFieldName = POG_User50_Dr ];

/// 允许退药标志
Property POGAllowFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = POG_AllowFlag ];

/// 允许退药标志处理人
Property POGAllowUserDr As User.SSUser [ SqlColumnNumber = 31, SqlFieldName = POG_AllowUser_Dr ];

/// 调配人
Property POGUser60Dr As User.SSUser [ SqlColumnNumber = 32, SqlFieldName = POG_User60_Dr ];

/// 成品核对人
Property POGUser70Dr As User.SSUser [ SqlColumnNumber = 33, SqlFieldName = POG_User70_Dr ];

/// 患者输液顺序
Property POGInfusionOrd As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = POG_InfusionOrd ];

/// 是否已经给第三方贴签机发送
Property POGSendLabelFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = POG_SendLabelFlag ];

/// 打签时的床号
Property POGBedNo As %Library.String [ SqlColumnNumber = 36, SqlFieldName = POG_BedNo ];

/// 按日期累加的顺序号
Property POGDateNo As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = POG_DateNo ];

/// 配液流程日期
Property POGPSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 38, SqlFieldName = POG_PSDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVA)</SqlIdExpression>
<SQLMap name="DataMasterPOG">
<Data name="POG_AllowFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="POG_AllowUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="POG_Barcode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="POG_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POG_BedNo">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="POG_CDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="POG_CPNo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="POG_CPrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="POG_CTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="POG_CUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="POG_ChkCDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="POG_ChkCTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="POG_ChkCUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="POG_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="POG_DateNo">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="POG_GrpNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POG_InfusionOrd">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="POG_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POG_Oper">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="POG_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="POG_OrdTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="POG_PCP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="POG_PHAC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="POG_PNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="POG_POR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="POG_PSDate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="POG_PS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="POG_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="POG_Req_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="POG_RetFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="POG_SendLabelFlag">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="POG_User30_Dr">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="POG_User40_Dr">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="POG_User50_Dr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="POG_User60_Dr">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="POG_User70_Dr">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="POG_WorkType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^PIVA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarcode">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BARCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_Barcode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocBat">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCBAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_OrdDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POG_BatNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocOper">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCOPER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_OrdDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POG_Oper}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocOperReason">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_OrdDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POG_POR_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocOrdDate">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCORDDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_OrdDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocPSDate">
<Global>^PIVA</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATEPS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_PSDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POG_PS_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocState">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCSTATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_OrdDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POG_PS_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeGrp">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_GrpNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPCP">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PCP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_PCP_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHAC">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHAC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_PHAC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHACBAT">
<Global>^PIVA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>POG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHACBAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POG_PHAC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POG_BatNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{POG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrdGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PIVA)
	s oldI = +$g(^mdata("PIVAORDGRP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PIVA = maxI
	s ^mdata("PIVAORDGRP") = maxI
}

}
