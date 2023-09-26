/// Creator:李欣
/// CreatDate:20180510
/// Description：医用知识库知识点映射注册实体类
/// Table：User.MKBKLMappingBase
Class web.Entity.MKB.MKBKLMappingBase Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBKLMappingBase";

/// RowId
Property MKBKMBRowId As %String;

/// 代码
Property MKBKMBCode As %String;

/// 标题
Property MKBKMBDesc As %String;

/// 映射关系
Property MKBKMBMappingRelation As %String;

/// 知识点1
Property MKBKMBKnowledge1 As %String;

/// 知识点2
Property MKBKMBKnowledge2 As %String;

/// 备注
Property MKBKMBNote As %String;

/// 标识
Property MKBKMBFlag As %String;

/// 顺序
Property MKBKMBSequence As %String;

/// 知识库标识
Property MKBKMBIdentify As %String;

}
