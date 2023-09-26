/// 名称:检查检验治疗
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.YZXEntity Extends (web.Entity.CT.ARCItmMast, web.Entity.CT.DHCTarItem, web.Entity.CT.DHCOrderLinkTar, web.Entity.CT.DHCTarItemPrice, web.Entity.CT.DHCTarItemAlias, web.Entity.CT.ARCAlias)
{

Parameter PersistentClassName = "web.BDPExt.YZXEntity";

// 2017-3-6

Property OrdCat As %String;

Property BillGrp As %String;

Property TarCat As %String;

Property InpaCat As %String;

Property OutpaCat As %String;

Property EmCat As %String;

Property AcctCat As %String;

Property MrCat As %String;

Property MrCatNew As %String;

/// 计价转换系数
Property ARCIMBillingUOMFac As %String;

/// 医院 2019-02-24
Property ARCIMHOSPDR As %String;

}
