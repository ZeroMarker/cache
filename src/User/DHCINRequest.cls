Class User.DHCINRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INRQ_RowId, SqlTableName = DHC_INRequest, StorageStrategy = SQLStorage ]
{

/// INRQ_Type
Property INRQType As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INRQ_Type ];

/// INRQ_PrintFlag
Property INRQPrintFlag As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INRQ_PrintFlag ];

/// INRQ_CollectDate
Property INRQCollectDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = INRQ_CollectDate ];

/// INRQ_CollectTime
Property INRQCollectTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = INRQ_CollectTime ];

/// INRQ_CollectUser_DR
Property INRQCollectUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = INRQ_CollectUser_DR ];

/// INRQ_DispDate
Property INRQDispDate As %Library.Date [ SqlColumnNumber = 7, SqlFieldName = INRQ_DispDate ];

/// INRQ_DispTime
Property INRQDispTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = INRQ_DispTime ];

/// INRQ_DispUser_DR
Property INRQDispUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = INRQ_DispUser_DR ];

/// INRQ_INRQ_DR
Property INRQINRQDR As User.INRequest [ SqlColumnNumber = 10, SqlFieldName = INRQ_INRQ_DR ];

/// INRQ_SCG_DR
Property INRQSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 11, SqlFieldName = INRQ_SCG_DR ];

/// INRQ_AuditUser_Dr
Property INRQAuditUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = INRQ_AuditUser_Dr ];

/// INRQ_AuditDate
Property INRQAuditDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = INRQ_AuditDate ];

/// INRQ_AuditTime
Property INRQAuditTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = INRQ_AuditTime ];

/// INRQ_AuditUser_Prov_Dr
Property INRQAuditUserProvDr As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = INRQ_AuditUser_Prov_Dr ];

/// INRQ_AuditDate_Prov
Property INRQAuditDateProv As %Library.Date [ SqlColumnNumber = 16, SqlFieldName = INRQ_AuditDate_Prov ];

/// INRQ_AuditTime_Prov
Property INRQAuditTimeProv As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = INRQ_AuditTime_Prov ];

/// 建单科室
Property INRQCreateLocDR As User.CTLoc [ SqlColumnNumber = 18, SqlFieldName = INRQ_CreateLoc_DR ];

/// INRQ_Template  - 模板
Property INRQTemplate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = INRQ_Template ];

/// INRQ_AutoSum - 自动汇总标志
Property INRQAutoSum As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = INRQ_AutoSum ];

/// INRQ_PreFlag - 预申领标志
Property INRQPreFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 21, SqlFieldName = INRQ_PreFlag ];

/// INRQ_State 10 – 审核拒绝,50 – 暂时挂起,90 – 审核通过
Property INRQState As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INRQ_State ];

/// INRQ_PrintDate
Property INRQPrintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = INRQ_PrintDate ];

/// INRQ_PrintTime
Property INRQPrintTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = INRQ_PrintTime ];

/// INRQ_RelateReq_DR - 关联请求单(比如拆分出的请求单的原单)
Property INRQRelateReqDR As User.INRequest [ SqlColumnNumber = 25, SqlFieldName = INRQ_RelateReq_DR ];

/// INRQ_ExpressFlag  - 送货标志
Property INRQExpressFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = INRQ_ExpressFlag ];

/// 病案号
Property INRQMrNo As %String [ SqlColumnNumber = 27, SqlFieldName = INRQ_MrNo ];

/// INRQ_SNCCNum - 智能仓储单号
Property INRQSNCCNum As %String [ SqlColumnNumber = 28, SqlFieldName = INRQ_SNCCNum ];

/// INRQ_ANArrDR - 手术安排 DHC_AN_Arrange ID
Property INRQANArrDR As %String [ SqlColumnNumber = 29, SqlFieldName = INRQ_ANArrDR ];

/// INRQ_RefuseReason_Req
Property INRQRefuseReasonReq As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INRQ_RefuseReason_Req ];

/// INRQ_RefuseReason_Prov
Property INRQRefuseReasonProv As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INRQ_RefuseReason_Prov ];

/// INRQ_SplitFlag  - 拆分标识
Property INRQSplitFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = INRQ_SplitFlag ];

/// INRQ_StkType  - 单据类型
Property INRQStkType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 33, SqlFieldName = INRQ_StkType ];

/// INRQ_AddStockFlag  - 依据请求单出库是否需要增加科室库存标志
Property INRQAddStockFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = INRQ_AddStockFlag ];

/// INRQ_StkCat_DR库存分类
Property INRQStkCatDR As User.INCStkCat [ SqlColumnNumber = 35, SqlFieldName = INRQ_StkCat_DR ];

/// INRQ_BasisCondition
Property INRQBasisCondition As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = INRQ_BasisCondition ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINRQ)</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="INRQ_ANArrDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INRQ_AddStockFlag">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INRQ_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INRQ_AuditDate_Prov">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INRQ_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INRQ_AuditTime_Prov">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INRQ_AuditUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INRQ_AuditUser_Prov_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INRQ_AutoSum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INRQ_BasisCondition">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INRQ_CollectDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INRQ_CollectTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INRQ_CollectUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INRQ_CreateLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INRQ_DispDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INRQ_DispTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INRQ_DispUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INRQ_ExpressFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INRQ_INRQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INRQ_MrNo">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INRQ_PreFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INRQ_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INRQ_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INRQ_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INRQ_RefuseReason_Prov">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INRQ_RefuseReason_Req">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INRQ_RelateReq_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INRQ_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INRQ_SNCCNum">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INRQ_SplitFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INRQ_State">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INRQ_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INRQ_StkType">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INRQ_Template">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INRQ_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCINRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INRQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAnArr">
<Global>^DHCINRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AnArr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRQ_ANArrDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINRQ">
<Global>^DHCINRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INRQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRQ_INRQ_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRelateRequest">
<Global>^DHCINRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RLRQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRQ_RelateReq_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSNCCNum">
<Global>^DHCINRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SNCCNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRQ_SNCCNum}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTemplate">
<Global>^DHCINRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LocTem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INRQ_Template}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INRQ_INRQ_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINRQ)
	s oldI = +$g(^mdata("DHCINREQUEST"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINRQ = maxI
	s ^mdata("DHCINREQUEST") = maxI
}

}
