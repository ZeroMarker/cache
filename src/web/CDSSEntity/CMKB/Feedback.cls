/// 名称:CDSS反馈意见
/// 描述:实体类
/// 编写者:基础数据平台组 - 谷雪萍
/// 编写日期:2021-3-4
Class web.CDSSEntity.CMKB.Feedback Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.Feedback";

/// rowid
Property ID As %String;

/// 意见入口
Property OpinionPortal As %String;

/// 反馈意见
Property Feedback As %String;

/// 创建科室
Property CreateLoc As %String;

/// 创建人员
Property CreateUser As %String;

/// 创建时间
Property CreateTime As %String;

/// 意见入口分类：评估表、文献
Property OpinionPortalType As %String;

}
