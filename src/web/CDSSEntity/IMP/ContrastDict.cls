/// 名称:实施综合管理平台-字典对照表2.0
/// 描述:实体类
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-12-25
Class web.CDSSEntity.IMP.ContrastDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.IMP.ContrastDict";

// rowid

Property ID As %String;

/// 知识库字典代码
Property DictCode As %String;

/// 知识库字典描述
Property DictName As %String;

/// 对照类型(药品，诊断，检查检验，手术，护理）
Property ContrastType As %String;

/// 对接方字典代码
Property ConDictCode As %String;

/// 对接方字典描述
Property ConDictName As %String;

/// 状态（未关联/已关联/已确认/已删除）
Property State As %String;

/// 医院
Property HospitalDR As %String;

/// 备注
Property Remarks As %String;

/// CDSS字典DR	2021-5-31 zrf 增加知识库id和对接方id，以确定唯一
Property DictDR As %String;

/// 对接方字典DR
Property IntDictDR As %String;

}
