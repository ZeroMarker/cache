/// 名称:通用字类型典表V2.0 
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2020-1-14
Class web.CDSSEntity.CMKB.CommonDictType Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.CommonDictType";

/// rowid
Property ID As %String;

/// 类型代码
Property TypeCode As %String;

/// 类型描述（目前有月经婚育字典、妊娠/产后状态字典、生命体征字典、麻醉方式字典、存在状态字典）
Property TypeDesc As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 备注
Property Remarks As %String;

/// 别名
Property TypeAlias As %String;

}
