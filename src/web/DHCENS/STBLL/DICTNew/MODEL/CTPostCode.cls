Class web.DHCENS.STBLL.DICTNew.MODEL.CTPostCode Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_Postcode";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 邮编代码
Property CTPCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_Code");

/// 邮编名称
Property CTPDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTP_Desc");

/// 代码表类型
Property CTPCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_CodesystemCode");

/// 国家代码
Property CTPCountryCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_CountryCode");

/// 省代码
Property CTPProvinceCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_ProvinceCode");

/// 市代码
Property CTPCityCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_CityCode");

/// 县代码
Property CTPCountyCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_CountyCode");

/// 备注
Property CTPRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTP_Remarks");

/// 状态
Property CTPStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTP_Status");

/// 最后更新人编码
Property CTPUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_UpdateUserCode");

/// 最后更新日期
Property CTPUpdateDate As %Library.String(MAXLEN = 50, XMLNAME = "CTP_UpdateDate");

/// 最后更新时间
Property CTPUpdateTime As %Library.String(MAXLEN = 50, XMLNAME = "CTP_UpdateTime");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTPCreatDate As %Library.String(XMLNAME = "CTP_CreatDate");

/// 创建时间
Property CTPCreatTime As %Library.String(XMLNAME = "CTP_CreatTime");

/// 原代码
Property CTPOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTP_OriginalCode");

/// 原描述
Property CTPOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTP_OriginalDesc");

/// 有效开始日期
Property CTPStartDate As %Library.String(XMLNAME = "CTP_StartDate");

/// 有效结束日期
Property CTPEndDate As %Library.String(XMLNAME = "CTP_EndDate");

/// 医院代码
Property CTPHosCode As %Library.String(XMLNAME = "CTP_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
