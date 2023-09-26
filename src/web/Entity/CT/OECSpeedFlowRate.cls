/// 名称: 输液流速单位界面
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2015-6-26
Class web.Entity.CT.OECSpeedFlowRate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECSpeedFlowRate";

/// RowId号
Property SFRRowId As %String;

/// 代码
Property SFRCode As %String;

/// 描述
Property SFRDesc As %String;

}
