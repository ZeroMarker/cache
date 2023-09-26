/// 名称: 病历业务域对象
/// 描述: 病历业务域对象
/// 编写者：叶剑
/// 编写日期: 2020-5-13
Class EMRservice.entity.EEMRStructure Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 结构类型枚举值，目录：Category,文档：Document
Property StructType As %String(TRUNCATE = 1);

/// 结构描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构编码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 关联上级节点Code
Property ParentCode As %String(TRUNCATE = 1);

/// 关联上级节点
Property ParentID As %String(TRUNCATE = 1);

/// 术语集内部标识符
Property GlossaryInternalID As %String(TRUNCATE = 1);

}
