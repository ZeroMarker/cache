/// 名称: 就诊分类维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.PACAdmCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACAdmCategory";

/// RowId号
Property ADMCATRowId As %String;

/// 代码
Property ADMCATCode As %String;

/// 描述
Property ADMCATDesc As %String;

/// 开始日期
Property ADMCATDateFrom As %String;

/// 结束日期
Property ADMCATDateTo As %String;

/// 先诊疗后付费
Property ADMCATIsPayAfterTrea As %String;

}
