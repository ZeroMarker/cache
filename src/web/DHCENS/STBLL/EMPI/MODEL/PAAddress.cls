Class web.DHCENS.STBLL.EMPI.MODEL.PAAddress Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PATAddress";

/// 地址类型
Property PATAddressType As %Library.String(MAXLEN = 3, XMLNAME = "PATAddressType");

/// 地址
Property PATAddressDesc As %Library.String(MAXLEN = 200, XMLNAME = "PATAddressDesc");

/// 地址-门牌号码
Property PATHouseNum As %Library.String(MAXLEN = 70, XMLNAME = "PATHouseNum");

/// 地址-村（街、路、弄等）
Property PATVillage As %Library.String(MAXLEN = 70, XMLNAME = "PATVillage");

/// 地址-乡（镇、街道办事处）
Property PATCountryside As %Library.String(MAXLEN = 70, XMLNAME = "PATCountryside");

/// 地址-县（区）代码
Property PATCountyCode As %Library.String(MAXLEN = 70, XMLNAME = "PATCountyCode");

/// 地址-县（区）描述
Property PATCountyDesc As %Library.String(MAXLEN = 70, XMLNAME = "PATCountyDesc");

/// 地址-市（地区）代码
Property PATCityCode As %Library.String(MAXLEN = 70, XMLNAME = "PATCityCode");

/// 地址-市（地区）描述
Property PATCityDesc As %Library.String(MAXLEN = 70, XMLNAME = "PATCityDesc");

/// 地址-省（自治区、直辖市）代码
Property PATProvinceCode As %Library.String(MAXLEN = 70, XMLNAME = "PATProvinceCode");

/// 地址-省（自治区、直辖市）描述
Property PATProvinceDesc As %Library.String(MAXLEN = 70, XMLNAME = "PATProvinceDesc");

/// 地址邮政编码
Property PATPostalCode As %Library.String(MAXLEN = 6, XMLNAME = "PATPostalCode");

}
