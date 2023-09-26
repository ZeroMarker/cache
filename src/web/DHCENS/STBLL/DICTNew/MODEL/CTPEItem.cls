Class web.DHCENS.STBLL.DICTNew.MODEL.CTPEItem Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_PEItem";

/// 代码
Property CTPEICode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEI_Code");

/// 描述
Property CTPEIDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPEI_Desc");

/// 代码表类型
Property CTPEICodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEI_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTPEIStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPEI_Status");

/// 最后更新人编码
Property CTPEIUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEI_UpdateUserCode");

/// 最后更新日期
Property CTPEIUpdateDate As %Library.Date(XMLNAME = "CTPEI_UpdateDate");

/// 最后更新时间
Property CTPEIUpdateTime As %Library.Time(XMLNAME = "CTPEI_UpdateTime");

/// 备注
Property CTPEIRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPEI_Remarks");

/// 创建日期
Property CTPEICreatDate As %Library.Date(XMLNAME = "CTPEI_CreatDate");

/// 创建时间
Property CTPEICreatTime As %Library.Time(XMLNAME = "CTPEI_CreatTime");

/// 原代码
Property CTPEIOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEI_OriginalCode");

/// 原描述
Property CTPEIOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPEI_OriginalDesc");

/// 有效开始日期
Property CTPEIStartDate As %Library.Date(XMLNAME = "CTPEI_StartDate");

/// 有效结束日期
Property CTPEIEndDate As %Library.Date(XMLNAME = "CTPEI_EndDate");

/// 医院代码
Property CTPEIHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEI_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
