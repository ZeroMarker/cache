/// 名称:检验字典表 
/// 描述:实体类
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-6-21
Class web.CDSSEntity.CMKB.LabInspectionDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.LabInspectionDict";

// rowid

Property LabRowId As %String;

/// 国家（国际）编码
Property LabNationCode As %String;

/// 公司编码
Property LabCode As %String;

/// 检验项目名称
Property LabName As %String;

/// 汉语拼音
Property LabNamePinyin As %String;

/// 汉语首拼
Property LabNameFirstPinyin As %String;

/// 英文名
Property LabEnglishName As %String;

/// 检验项目类型DR
Property LabClassCodeDR As %String;

/// 检验项目类型描述
Property LabClassDesc As %String;

/// 检验项目概述
Property LabDesc As %String;

/// 检验标本概述
Property LabSpecimen As %String;

/// 检验过程概述
Property LabProcess As %String;

/// 适用症概述
Property IndicationOverview As %String;

/// 禁忌症概述
Property LabTaboo As %String;

/// 不良反应概述
Property AdverseReactions As %String;

/// 注意事项概述
Property LabPrecautions As %String;

/// 检验结果概述
Property LabResult As %String;

/// 检验结果有效期（天）
Property LabResultExp As %String;

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
