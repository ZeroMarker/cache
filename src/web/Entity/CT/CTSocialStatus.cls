/// 名称: 患者类别
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-30
Class web.Entity.CT.CTSocialStatus Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTSocialStatus";

/// RowId
Property SSRowId As %String;

/// 代码
Property SSCode As %String;

/// 描述
Property SSDesc As %String;

}
