/// Function:    别名维护的实体类
/// CreateDate:  2014-04-16
/// Creator:     基础数据平台组 孙凤超
Class web.Entity.CT.BDPAlias Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPAlias";

/// 表名称
Property TableName As %String;

/// 别名
Property DataAlias As %String;

/// ID
Property DataReference As %String;

Property AliasRowId As %String;

}
