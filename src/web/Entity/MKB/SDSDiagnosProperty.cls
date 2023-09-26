/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：结构化诊断属性及内容实体类
/// Table：User.SDSDiagnosProperty
Class web.Entity.MKB.SDSDiagnosProperty Extends %RegisteredObject
{

Parameter PersistentClassName = "web.Entity.MKB.SDSDiagnosProperty";

Property SDSRowId As %String;

/// 属性id
Property SDSPropertyDR As %String;

/// 属性内容id
Property SDSProDetail As %String;

/// 标识
Property SDSFlag As %String;

}
