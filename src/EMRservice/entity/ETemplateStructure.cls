Class EMRservice.entity.ETemplateStructure Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// 结构类型枚举值，目录：Category,文档：Document,章节：Section
Property StructType As %String(TRUNCATE = 1);

/// 结构描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构编码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 关联上级节点
Property ParentID As %String(TRUNCATE = 1);

/// 是否是文档固定章节(True/False),仅在StructType='Section'数据上有效
Property IsFixedSection As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

/// 病历类型页码设置（页眉、页脚）
Property MetaTemplate As %GlobalCharacterStream(LOCATION = "^DHCEMRM.TemplateStructureS");

}
