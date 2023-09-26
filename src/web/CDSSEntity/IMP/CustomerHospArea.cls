/// 名称:实施综合管理平台-字典对照1.0
/// 描述:实体类
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2022=1-21
Class web.CDSSEntity.IMP.CustomerHospArea Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.IMP.CustomerHospArea";

/// 父表指针
Property ParRef As %String;

// rowid

Property HospAreaID As %String;

/// 院区代码
Property HospAreaCode As %String;

/// 院区名称
Property HospAreaDesc As %String;

/// 开始日期
Property StartDate As %String;

/// 截止日期
Property EndDate As %String;

}
