/// Fucntion: 物资审批表 实体类
/// CreateDate: 2023-04-23
/// Creator：sunfengchao 
Class web.BDPExt.WZAuditEntity Extends (web.Entity.CT.INCMaterialEntity, web.Entity.CT.DHCAuditARCIM, web.Entity.CT.DHCAuditTarItem)
{

Parameter PersistentClassName = "web.BDPExt.WZAuditEntity";

Property ID As %String;

/// 医院  
Property ARCIMHOSPDR As %String;

}
