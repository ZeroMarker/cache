/// 医院楼表	Entity
/// 基础数据平台-李可凡
/// 2020年8月11日
Class web.Entity.CT.CTLocBuilding Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTLocBuilding";

/// RowId
Property CTLBRowId As %String;

/// Code
Property CTLBCode As %String;

/// Desc
Property CTLBDesc As %String;

/// Date From
Property CTLBDateFrom As %String;

/// Date To
Property CTLBDateTo As %String;

/// Mark
Property CTLBMark As %String;

/// HospitalDR
Property CTLBHospitalDR As %String;

}
