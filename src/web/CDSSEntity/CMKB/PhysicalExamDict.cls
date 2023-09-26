/// 名称:临床决策支持-体格检查字典表 
/// 描述:实体类
/// 编写者:基础平台组 - 钟荣枫
/// 编写日期:2020-6-29
Class web.CDSSEntity.CMKB.PhysicalExamDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.PhysicalExamDict";

// rowid

Property PhysicalExamID As %String;

/// 体格检查编码
Property PhysicalExamCode As %String;

/// 体格检查名称
Property PhysicalExamName As %String;

/// 体格检查概述
Property PhysicalExamDesc As %String;

/// 体格检查说明
Property PhysicalExamExplain As %String;

/// 体格检查值域
Property PhysicalExamValue As %String;

/// 备注
Property Remarks As %String;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String;

/// 使用标志（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 别名
Property PhysicalExamAlias As %String;

}
