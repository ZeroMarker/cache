/// Function: 地理信息-地址维护   
/// Creator:  sunfengchao
/// CreateDate: 2015-11-12
Class web.Entity.CT.CTAddress Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTAddress";

/// ID号
Property CTADDRowId As %String;

/// 代码
Property CTADDCode As %String;

/// 描述
Property CTADDDesc As %String;

/// 省
Property CTADDProvinceDR As %String;

/// 市
Property CTADDCityDR As %String;

/// 区/县
Property CTADDCityAreaDR As %String;

/// 街道
Property CTADDStreetDR As %String;

/// 社区 
Property CTADDCommunityDR As %String;

/// 省描述
Property CTADDProvinceDRDesc As %String;

/// 市描述
Property CTADDCityDRDesc As %String;

/// 区/县描述
Property CTADDCityAreaDRDesc As %String;

/// 街道描述
Property CTADDStreetDRDesc As %String;

/// 社区描述 
Property CTADDCommunityDRDesc As %String;

/// 拼音检索码 
Property CTADDSearchCode As %String;

/// 开始日期 
Property CTADDDateFrom As %String;

/// 结束日期 
Property CTADDDateTo As %String;

}
