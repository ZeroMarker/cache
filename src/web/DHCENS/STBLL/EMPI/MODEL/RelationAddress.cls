Class web.DHCENS.STBLL.EMPI.MODEL.RelationAddress Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PATRelationAddress";

/// 地址
Property PATAddressDesc As %Library.String(MAXLEN = 200, XMLNAME = "PATRelationAddressDesc");

/// 地址-门牌号码
Property PATHouseNum As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationHouseNum");

/// 地址-村（街、路、弄等）
Property PATVillage As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationVillage");

/// 地址-乡（镇、街道办事处）
Property PATCountryside As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationCountryside");

/// 地址-县（区）代码
Property PATCountyCode As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationCountyCode");

/// 地址-县（区）描述
Property PATCountyDesc As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationCountyDesc");

/// 地址-市（地区）代码
Property PATCityCode As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationCityCode");

/// 地址-市（地区）描述
Property PATCityDesc As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationCityDesc");

/// 地址-省（自治区、直辖市）代码
Property PATProvinceCode As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationProvinceCode");

/// 地址-省（自治区、直辖市）描述
Property PATProvinceDesc As %Library.String(MAXLEN = 70, XMLNAME = "PATRelationProvinceDesc");

/// 地址邮政编码
Property PATPostalCode As %Library.String(MAXLEN = 6, XMLNAME = "PATRelationPostalCode");

}
