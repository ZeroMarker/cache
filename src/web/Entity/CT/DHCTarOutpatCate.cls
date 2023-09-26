/// 名称: 门诊费用子类 
/// 描述: 实体类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-2
Class web.Entity.CT.DHCTarOutpatCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarOutpatCate";

/// RowId        
Property TAROCRowId As %String;

/// 代码
Property TAROCCode As %String;

/// 描述
Property TAROCDesc As %String;

/// 门诊费用大类
Property TAROCTARTOCDR As %String;

}
