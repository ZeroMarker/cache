/// Description：检查字典表
/// Table：CT.WDT.CDSS.ExamDict 
Class web.CDSSEntity.CMKB.ExamDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.ExamDict";

/// ExamRowId
Property ExamRowId As %String;

///  国家（国际）编码
Property ExamNationCode As %String;

/// 检查编码
Property ExamCode As %String;

/// 检查名称
Property ExamName As %String;

/// 检查拼音
Property ExamNamePinyin As %String;

/// 汉语首拼
Property ExamNameFirstPinyin As %String;

/// 英文名
Property ExamEnglishName As %String;

/// 检查一级分类编码
Property ExamFirstClass As %String;

/// 检查一级分类编码描述
Property FirstClassDesc As %String;

/// 检查二级分类编码
Property ExamSecondClass As %String;

/// 检查二级分类编码描述
Property SecondClassDesc As %String;

/// 检查三级分类编码
Property ExamClass As %String;

/// 检查三级分类编码描述
Property ClassDesc As %String;

/// 检查项目概述
Property ExamDesc As %String;

/// 检查部位概述
Property ExamParts As %String;

/// 检查过程概述
Property ExamProcess As %String;

/// 适用症概述
Property IndicationOverview As %String;

/// 禁忌症概述
Property ExamTaboo As %String;

/// 不良反应概述
Property AdverseReactions As %String;

/// 注意事项概述
Property ExamPrecautions As %String;

/// 检查结果概述
Property ExamResult As %String;

/// 备注
Property Remarks As %String;

/// 引用标志
Property QuoteFlag As %String;

/// 知识数量
Property KnowledgeTotal As %String;

/// 创建时间
Property CreateDate As %String;

/// 创建人员
Property CreateUserID As %String;

/// 别名
Property Alias As %String;

/// 状态
Property UseFlag As %String;

}
