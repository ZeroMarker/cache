/// Creator:Xuwenhu
/// CreatDate:2022-04-26
/// Description：配置分类表实体类
/// Table：CF.WDT.CDSS.ConfigCategory
Class web.CDSSEntity.Config.ConfigCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Config.ConfigCategory";

Property RowId As %String;

/// 类别代码
Property CategoryCode As %String;

/// 类别描述
Property CategoryDesc As %String;

/// 父级
Property CategoryParentDR As %String;

/// 父级
Property CategoryParentDesc As %String;

/// 是否激活
Property CategoryActive As %String;

/// 操作人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 备注
Property Remarks As %String;

}
