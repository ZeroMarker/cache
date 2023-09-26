/// 名称:方位字典
/// 描述:实体类
/// 编写者:基础数据平台组 - 胡宜良
/// 编写日期:2022-03-22
Class web.CDSSEntity.CMKB.ALLDictSearchSet Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.ALLDictSearchSet";

/// rowid
Property ID As %String;

/// 中文表名（与菜单名称保持一致）
Property TableDictDesc As %String;

/// 数据表名称
Property TableName As %String;

/// 数据表字段名称
Property TableFieldName As %String;

/// 数据表字段顺序号
Property TableFieldNum As %Integer;

/// 数据表字段描述
Property TableFieldDesc As %String(MAXLEN = "");

/// 菜单代码
Property MenuUrl As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 数据状态顺序号
Property DataStateNum As %String;

}
