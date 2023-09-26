/// Function: 医疗单元医护人员定义,作为医疗单元的子表
/// Creator:  sunfengchao
/// CreateDate：2015-12-30
Class web.Entity.CT.DHCCTLocMedUnitCareProv Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCCTLocMedUnitCareProv";

/// Paref 医疗单元对象
Property MUCPParRef As %String;

/// Childsub
Property MUCPChildsub As %String;

/// RowId
Property MUCPRowId As %String;

/// 医护人员指针
Property MUCPDoctorDR As %String;

/// 医生工号 MUCPDoctorDR->CTPCPCode
Property CTPCPCode As %String;

/// 医生姓名 MUCPDoctorDR->CTPCPDesc
Property CTPCPDesc As %String;

/// 组长标志
Property MUCPLeaderFlag As %String;

/// 门诊出诊标志
Property MUCPOPFlag As %String;

/// 住院出诊标志
Property MUCPIPFlag As %String;

/// 开始日期
Property MUCPDateFrom As %String;

/// 结束日期
Property MUCPDateTo As %String;

/// 开始时间
Property MUCPTimeFrom As %String;

/// 截止时间
Property MUCPTimeTo As %String;

}
