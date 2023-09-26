/// 名称:		EMR.DOC.DTO.TextKBContent
/// 描述:		专科知识库 内容
/// 编写者：	zhangxl
/// 编写日期: 	2021-7-27
/// 产品组：	电子病历产品组
Class EMR.DOC.DTO.TextKBContent1 Extends %RegisteredObject
{

/// 目录
Property CategoryID As %String;

/// 创建者UserID
Property UserID As %String;

/// 创建时间
Property CreateDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 审核者ID
Property AuditID As %String;

/// 审核时间
Property AuditDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 使用状态 0 未审核，1 已审核,2 申请审核,3 重新申请审核,4 审核不通过,-1 已删除 
Property Status As %String;

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 专科文本
Property Content As %GlobalCharacterStream;

}
