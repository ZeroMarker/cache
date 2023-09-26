Class web.DHCENS.STBLL.DICTNew.MODEL.CTPEItemDetail Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_PEItemDetail";

/// 代码
Property CTPEIDCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEID_Code");

/// 描述
Property CTPEIDDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPEID_Desc");

/// 代码表类型
Property CTPEIDCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEID_CodesystemCode");

/// 体检大项代码
Property CTPEIDParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEID_ParentCode");

/// 状态（1启用0停用-1删除）
Property CTPEIDStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPEID_Status");

/// 最后更新人编码
Property CTPEIDUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEID_UpdateUserCode");

/// 最后更新日期
Property CTPEIDUpdateDate As %Library.Date(XMLNAME = "CTPEID_UpdateDate");

/// 最后更新时间
Property CTPEIDUpdateTime As %Library.Time(XMLNAME = "CTPEID_UpdateTime");

/// 备注
Property CTPEIDRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPEID_Remarks");

/// 创建日期
Property CTPEIDCreatDate As %Library.Date(XMLNAME = "CTPEID_CreatDate");

/// 创建时间
Property CTPEIDCreatTime As %Library.Time(XMLNAME = "CTPEID_CreatTime");

/// 原代码
Property CTPEIDOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEID_OriginalCode");

/// 原描述
Property CTPEIDOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPEID_OriginalDesc");

/// 有效开始日期
Property CTPEIDStartDate As %Library.Date(XMLNAME = "CTPEID_StartDate");

/// 有效结束日期
Property CTPEIDEndDate As %Library.Date(XMLNAME = "CTPEID_EndDate");

/// 医院代码
Property CTPEIDHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPEID_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
