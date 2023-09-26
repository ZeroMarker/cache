/// 名称:症状字典表V2.0
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2021-1-15
Class web.CDSSEntity.CMKB.SymptomDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.SymptomDict";

/// rowid
Property ID As %String;

/// 症状代码
Property SymptomCode As %String;

/// 症状名称
Property SymptomDesc As %String;

/// 别名
Property SymptomAlias As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 备注
Property Remarks As %String;

}
