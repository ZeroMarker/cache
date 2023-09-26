Class User.DHCItmTrack Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCIT_Rowid, SqlTableName = DHC_ItmTrack, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCItmTrackDetail As User.DHCItmTrackDetail [ Cardinality = children, Inverse = DHCITDParref ];

Relationship ChildDHCItmTrackItm As User.DHCItmTrackItm [ Cardinality = children, Inverse = DHCITIParref ];

Relationship ChildDHCItmTrackPackItm As User.DHCItmTrackPackItm [ Cardinality = children, Inverse = DHCITPIDHCITParref ];

/// 库存项
Property DHCITINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = DHCIT_INCI_DR ];

/// 高值条码
Property DHCITLabel As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCIT_Label ];

/// DHCIT_INGRI_DR  (Not Use)
Property DHCITINGRIDR As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DHCIT_INGRI_DR ];

/// DHCIT_INGRTI_DR  (Not Use)
Property DHCITINGRTIDR As %Library.String [ SqlColumnNumber = 6, SqlFieldName = DHCIT_INGRTI_DR ];

/// 发票号
Property DHCITInvNo As %Library.String [ SqlColumnNumber = 7, SqlFieldName = DHCIT_InvNo ];

/// 发票日期
Property DHCITInvDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DHCIT_InvDate ];

/// 条码状态
Property DHCITStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCIT_Status ];

/// 暂存库科室,暂存库间调拨时,修改此字段
Property DHCITCurrentLoc As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = DHCIT_CurrentLoc ];

Property DHCITINCIBDR As User.INCItmBat [ SqlColumnNumber = 11, SqlFieldName = DHCIT_INCIB_DR ];

/// 注册日期
Property DHCITDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = DHCIT_Date ];

/// 注册时间
Property DHCITTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DHCIT_Time ];

/// 注册人Id
Property DHCITSSUSRDR As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = DHCIT_SSUSR_DR ];

/// 供应商
Property DHCITAPCVMDR As User.APCVendor [ SqlColumnNumber = 15, SqlFieldName = DHCIT_APCVM_DR ];

Property DHCITINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 16, SqlFieldName = DHCIT_INCLB_DR ];

/// 自带条码(系统要求唯一)
Property DHCITOriginalCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCIT_OriginalCode ];

/// 订单子表Id
Property DHCITINPOIDR As User.INPOItm [ SqlColumnNumber = 18, SqlFieldName = DHCIT_INPOI_DR ];

/// 厂商Id
Property DHCITPHMNFDR As User.PHManufacturer [ SqlColumnNumber = 19, SqlFieldName = DHCIT_PHMNF_DR ];

/// 进价
Property DHCITRealPrice As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = DHCIT_RealPrice ];

/// 批号
Property DHCITBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DHCIT_BatchNo ];

/// 有效期
Property DHCITExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = DHCIT_ExpDate ];

/// 具体规格
Property DHCITSpecList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DHCIT_SpecList ];

/// 生产日期
Property DHCITProduceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = DHCIT_ProduceDate ];

/// 打印标记
Property DHCITPrintFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = DHCIT_PrintFlag ];

/// 注册证号
Property DHCITCertNo As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = DHCIT_CertNo ];

/// 注册证效期
Property DHCITCertExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = DHCIT_CertExpDate ];

/// 停医嘱前的审核标记
Property DHCITRetOriFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = DHCIT_RetOriFlag ];

/// 平台订单子表ID
Property DHCITOrderDetailSubId As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DHCIT_OrderDetailSubId ];

/// 所属科室 
Property DHCITOwnLocDR As User.CTLoc [ SqlColumnNumber = 30, SqlFieldName = DHCIT_OwnLoc_DR ];

/// 紧急业务标志 绿色通道
Property DHCITUrgentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = DHCIT_UrgentFlag ];

/// 重生成关联
Property DHCITDHCITDR As User.DHCItmTrack [ SqlColumnNumber = 32, SqlFieldName = DHCIT_DHCIT_DR ];

/// DHCIT_INCIB_Modify_DR
Property DHCITINCIBModifyDR As User.INCItmBat [ SqlColumnNumber = 33, SqlFieldName = DHCIT_INCIB_Modify_DR ];

/// 自带条码(允许重复)
Property DHCITOldOriginalBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = DHCIT_OldOriginalBarcode ];

/// 随行单号
Property DHCITSxNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = DHCIT_SxNo ];

/// 灭菌批号
Property DHCITSterilizedBat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = DHCIT_SterilizedBat ];

/// 灭菌日期
Property DHCITSterilizedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = DHCIT_SterilizedDate ];

/// 高值批次码
Property DHCITBatchCode As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = DHCIT_BatchCode ];

/// 初始状态(记录条码注册时状态) Temp:跟台高值注册(先注册后医嘱),...
Property DHCITOriginalStatus As %Library.String [ SqlColumnNumber = 39, SqlFieldName = DHCIT_OriginalStatus ];

/// 售价
Property DHCITSalePrice As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = DHCIT_SalePrice ];

/// 高值序列码(医大用于存放首尾码)
Property DHCITSequenceNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = DHCIT_SequenceNo ];

/// 条码对应的物资数量，用于批次码管理的情况
Property DHCITQty As %Library.Float [ SqlColumnNumber = 42, SqlFieldName = DHCIT_Qty ];

Property DHCITHospitalDR As User.CTHospital [ SqlColumnNumber = 43, SqlFieldName = DHCIT_Hospital_DR ];

/// 备注
Property DHCITRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = DHCIT_Remark ];

/// DHCIT_PurWithQtyType 采购类型
Property DHCITPurWithQtyType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = DHCIT_PurWithQtyType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIT)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusInci">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCIT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"StatusInci"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="datamap">
<Data name="DHCIT_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCIT_BatchCode">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DHCIT_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCIT_CertExpDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCIT_CertNo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCIT_CurrentLoc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCIT_DHCIT_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHCIT_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCIT_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCIT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DHCIT_INCIB_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCIT_INCIB_Modify_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHCIT_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCIT_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCIT_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCIT_INGRTI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCIT_INPOI_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCIT_InvDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DHCIT_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DHCIT_Label">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCIT_OldOriginalBarcode">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHCIT_OrderDetailSubId">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHCIT_OriginalCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCIT_OriginalStatus">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DHCIT_OwnLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHCIT_PHMNF_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCIT_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCIT_ProduceDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCIT_PurWithQtyType">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="DHCIT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DHCIT_RealPrice">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCIT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DHCIT_RetOriFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHCIT_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCIT_SalePrice">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DHCIT_SequenceNo">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DHCIT_SpecList">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCIT_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCIT_SterilizedBat">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHCIT_SterilizedDate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHCIT_SxNo">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHCIT_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCIT_UrgentFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexBatchCode">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"BatchCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_BatchCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDHCIT">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DHCIT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_DHCIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOldOriginalCode">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"OLDORIGINALCODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_OldOriginalBarcode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOriginalCode">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ORIGINALCODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_OriginalCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexStatus">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCIT_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexVendor">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"VENDOR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinci">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexingri">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
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
<Expression>{DHCIT_INGRI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexingrti">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INGRTI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_INGRTI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinpoi">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INPOI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_INPOI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexlabel">
<Global>^DHCIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LABEL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Label}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHCIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmTrackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCIT)
	s oldI = +$g(^mdata("DHCITMTRACK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCIT = maxI
	s ^mdata("DHCITMTRACK") = maxI
}

}
