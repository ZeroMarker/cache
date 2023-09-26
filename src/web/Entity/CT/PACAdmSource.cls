/// 名称: 许可来源维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.PACAdmSource Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACAdmSource";

/// RowId号
Property ADSOURowId As %String;

/// 代码
Property ADSOUCode As %String;

/// 描述
Property ADSOUDesc As %String;

/// 开始日期
Property ADSOUDateFrom As %String;

/// 结束日期
Property ADSOUDateTo As %String;

/// Episode Type
Property ADSOUEpisodeType As %String;

}
