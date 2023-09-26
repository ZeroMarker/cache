Class web.DHCENS.STBLL.DICTNew.MODEL.CTOPChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_OPChargeChildCategory";

/// 门诊大类代码
Property CTOPCCCParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCCC_ParentCode");

/// 门诊子类代码
Property CTOPCCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCCC_Code");

/// 门诊子类描述
Property CTOPCCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOPCCC_Desc");

/// 代码表类型
Property CTOPCCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCCC_CodesystemCode");

/// 最后更新人代码
Property CTOPCCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCCC_UpdateUserCode");

/// 最后更新日期
Property CTOPCCCUpdateDate As %Library.Date(XMLNAME = "CTOPCCC_UpdateDate");

/// 最后更新时间
Property CTOPCCCUpdateTime As %Library.Time(XMLNAME = "CTOPCCC_UpdateTime");

/// 创建日期
Property CTOPCCCCreatDate As %Library.Date(XMLNAME = "CTOPCCC_CreatDate");

/// 创建时间
Property CTOPCCCCreatTime As %Library.Time(XMLNAME = "CTOPCCC_CreatTime");

/// 原代码
Property CTOPCCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCCC_OriginalCode");

/// 原描述
Property CTOPCCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOPCCC_OriginalDesc");

/// 有效开始日期
Property CTOPCCCStartDate As %Library.Date(XMLNAME = "CTOPCCC_StartDate");

/// 有效结束日期
Property CTOPCCCEndDate As %Library.Date(XMLNAME = "CTOPCCC_EndDate");

/// 医院代码
Property CTOPCCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCCC_HosCode");

/// 状态
Property CTOPCCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOPCCC_Status");

/// 备注
Property CTOPCCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOPCCC_Remarks");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
