/// 名称:原药品（HIS8.3以前）
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.YPEntity Extends (web.Entity.CT.ARCItmMast, web.Entity.CT.DHCTarItem, web.Entity.CT.DHCOrderLinkTar, web.Entity.CT.DHCTarItemPrice, web.Entity.CT.DHCTarItemAlias, web.Entity.CT.ARCAlias)
{

Parameter PersistentClassName = "web.BDPExt.YPEntity";

/// ROWID
Property ID As %String;

/// 基本单位(名称)
Property INCICTUOMDR As %String;

/// 入库单位(名称)
Property INCICTUOMPurchDR As %String;

/// 库存分类(名称)
Property INCIINCSCDR As %String;

/// 别名("/"分隔)
Property INCALIAS As %String;

/// 不可用标志(Y/N)
Property INCINotUseFlag As %String;

/// 条码
Property INCIBarCode As %String;

/// 售价
Property Sp As %String;

/// 进价
Property Rp As %String;

/// 价格生效日期(yyyy-MM-dd,空为当天)
Property PriceDate As %String;

/// 规格
Property INFOSpec As %String;

/// 进口标志(国产/进口/合资)
Property INFOImportFlag As %String;

/// 质量层次
Property INFOQualityLevel As %String;

/// 处方药分类(甲类/乙类/双跨)
Property INFOOTC As %String;

/// 基本药物标志(Y/N)
Property INFOBasicDrug As %String;

/// 中国药典标志(Y/N)
Property INFOCodex As %String;

/// 临床验证用药标志(Y/N)
Property INFOTest As %String;

/// 处方购药标志(Y/N)
Property INFORec As %String;

/// 质量编号
Property INFOQualityNo As %String;

/// 国(省)别
Property INFOComFrom As %String;

/// 批准文号(国药准字-H0023N1)
Property INFORemark As %String;

/// 高值类标志(Y/N)
Property INFOHighPrice As %String;

/// 定价类型(名称)
Property INFOMTDR As %String;

/// 最高售价
Property INFOMaxSp As %String;

/// 本院药品目录标志(Y/N)
Property INFOInHosFlag As %String;

/// 招标进价
Property INFOPbRp As %String;

/// 招标供应商(全称)
Property INFOPbVendorDR As %String;

/// 招标生产商(全称)
Property INFOPbManfDR As %String;

/// 招标配送商(全称)
Property INFOPbCarrierDR As %String;

/// 招标级别
Property INFOPBLevel As %String;

/// 阳光采购标志(Y/N)
Property INFOBAflag As %String;

/// 物价文件号
Property INFOPrcFile As %String;

/// 物价文件备案时间(yyyy-MM-dd)
Property INFOPrcFileD As %String;

/// 皮试标志(Y/N)
Property INFOSkinTest As %String;

/// 帐簿分类(名称)
Property INFOBCDr As %String;

/// 用药说明
Property INFODrugUse As %String;

/// 省基本药物标志(Y/N)
Property INFODrugbase2 As %String;

/// 市级基本药物(Y/N)
Property INFOPDrugbase1 As %String;

/// 区(县)基本药物(Y/N)
Property INFOPDrugbase2 As %String;

/// 药品本位码
Property INFOStandardCode As %String;

/// 进药依据
Property INFOInMedBasis As %String;

/// 大包装单位
Property INFOPackUom As %String;

/// 大包装单位系数
Property INFOPackUomFactor As %String;

/// 存储条件-常温(Y/N)
Property ISCCommonTemp As %String;

/// 存储条件-干燥(Y/N)
Property ISCDry As %String;

/// 存储条件-密闭(Y/N)
Property ISCAirtight As %String;

/// 存储条件-避光(Y/N)
Property ISCDark As %String;

/// 存储条件-通风(Y/N)
Property ISCVentilate As %String;

/// 存储条件-防辐射(Y/N)
Property ISCRadiation As %String;

/// 存储条件-熔封(Y/N)
Property ISCSeal As %String;

/// 存储条件-阴凉(Y/N)
Property ISCCoolGloomy As %String;

/// 存储条件-凉暗(Y/N)
Property ISCGloomyCool As %String;

/// 存储条件-密封(Y/N)
Property ISCMeltPack As %String;

/// 存储条件-冷藏(Y/N)
Property ISCCOLDST As %String;

/// 存储条件-冷冻(Y/N)
Property ISCFREEZE As %String;

/// 存储条件-防潮(Y/N)
Property ISCDAMPPROOF As %String;

/// 存储条件-最低湿度
Property ISCMinHumidity As %String;

/// 存储条件-最高湿度
Property ISCMaxHumidity As %String;

/// 存储条件-最低温度
Property ISCMinTemp As %String;

/// 存储条件-最高温度
Property ISCMaxTemp As %String;

/* 库存项 end */

/* 药学项 start */
/// 药品代码
Property INCICode As %String;

/// 药品名称
Property INCIDesc As %String;

/// 剂型(名称)
Property PHCDFPHCFDR As %String;

/// 用法(名称)
Property PHCDFPHCINDR As %String;

/// 疗程(名称)
Property PHCDFPHCDUDR As %String;

/// 基本数量(数字)
Property PHCDFBaseQty As %String;

/// 厂商(全称)
Property PHCDPHMNFDR As %String;

/// 管制分类(名称)
Property PHCDPHCPODR As %String;

/// 频次(名称)
Property PHCDFPHCFRDR As %String;

/// 医保类别(全称-字典维护)
Property PHCDOfficialCode As %String;

/// 通用名(名称)
Property PHCDGenericDR As %String;

/// 英文国际非专利药名
Property PHCDLabelName21 As %String;

/// 国际专利药名
Property PHCDLabelName22 As %String;

/// 商品名
Property PHCDLabelName1 As %String;

/// 制剂通用名
Property PHCDFOfficialCode1 As %String;

/// 原料通用名
Property PHCDFOfficialCode2 As %String;

/// 住院一天量标志(Y/N)
Property PHCDFDeductPartially As %String;

/// 门诊一天量标志(Y/N)
Property PHCDFCalcuDose As %String;

/// 门诊皮试用原液(Y/N)
Property PHCDFOPSkinTestYY As %String;

/// 住院皮试用原液(Y/N)
Property PHCDFIPSkinTestYY As %String;

/// 抗菌药标志(Y/N)
Property PHCDFAntibioticFlag As %String;

/// 危重药标志(Y/N)
Property PHCDFCriticalFlag As %String;

/// WHONET码
Property PHCDFWHONET As %String;

/// 草药备注-----------------待确定怎么存
Property PHCDFCHPhSpecInstr As %String;

/// WhoDDD值
Property PHCDFWHODDD As %String;

/// WhoDDD单位(名称)
Property PHCDFWHODDDUomDr As %String;

/// 滴速(数字,对应单位gtt/min)
Property PHCDFivgttSpeed As %String;

/// 颗粒单位系数
Property PHCDFGranulesFact As %String;

/// 省属常用药物(Y/N)
Property PHCDFProvinceComm As %String;

/// 药学分类1级(名称)
Property DHCPHCCat1 As %String;

/// 药学分类2级(名称)
Property DHCPHCCat2 As %String;

/// 药学分类3级(名称)
Property DHCPHCCat3 As %String;

/// 药学分类4级(名称)
Property DHCPHCCat4 As %String;

/// 药学分类5级(名称)
Property DHCPHCCat5 As %String;

/// 药学分类6级(名称)
Property DHCPHCCat6 As %String;

/// 药学分类7级(名称)
Property DHCPHCCat7 As %String;

/// 等效单位1(名称)
Property EQCTUOMDR1 As %String;

/// 等效数量1
Property EQQty1 As %String;

/// 缺省数量1
Property EQDefaultDose1 As %String;

/// 等效单位2(名称)
Property EQCTUOMDR2 As %String;

/// 等效数量2
Property EQQty2 As %String;

/// 缺省数量2
Property EQDefaultDose2 As %String;

Property OrdCat As %String;

Property OrdSubCat As %String;

Property BillCat As %String;

Property BillSubCat As %String;

Property TarCat As %String;

Property TarSubCat As %String;

Property InpaCat As %String;

Property InpaSubCat As %String;

Property OutpaCat As %String;

Property OutpaSubCat As %String;

Property EmCat As %String;

Property EmSubCat As %String;

Property AcctCat As %String;

Property AcctSubCat As %String;

Property MrCat As %String;

Property MrSubCat As %String;

Property MrCatNew As %String;

Property MrSubCatNew As %String;

Property Priority As %String;

Property Onitsown As %String;

Property INFOISCDR As %String;

/// 入库转换系数  2017-03-21
Property INCICTUOMPurchFac As %String;

// Property ARCIMBillingUOMDR As %String;

/// 计价单位 2017-3-20
/// 计价转换系数
Property ARCIMBillingUOMFac As %String;

// Property ARCIMOEMessage As %String;

///  备注 20170721
Property BillGrp As %String;

/// 协和码 2018-10-11 交付中心提
Property INCIReportingDays As %String;

}
