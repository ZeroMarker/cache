/// Description：用法字典表 
/// Table：CT.WDT.CDSS.UsageDict
Class web.CDSSEntity.CMKB.UsageDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.UsageDict";

/// UsageRowId
Property UsageRowId As %String;

/// 用法编码
Property UsageCode As %String;

/// 用法名称
Property UsageName As %String;

/// 用法描述
Property UsageDesc As %String;

Property UseFlag As %String;

Property CreateDate As %String;

Property CreateUserID As %String;

Property Remarks As %String;

/// 别名
Property UsageAlias As %String;

}
