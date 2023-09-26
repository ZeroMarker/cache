/// 名称: 严重事故类型维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.PACTrafAccidCode Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACTrafAccidCode";

/// RowId号
Property TRFRowId As %String;

/// 代码
Property TRFCode As %String;

/// 描述
Property TRFDesc As %String;

/// 开始日期
Property TRFDateFrom As %String;

/// 结束日期
Property TRFDateTo As %String;

}
