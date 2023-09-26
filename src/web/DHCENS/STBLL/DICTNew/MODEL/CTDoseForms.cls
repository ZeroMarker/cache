Class web.DHCENS.STBLL.DICTNew.MODEL.CTDoseForms Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DoseForms";

/// 代码
Property CTDFCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDF_Code");

/// 描述
Property CTDFDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDF_Desc");

/// 原代码
Property CTDFOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDF_OriginalCode");

/// 原描述
Property CTDFOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDF_OriginalDesc");

/// 代码表类型
Property CTDFCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDF_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTDFStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDF_Status");

/// 最后更新人编码
Property CTDFUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDF_UpdateUserCode");

/// 有效开始日期
Property CTDFStartDate As %Library.Date(XMLNAME = "CTDF_StartDate");

/// 有效结束日期
Property CTDFEndDate As %Library.Date(XMLNAME = "CTDF_EndDate");

/// 创建日期
Property CTDFCreatDate As %Library.Date(XMLNAME = "CTDF_CreatDate");

/// 创建时间
Property CTDFCreatTime As %Library.Time(XMLNAME = "CTDF_CreatTime");

/// 最后更新日期
Property CTDFUpdateDate As %Library.Date(XMLNAME = "CTDF_UpdateDate");

/// 最后更新时间
Property CTDFUpdateTime As %Library.Time(XMLNAME = "CTDF_UpdateTime");

/// 备注
Property CTDFRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDF_Remarks");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
