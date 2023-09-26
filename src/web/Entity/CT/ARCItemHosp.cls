/// 名称: 医嘱项医院关联
/// 描述: 实体类 
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2014-10-20
Class web.Entity.CT.ARCItemHosp Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCItemHosp";

/// HOSP_RowId   HOSP_ParRef HOSP_RowId HOSP_Childsub HOSP_Hospital_DR 
Property HOSPRowId As %String;

/// 医嘱项DR ARCItmMast
Property HOSPParRef As %String;

/// 孩子
Property HOSPChildsub As %String;

/// 医院指向
Property HOSPHospitalDR As %String;

}
