/// 名称: 门诊费用大类 
/// 描述: 实体类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-2
Class web.Entity.CT.DHCTarOC Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarOC";

/// RowId
Property TARTOCRowId As %String;

/// 代码
Property TARTOCCode As %String;

/// 描述
Property TARTOCDesc As %String;

}
