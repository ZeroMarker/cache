Class User.DHCInIsTrf Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INIT_RowId, SqlTableName = DHC_InIsTrf, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Relationship ChildDHCInIsTrfItm As User.DHCInIsTrfItm [ Cardinality = children, Inverse = INITIINITParRef ];

Relationship ChildDHCInIsTrfINRequestRelations As User.DHCInIsTrfINRequestRelations [ Cardinality = children, Inverse = ITIRISTRParref ];

/// OUT Acknowledge date
Property INITAckDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 2, SqlFieldName = INIT_AckDate ];

/// OUT Acknowledgement Completed
Property INITAcknowCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = INIT_AcknowCompleted ];

/// OUT Acknowledge Time
Property INITAckTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = INIT_AckTime ];

/// OUT Acknowledge by
Property INITAckUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = INIT_AckUser_DR ];

/// Issue/Transfer Date
Property INITDate As %Library.Date(FORMAT = 4) [ InitialExpression = "T", Required, SqlColumnNumber = 6, SqlFieldName = INIT_Date ];

/// Des Ref to CTLOC
Property INITFrLocDR As User.CTLoc [ Required, SqlColumnNumber = 7, SqlFieldName = INIT_FrLoc_DR ];

/// Des Ref to INRQ
Property INITINRQDR As User.INRequest [ SqlColumnNumber = 8, SqlFieldName = INIT_INRQ_DR ];

/// Issue/Transfer Reference No
Property INITNo As %Library.String(COLLATION = "AlphaUp", MAXLEN = 50, SELECTIVITY = 1, TRUNCATE = 0) [ Required, SqlColumnNumber = 9, SqlFieldName = INIT_No ];

/// Remarks
Property INITRemarks As list Of %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INIT_Remarks, SqlListType = SUBNODE ];

/// Des Ref to SSUSR
Property INITSSUSRDR As User.SSUser [ Required, SqlColumnNumber = 11, SqlFieldName = INIT_SSUSR_DR ];

/// Transfer Time
Property INITTime As %Library.Time [ InitialExpression = "N", Required, SqlColumnNumber = 12, SqlFieldName = INIT_Time ];

/// Des Ref to CTLOC
Property INITToLocDR As User.CTLoc [ SqlColumnNumber = 13, SqlFieldName = INIT_ToLoc_DR ];

/// Transaction Type (T-Iss/trf, W- ward Stk)
Property INITType As %Library.String(COLLATION = "AlphaUp", MAXLEN = 1, TRUNCATE = 0) [ InitialExpression = "T", Required, SqlColumnNumber = 14, SqlFieldName = INIT_Type ];

/// INIT_UserCompleted
Property INITUserCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INIT_UserCompleted ];

/// Transfer State
Property INITState As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 16, SqlFieldName = INIT_State ];

/// IN Acknowledge date
Property INITInAckDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 17, SqlFieldName = INIT_InAckDate ];

/// IN Acknowledge Time
Property INITInAckTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INIT_InAckTime ];

/// IN Acknowledge By
Property INITInAckUserDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = INIT_InAckUser_DR ];

/// pointer IN_IsTrf
Property INITIsTrfDR As User.INIsTrf [ SqlColumnNumber = 20, SqlFieldName = INIT_IsTrf_DR ];

/// INIT_OperationRemark
Property INITOperationRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INIT_OperationRemark ];

/// INIT_OperateType
Property INITOperateType As User.DHCOperateType [ SqlColumnNumber = 22, SqlFieldName = INIT_OperateType ];

/// INIT_INGR_Dr
Property INITINGRDr As User.DHCINGdRec [ SqlColumnNumber = 23, SqlFieldName = INIT_INGR_Dr ];

/// INIT_SCG_DR
Property INITPrintFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = INIT_PrintFlag ];

/// INIT_SCG_DR
Property INITSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 25, SqlFieldName = INIT_SCG_DR ];

/// INIT_StkType
Property INITStkType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 26, SqlFieldName = INIT_StkType ];

/// 送到哪个科室
Property INITReqLocDR As User.CTLoc [ SqlColumnNumber = 27, SqlFieldName = INIT_ReqLoc_DR ];

/// INIT_Red  - 红冲标志
Property INITRed As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = INIT_Red ];

/// INIT_INIT_Red - 被红冲的库存转移单
Property INITINITRed As User.DHCInIsTrf [ SqlColumnNumber = 29, SqlFieldName = INIT_INIT_Red ];

/// INIT_ReqUser_DR - 请领人
Property INITReqUserDR As User.SSUser [ SqlColumnNumber = 30, SqlFieldName = INIT_ReqUser_DR ];

/// INIT_ExpressFlag  - 送货标志
Property INITExpressFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = INIT_ExpressFlag ];

/// INIT_SSUSR_Treasurer_DR - 会计审核人 
Property INITSSUSRTreasurerDR As User.SSUser [ SqlColumnNumber = 32, SqlFieldName = INIT_SSUSR_Treasurer_DR ];

/// INIT_TreasureDate - 会计审核日期 
Property INITTreasureDate As %Library.Date [ SqlColumnNumber = 33, SqlFieldName = INIT_TreasureDate ];

/// INIT_TreasureTime - 会计审核时间 
Property INITTreasureTime As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = INIT_TreasureTime ];

/// INIT_AuditNoDate - 拒绝接收日期
Property INITRefuseDate As %Library.Date [ SqlColumnNumber = 35, SqlFieldName = INIT_RefuseDate ];

/// INIT_AuditNoTime - 拒绝接收时间 
Property INITRefuseTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = INIT_RefuseTime ];

/// INIT_AuditNoUser_DR  拒绝接收人
Property INITRefuseUserDR As User.SSUser [ SqlColumnNumber = 37, SqlFieldName = INIT_RefuseUser_DR ];

/// INIT_AgainINIT_DR - 指向作废重转之后新产生的转移单
Property INITAgainINITDR As User.DHCInIsTrf [ SqlColumnNumber = 38, SqlFieldName = INIT_AgainINIT_DR ];

/// 接收核对人
Property INITInAckCheckUserDR As User.SSUser [ SqlColumnNumber = 39, SqlFieldName = INIT_InAckCheckUser_DR ];

/// INIT_StkCat_DR库存分类
Property INITStkCatDR As User.INCStkCat [ SqlColumnNumber = 40, SqlFieldName = INIT_StkCat_DR ];

Index INITNoUnqIdx1 On INITNo;

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SqlIdExpression>$i(^DHCINIT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INIT_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INIT_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INIT_AckUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INIT_AcknowCompleted">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INIT_AgainINIT_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INIT_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INIT_ExpressFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INIT_FrLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INIT_INGR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INIT_INIT_Red">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INIT_INRQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INIT_InAckCheckUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INIT_InAckDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INIT_InAckTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INIT_InAckUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INIT_IsTrf_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INIT_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INIT_OperateType">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INIT_OperationRemark">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INIT_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INIT_Red">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INIT_RefuseDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INIT_RefuseTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INIT_RefuseUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INIT_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INIT_ReqLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INIT_ReqUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INIT_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INIT_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INIT_SSUSR_Treasurer_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INIT_State">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INIT_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INIT_StkType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INIT_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INIT_ToLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INIT_TreasureDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INIT_TreasureTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INIT_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INIT_UserCompleted">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCINIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INIT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAgianINTI">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AgainINIT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIT_AgainINIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateIsTrfDR">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateTrfDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INIT_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_IsTrf_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGR">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INGR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIT_INGR_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITAckDate">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AckDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INIT_AckDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITDate">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TrfDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INIT_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITFrLoc">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FrLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INIT_FrLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITInAckDate">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InAckDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INIT_InAckDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITNO">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INIT_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTo">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocTo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIT_ToLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIT_FrLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequest">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIT_INRQ_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInIsTrfS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINIT)
	s oldI = +$g(^mdata("DHCINISTRF"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINIT = maxI
	s ^mdata("DHCINISTRF") = maxI
}

}
