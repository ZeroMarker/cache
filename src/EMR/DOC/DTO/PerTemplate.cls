/// 名称:	EMR.DOC.DTO.PerTemplate
/// 描述:	个人模板传输对象
/// 编写者：yejian
/// 编写日期: 2022-11-1
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.PerTemplate Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 就诊号
Property EpisodeID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 类型（个人目录:"category",个人节点:"node"）
Property Type As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 科室ID
Property UserLocID As %String(TRUNCATE = 1);

/// 目录顺序
Property Sequence As %Integer;

/// 父节点
Property ParentID As %Integer;

/// 病历ID
Property DocumentID As %String;

/// 模板ID
Property TemplateID As %String;

/// 使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
Property Status As %String(TRUNCATE = 1);

/// 分享为科室模板的科室ID，多个以^拼接
Property ShareLocID As %String(MAXLEN = 20000, TRUNCATE = 1);

Property LangID As %String(TRUNCATE = 1);

/// 章节内容
Property DocumentData As %GlobalCharacterStream;

}
