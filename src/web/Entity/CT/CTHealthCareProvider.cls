/// Function: 病人管理-健康医护人员
/// CreateDate: 2015-3-2
/// Creator: sunfengchao
Class web.Entity.CT.CTHealthCareProvider Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

///  HCP_RowId HCP_Code HCP_Desc HCP_HCA_DR HCP_InternAgreem_DR  HCP_Region_DR
Parameter PersistentClassName = "web.Entity.CT.CTHealthCareProvider";

Property HCPRowId As %String;

/// 代码
Property HCPCode As %String;

/// 描述
Property HCPDesc As %String;

/// 健康保护区域
Property HCPHCADR As %String;

/// 国际协定
Property HCPInternAgreemDR As %String;

/// 区域
Property HCPRegionDR As %String;

/// 有效标志
Property HCPActiveFlag As %String;

}
