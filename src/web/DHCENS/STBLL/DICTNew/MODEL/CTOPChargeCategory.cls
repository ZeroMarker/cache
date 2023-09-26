/// 门诊大类
Class web.DHCENS.STBLL.DICTNew.MODEL.CTOPChargeCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_OPChargeCategory";

/// 门诊大类代码
Property CTOPCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCC_Code");

/// 门诊大类描述
Property CTOPCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOPCC_Desc");

/// 代码表类型
Property CTOPCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCC_CodesystemCode");

/// 备注
Property CTOPCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTOPCC_Remarks");

/// 最后更新日期
Property CTOPCCUpdateDate As %Library.Date(XMLNAME = "CTOPCC_UpdateDate");

/// 最后更新时间
Property CTOPCCUpdateTime As %Library.Time(XMLNAME = "CTOPCC_UpdateTime");

/// 最后更新人
Property CTOPCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCC_UpdateUserCode");

/// 创建日期
Property CTOPCCCreatDate As %Library.Date(XMLNAME = "CTOPCC_CreatDate");

/// 创建时间
Property CTOPCCCreatTime As %Library.Time(XMLNAME = "CTOPCC_CreatTime");

/// 原代码
Property CTOPCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCC_OriginalCode");

/// 原描述
Property CTOPCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTOPCC_OriginalDesc");

/// 有效开始日期
Property CTOPCCStartDate As %Library.Date(XMLNAME = "CTOPCC_StartDate");

/// 有效开始日期
Property CTOPCCEndDate As %Library.Date(XMLNAME = "CTOPCC_EndDate");

/// 医院代码
Property CTOPCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTOPCC_HosCode");

/// 状态
Property CTOPCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTOPCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
