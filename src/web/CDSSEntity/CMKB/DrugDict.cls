/// Description：药物字典表
/// Table：CT.WDT.CDSS.DrugDict 
Class web.CDSSEntity.CMKB.DrugDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DrugDict";

/// DrugRowId
Property DrugRowId As %String;

/// 国家（国际）编码
Property DrugNationCode As %String;

/// 公司编码
Property DrugCode As %String;

/// 通用名（中文名）
Property DrugName As %String;

/// 汉语拼音
Property DrugNamePinyin As %String;

/// 汉语首拼
Property DrugNameFirstPinyin As %String;

/// 英文名
Property DrugEnglishName As %String;

/// 药物一级分类编码
Property DrugFirstClass As %String;

/// 药物二级分类编码
Property DrugSecondClass As %String;

/// 药物三级分类编码
Property DrugClass As %String;

/// 药物概述
Property DrugOverview As %String;

/// 适应症概述
Property IndicationOverview As %String;

/// 用法用量概述
Property DosageOverview As %String;

/// 不良反应概述
Property AdverseReactions As %String;

/// 禁忌症概述
Property Contraindications As %String;

/// 辅料信息概述
Property DrugAccessories As %String;

/// 适用情况概述
Property DrugApplication As %String;

/// 相互作用概述
Property DrugInteraction As %String;

/// 药物过量概述
Property DrugOverdose As %String;

/// 备注
Property Remarks As %String;

/// 引用标志 D（Decision）被决策知识库引用 K（Knowledge） 被医为百科引用 R（Rule） 被规则知识库引用 M（Mapping）数据对照
Property QuoteFlag As %String;

/// 知识数量
Property KnowledgeTotal As %String;

/// 药监局报批
Property ApprovalFlag As %String;

/// 剂型
Property DrugType As %String;

/// 别名
Property DrugAlias As %String;

/// 药物类
Property DrugCategory As %String;

/// 化学名
Property DrugChemicalName As %String;

/// 成分
Property DrugComposition As %String;

/// 商品名
Property DrugTradeName As %String;

/// 状态 (编辑中 0 ,已审核 1)
Property MaintainFlag As %String;

/// 创建时间
Property CreateDate As %String;

/// 创建人员
Property CreateUserID As %String;

}
