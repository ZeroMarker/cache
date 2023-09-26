/// Description：文献管理表
/// Table：CT.WDT.CDSS.DocuManage
Class web.CDSSEntity.CMKB.DocuManage Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DocuManage";

/// RowId
Property RowId As %String;

/// 文献代码
Property DocuCode As %String;

/// 中文文献名称
Property DocuDesc As %String;

/// 英文文献名称
Property DocuEngDesc As %String;

/// 文献路径
Property DocuPath As %String;

/// 关键词
Property DocuKeyWords As %String;

/// 类型
Property DocuType As %String;

/// 发布机构
Property DocuInstitution As %String;

/// 指南出处
Property DocuSource As %String;

/// 发布年月
Property DocuMonth As %String;

/// 关联文献
Property DocuAssociation As %String;

/// 状态
Property DocuState As %String;

/// 修改时间
Property DocuModifyDate As %String;

/// 修改人
Property DocuModifyUser As %String;

/// 审核人
Property DocuReviewer As %String;

/// 关联诊断
Property Disease As %String;

/// 关联科室
Property Dept As %String;

/// 路径修改标识:新增/删除
Property PathFlag As %String;

/// 关联诊断条件【识别词】
Property Words As %String;

}
