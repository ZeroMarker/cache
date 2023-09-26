/// CTOR: QP
/// DATE: 2020-10-27
/// DESC: 化疗模板备注导入
Class DHCDoc.Chemo.Model.ImportTPLNote Extends %RegisteredObject
{

/// 模板ID
Property TPID As %String;

/// 模板类型
Property TPType As %String;

/// 模板描述
Property TPDesc As %String;

/// 方案名称
Property TPName As %String;

/// 主药备注
Property TPNote As %String;

/// 化疗标题
Property TPTitle As %String;

/// 化疗方案别名
Property TPOtherName As %String;

}
