/// 名称: 系统医嘱执行分类维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-4
Class web.Entity.CT.OECExecCateg Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECExecCateg";

/// RowId号
Property EXECRowId As %String;

/// 代码
Property EXECCode As %String;

/// 描述
Property EXECDesc As %String;

}
