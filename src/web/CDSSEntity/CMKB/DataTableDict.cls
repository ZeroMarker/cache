/// 名称:实施综合管理平台-数据库字典表
/// 描述:实体类
/// 编写者:基础数据平台组 - 阚延新
/// 编写日期:2020-10-21
Class web.CDSSEntity.CMKB.DataTableDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DataTableDict";

/// rowid
Property ID As %String;

/// 表空间名
Property TableSpaceName As %String;

/// 数据表顺序号
Property TableNum As %String;

/// 数据表名称
Property TableName As %String;

/// 数据表字段顺序号
Property TableFieldNum As %Integer;

/// 数据表字段数据描述
Property TableFieldName As %String;

/// 数据表字段数据类型
Property TableFieldClass As %String;

/// 数据表字段长度
Property TableFieldLength As %String;

/// 数据表字段主键标记（0是，1否）
Property TableFieldKeyFlag As %String;

/// 数据表字段外键
Property TableFieldFkey As %String;

/// 数据表字段默认值
Property TableFieldDefaults As %String;

/// 数据表字段描述
Property TableFieldDesc As %String;

/// 备注
Property Remarks As %String;

/// 患者模型数据类型
Property PMDataType As %String;

}
