/// 名称:		EMR.DOC.DTO.TextKBCategory
/// 描述:		专科知识库 目录对象
/// 编写者：	zhangxl
/// 编写日期: 	2021-7-27
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.TextKBCategory Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 目录名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

/// 目录类型
Property Type As %String(MAXLEN = 100, TRUNCATE = 1);

/// 父节点
Property ParentID As %Integer;

/// 目录顺序
Property Sequence As %Integer;

/// 是否有效
Property IsValid As %String(MAXLEN = 100, TRUNCATE = 1);

}
