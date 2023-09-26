Class EMR.DOC.DTO.LocTemplateVersion Extends %RegisteredObject
{

/// 起效日期
Property EffectiveDate As %Date;

/// 起效时间
Property EffectiveTime As %Time;

/// 使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
Property Status As %Integer;

/// 模板编码
Property Template As %String;

/// 模板版本
Property TepmplateVersionNumber As %Integer;

/// /word/document.xml
Property DocumentData As %GlobalBinaryStream;

}
