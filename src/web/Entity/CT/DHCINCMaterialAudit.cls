/// Function:材料审批表
/// CreateDate:2023-04-18
/// Creator:sunfengchao
Class web.Entity.CT.DHCINCMaterialAudit Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.BDPINCItmAudit";

/// RowId
Property ID As %String;

/// 材料代码
Property BDPINCAMaterialCode As %String;

/// 材料名称 
Property BDPINCAMaterialDesc As %String;

/// 业务类型  (A 新增,U  修改)
Property BDPINCAType As %String;

///  spd数据同步日期
Property BDPINCACreatDate As %String;

///  spd数据同步时间
Property BDPINCACreatTime As %String;

///  spd推送的材料数据   
Property BDPINCAMaterialValue As %String;

/// 物价办审批状态 (N：未审核，Y：通过 ,R 拒绝）
Property BDPINCAWJAuditStatus As %String;

/// 物价办审批人  
Property BDPINCAWJAuditerDR As %String;

/// 物价办审批日期
Property BDPINCAWJAuditDate As %String;

/// 物价办审批时间
Property BDPINCAWJAuditTime As %String;

/// 医务处 审批状态 (N：未审核，Y：通过 ,R 拒绝）
Property BDPINCAYWAuditStatus As %String;

/// 医务处审批人
Property BDPINCAYWAuditerDR As %String;

/// 医务处审批日期
Property BDPINCAYWAuditDate As %String;

/// 医务处审批时间
Property BDPINCAYWAuditTime As %String;

///  物价办需审批的数据  (收费项主表字段)
Property BDPINCATarValue As %String;

///  医务处审批 医嘱项主表字段 
Property BDPINCAARCIMValue As %String;

/// 物价审批完成生成的收费项id  
Property BDPINCATarReference As %String;

/// 新增 医嘱项时存的医嘱id 
Property BDPINCAARCIMReference As %String;

///  库存项id 
Property BDPINCAMaterialReference As %String;

///  流程平台对应的流程实例 id 
Property BDPINCAProcInsId As %String;

/// 任务ID
Property taskId As %String;

}
