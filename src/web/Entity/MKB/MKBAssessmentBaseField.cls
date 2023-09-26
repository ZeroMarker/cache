/// Creator:李欣
/// CreatDate:20180510
/// Description：医用知识库评分表注册字段实体类
/// Table：User.MKBAssessmentBaseField
Class web.Entity.MKB.MKBAssessmentBaseField Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBAssessmentBaseField";

Property MKBABFParRef As %String;

Property MKBABFRowId As %String;

/// 代码
Property MKBABFCode As %String;

/// 展示名
Property MKBABFDesc As %String;

/// 字段类型
Property MKBABFType As %String;

/// 字段配置项
Property MKBABFConfig As %String;

/// 顺序
Property MKBABFSequence As %String;

}
