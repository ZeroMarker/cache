/// Description：频率字典表 
/// Table：CT.WDT.CDSS.FrequencyDict
Class web.CDSSEntity.CMKB.FrequencyDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.FrequencyDict";

/// FrequencyRowId
Property FrequencyRowId As %String;

/// 频率编码
Property FrequencyCode As %String;

/// 频率名称
Property FrequencyName As %String;

/// 频率描述
Property FrequencyDesc As %String;

Property UseFlag As %String;

Property CreateDate As %String;

Property CreateUserID As %String;

Property Remarks As %String;

/// 频率别名
Property FrequencyAlias As %String;

}
