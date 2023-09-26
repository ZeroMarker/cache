Class User.DHCMatPurCatalog Extends (%Persistent, User.Abstract) [ SqlRowIdName = MatPurCatalog_RowId, SqlTableName = DHC_MatPurCatalog, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCSpecModelList As User.DHCSpecModelList [ Cardinality = children, Inverse = SMListMPCLogParRef ];

/// 医疗机构账号
Property DHCMPCHospId As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DHC_MPC_HospId ];

/// 部门编号
Property DHCMPCDeptId As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DHC_MPC_DeptId ];

/// 产品ID
Property DHCMPCGoodsId As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DHC_MPC_GoodsId ];

/// 分类
Property DHCMPCSortName As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DHC_MPC_SortName ];

/// 一级目录
Property DHCMPCProductNameFirst As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DHC_MPC_ProductNameFirst ];

/// 二级目录
Property DHCMPCProductNameSecond As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DHC_MPC_ProductNameSecond ];

/// 产品名
Property DHCMPCGoodsName As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DHC_MPC_GoodsName ];

/// 规格
Property DHCMPCOutLookc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DHC_MPC_OutLookc ];

/// 型号
Property DHCMPCGoodsType As %Library.String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DHC_MPC_GoodsType ];

/// 单位
Property DHCMPCUnit As %Library.String [ SqlColumnNumber = 11, SqlFieldName = DHC_MPC_Unit ];

/// 注册证名称
Property DHCMPCRegCodeName As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DHC_MPC_RegCodeName ];

/// 品牌
Property DHCMPCBrand As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DHC_MPC_Brand ];

/// 来源
Property DHCMPCSource As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DHC_MPC_Source ];

/// 医疗机构设置采购价格 
Property DHCMPCPurchasePrice As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DHC_MPC_PurchasePrice ];

/// 投标企业编号 申报企业
Property DHCMPCCompanyIdTb As %Library.String [ SqlColumnNumber = 16, SqlFieldName = DHC_MPC_CompanyIdTb ];

/// 投标企业 申报企业
Property DHCMPCCompanyNameTb As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = DHC_MPC_CompanyNameTb ];

/// 配送商编号
Property DHCMPCCompanyIdPs As %Library.String [ SqlColumnNumber = 18, SqlFieldName = DHC_MPC_CompanyIdPs ];

/// 配送商
Property DHCMPCCompanyNamePs As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = DHC_MPC_CompanyNamePs ];

/// 采购类别
Property DHCMPCPurchaseType As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = DHC_MPC_PurchaseType ];

/// 添加日期
Property DHCMPCAddDate As %Library.Date [ SqlColumnNumber = 21, SqlFieldName = DHC_MPC_AddDate ];

/// 添加时间
Property DHCMPCAddTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = DHC_MPC_AddTime ];

/// 变更日期
Property DHCMPCLastUpdateDate As %Library.Date [ SqlColumnNumber = 23, SqlFieldName = DHC_MPC_LastUpdateDate ];

/// 变更时间
Property DHCMPCLastUpdateTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = DHC_MPC_LastUpdateTime ];

/// 下载日期
Property DHCMPCDownDate As %Library.Date [ SqlColumnNumber = 25, SqlFieldName = DHC_MPC_DownDate ];

/// 下载时间
Property DHCMPCDownTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = DHC_MPC_DownTime ];

/// 下载人
Property DHCMPCDownUser As User.SSUser [ SqlColumnNumber = 27, SqlFieldName = DHC_MPC_DownUser ];

/// 市标产品码（cn 码）
Property DHCMPCProvinceId As %Library.String [ SqlColumnNumber = 28, SqlFieldName = DHC_MPC_ProvinceId ];

/// 其他采购价格(与其他采购标识对应) 挂网现价/中选价
Property DHCMPCDailPurchasePrice As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = DHC_MPC_DailPurchasePrice ];

/// 其他采购类型标识(0:禁用,1:带量采购)
Property DHCMPCPurchaseIDentification As %Library.String [ SqlColumnNumber = 30, SqlFieldName = DHC_MPC_PurchaseIDentification ];

/// 三级目录
Property DHCMPCProductNameThree As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = DHC_MPC_ProductNameThree ];

/// 目录通用名
Property DHCMPCProductName As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = DHC_MPC_ProductName ];

/// 生产企业编号
Property DHCMPCCompanyIdSc As %Library.String [ SqlColumnNumber = 33, SqlFieldName = DHC_MPC_CompanyIdSc ];

/// 生产企业名称 
Property DHCMPCCompanyNameSc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = DHC_MPC_CompanyNameSc ];

/// 目录材质 产品材质
Property DHCMPCMaterialName As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = DHC_MPC_MaterialName ];

/// 医保耗材代码
Property DHCMPCYBCode As %Library.String [ SqlColumnNumber = 36, SqlFieldName = DHC_MPC_YBCode ];

/// 是否启用,启用(1)停用(0)
Property DHCMPCIsUsing As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = DHC_MPC_IsUsing ];

/// 转换比 
Property DHCMPCFactor As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = DHC_MPC_Factor ];

/// 议价状态  价格状态
Property DHCMPCbargainStatus As %Library.String [ SqlColumnNumber = 39, SqlFieldName = DHC_MPC_bargainStatus ];

/// 合同状态 
Property DHCMPCcontractStatus As %Library.String [ SqlColumnNumber = 40, SqlFieldName = DHC_MPC_contractStatus ];

/// 注册证号
Property DHCMPCRegNo As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = DHC_MPC_RegNo ];

/// 包装规格
Property DHCMPCPackOutlookc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = DHC_MPC_PackOutlookc ];

/// 商品流水号
Property DHCMPCProcurecatalogId As %Library.String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = DHC_MPC_ProcurecatalogId ];

/// 注册证截止日期
Property DHCMPCRegEndDate As %Library.Date [ SqlColumnNumber = 44, SqlFieldName = DHC_MPC_RegEndDate ];

/// 包装材质
Property DHCMPCPack As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = DHC_MPC_Pack ];

/// 九段线状态
Property DHCMPCnineState As %Library.String [ SqlColumnNumber = 46, SqlFieldName = DHC_MPC_nineState ];

/// 注册证ID
Property DHCMPCRegCode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = DHC_MPC_RegCode ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMatPurCataLog)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHC_MPC_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHC_MPC_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHC_MPC_Brand">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHC_MPC_CompanyIdPs">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHC_MPC_CompanyIdSc">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHC_MPC_CompanyIdTb">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHC_MPC_CompanyNamePs">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHC_MPC_CompanyNameSc">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHC_MPC_CompanyNameTb">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHC_MPC_DailPurchasePrice">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHC_MPC_DeptId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHC_MPC_DownDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHC_MPC_DownTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHC_MPC_DownUser">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHC_MPC_Factor">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DHC_MPC_GoodsId">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHC_MPC_GoodsName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHC_MPC_GoodsType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHC_MPC_HospId">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_MPC_IsUsing">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DHC_MPC_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHC_MPC_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHC_MPC_MaterialName">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DHC_MPC_OutLookc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHC_MPC_Pack">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="DHC_MPC_PackOutlookc">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="DHC_MPC_ProcurecatalogId">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="DHC_MPC_ProductName">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHC_MPC_ProductNameFirst">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHC_MPC_ProductNameSecond">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHC_MPC_ProductNameThree">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHC_MPC_ProvinceId">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHC_MPC_PurchaseIDentification">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHC_MPC_PurchasePrice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHC_MPC_PurchaseType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHC_MPC_RegCode">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DHC_MPC_RegCodeName">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHC_MPC_RegEndDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DHC_MPC_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DHC_MPC_SortName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHC_MPC_Source">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHC_MPC_Unit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHC_MPC_YBCode">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DHC_MPC_bargainStatus">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DHC_MPC_contractStatus">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DHC_MPC_nineState">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Global>^DHCMatPurCataLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MatPurCatalog_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MatPurCatalog_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDownDate">
<Global>^DHCMatPurCataLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MatPurCatalog_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DownDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_MPC_DownDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MatPurCatalog_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGoodsId">
<Global>^DHCMatPurCataLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MatPurCatalog_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GoodsId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DHC_MPC_GoodsId})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MatPurCatalog_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvinceId">
<Global>^DHCMatPurCataLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MatPurCatalog_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ProvinceId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DHC_MPC_ProvinceId})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MatPurCatalog_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MatPurCatalog_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMatPurCataLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMatPurCataLog)
	s oldI = +$g(^mdata("DHCMatPurCataLog"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMatPurCataLog = maxI
	s ^mdata("DHCMatPurCataLog") = maxI
}

Parameter EXTENTSIZE = 250;

}
