/// Description：护理字典表 
/// Table：CT.WDT.CDSS.NursingDict
Class web.CDSSEntity.CMKB.NursingDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.NursingDict";

/// NursingRowId
Property NursingRowId As %String;

///  国家（国际）编码
Property NursingNationCode As %String;

/// 护理编码
Property NursingCode As %String;

/// 护理名称
Property NursingName As %String;

/// 护理项目概述
Property NursingOverview As %String;

/// 护理拼音
Property NursingNamePinyin As %String;

/// 汉语首拼
Property NursingNameFirstPinyin As %String;

/// 英文名
Property NursingEnglishName As %String;

/// 护理分类编码
Property NursingClassCodeDR As %String;

/// 护理分类描述
Property NursingClassDesc As %String;

/// 护理操作概述
Property NursingContent As %String;

Property NursingIndication As %String;

Property NursingTaboo As %String;

Property AdverseReactions As %String;

Property NursingPrecaution As %String;

Property Complication As %String;

Property ChildFlag As %String;

/// 引用标志
Property QuoteFlag As %String;

/// 知识数量
Property KnowledgeTotal As %String;

/// 创建时间
Property CreateDate As %String;

/// 创建人员
Property CreateUserID As %String;

/// 类型  护理/处置
Property NursingType As %String;

/// 状态 0 编辑中,1 已删除，2 已审核
Property UseFlag As %String;

/// 别名
Property NursingAliasName As %String;

}
