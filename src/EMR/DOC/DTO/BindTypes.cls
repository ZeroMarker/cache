/// 名称:EMR.DOC.DTO.BindTypes
/// 描述:通用文档管理模块 数据集类型传输对象
/// 编写者：yejian
/// 编写日期: 2020-9-29
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.BindTypes Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 项目标识
Property Product As %String(TRUNCATE = 1);

/// 编码(EpisodeID/UserID/EventID)
Property Code As %String(TRUNCATE = 1);

/// 名称(就诊号/登录号/手术ID/)
Property Name As %String(TRUNCATE = 1);

/// 描述(就诊号/登录号/手术ID/)
Property Description As %String(TRUNCATE = 1);

}
