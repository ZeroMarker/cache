/// 名称:诊断因子字典库V2.0 
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2020-1-11
Class web.CDSSEntity.CMKB.DiagFactorBase Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DiagFactorBase";

Property ID As %String;

/// 诊断因子编码(依据诊断因子分级编码)
Property DiagFactorCode As %String;

/// 诊断因子名称
Property DiagFactorName As %String;

/// 诊断因子分类诊断因子分类（诊断、症状、查体、生命体征、检查结果描述、检验结果标准、病因/诱因）
Property DiagFactorClass As %String;

/// 使用标志(0在用，1停用)
Property UseFlag As %String;

/// 创建时间
Property CreateDate As %String;

/// 创建人员
Property CreateUserID As %String;

/// 备注
Property Remarks As %String;

}
