/// 名称: 医嘱项与收费项对照实体类 
/// 编写者：基础数据平台组-CHENYING
/// 编写日期: 2020-01-31
Class web.BDPExt.DHCOrderLinkTarEntity Extends web.Entity.CT.DHCOrderLinkTar
{

Parameter PersistentClassName = "web.BDPExt.DHCOrderLinkTarEntity";

/// 医嘱代码
Property OLTARCCode As %String;

/// 医嘱名称
Property OLTARCDesc As %String;

/// 收费项代码
Property OLTTARCode As %String;

/// 收费项描述
Property OLTTARDesc As %String;

}
