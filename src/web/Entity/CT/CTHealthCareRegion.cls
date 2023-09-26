/// Function:   CTHealthCareRegion 实体类
/// CreateDate: 2015-3-3
/// Creator:　　sunfengchao
/// Others:     HCR_RowId HCR_Code HCR_Desc HCR_DateFrom HCR_DateTo
Class web.Entity.CT.CTHealthCareRegion Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHealthCareRegion";

/// RowId号
Property HCRRowId As %String;

/// 代码
Property HCRCode As %String;

/// 描述
Property HCRDesc As %String;

/// 开始日期
Property HCRDateFrom As %String;

/// 结束日期
Property HCRDateTo As %String;

}
