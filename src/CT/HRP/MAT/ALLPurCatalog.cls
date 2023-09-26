Class CT.HRP.MAT.ALLPurCatalog Extends (%Persistent, User.Abstract) [ SqlTableName = ALLPurCatalog, StorageStrategy = Default ]
{

/// 医疗机构账号
Property DHCMAPCHospId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = DHC_MAPC_HospId ];

/// 部门编号
Property DHCMAPCDeptId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = DHC_MAPC_DeptId ];

/// 产品ID
Property DHCMAPCGoodsId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = DHC_MAPC_GoodsId ];

/// 分类
Property DHCMAPCSortName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = DHC_MAPC_SortName ];

/// 一级目录
Property DHCMAPCProductNameFirst As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = DHC_MAPC_ProductNameFirst ];

/// 二级目录
Property DHCMAPCProductNameSecond As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = DHC_MAPC_ProductNameSecond ];

/// 产品名
Property DHCMAPCGoodsName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8, SqlFieldName = DHC_MAPC_GoodsName ];

/// 规格
Property DHCMAPCOutLookc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 9, SqlFieldName = DHC_MAPC_OutLookc ];

/// 型号
Property DHCMAPCGoodsType As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 10, SqlFieldName = DHC_MAPC_GoodsType ];

/// 单位 计量单位
Property DHCMAPCUnit As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = DHC_MAPC_Unit ];

/// 注册证名称
Property DHCMAPCRegCodeName As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 12, SqlFieldName = DHC_MAPC_RegCodeName ];

/// 品牌
Property DHCMAPCBrand As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13, SqlFieldName = DHC_MAPC_Brand ];

/// 来源
Property DHCMAPCSource As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 14, SqlFieldName = DHC_MAPC_Source ];

/// 医疗机构设置采购价格 
Property DHCMAPCPurchasePrice As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DHC_MAPC_PurchasePrice ];

/// 投标企业编号 申报企业
Property DHCMAPCCompanyIdTb As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = DHC_MAPC_CompanyIdTb ];

/// 投标企业 申报企业
Property DHCMAPCCompanyNameTb As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = DHC_MAPC_CompanyNameTb ];

/// 配送商编号
Property DHCMAPCCompanyIdPs As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = DHC_MAPC_CompanyIdPs ];

/// 配送商
Property DHCMAPCCompanyNamePs As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = DHC_MAPC_CompanyNamePs ];

/// 采购类别
Property DHCMAPCPurchaseType As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = DHC_MAPC_PurchaseType ];

/// 添加日期
Property DHCMAPCAddDate As %Library.Date [ SqlColumnNumber = 21, SqlFieldName = DHC_MAPC_AddDate ];

/// 添加时间
Property DHCMAPCAddTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = DHC_MAPC_AddTime ];

/// 变更日期
Property DHCMAPCLastUpdateDate As %Library.Date [ SqlColumnNumber = 23, SqlFieldName = DHC_MAPC_LastUpdateDate ];

/// 变更时间
Property DHCMAPCLastUpdateTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = DHC_MAPC_LastUpdateTime ];

/// 下载日期
Property DHCMAPCDownDate As %Library.Date [ SqlColumnNumber = 25, SqlFieldName = DHC_MAPC_DownDate ];

/// 下载时间
Property DHCMAPCDownTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = DHC_MAPC_DownTime ];

/// 下载人
Property DHCMAPCDownUser As User.SSUser [ SqlColumnNumber = 27, SqlFieldName = DHC_MAPC_DownUser ];

/// 市标产品码（cn 码）
Property DHCMAPCProvinceId As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 28, SqlFieldName = DHC_MAPC_ProvinceId ];

/// 其他采购价格(与其他采购标识对应) 挂网现价/中选价
Property DHCMAPCDailPurchasePrice As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = DHC_MAPC_DailPurchasePrice ];

/// 其他采购类型标识(0:禁用,1:带量采购)
Property DHCMAPCPurchaseIDentification As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 30, SqlFieldName = DHC_MAPC_PurchaseIDentification ];

/// 三级目录
Property DHCMAPCProductNameThree As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = DHC_MAPC_ProductNameThree ];

/// 目录通用名
Property DHCMAPCProductName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = DHC_MAPC_ProductName ];

/// 生产企业编号
Property DHCMAPCCompanyIdSc As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 33, SqlFieldName = DHC_MAPC_CompanyIdSc ];

/// 生产企业名称 
Property DHCMAPCCompanyNameSc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = DHC_MAPC_CompanyNameSc ];

/// 目录材质 产品材质
Property DHCMAPCMaterialName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = DHC_MAPC_MaterialName ];

/// 医保耗材代码
Property DHCMAPCYBCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 36, SqlFieldName = DHC_MAPC_YBCode ];

/// 是否启用,启用(1)停用(0)
Property DHCMAPCIsUsing As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = DHC_MAPC_IsUsing ];

/// 转换比 
Property DHCMAPCFactor As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = DHC_MAPC_Factor ];

/// 议价状态  价格状态
Property DHCMAPCbargainStatus As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 39, SqlFieldName = DHC_MAPC_bargainStatus ];

/// 合同状态 
Property DHCMAPCcontractStatus As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 40, SqlFieldName = DHC_MAPC_contractStatus ];

/// 注册证号
Property DHCMAPCRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 41, SqlFieldName = DHC_MAPC_RegNo ];

/// 包装规格
Property DHCMAPCPackOutlookc As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 42, SqlFieldName = DHC_MAPC_PackOutlookc ];

/// 商品流水号
Property DHCMAPCProcurecatalogId As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 43, SqlFieldName = DHC_MAPC_ProcurecatalogId ];

/// 注册证截止日期
Property DHCMAPCRegEndDate As %Library.Date [ SqlColumnNumber = 44, SqlFieldName = DHC_MAPC_RegEndDate ];

/// 包装材质
Property DHCMAPCPack As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = DHC_MAPC_Pack ];

/// 九段线状态
Property DHCMAPCnineState As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 46, SqlFieldName = DHC_MAPC_nineState ];

/// 注册证ID
Property DHCMAPCRegCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 47, SqlFieldName = DHC_MAPC_RegCode ];

/// UDI耗材唯一码
Property DHCMAPCudiCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 48, SqlFieldName = DHC_MAPC_udiCode ];

/// 联采（或国家）平台唯一编码
Property DHCMAPChclcCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 49, SqlFieldName = DHC_MAPC_hclcCode ];

/// 联盟地区省级平台耗材规格型号编码
Property DHCMAPCshcDetailId As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 50, SqlFieldName = DHC_MAPC_shcDetailId ];

/// 上月最低价
Property DHCMAPClastMinPrice As %Library.Float [ SqlColumnNumber = 51, SqlFieldName = DHC_MAPC_lastMinPrice ];

/// 最高价格
Property DHCMAPCmaxPrice As %Library.Float [ SqlColumnNumber = 52, SqlFieldName = DHC_MAPC_maxPrice ];

/// 最低价格
Property DHCMAPCminPrice As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = DHC_MAPC_minPrice ];

/// 平均价格
Property DHCMAPCavgPrice As %Library.Float [ SqlColumnNumber = 54, SqlFieldName = DHC_MAPC_avgPrice ];

/// 是否国产(0:进口,1:国产)
Property DHCMAPCisMade As %Library.Float [ SqlColumnNumber = 55, SqlFieldName = DHC_MAPC_isMade ];

/// 是否中选（0:非中选、1：中选）
Property DHCMAPCisBid As %Library.Float [ SqlColumnNumber = 56, SqlFieldName = DHC_MAPC_isBid ];

/// 集采批次
Property DHCMAPCscBid As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 57, SqlFieldName = DHC_MAPC_scBid ];

Index GOODSID On DHCMAPCGoodsId As Exact;

Index DOWNDATEGOODSID On (DHCMAPCDownDate As Exact, DHCMAPCGoodsId As Exact);

Storage Default
{
<Data name="ALLPurCatalogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DHCMAPCHospId</Value>
</Value>
<Value name="3">
<Value>DHCMAPCDeptId</Value>
</Value>
<Value name="4">
<Value>DHCMAPCGoodsId</Value>
</Value>
<Value name="5">
<Value>DHCMAPCSortName</Value>
</Value>
<Value name="6">
<Value>DHCMAPCProductNameFirst</Value>
</Value>
<Value name="7">
<Value>DHCMAPCProductNameSecond</Value>
</Value>
<Value name="8">
<Value>DHCMAPCGoodsName</Value>
</Value>
<Value name="9">
<Value>DHCMAPCOutLookc</Value>
</Value>
<Value name="10">
<Value>DHCMAPCGoodsType</Value>
</Value>
<Value name="11">
<Value>DHCMAPCUnit</Value>
</Value>
<Value name="12">
<Value>DHCMAPCRegCodeName</Value>
</Value>
<Value name="13">
<Value>DHCMAPCBrand</Value>
</Value>
<Value name="14">
<Value>DHCMAPCSource</Value>
</Value>
<Value name="15">
<Value>DHCMAPCPurchasePrice</Value>
</Value>
<Value name="16">
<Value>DHCMAPCCompanyIdTb</Value>
</Value>
<Value name="17">
<Value>DHCMAPCCompanyNameTb</Value>
</Value>
<Value name="18">
<Value>DHCMAPCCompanyIdPs</Value>
</Value>
<Value name="19">
<Value>DHCMAPCCompanyNamePs</Value>
</Value>
<Value name="20">
<Value>DHCMAPCPurchaseType</Value>
</Value>
<Value name="21">
<Value>DHCMAPCAddDate</Value>
</Value>
<Value name="22">
<Value>DHCMAPCAddTime</Value>
</Value>
<Value name="23">
<Value>DHCMAPCLastUpdateDate</Value>
</Value>
<Value name="24">
<Value>DHCMAPCLastUpdateTime</Value>
</Value>
<Value name="25">
<Value>DHCMAPCDownDate</Value>
</Value>
<Value name="26">
<Value>DHCMAPCDownTime</Value>
</Value>
<Value name="27">
<Value>DHCMAPCDownUser</Value>
</Value>
<Value name="28">
<Value>DHCMAPCProvinceId</Value>
</Value>
<Value name="29">
<Value>DHCMAPCDailPurchasePrice</Value>
</Value>
<Value name="30">
<Value>DHCMAPCPurchaseIDentification</Value>
</Value>
<Value name="31">
<Value>DHCMAPCProductNameThree</Value>
</Value>
<Value name="32">
<Value>DHCMAPCProductName</Value>
</Value>
<Value name="33">
<Value>DHCMAPCCompanyIdSc</Value>
</Value>
<Value name="34">
<Value>DHCMAPCCompanyNameSc</Value>
</Value>
<Value name="35">
<Value>DHCMAPCMaterialName</Value>
</Value>
<Value name="36">
<Value>DHCMAPCYBCode</Value>
</Value>
<Value name="37">
<Value>DHCMAPCIsUsing</Value>
</Value>
<Value name="38">
<Value>DHCMAPCFactor</Value>
</Value>
<Value name="39">
<Value>DHCMAPCbargainStatus</Value>
</Value>
<Value name="40">
<Value>DHCMAPCcontractStatus</Value>
</Value>
<Value name="41">
<Value>DHCMAPCRegNo</Value>
</Value>
<Value name="42">
<Value>DHCMAPCPackOutlookc</Value>
</Value>
<Value name="43">
<Value>DHCMAPCProcurecatalogId</Value>
</Value>
<Value name="44">
<Value>DHCMAPCRegEndDate</Value>
</Value>
<Value name="45">
<Value>DHCMAPCPack</Value>
</Value>
<Value name="46">
<Value>DHCMAPCnineState</Value>
</Value>
<Value name="47">
<Value>DHCMAPCRegCode</Value>
</Value>
<Value name="48">
<Value>DHCMAPCudiCode</Value>
</Value>
<Value name="49">
<Value>DHCMAPChclcCode</Value>
</Value>
<Value name="50">
<Value>DHCMAPCshcDetailId</Value>
</Value>
<Value name="51">
<Value>DHCMAPClastMinPrice</Value>
</Value>
<Value name="52">
<Value>DHCMAPCmaxPrice</Value>
</Value>
<Value name="53">
<Value>DHCMAPCminPrice</Value>
</Value>
<Value name="54">
<Value>DHCMAPCavgPrice</Value>
</Value>
<Value name="55">
<Value>DHCMAPCisMade</Value>
</Value>
<Value name="56">
<Value>DHCMAPCisBid</Value>
</Value>
<Value name="57">
<Value>DHCMAPCscBid</Value>
</Value>
</Data>
<DataLocation>^CT.HRP.MAT.ALLPurCatalogD</DataLocation>
<DefaultData>ALLPurCatalogDefaultData</DefaultData>
<IdLocation>^CT.HRP.MAT.ALLPurCatalogD</IdLocation>
<IndexLocation>^CT.HRP.MAT.ALLPurCatalogI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.ALLPurCatalogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
