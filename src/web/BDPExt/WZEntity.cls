/// 名称:物资
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.WZEntity Extends (web.Entity.CT.ARCItmMast, web.Entity.CT.DHCTarItem, web.Entity.CT.DHCOrderLinkTar, web.Entity.CT.DHCTarItemPrice, web.Entity.CT.DHCTarItemAlias, web.Entity.CT.ARCAlias)
{

Parameter PersistentClassName = "web.BDPExt.WZEntity";

Property ID As %String;

Property Charge As %String;

// 2017-3-6

Property ArcAbbrev As %String;

Property ArcOEMessage As %String;

Property PackUomMax As %String;

Property PackUomFacMax As %String;

Property FeeUomFac As %String;

// dhc_stkcatgroup

Property CatGrp As %String;

// inc_stkcat

Property StkCat As %String;

Property Code As %String;

Property Desc As %String;

Property Spec As %String;

Property Model As %String;

Property Origin As %String;

Property Brand As %String;

Property Abbr As %String;

Property Alias As %String;

Property BUom As %String;

Property PUom As %String;

Property Factor As %String;

Property FeeUom As %String;

Property RP As %String;

Property SP As %String;

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

Property InsuCode As %String;

Property InsuDesc As %String;

Property Priority As %String;

Property Onitsown As %String;

Property Wostock As %String;

Property HighValue As %String;

Property BatRequired As %String;

Property ExpdateRequired As %String;

Property Supervision As %String;

Property Barcode As %String;

Property PbFlag As %String;

Property PbRP As %String;

Property Vendor As %String;

Property Manf As %String;

Property Carrier As %String;

Property RegisterNo As %String;

Property RegisterExpdate As %String;

Property ProductionLicense As %String;

Property ProductionLicenseExpdate As %String;

Property BusinessLicense As %String;

Property BusinessLicenseDate As %String;

Property RevReg As %String;

Property OrgCode As %String;

Property OrgCodeDate As %String;

Property BusinessCertificate As %String;

Property BusinessCertificateExpdate As %String;

Property AuthorizationDate As %String;

Property ContactPerson As %String;

Property ContactTel As %String;

Property Remarks As %String;

Property PriceInformation As %String;

/// 入库转换系数  2017-03-21
Property INCICTUOMPurchFac As %String;

// Property ARCIMBillingUOMDR As %String;

/// 计价单位 2017-3-20
/// 计价转换系数
Property ARCIMBillingUOMFac As %String;

Property BillGrp As %String;

/// 医院 2019-02-24
Property ARCIMHOSPDR As %String;

/// 不可用标志  医大一
Property NotUseFlag As %String;

/// 收费项别名
Property TARIALIAS As %String;

/// 进口标志(进口/国产/合资)
Property ImportFlag As %String;

/// 质地
Property MatQuality As %String;

/// 植入标志(Y/N)
Property ImplantFlag As %String;

/// 集采标志(Y/N)
Property CentralPurFlag As %String;

/// 临采标志(Y/N)
Property TemPurchase As %String;

/// 本院目录标志(Y/N)
Property InHosFlag As %String;

/// 账簿分类
Property BookCat As %String;

}
