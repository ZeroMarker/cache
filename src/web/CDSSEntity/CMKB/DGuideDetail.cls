/// Creator:胡宜良
/// CreatDate:2021-12-6
/// Description：出院指导详情
/// Table：CT.WDT.CDSS.DischargeGuide
Class web.CDSSEntity.CMKB.DGuideDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DGuideDetail";

Property ID As %String;

/// 出院指导指针
Property DGuideDR As %String;

/// 出院指导详情
Property DGuideDetail As %String;

/// 出院指导详情顺序
Property DGuideOrder As %String;

}
