/// 名称:化学通用名导入实体类
/// 编写者基础数据平台组-陈莹
/// 编写日期: 2018-11-25
Class web.BDPExt.DHCPHChemicalEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.DHCPHChemicalEntity";

/// rowid
Property PHCMRowId As %String;

/// 药学分类代码
Property PHCCCode As %String;

/// 药学分类描述
Property PHCCDesc As %String;

/// 化学通用名代码
Property PHCMCode As %String;

/// 化学通用名名称
Property PHCMDesc As %String;

/// 处方通用名代码
Property PHCGECode As %String;

/// 处方通用名描述
Property PHCGEName As %String;

/// 处方通用名别名
Property DataAlias As %String;

/// 处方通用名剂型
Property PHCGEPHCFDr As %String;

/// 开始日期
Property PHCGEDateFrom As %String;

/// 结束日期
Property PHCGEDateTo As %String;

/// 药学分类的医院DR
Property PHCCHospDr As %String;

}
