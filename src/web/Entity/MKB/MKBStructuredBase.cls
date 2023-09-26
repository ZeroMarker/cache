/// 石萧伟
/// 2019-07-18
/// 工厂注册
Class web.Entity.MKB.MKBStructuredBase Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBStructuredBase";

Property Rowid As %String;

/// 名称
Property MKBSTBDesc As %String;

/// icd配置
Property MKBSTBICDDr As %String;

/// 结构化配置
Property MKBSTBStrDr As %String;

/// 数据来源配置项	配置项1,配置项2
Property MKBSTBSource As %String;

/// 是否录入非标ICD诊断
/// Property MKBSTBNonstandardFlag As %String;
/// 实际科室
Property MKBSTBLocDr As %String;

/// 标识，区分手术和诊断工厂
Property MKBSTBODFlag As %String;

}
