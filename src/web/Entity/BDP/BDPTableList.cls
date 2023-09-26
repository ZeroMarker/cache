/// Function: 表结构实体类
/// Creaor: 谷雪萍
Class web.Entity.BDP.BDPTableList Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPTableList";

Property ID As %String;

/// 表名称
Property TableName As %String;

/// 表中文名称
Property TableDesc As %String;

/// 获取 这个表中的中文描述字段值 
/// 使用X执行
Property XCode As %String;

Property Type As %String;

Property XCode2 As %String;

Property Sources As %String;

Property ClassName As %String;

Property TableGlobal As %String;

/// 2019-06-28
Property DataType As %String;

/// 2019年12月19日 版本号维护
Property VersionFlag As %String;

/// 是否使用公共私有数据关联表
Property MappingHospFlag As %String;

/// 是否特别 2020年4月29日
Property SpecialFlag As %String;

/// 属性 基础数据/配置数据	2020年5月7日
Property Attribute As %String;

/// 描述在表里的字段名	2020年6月16日
Property DescPropertyName As %String;

/// 代码在表里的字段名  2020年6月16日
Property CodePropertyName As %String;

/// 标准数据类型 国标/行标/省标/企标
Property StandardDataType As %String;

/// 标准数据版本
Property StandardDataVersion As %String;

/// 增删改管控权限	2021-09-05
Property AUDControlRights As %String;

/***************增删改管控权限窗口勾选***2021-09-05**************/
/// 禁止新增
Property BanAdd As %String;

/// 禁止修改
Property BanUpdate As %String;

/// 禁止删除
Property BanDelete As %String;

}
