/// 名称:	EMR.DOC.DTO.NIScattorRelation
/// 描述:	打散数据-解析关联数据
/// 编写者：	yejian
/// 编写日期: 	2022-11-24
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.NIScattorRelation Extends (%RegisteredObject, %XML.Adaptor)
{

/// 章节编码
Property SectionCode As %String(TRUNCATE = 1);

/// 片段编码
Property KBCode As %String(TRUNCATE = 1);

/// 片段原始编码
Property KBSourceCode As %String(TRUNCATE = 1);

/// 宏编码
Property MacroCode As %String(TRUNCATE = 1);

/// 宏原始编码
Property MacroSourceCode As %String(TRUNCATE = 1);

/// 牙位图编码
Property ToothImageCode As %String(TRUNCATE = 1);

/// 牙位图名称
Property ToothImageName As %String(TRUNCATE = 1);

/// 牙位图标识
Property ToothCodeSystem As %String(TRUNCATE = 1);

/// 牙位图标识名称
Property ToothCodeSystemName As %String(TRUNCATE = 1);

/// 牙编码
Property ToothCode As %String(TRUNCATE = 1);

/// 牙名称
Property ToothName As %String(TRUNCATE = 1);

}
