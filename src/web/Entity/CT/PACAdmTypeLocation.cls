/// 名称: 访问类型位置维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-29
Class web.Entity.CT.PACAdmTypeLocation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACAdmTypeLocation";

/// rowid
Property ADMLOCRowId As %String;

/// 病人类型
Property ADMLOCAdmType As %String;

/// 位置
Property ADMLOCCTLOCDR As %String;

}
