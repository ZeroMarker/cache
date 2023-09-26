/// Function: 资源定义实体类
/// Creator:  sunfengchao
/// CreateDate:  2016-2-29
Class web.Entity.CT.RBResourceForOwn Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBResourceForOwn";

Property RESRowId1 As %String;

Property RESCTPCPDR As %String;

Property RESCTLOCDR As %String;

Property RESAdmittingRights As %String;

Property RESScheduleRequired As %String;

Property RESIgnorePubHol As %String;

Property RESMRRequest As %String;

Property RESDateActiveTo As %String;

Property RESDateActiveFrom As %String;

}
