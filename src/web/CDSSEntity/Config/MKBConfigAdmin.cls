Class web.CDSSEntity.Config.MKBConfigAdmin Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Config.MKBConfigAdmin";

/// RowId
Property ID As %String;

/// 配置项代码
Property ConfigCode As %String;

/// 配置项描述
Property ConfigDesc As %String;

/// 配置项值
Property ConfigValue As %String;

/// 配置项类型
Property ConfigType As %String;

/// 配置项说明
Property ConfigExplain As %String;

/// 是否激活
Property ConfigActive As %String;

/// 是否可修改
Property ConfigEdit As %String;

/// 配置分类DR
Property ConfigCategory As %String;

/// 配置分类描述
Property ConfigCategoryDesc As %String;

/// 配置项所属版本
Property ConfigVersion As %String;

}
