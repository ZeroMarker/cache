/// 名称:EMR.DOC.DTO.TemplateVersion
/// 描述:通用文档管理模块 Document(Doc) 文档模板版本管理
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-06
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.TemplateVersion Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 起效日期
Property EffectiveDate As %Date;

/// 起效时间
Property EffectiveTime As %Time;

/// 使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
Property Status As %Integer;

/// 模板ID
Property Template As %String;

/// 模板版本
Property TepmplateVersionNumber As %Integer;

/// 文档板式版本  CF.EMR.DOC.HFFormatVersion（默认关联最新发布版本）
Property HFVersion As %String;

/// /word/document.xml
Property DocumentData As %GlobalBinaryStream;

}
