/// 名称:		EMR.DOC.DTO.KBCategory
/// 描述:		文档片段--目录传输对象
/// 编写者：	duan
/// 编写日期: 	2021-05-06
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.KBCategory Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 项目标识
Property Product As CT.EMR.DOC.Products;

/// 节点类型
Property KBCategoryTypes As %String;

/// 科室
Property CTLoc As %String;

/// 文档结构 CF.EMR.DOC.BDMCategory表中StructType为document类型(KBCategoryTypes为document)
Property BDMCategory As %String;

/// 父节点ID
Property ParentID As %String(TRUNCATE = 1);

/// 在同级节点中的显示次序
Property CategorySeq As %Integer;

/// 子节点数（节点为Section类型）
Property ResChildCount As %Integer;

Property ParentType As %String;

/// 病种
Property Disease As %String;

}
