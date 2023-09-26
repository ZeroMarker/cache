/// Functgion: 多院区业务 
/// CreateDate:2021-07-02
/// Creator:   sunfengchao
Class web.Entity.CT.BDPMultiHospitalService Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPMultiHospitalService";

Property ID As %String;

/// 代码
Property BDPMHOSPServiceCode As %String;

/// 功能
Property BDPMHOSPServiceDesc As %String;

/// 类型：受限  不受限   
Property BDPMHOSPServiceType As %String;

}
