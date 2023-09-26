/// 名称：单双症状规则表
/// 描述：实体类
/// 编写者：基础数据平台组_xuwenhu
/// 编写日期：2021-06-02
Class web.CDSSEntity.CMKB.SingleSymptomRule Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.SingleSymptomRule";

Property ID As %String;

/// 规则编码
Property RuleCode As %String;

/// 一条规则共几行
Property RuleTotal As %String;

/// 症状名称
Property RuleSymptom As %String;

/// 年龄最小值
Property MinAge As %String;

/// 最小值操作符
Property MinAgeOpera As %String;

/// 年龄最大值
Property MaxAge As %String;

/// 最大值操作符
Property MaxAgeOpera As %String;

/// 性别
Property Gender As %String;

/// 疾病列表
Property RuleDiseases As %String;

/// 年龄最小值单位
Property MinAgeUnit As %String;

/// 年龄最大值单位
Property MaxAgeUnit As %String;

}
