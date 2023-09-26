/// Creator:李欣
/// CreatDate:20180510
/// Description：医用知识库知识点映射注册字段实体类
/// Table：User.MKBKLMappingBaseField
Class web.Entity.MKB.MKBKLMappingBaseField Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBKLMappingBaseField";

Property MKBKMBFParRef As %String;

Property MKBKMBFRowId As %String;

/// 代码
Property MKBKMBFCode As %String;

/// 展示名
Property MKBKMBFDesc As %String;

/// 字段类型
Property MKBKMBFType As %String;

/// 字段配置项
Property MKBKMBFConfig As %String;

/// 顺序
Property MKBKMBFSequence As %String;

}
