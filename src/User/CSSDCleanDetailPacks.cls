/// 记录每个清洗批号包含的消毒包数量， 标牌追溯包具体到条码。
Class User.CSSDCleanDetailPacks Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_CleanDetailPacks ]
{

/// 清洗主表DR
Property CSSDCDPCleanMain As User.CSSDClean [ SqlColumnNumber = 3, SqlFieldName = CSSDCDP_CleanMainDR ];

/// 标签号
Property CSSDCDPLabel As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CSSDCDP_Label ];

/// 消毒包rowid
Property CSSDPRPackage As User.CSSDPackage [ SqlColumnNumber = 5, SqlFieldName = CSSDPR_Package_DR ];

/// 数量
Property CSSDCDPQty As %Integer [ SqlColumnNumber = 6, SqlFieldName = CSSDCDP_Qty ];

/// 是否生成标签
Property CSSDCDPIsCrtLbl As %Integer [ InitialExpression = "0", SqlColumnNumber = 7, SqlFieldName = CSSDCDP_IsCrtLbl ];

/// 已经生成的数量
Property CSSDCDPCreatedQty As %Integer [ InitialExpression = "0", SqlColumnNumber = 8, SqlFieldName = CSSDCDP_CreatedQty ];

/// 验收时间
Property CSSDCDPCheckTime As %TimeStamp [ SqlColumnNumber = 9, SqlFieldName = CSSDCDP_CheckTime ];

/// 验收人
Property CSSDCDPChecker As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = CSSDCDP_Checker ];

/// 验收结果 1 合格、0 不合格
Property CSSDCDPResult As %Integer [ SqlColumnNumber = 11, SqlFieldName = CSSDCDP_Result ];

Property CSSDCDPApplyDetailDr As User.CSSDPackageApplyDetail [ SqlColumnNumber = 12, SqlFieldName = CSSDCDP_ApplyDetailDr ];

Property CSSDCDPCallBackDetailDr As User.CSSDCallbackDetailNew [ SqlColumnNumber = 13, SqlFieldName = CSSDCDP_CallBackDetailDr ];

/// 合格状态：Y-合格 、N-不合格
Property CSSDCDPStates As %String(COLLATION = "Exact") [ SqlColumnNumber = 14, SqlFieldName = CSSDCDP_States ];

/// 不合格原因
Property CSSDCDPReason As User.CSSDCleanItmReason [ SqlColumnNumber = 15, SqlFieldName = CSSDCDP_Reason ];

/// 用以区分明细是根据待清洗添加(null)或是页面添加(Y)
Property CSSDCDPCreWay As %String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = CSSDCDP_CreWay ];

/// 数量
Property CSSDCDPUnPassQty As %Integer [ SqlColumnNumber = 17, SqlFieldName = CSSDCDP_UnPassQty ];

/// 原不合格的清洗明细绑定重新清洗的清洗明细ID（预留后续追踪----banxiongbao）
Property CSSDCDPCleanDetailId As %String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = CSSDCDP_CleanDetailId ];

/// 重新清洗的清洗明细数据绑定原不合格清洗明细数据的Id，用于回置状态（清洗添加后再次删除，需要回置不合格里的状态）
Property CSSDCDPBindCleanDetailId As %String(COLLATION = "Exact") [ SqlColumnNumber = 19, SqlFieldName = CSSDCDP_BindCleanDetailId ];

/// 绿色通道标识 
Property CSSDCDPGreenFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 20, SqlFieldName = CSSDCDP_GreenFlag ];

/// 二次清洗标志：Y-是二次清洗 、N-默认非二次清洗（判断明细包是否为二次清洗）
Property CSSDCDPFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 21, SqlFieldName = CSSDCDP_Flag ];

/// 总数数量
Property CSSDCDPTotalQty As %Integer [ SqlColumnNumber = 22, SqlFieldName = CSSDCDP_TotalQty ];

/// 外来器械表DR
Property CSSDCDPExtDR As User.CSSDExtDevBind [ SqlColumnNumber = 23, SqlFieldName = CSSDCDP_ExtDR ];

/// 组合包  以哪个包为主
Property CSSDCDPComposePkg As User.CSSDPackage [ SqlColumnNumber = 24, SqlFieldName = CSSDCDP_ComposePkg ];

/// 组合名称
Property CSSDCDPComposePkgName As %String(COLLATION = "Exact") [ SqlColumnNumber = 25, SqlFieldName = CSSDCDP_ComposePkgName ];

/// 组合标志 Y  按照自己的规定，几个明细包组合打一包
Property CSSDCDPComposeFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 26, SqlFieldName = CSSDCDP_ComposeFlag ];

/// 拆包标志 Y  按照自己的规定，设置几件打一包 
Property CSSDCDPPackFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 27, SqlFieldName = CSSDCDP_PackFlag ];

/// 包装材料Id
Property CSSDCDPMaterialDR As User.CSSDMaterial [ SqlColumnNumber = 28, SqlFieldName = CSSDCDP_MaterialDR ];

Property CSSDCDPLevelFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 29, SqlFieldName = CSSDCDP_LevelFlag ];

Index IndexMainDr On CSSDCDPCleanMain As Exact;

Index CSSDIndexCDPLabel On CSSDCDPLabel As Exact;

Index IndexMainDrPkgdr On (CSSDCDPCleanMain As Exact, CSSDPRPackage As Exact);

Index IndexPkgdr On CSSDPRPackage As Exact;

/// 添加清洗主表ID和是否生成标签索引
Index IndexMainDrIsCrtLbl On (CSSDCDPCleanMain As Exact, CSSDCDPIsCrtLbl As Exact);

Index IndexCallBackDetailDr On CSSDCDPCallBackDetailDr As Exact;

/// 包装材料的索引
Index IndexMainDrMaterialPkgdr On (CSSDCDPCleanMain As Exact, CSSDCDPMaterialDR As Exact, CSSDPRPackage As Exact);

Storage Default
{
<Data name="CSSDCleanDetailPacksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2"/>
<Value name="3">
<Value>CSSDCDPCleanMain</Value>
</Value>
<Value name="4">
<Value>CSSDCDPLabel</Value>
</Value>
<Value name="5">
<Value>CSSDPRPackage</Value>
</Value>
<Value name="6">
<Value>CSSDCDPQty</Value>
</Value>
<Value name="7">
<Value>CSSDCDPIsCrtLbl</Value>
</Value>
<Value name="8">
<Value>CSSDCDPCreatedQty</Value>
</Value>
<Value name="9">
<Value>CSSDCDPCheckTime</Value>
</Value>
<Value name="10">
<Value>CSSDCDPChecker</Value>
</Value>
<Value name="11">
<Value>CSSDCDPResult</Value>
</Value>
<Value name="12">
<Value>CSSDCDPApplyDetailDr</Value>
</Value>
<Value name="13">
<Value>CSSDCDPCallBackDetailDr</Value>
</Value>
<Value name="14">
<Value>CSSDCDPStates</Value>
</Value>
<Value name="15">
<Value>CSSDCDPReason</Value>
</Value>
<Value name="16">
<Value>CSSDCDPCreWay</Value>
</Value>
<Value name="17">
<Value>CSSDCDPUnPassQty</Value>
</Value>
<Value name="18">
<Value>CSSDCDPCleanDetailId</Value>
</Value>
<Value name="19">
<Value>CSSDCDPBindCleanDetailId</Value>
</Value>
<Value name="20">
<Value>CSSDCDPGreenFlag</Value>
</Value>
<Value name="21">
<Value>CSSDCDPFlag</Value>
</Value>
<Value name="22">
<Value>CSSDCDPTotalQty</Value>
</Value>
<Value name="23">
<Value>CSSDCDPExtDR</Value>
</Value>
<Value name="24">
<Value>CSSDCDPComposePkg</Value>
</Value>
<Value name="25">
<Value>CSSDCDPComposePkgName</Value>
</Value>
<Value name="26">
<Value>CSSDCDPComposeFlag</Value>
</Value>
<Value name="27">
<Value>CSSDCDPPackFlag</Value>
</Value>
<Value name="28">
<Value>CSSDCDPMaterialDR</Value>
</Value>
<Value name="29">
<Value>CSSDCDPLevelFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCleanDetailPacksD</DataLocation>
<DefaultData>CSSDCleanDetailPacksDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDCleanDetailPacksD</IdLocation>
<IndexLocation>^User.CSSDCleanDetailPacksI</IndexLocation>
<StreamLocation>^User.CSSDCleanDetailPacksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
