/// 名称: 中医法治
/// 描述: 实体类
/// 编写者：基础数据平台组 陈莹
/// 编写日期: 2020-12-22
Class web.Entity.CT.MRCTCMTreatment Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.MRCTCMTreatment";

/// RowId
Property TCMTRowId As %String;

/// 中医治法代码
Property TCMTCode As %String;

/// 中医治法名称
Property TCMTDesc As %String;

/// 编号
Property TCMTNumber As %String;

/// 国家标准名称
Property TCMTNationalDesc As %String;

/// 临床可用标识
Property TCMTValid As %String;

/// 开始日期
Property TCMTDateFrom As %String;

/// 结束日期
Property TCMTDateTo As %String;

/// 检索码
Property TCMTAlias As %String;

}
