/// Functgion: 多院区业务  配置分类 数据明细
/// CreateDate:2021-07-02
/// Creator:   sunfengchao
Class web.Entity.CT.BDPHospSerConfigCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPHospSerConfigCategory";

Property ID As %String;

Property ServiceConfigParRef As %String;

Property childsub As %String;

/// 数据指向id
Property BDPMHOSPCateReference As %String;

}
