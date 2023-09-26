/// 名称:	EMR.OP.DTO.DocCategory
/// 描述:	门诊病历-病历导航参数对象
/// 编写者：yejian
/// 编写日期: 2022-5-24
/// 产品组：电子病历产品组
Class EMR.OP.DTO.DocCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowID
Property ID As %String;

/// 业务活动记录分类ID 
Property ParentID As %String;

/// 就诊号   
Property EpisodeID As %String;

/// 用户ID
Property UserID As %String;

/// 展现类型，卡片 "Card",列表 "List" 
Property ResultType As %String;

/// 事件类型 
Property EventType As %String;

/// 事件ID 
Property EventID As %String;

/// 本科ID 
Property CTLocID As %String;

/// 安全组ID 
Property SSGroupID As %String;

/// 业务活动记录分类编码 
Property DOCCategoryCode As %String;

/// 业务活动记录分类编码(条件过滤)
Property DOCCategoryCodeFilter As %String;

/// 业务活动记录编码
Property DOCCode As %String;

/// 其他科室ID，所有 "ALL" 
Property OtherCTLocID As %String;

/// 搜索条件 
Property Text As %String;

/// 诊断 
Property DiseaseCodeAndName As %String;

/// 项目标识编码
Property ProductCode As %String;

/// 顺序展示（-1 降序，1或空 正序） 
Property Order As %String;

/// 病历状态（Sign:签名，Save:保存） 
Property Status As %String;

/// 语言ID
Property LangID As %String;

/// 文档ID
Property DocumentID As %String;

}
