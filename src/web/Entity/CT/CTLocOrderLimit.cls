/// Function: 科室开医嘱限制
/// CreateDate:2019-11-08
/// Creator: sunfengchao
Class web.Entity.CT.CTLocOrderLimit Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTLocOrderLimit";

/// DEP_ParRef   
Property OrderLimtParRef As %String;

/// OrderLimt_RowId
Property OrderLimtRowId As %String;

/// OrderLimt_ARCItmMast_DR
Property OrderLimtARCItmMastDR As %String;

}
