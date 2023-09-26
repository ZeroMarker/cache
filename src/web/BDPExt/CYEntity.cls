/// 新草药医嘱模式 药品数据导入实体类
/// Creator:陈莹 
/// CreatDate:2018-11-18
/// 基础数据平台组
Class web.BDPExt.CYEntity Extends (web.Entity.CT.ARCItmMast, web.Entity.CT.DHCTarItem, web.Entity.CT.DHCOrderLinkTar, web.Entity.CT.DHCTarItemPrice, web.Entity.CT.DHCTarItemAlias, web.Entity.CT.ARCAlias)
{

Parameter PersistentClassName = "web.BDPExt.CYEntity";

Property ID As %String;

// 处方通用名名称

Property PHCDGenericDR As %String;

// 药学项/医嘱项代码

// Property ARCIMCode As %String;

// 药学项/医嘱项名称

// Property ARCIMDesc As %String;

// 别名("/"分隔)  医嘱项/药学项

Property ALIASText As %String;

// 别名 收费项/库存项 2019-01-22

Property INCALIAS As %String;

// 药学基本单位转换系数

Property PHCDFCTUOMFac As %String;

// 药学项基本单位

Property PHCDFCTUOMDR As %String;

// 库存项代码

Property INCICode As %String;

// 库存项名称

Property INCIDesc As %String;

// 进价

Property Rp As %String;

// 售价

Property Sp As %String;

// 入库单位

Property INCICTUOMPurchDR As %String;

// 入库转换系数

Property INCICTUOMPurchFac As %String;

// 基本单位

Property INCICTUOMDR As %String;

// 门诊发药单位

Property INCICTUOMOutPatDR As %String;

// 门诊发药转换系数

Property INCICTUOMOutPatFac As %String;

// 住院发药单位

Property INCICTUOMInPatDR As %String;

// 住院发药转换系数

Property INCICTUOMInPatFac As %String;

// 包装规格

Property INFOSpec As %String;

// 剂型

Property PHCDFPHCFDR As %String;

// 用法

Property PHCDFPHCINDR As %String;

// 频次

Property PHCDFPHCFRDR As %String;

// 疗程

Property PHCDFPHCDUDR As %String;

// 等效数量1

Property EQQty1 As %String;

// 等效单位1

Property EQCTUOMDR1 As %String;

// 缺省数量1

Property EQDefaultDose1 As %String;

// 等效数量2

Property EQQty2 As %String;

// 等效单位2

Property EQCTUOMDR2 As %String;

// 缺省数量2

Property EQDefaultDose2 As %String;

// 厂商 改成DHC_ItmAddionInfo  INFOPHMNFDR

Property PHCDPHMNFDR As %String;

// 管制分类

Property PHCDPHCPODR As %String;

// 医嘱大类

Property OrdCat As %String;

// 医嘱子类

Property OrdSubCat As %String;

// 库存分类

Property INCIINCSCDR As %String;

// 账单大类

Property BillCat As %String;

// 账单子类

Property BillSubCat As %String;

// 收费大类

Property TarCat As %String;

// 收费子类

Property TarSubCat As %String;

// 住院大类

Property InpaCat As %String;

// 住院子类

Property InpaSubCat As %String;

// 门诊大类

Property OutpaCat As %String;

// 门诊子类

Property OutpaSubCat As %String;

// 核算大类

Property EmCat As %String;

// 核算子类

Property EmSubCat As %String;

// 会计大类

Property AcctCat As %String;

// 会计子类

Property AcctSubCat As %String;

// 病案大类

Property MrCat As %String;

// 病案子类

Property MrSubCat As %String;

// 新病案首页案大类

Property MrCatNew As %String;

// 新病案首页子类

Property MrSubCatNew As %String;

// 独立医嘱(Y/N)

Property Onitsown As %String;

// 长期默认嘱托

Property PHCDFCQZTFlag As %String;

// 临时默认取药

Property PHCDFONEFlag As %String;

// 默认医嘱优先级

Property Priority As %String;

// 限制量

Property DARCIMLimitQty As %String;

// 极限量

Property DARCIMMaxQty As %String;

// 抗菌药标志(Y/N)

Property PHCDFAntibioticFlag As %String;

// 皮试标志(Y/N)

Property INFOSkinTest As %String;

// 住院一天量标志(Y/N)

Property PHCDFDeductPartially As %String;

// 门诊一天量标志(Y/N)

Property PHCDFCalcuDose As %String;

// 门诊皮试用原液(Y/N)

Property PHCDFOPSkinTestYY As %String;

// 住院皮试用原液(Y/N)

Property PHCDFIPSkinTestYY As %String;

// 基本药物标志(Y/N)

Property INFOBasicDrug As %String;

// 省基本药物标志(Y/N)

Property INFODrugbase2 As %String;

// 批准文号

Property INFORemark As %String;

// 市级基本药物(Y/N)

Property INFOPDrugbase1 As %String;

// 区(县)基本药物(Y/N)

Property INFOPDrugbase2 As %String;

// 中国药典标志(Y/N)

Property INFOCodex As %String;

// 临床验证用药标志(Y/N)

Property INFOTest As %String;

// 处方购药标志(Y/N)

Property INFORec As %String;

// 本院药品目录标志(Y/N)

Property INFOInHosFlag As %String;

// 阳光采购标志(Y/N)

Property INFOBAflag As %String;

// 定价类型

Property INFOMTDR As %String;

// 医保类别

Property PHCDOfficialCode As %String;

// 危重药标志(Y/N)

Property PHCDFCriticalFlag As %String;

// 大包装单位

Property INFOPackUom As %String;

// 大包装单位系数

Property INFOPackUomFactor As %String;

// DDD值

Property PHCDFDDD As %String;

// WHONET码

Property PHCDFWHONET As %String;

// WhoDDD值

Property PHCDFWHODDD As %String;

// WhoDDD单位

Property PHCDFWHODDDUomDr As %String;

// TPN标志

Property PHCDFTpnFlag As %String;

// 省属常用药物(Y/N)

Property PHCDFProvinceComm As %String;

// 英文国际非专利药名

Property PHCDLabelName21 As %String;

// 国际专利药名

Property PHCDLabelName22 As %String;

// 商品名

Property PHCDLabelName1 As %String;

// 不可用标志(Y/N)

Property INCINotUseFlag As %String;

// 条码

Property INCIBarCode As %String;

// 价格生效日期(yyyy-MM-dd)

Property PriceDate As %String;

// 进口标志(国产/进口/合资)

Property INFOImportFlag As %String;

// 质量层次

Property INFOQualityLevel As %String;

// 处方药分类(甲类/乙类/双跨)

Property INFOOTC As %String;

// 最高售价

Property INFOMaxSp As %String;

// 药品本位码

Property INFOStandardCode As %String;

// 协和码

Property INCIReportingDays As %String;

// 进药依据

Property INFOInMedBasis As %String;

// 质量编号

Property INFOQualityNo As %String;

// 国省别

Property INFOComFrom As %String;

// 贵重药标志=高值类标志(Y/N)

Property INFOHighPrice As %String;

// 招标进价

Property INFOPbRp As %String;

// 招标供应商

Property INFOPbVendorDR As %String;

// 招标生产商

Property INFOPbManfDR As %String;

// 招标配送商

Property INFOPbCarrierDR As %String;

// 招标级别

Property INFOPBLevel As %String;

// 物价文件号

Property INFOPrcFile As %String;

// 物价文件备案时间

Property INFOPrcFileD As %String;

// 帐簿分类

Property INFOBCDr As %String;

// 用药说明

Property INFODrugUse As %String;

// 常温(Y/N)

Property ISCCommonTemp As %String;

// 干燥(Y/N)

Property ISCDry As %String;

// 密闭(Y/N)

Property ISCAirtight As %String;

// 避光(Y/N)

Property ISCDark As %String;

// 通风(Y/N)

Property ISCVentilate As %String;

// 防辐射(Y/N)

Property ISCRadiation As %String;

// 熔封(Y/N)

Property ISCSeal As %String;

// 阴凉(Y/N)

Property ISCCoolGloomy As %String;

// 凉暗(Y/N)

Property ISCGloomyCool As %String;

// 密封(Y/N)

Property ISCMeltPack As %String;

// 冷藏(Y/N)

Property ISCCOLDST As %String;

// 冷冻(Y/N)

Property ISCFREEZE As %String;

// 防潮(Y/N)

Property ISCDAMPPROOF As %String;

// 最低湿度

Property ISCMinHumidity As %String;

// 最高湿度

Property ISCMaxHumidity As %String;

// 最低温度

Property ISCMinTemp As %String;

// 最高温度

Property ISCMaxTemp As %String;

// 制剂通用名

Property PHCDFOfficialCode1 As %String;

// 原料通用名

Property PHCDFOfficialCode2 As %String;

// 草药备注

Property PHCDFCHPhSpecInstr As %String;

// 滴速(gtt/min)

Property PHCDFivgttSpeed As %String;

// 颗粒单位系数

Property PHCDFGranulesFact As %String;

// 含量规格

Property PHCDFSpec As %String;

/// 数量
Property INCTRQty As %String;

/// 开始时间
Property INCTRStartDate As %String;

/// 截止时间
Property INCTREndDate As %String;

/// 免费药 2019-06-14
Property DARCIMFreeDrugFlag As %String;

/// 药学项 化疗标志(Y/N) 2019-12-18
Property PHCDFChemotherapeutic As %String;

/// 药学项 高危级别(高危-H,特殊高危-S)
Property PHCDFHighRisk As %String;

/// 药学项 急救药品(Y/N)
Property PHCDFFirstAid As %String;

/// 药学项 附加说明默认自备(Y/N)
Property PHCDFOMFlag As %String;

/// 药学项 兴奋剂
Property PHCDFDope As %String;

/// 药学项 跌倒风险
Property PHCDFTumble As %String;

/// 药学项 过敏
Property PHCDFAllergyFlag As %String;

/// 药学项 饮食禁忌
Property PHCDFDietTaboo As %String;

/// 库存项 易混淆
Property INFOEasyConfuse As %String;

/// 库存项 国家集中带量采购(Y/N)(4+7)
Property INFOCentralPurFlag As %String;

/// 2020-01-06
/// 药学项 等效单位1默认(Y/N)
Property EQDefault1 As %String;

/// 药学项 等效单位2默认(Y/N)
Property EQDefault2 As %String;

/// 库存项 存储条件备注
Property ISCRemark As %String;

/// 库存项 谈判药(Y/N)
Property INFONegotiateFlag As %String;

/// 库存项 药品采购码
Property INFOPurPlanCode As %String;

/// 收费项别名
Property TARIALIAS As %String;

/// 皮试阳性不产生过敏记录(Y/N) 2022-01-05
Property PHCDFNoAllergy As %String;

/// 抗肿瘤药物级别（O - 普通级，S - 限制级）
Property PHCDFAntiLevSCDIDr As %String;

/// 草药是否允许录入小数(Y/N)
Property DARCIMCMAllowEntryDecimal As %String;

/// 住院单次剂量偏好(偏好取半,偏好向下取整,偏好向上取整)
/// H-偏好取半(即不足一半取半,足够一半取整), FD-偏好向下取整(即不为整数则向下取整，最小值不低于1),FU-偏好向上取整(即不为整数则向上取整)
Property DARCIMPartialValue As %String;

/// 产地  2022-05-13
Property INFOOrigin As %String;

/// 门诊单次剂量偏好(偏好取半,偏好向下取整,偏好向上取整) 20221024
/// H-偏好取半(即不足一半取半,足够一半取整), FD-偏好向下取整(即不为整数则向下取整，最小值不低于1),FU-偏好向上取整(即不为整数则向上取整)
Property DARCIMOPPartialValue As %String;

/// 院内重点监控药物(Y/N)
Property INFOMonitorFlag As %String;

}
