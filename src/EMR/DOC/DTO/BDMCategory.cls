/// 名称:		EMR.DOC.DTO.BDMCategory
/// 描述:		文档管理--业务数据模型目录传输对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-12
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.BDMCategory Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识
Property Product As %String;

/// 结构编码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 结构类型
Property StructType As %String;

/// 关联上级节点
Property ParentID As %String(TRUNCATE = 1);

/// 关联上级节点Code
Property ParentCode As %String(TRUNCATE = 1);

/// 是否是文档固定章节(True/False),仅在StructType='Section'数据上有效
Property IsFixedSection As %String(TRUNCATE = 1);

/// 不同类型的子节点数
Property ResChildCount As %Integer;

/// 排序
Property Sequence As %Integer;

/// Section关联CF.EMR.DOC.GlossaryItem表的ID集合,以^分隔，Category/Document关联CF.EMR.DOC.Glossary表ID
Property GlossaryItemIDS As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentType As %String;

}
