/// 名称: ICD诊断代码别名维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2014-7-18
Class web.Entity.CT.MRCICDAlias Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.MRCICDAlias";

/// ALIASParRef
Property ALIASParRef As %String;

/// RowId
Property ALIASRowId As %String;

/// 别名
Property ALIASText As %String;

}
