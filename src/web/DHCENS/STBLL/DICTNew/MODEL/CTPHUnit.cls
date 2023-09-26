Class web.DHCENS.STBLL.DICTNew.MODEL.CTPHUnit Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_PHUnit";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTPHUCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHU_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTPHUCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHU_CodesystemCode");

/// 描述
Property CTPHUDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPHU_Desc");

/// 备注
Property CTPHURemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPHU_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTPHUStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPHU_Status");

/// 最后更新日期
Property CTPHUUpdateDate As %Library.Date(XMLNAME = "CTPHU_UpdateDate");

/// 最后更新时间
Property CTPHUUpdateTime As %Library.Time(XMLNAME = "CTPHU_UpdateTime");

/// 最后更新人编码
Property CTPHUUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHU_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTPHUCreatDate As %Library.Date(XMLNAME = "CTPHU_CreatDate");

/// 创建时间
Property CTPHUCreatTime As %Library.Time(XMLNAME = "CTPHU_CreatTime");

/// 原代码
Property CTPHUOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHU_OriginalCode");

/// 原描述
Property CTPHUOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPHU_OriginalDesc");

/// 有效开始日期
Property CTPHUStartDate As %Library.String(XMLNAME = "CTPHU_StartDate");

/// 有效结束日期
Property CTPHUEndDate As %Library.String(XMLNAME = "CTPHU_EndDate");

/// 医院代码
Property CTPHUHosCode As %Library.String(XMLNAME = "CTPHU_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
