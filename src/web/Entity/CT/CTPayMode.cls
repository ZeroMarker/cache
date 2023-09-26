/// 基础数据平台组  孙凤超
/// 支付方式维护 实体类
/// 2013-6-22
Class web.Entity.CT.CTPayMode Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

/// CTPMRowId CtpmCode  CtpmDesc CtpmDateFrom  CtpmDateTo  CtpmGrpCode  CTPMNotUseFlag CTPMChangeGiven
Parameter PersistentClassName = "web.Entity.CT.CTPayMode";

Property CTPMRowId As %String;

/// 代码
Property CTPMCode As %String;

/// 描述
Property CTPMDesc As %String;

/// 开始日期
Property CTPMDateFrom As %String;

/// 结束日期
Property CTPMDateTo As %String;

/// 支付类型
Property CTPMGrpCode As %String;

/// CTPMNotUseFlag
Property CTPMNotUseFlag As %String;

/// CTPMChangeGiven
Property CTPMChangeGiven As %String;

}
