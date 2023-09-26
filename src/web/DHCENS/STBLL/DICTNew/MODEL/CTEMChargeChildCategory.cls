/// 核算子类
Class web.DHCENS.STBLL.DICTNew.MODEL.CTEMChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_EMChargeChildCategory";

/// 核算大类代码
Property CTEMCCCParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTEMCCC_ParentCode");

/// 核算子类代码
Property CTEMCCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTEMCCC_Code");

/// 核算子类代码
Property CTEMCCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCCC_Desc");

/// 代码表类型
Property CTEMCCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTEMCCC_CodesystemCode");

/// 备注
Property CTEMCCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCCC_Remarks");

/// 最后更新人代码
Property CTEMCCCUpdateUserCode As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCCC_UpdateUserCode");

/// 最后更新日期
Property CTEMCCCUpateDate As %Library.Date(XMLNAME = "CTEMCCC_UpdateDate");

/// 最后更新时间
Property CTEMCCCUpateTime As %Library.Time(XMLNAME = "CTEMCCC_UpdateTime");

/// 创建日期
Property CTEMCCCCreatDate As %Library.Date(XMLNAME = "CTEMCCC_CreatDate");

/// 创建时间
Property CTEMCCCCreatTime As %Library.Time(XMLNAME = "CTEMCCC_CreatTime");

/// 原代码
Property CTEMCCCOriginalCode As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCCC_OriginalCode");

/// 原描述
Property CTEMCCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCCC_OriginalDesc");

/// 有效开始日期
Property CTEMCCCStartDate As %Library.Date(XMLNAME = "CTEMCCC_StartDate");

/// 有效结束日期
Property CTEMCCCEndDate As %Library.Time(XMLNAME = "CTEMCCC_CreatTime");

/// 医院代码
Property CTEMCCCHosCode As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCCC_HosCode");

/// 状态
Property CTEMCCCStatus As %Library.String(MAXLEN = 100, XMLNAME = "CTEMCCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
