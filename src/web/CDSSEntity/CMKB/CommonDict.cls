/// 名称:通用名字典表V2.0
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2020-1-14
Class web.CDSSEntity.CMKB.CommonDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.CommonDict";

/// rowid
Property ID As %String;

/// 通用名字典类型
Property TypeDR As %String;

/// 通用名代码
Property DictCode As %String;

/// 通用名名称
Property DictDesc As %String;

/// 使用标志（0在用，1停用）
Property UseFlag As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 备注
Property Remarks As %String;

/// 默认单位
Property DefaultUnitDR As %String;

/// 英文名称
Property EnName As %String;

/// 别名
Property DictAlias As %String;

}
