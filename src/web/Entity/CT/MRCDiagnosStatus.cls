/// 名称: 系统转移
/// 描述: 实体类
/// 编写者：基础数据平台组-丁亚男
/// 编写日期: 2017-12-21
Class web.Entity.CT.MRCDiagnosStatus Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.MRCDiagnosStatus";

/// RowId
Property DSTATRowId As %String;

/// 代码
Property DSTATCode As %String;

/// 描述
Property DSTATDesc As %String;

}
