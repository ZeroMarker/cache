///  名称：		EMRservice.entity.EKBNodeShare
///  描述：		个人知识库分享数据
///  编写者：	yejian
///  编写时间：	2019-6-20
Class EMRservice.entity.EKBNodeShare Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// EMRmeta.KBNode表ID
Property KBNodeID As %String;

/// 分享者UserID
Property UserID As %String;

/// 科室ID
Property CTLocID As %String;

/// KBNodeID 关联的 EMRmeta.KBTree表中ParentID为0的KBTreeID（知识库目录与科室关联的一级）
Property KBTreeParentID As %String(TRUNCATE = 1);

/// 使用状态 1 已审核,2 申请审核, 审核不通过，取消分享该数据，物理删除
Property Status As %String(TRUNCATE = 1);

/// 审核者ID
Property AuditID As %String;

/// 审核时间
Property AuditDate As %String;

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

}
