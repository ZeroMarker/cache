/// Function: 医嘱项 性别/年龄实体类
/// Creator:  sunfengchao
/// CreateDate: 2014/11/4
Class web.Entity.CT.ARCItemAgeSexRestriction Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCItemAgeSexRestriction";

Property AGERowId As %String;

/// ref
Property AGEParRef As %String;

/// 开始年龄
Property AGEAgeFrom As %String;

/// 结束年龄
Property AGEAgeTo As %String;

/// 年龄DR
Property AGESexDR As %String;

/// 从年龄类型 （岁/月/日） ^4
Property AGEAgeFromType As %String;

/// 到年龄类型 （岁/月/日） ^5
Property AGEAgeToType As %String;

}
