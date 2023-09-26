/// 名称:实施综合管理平台-对接方字典关联院区表2.0
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2022=2-22
Class web.CDSSEntity.IMP.ConDictConArea Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.IMP.ConDictConArea";

Property ID As %String;

/// 对接方字典类型
Property ConDictType As %String;

/// 对接方字典DR
Property InterDictDR As %String;

/// 院区指针
Property HospAreaDR As %String;

}
