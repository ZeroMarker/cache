/// DHC_IncItmBat
Class User.DHCIncItmBat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCIB_RowID, SqlTableName = DHC_IncItmBat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INCIB_INCIB_Dr
Property INCIBINCIBDr As User.INCItmBat [ SqlColumnNumber = 2, SqlFieldName = INCIB_INCIB_Dr ];

/// INCIB_ProduceDate
Property INCIBProduceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = INCIB_ProduceDate ];

/// INCIB_Rp
Property INCIBRp As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = INCIB_Rp ];

/// INCIB_RpPuruom
Property INCIBRpPuruom As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = INCIB_RpPuruom ];

/// INCIB_Sp
Property INCIBSp As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = INCIB_Sp ];

/// INCIB_SpPuruom
Property INCIBSpPuruom As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = INCIB_SpPuruom ];

/// INCIB_PHMNF_Dr
Property INCIBPHMNFDr As User.PHManufacturer [ SqlColumnNumber = 8, SqlFieldName = INCIB_PHMNF_Dr ];

/// INCIB_APCVM_Dr
Property INCIBAPCVMDr As User.APCVendor [ SqlColumnNumber = 9, SqlFieldName = INCIB_APCVM_Dr ];

/// INCIB_INGRI_Dr
Property INCIBINGRIDr As User.DHCINGdRecItm [ SqlColumnNumber = 10, SqlFieldName = INCIB_INGRI_Dr ];

/// INCIB_DateAdd
Property INCIBDateAdd As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = INCIB_DateAdd ];

/// INCIB_TimeAdd
Property INCIBTimeAdd As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = INCIB_TimeAdd ];

/// INCIB_SourceOfFund
Property INCIBSourceOfFund As User.DHCSourceOfFund [ SqlColumnNumber = 13, SqlFieldName = INCIB_SourceOfFund ];

/// 具体规格INCIB_SpecList
Property INCIBSpecList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INCIB_SpecList ];

/// INCIB_TempStoreFlag (虚库/暂存库标记)
Property INCIBTempStoreFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INCIB_TempStoreFlag ];

/// 捐赠标志
Property INCIBGiftFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INCIB_GiftFlag ];

/// 调价换票标志
Property INCIBAdjCheque As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = INCIB_AdjCheque ];

/// 条码
Property INCIBBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INCIB_BarCode ];

/// 打印次数
Property INCIBPrintNum As %Library.Integer [ SqlColumnNumber = 19, SqlFieldName = INCIB_PrintNum ];

/// 灭菌批号INCIB_SterilizedBat
Property INCIBSterilizedBat As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INCIB_SterilizedBat ];

/// 类似incib的id信息(记录第三方数据)
Property INCIBDetailId As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INCIB_DetailId ];

/// INCIB_Tax 基本单位对应税额
Property INCIBTax As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = INCIB_Tax ];

/// INCIB_SterilizedDate
Property INCIBSterilizedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = INCIB_SterilizedDate ];

/// 疫苗批签发号 INCIB_IssuedBatNo
Property INCIBIssuedBatNo As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INCIB_IssuedBatNo ];

/// INCIB_StkType
Property INCIBStkType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 25, SqlFieldName = INCIB_StkType ];

/// 连包标志（草药）
Property INCIBDrugPackFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = INCIB_DrugPackFlag ];

/// 包装方式
Property INCIBPackWaysDR As User.INCPackInstructions [ SqlColumnNumber = 27, SqlFieldName = INCIB_PackWays_DR ];

/// 配送商
Property INCIBCarrierDR As User.DHCCarrier [ SqlColumnNumber = 28, SqlFieldName = INCIB_Carrier_DR ];

/// INGRI_FactoryNo出厂编号
Property INCIBFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INCIB_FactoryNo ];

/// 批次锁定日期
Property INCIBLockDate As %Date [ SqlColumnNumber = 30, SqlFieldName = INCIB_LockDate ];

/// 批次锁定时间
Property INCIBLockTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = INCIB_LockTime ];

/// 批次解锁日期
Property INCIBUnLockDate As %Date [ SqlColumnNumber = 32, SqlFieldName = INCIB_UnLockDate ];

/// 批次解锁时间
Property INCIBUnLockTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = INCIB_UnLockTime ];

/// 采购来源
Property INCIBPurSourceDr As User.DHCStkComDictionary [ SqlColumnNumber = 34, SqlFieldName = INCIB_PurSource_Dr ];

/// 注册证号
Property INCIBCertNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INCIB_CertNo ];

/// 采购类型
Property INCIBPurWithQtyType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INCIB_PurWithQtyType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINCIB)</SqlIdExpression>
<SQLMap name="DataMasterDHCINCIB">
<Data name="INCIB_APCVM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCIB_AdjCheque">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INCIB_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INCIB_Carrier_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INCIB_CertNo">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INCIB_DateAdd">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCIB_DetailId">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INCIB_DrugPackFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INCIB_FactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INCIB_GiftFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INCIB_INCIB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCIB_INGRI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCIB_IssuedBatNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INCIB_LockDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INCIB_LockTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INCIB_PHMNF_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCIB_PackWays_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INCIB_PrintNum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INCIB_ProduceDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCIB_PurSource_Dr">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INCIB_PurWithQtyType">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INCIB_Rp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCIB_RpPuruom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCIB_SourceOfFund">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INCIB_Sp">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCIB_SpPuruom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCIB_SpecList">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INCIB_SterilizedBat">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INCIB_SterilizedDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INCIB_StkType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INCIB_Tax">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INCIB_TempStoreFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INCIB_TimeAdd">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCIB_UnLockDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INCIB_UnLockTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Global>^DHCINCIB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INCIB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarCode">
<Global>^DHCINCIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCIB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BarCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCIB_INCIB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCIB_BarCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDetailId">
<Global>^DHCINCIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCIB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DetailId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INCIB_DetailId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INCIB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIB">
<Global>^DHCINCIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCIB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIB_INCIB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRI">
<Global>^DHCINCIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INGRI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIB_INCIB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIB_INGRI_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexManf">
<Global>^DHCINCIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHMNF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIB_INCIB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIB_PHMNF_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPA">
<Global>^DHCINCIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>INCIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PPA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIB_INCIB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIB_ProduceDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCIB_PHMNF_Dr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INCIB_APCVM_Dr}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{INCIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProduceDate">
<Global>^DHCINCIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PRODATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIB_INCIB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIB_ProduceDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor">
<Global>^DHCINCIB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INCIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"APCVM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INCIB_INCIB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INCIB_APCVM_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIncItmBatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINCIB)
	s oldI = +$g(^mdata("DHCINCLBADDION"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINCIB = maxI
	s ^mdata("DHCINCLBADDION") = maxI
}

}
