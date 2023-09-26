/// 名称:治疗方案字典表
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-1-7
Class web.CDSSEntity.CMKB.UnitDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.UnitDict";

/// rowid
Property ID As %String;

/// 单位代码
Property UnitCode As %String;

/// 单位名称
Property UnitDesc As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 备注
Property Remarks As %String;

/// 别名
Property Alias As %String;

}
