/// 名称:		EMR.DOC.DTO.EMR.DOC.DTO.KBNode
/// 描述:		文档片段--片段传输对象
/// 编写者：	duan
/// 编写日期: 	2021-05-06
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.KBNode Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 节点名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 知识库描述信息
Property Description As %String(TRUNCATE = 1);

/// 唯一标示
Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 项目标识
Property Product As %String;

/// 起效日期
Property EffectiveDate As %Date;

/// 起效时间
Property EffectiveTime As %Time;

/// 使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
Property Status As %Integer;

/// 章节ID（KBCategoryTypes类型为Section）
Property SectionID As %String;

/// 父目录
Property KBCategory As %String;

/// 顺序
Property Sequence As %Integer;

/// /word/document.xml
Property DocumentData As %GlobalBinaryStream;

/// 纯文本内容
Property TextData As %String(MAXLEN = 30000, TRUNCATE = 1);

}
