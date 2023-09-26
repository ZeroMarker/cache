/// 名称:EMR.DOC.DTO.TemplateStatusMLog
/// 描述:通用文档管理模块 Document(Doc) 数据传输对象
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-09
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.TemplateStatusMLog Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// 文档版本
Property TemplateVersion As %String;

/// 使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除(发布不允许删，删备注必填) 
Property Status As %String(TRUNCATE = 1);

/// 创建者ID
Property CreateID As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 修改者ID
Property ModifyID As %String;

/// 修改日期
Property ModifyDate As %Date;

/// 修改时间
Property ModifyTime As %Time;

/// 申请者ID
Property ApplicationID As %String;

/// 申请日期
Property ApplicationDate As %Date;

/// 申请时间
Property ApplicationTime As %Time;

/// 审核者ID
Property AuditID As %String;

/// 审核日期
Property AuditDate As %Date;

/// 审核时间
Property AuditTime As %Time;

/// 操作IP地址
Property OperateMachineIP As %String;

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

}
