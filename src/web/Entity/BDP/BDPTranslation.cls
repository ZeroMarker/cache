/// Creator:李欣
/// CreateDate：2017-09-12
/// Description：数据翻译表的Entity
/// Table:User.BDPTranslation
Class web.Entity.BDP.BDPTranslation Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPTranslation";

/// RowId
Property ID As %String;

/// 表名
Property BTTableName As %String;

/// 字段名
Property BTFieldName As %String;

/// 翻译语言
Property BTLanguages As %String;

/// 翻译前内容
Property BTFieldDesc As %String;

/// 翻译后内容
Property BTTransDesc As %String;

}
