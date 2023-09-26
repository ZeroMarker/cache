/// DHC IN Stock Take Header
Class User.DHCInStkTk Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_InStkTk, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCInStkTkGrp As DHCInStkTkGrp [ Cardinality = children, Inverse = TGINSTParRef ];

Relationship ChildDHCInStkTkItm As DHCInStkTkItm [ Cardinality = children, Inverse = INSTIINSTParref ];

Relationship ChildDHCInStkTkInput As DHCInStkTkInput [ Cardinality = children, Inverse = DHCSTIParref ];

/// INST_No
Property INSTNo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INST_No ];

/// INST_Date
Property INSTDate As %Date [ InitialExpression = "T", Required, SqlColumnNumber = 3, SqlFieldName = INST_Date ];

/// INST_SSUSR_DR
Property INSTSSUSRDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, Required, SqlColumnNumber = 4, SqlFieldName = INST_SSUSR_DR ];

/// INST_CTLOC_DR
Property INSTCTLOCDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = INST_CTLOC_DR ];

/// INST_FrGroup_DR
Property INSTFrGroupDR As DHCLocManGrp [ SqlColumnNumber = 6, SqlFieldName = INST_FrGroup_DR ];

/// INST_ToGroup_DR
Property INSTToGroupDR As DHCLocManGrp [ SqlColumnNumber = 7, SqlFieldName = INST_ToGroup_DR ];

/// INST_FrCode_DR
Property INSTFrCodeDR As INCItm [ SqlColumnNumber = 8, SqlFieldName = INST_FrCode_DR ];

/// INST_ToCode_DR
Property INSTToCodeDR As INCItm [ SqlColumnNumber = 9, SqlFieldName = INST_ToCode_DR ];

/// INST_Status
Property INSTStatus As %String(DISPLAYLIST = ",Freeze Stock,Check Comp,Data Entered,Variance Computed,Adjustment Done", MAXLEN = 17, VALUELIST = ",F,C,E,V,A") [ InitialExpression = "F", SqlColumnNumber = 10, SqlFieldName = INST_Status ];

/// INST_DoubleST
Property INSTDoubleST As %String(DISPLAYLIST = ",Single,Double", MAXLEN = 6, VALUELIST = ",S,D") [ InitialExpression = "S", SqlColumnNumber = 11, SqlFieldName = INST_DoubleST ];

/// INST_Time
Property INSTTime As %Time [ InitialExpression = "N", Required, SqlColumnNumber = 12, SqlFieldName = INST_Time ];

/// INST_Remarks
Property INSTRemarks As list Of %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INST_Remarks, SqlListType = SUBNODE ];

/// INST_Completed
Property INSTCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = INST_Completed ];

/// INST_StockTakeComplete
Property INSTStockTakeComplete As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INST_StockTakeComplete ];

/// INST_AdjustmentComplete
Property INSTAdjustmentComplete As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INST_AdjustmentComplete ];

/// INST_INAD_DR
Property INSTINADDR As DHCINAdj [ SqlColumnNumber = 17, SqlFieldName = INST_INAD_DR ];

/// INST_ManaFlag
Property INSTManaFlag As %String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INST_ManaFlag ];

/// INST_FreezeUom
Property INSTFreezeUom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INST_FreezeUom ];

/// INST_IncludeNotUse
Property INSTIncludeNotUse As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = INST_IncludeNotUse ];

/// INST_OnlyNotUse
Property INSTOnlyNotUse As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = INST_OnlyNotUse ];

/// INST_SCG_DR
Property INSTSCGDR As DHCStkCatGroup [ SqlColumnNumber = 22, SqlFieldName = INST_SCG_DR ];

/// INST_INCSC_DR
Property INSTINCSCDR As INCStkCat [ SqlColumnNumber = 23, SqlFieldName = INST_INCSC_DR ];

/// INST_FrStkBin
Property INSTFrStkBin As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INST_FrStkBin ];

/// INST_ToStkBin
Property INSTToStkBin As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INST_ToStkBin ];

/// INST_HighValueFlag - 0:All, 1:HighValue, 2:Not HighValue
Property INSTHighValueFlag As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INST_HighValueFlag ];

/// INST_PrintFlag
Property INSTPrintFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = INST_PrintFlag ];

/// INST_MinRp
Property INSTMinRp As %Float [ SqlColumnNumber = 28, SqlFieldName = INST_MinRp ];

/// INST_MaxRp
Property INSTMaxRp As %Float [ SqlColumnNumber = 29, SqlFieldName = INST_MaxRp ];

/// INST_RandomNum
Property INSTRandomNum As %Float [ SqlColumnNumber = 30, SqlFieldName = INST_RandomNum ];

/// 第三方HRP系统接口
Property INSTHRPID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INST_HRPID ];

/// 供应商
Property INSTAPCVMDR As User.APCVendor [ SqlColumnNumber = 32, SqlFieldName = INST_APCVM_DR ];

/// INST_InputType
Property INSTInputType As %Float [ SqlColumnNumber = 33, SqlFieldName = INST_InputType ];

/// 盘点的库存日期  InitialExpression = "T", 
Property INSTStockDate As %Date [ SqlColumnNumber = 34, SqlFieldName = INST_StockDate ];

/// 管制分类
Property INSTPhcPoison As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INST_PhcPoison ];

/// 单据类型(G:药品,M:耗材)
Property INSTStkType As %String [ SqlColumnNumber = 36, SqlFieldName = INST_StkType ];

/// 收费标志
Property INSTChargeFlag As %String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INST_ChargeFlag ];

/// 批次数量标志 ""=全部;Y-非零批次;N-零批次
Property INSTInclbQtyFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = INST_InclbQtyFlag ];

/// INST_AdjDate
Property INSTAdjDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = INST_AdjDate ];

/// INST_AdjTime
Property INSTAdjTime As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = INST_AdjTime ];

/// INST_QConditionJson
Property INSTQConditionJson As %String [ SqlColumnNumber = 41, SqlFieldName = INST_QConditionJson ];

Index INSTNoUnqIdx1 On INSTNo;

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINST)</SqlIdExpression>
<SQLMap name="DataMasterINST">
<Data name="INST_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INST_AdjDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INST_AdjTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INST_AdjustmentComplete">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INST_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INST_ChargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INST_Completed">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INST_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INST_DoubleST">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INST_FrCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INST_FrGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INST_FrStkBin">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INST_FreezeUom">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INST_HRPID">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INST_HighValueFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INST_INAD_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INST_INCSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INST_InclbQtyFlag">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INST_IncludeNotUse">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INST_InputType">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INST_ManaFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INST_MaxRp">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INST_MinRp">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INST_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INST_OnlyNotUse">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INST_PhcPoison">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INST_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INST_QConditionJson">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INST_RandomNum">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INST_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INST_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INST_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INST_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INST_StkType">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INST_StockDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INST_StockTakeComplete">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INST_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INST_ToCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INST_ToGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INST_ToStkBin">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCINST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINSTDate">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INST_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINSTManaFlag">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MANAFLAG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INST_ManaFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINSTNo">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INST_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INST_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INST_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocManaFlag">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCMANA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INST_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INST_ManaFlag}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"USERDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INST_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INST_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INST_RowId</SqlRowIdName>
<StreamLocation>^User.DHCInStkTkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINST)
	s oldI = +$g(^mdata("DHCINSTKTK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINST = maxI
	s ^mdata("DHCINSTKTK") = maxI
}

}
