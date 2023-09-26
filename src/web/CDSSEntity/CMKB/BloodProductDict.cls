/// Description：输血品字典表 
/// Table：CT.WDT.CDSS.BloodProductDict
Class web.CDSSEntity.CMKB.BloodProductDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.BloodProductDict";

/// BPRowId
Property BPRowId As %String;

///  国家（国际）编码
Property BPNationCode As %String;

/// 输血品编码
Property BPCode As %String;

/// 输血品名称
Property BPName As %String;

/// 输血品项目概述
Property BPOverview As %String;

/// 输血品拼音
Property BPNamePinyin As %String;

/// 汉语首拼
Property BPNameFirstPinyin As %String;

/// 英文名
Property BPEnglishName As %String;

/// 输血品分类编码
Property BPClassCodeDR As %String;

/// 输血品分类描述
Property BPClassDesc As %String;

/// 血型概述
Property BloodTypeDesc As %String;

Property IndicationDesc As %String;

Property TabooDesc As %String;

Property PrecautionDesc As %String;

Property AdverseReactionsDesc As %String;

Property DiseaseDesc As %String;

Property ComplicationDesc As %String;

Property SubstituteDesc As %String;

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String;

/// 知识数量
Property KnowledgeTotal As %String;

/// 更新时间
Property UpdateDate As %String;

/// 更新人员
Property UpdateUser As %String;

/// 使用标识（0编辑中，1已删除，2已审核）
Property UseFlag As %String;

/// 备注
Property Remarks As %String;

/// 别名
Property BPAlias As %String;

}
