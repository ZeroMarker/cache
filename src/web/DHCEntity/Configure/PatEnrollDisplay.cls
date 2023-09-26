Class web.DHCEntity.Configure.PatEnrollDisplay Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property DefaultCityDesc As %String(TRUNCATE = 1);

Property DefaultCountryDesc As %String(TRUNCATE = 1);

Property DefaultNationDesc As %String(TRUNCATE = 1);

Property DefaultProvinceDesc As %String(TRUNCATE = 1);

/// Y or N
Property AccManageFLag As %String(TRUNCATE = 1);

/// 可用的 卡类型列表, 如果为空， 本设置的 默认 设备类型为空
Property CardTypeList As list Of %String(TRUNCATE = 1);

/// Y or N
Property CardRefFlag As %String(TRUNCATE = 1);

Property DefaultCardTypeDR As %String(TRUNCATE = 1);

Property DefaultCityDR As %String(TRUNCATE = 1);

/// 默认的身份证读取器
Property DefaultIDEquipDR As %String(TRUNCATE = 1);

Property DefaultCountryDR As %String(TRUNCATE = 1);

Property DefaultNationDR As %String(TRUNCATE = 1);

Property DefaultPatTypeDR As %String(TRUNCATE = 1);

Property DefaultProvinceDR As %String(TRUNCATE = 1);

/// 默认性别
Property DefaultSexDR As %String(TRUNCATE = 1);

/// Y or N
Property PatMasFlag As %String(TRUNCATE = 1);

/// 患者类型列表
Property PatTypeList As list Of %String(TRUNCATE = 1);

}
