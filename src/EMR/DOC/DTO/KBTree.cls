/// 名称:	EMR.DOC.DTO.KBTree
/// 描述:	片段树数据传输对象
/// 编写者：yejian
/// 编写日期: 2022-11-1
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.KBTree Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 片段章节节点ID
Property KBSectionID As %String(TRUNCATE = 1);

/// 病种ID
Property DiseaseID As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 科室ID
Property UserLocID As %String(TRUNCATE = 1);

/// langid
Property LangID As %String(TRUNCATE = 1);

/// IsCollapse
Property IsCollapse As %String(TRUNCATE = 1);

}
