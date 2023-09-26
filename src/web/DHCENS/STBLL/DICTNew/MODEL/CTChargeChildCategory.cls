/// 收费项子类
Class web.DHCENS.STBLL.DICTNew.MODEL.CTChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ChargeChildCategory";

/// 收费项大类代码
Property CTCCCParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCCC_ParentCode");

/// 收费项子类代码
Property CTCCCCode As %Library.String(MAXLEN = 100, XMLNAME = "CTCCC_Code");

/// 收费项子类描述
Property CTCCCDesc As %Library.String(MAXLEN = 50, XMLNAME = "CTCCC_Desc");

/// 代码表类型
Property CTCCCCodesystemCode As %Library.String(MAXLEN = 100, XMLNAME = "CTCCC_CodesystemCode");

/// 备注
Property CTCCCRemarks As %Library.String(MAXLEN = 50, XMLNAME = "CTCCC_Remarks");

/// 最后更新人代码
Property CTCCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCCC_UpdateUserCode");

/// 最后更新日期
Property CTCCCUpdateDate As %Library.Date(XMLNAME = "CTCCC_UpdateDate");

/// 最后更新时间
Property CTCCCUpdateTime As %Library.Time(XMLNAME = "CTCCC_UpdateTime");

/// 原代码
Property CTCCCOriginalCode As %Library.String(XMLNAME = "CTCCC_OriginalCode");

/// 原描述
Property CTCCCOriginalDesc As %Library.String(XMLNAME = "CTCCC_OriginalDesc");

/// 有效开始日期
Property CTCCCStartDate As %Library.Date(XMLNAME = "CTCCC_StartDate");

/// 有效结束日期
Property CTCCCEndDate As %Library.Time(XMLNAME = "CTCCC_EndDate");

/// 医院代码
Property CTCCCHosCode As %Library.String(XMLNAME = "CTCCC_HosCode");

/// 状态
Property CTCCCStatus As %Library.String(XMLNAME = "CTCCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
