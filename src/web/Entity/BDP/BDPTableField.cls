/// 表字段维护实体类
/// Creaor：谷雪萍
Class web.Entity.BDP.BDPTableField Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPTableField";

Property ParRef As %String;

/// 表字段rowId
Property FieldRowId As %String;

/// 表字段名称
Property FieldName As %String;

/// 字段中文描述
Property FieldDesc As %String;

/// 表结构中定义的字段指向表的代码 只有DR类型的使用
Property FieldTabCode As %String;

/// 字段类型
Property FieldType As %String;

/// 是否可翻译
Property FieldTranslation As %String;

}
