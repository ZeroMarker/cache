/// Description：手术字典表
/// Table：CT.WDT.CDSS.OperationDict 
Class web.CDSSEntity.CMKB.OperationDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.OperationDict";

/// OperationRowId
Property OperationRowId As %String;

///  国家（国际）编码
Property OperationNationCode As %String;

/// 手术编码
Property OperationCode As %String;

/// 手术名称
Property OperationName As %String;

/// 手术拼音
Property OperationPinyin As %String;

/// 汉语首拼
Property OperationFirstPinyin As %String;

/// 英文名
Property OperationEnglishName As %String;

/// ICD-9编码
Property ICD9Code As %String;

/// ICD-9名称
Property ICD9Name As %String;

Property DeptName As %String;

/// 手术类别
Property OperationClass As %String;

Property UseFlag As %String;

Property UpdateDate As %String;

Property UpdateUser As %String;

Property Remarks As %String;

/// 		引用标志
Property QuoteFlag As %String;

/// 		知识数量
Property KnowledgeTotal As %String;

/// 别名
Property OperAliasName As %String;

/// 版本
Property Version As %String;

// 手术分类

// Property OperationCategory As %String;

// 手术分级

// Property OperationGrade As %String;

/// 麻醉方式
Property AnesthesiaMode As %String;

}
