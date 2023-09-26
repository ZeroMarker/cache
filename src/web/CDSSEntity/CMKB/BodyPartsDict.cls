/// 名称:部位字典表
/// 描述:实体类
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期:2021-3-5
Class web.CDSSEntity.CMKB.BodyPartsDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.BodyPartsDict";

/// rowid
Property ID As %String;

/// 部位代码
Property PartsCode As %String;

/// 部位名称
Property PartsDesc As %String;

/// 使用标志（0已审核，1编辑中）
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
