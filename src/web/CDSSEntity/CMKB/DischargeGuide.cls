/// 名称:出院指导
/// 描述:实体类
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2021-11-23
Class web.CDSSEntity.CMKB.DischargeGuide Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DischargeGuide";

/// rowid
Property ID As %String;

/// 出院指导名称
Property DGuideName As %String(MAXLEN = "");

/// 来源
Property DGuideSource As %String;

/// 状态：4-待审核、3-已审核、2-已驳回、1-已弃用、0-编辑中
Property DGuideState As %String;

/// 编辑人
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %TimeStamp;

/// 审核人
Property AuditUser As %String;

}
