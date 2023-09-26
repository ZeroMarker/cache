/// Functgion: 多院区业务配置 
/// CreateDate:2021-07-02
/// Creator:   sunfengchao
Class web.Entity.CT.BDPHospitalServiceConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPHospitalServiceConfig";

Property ID As %String;

Property HospitalServiceParRef As %String;

Property childsub As %String;

/// 类型
Property BDPSerConfigType As %String;

///  当前医院
Property BDPSerConfigCurrenHospDR As %String;

/// 可操作医院
Property BDPSerConfigOperateHospDR As %String;

/// 项目：科室L、医嘱项O、医嘱子类I
Property BDPSerConfigCategory As %String;

}
