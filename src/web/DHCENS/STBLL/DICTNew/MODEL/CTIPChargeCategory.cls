/// 住院收费大类
Class web.DHCENS.STBLL.DICTNew.MODEL.CTIPChargeCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_IPChargeCategory";

/// 住院大类代码
Property CTIPCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCC_Code");

/// 住院大类描述
Property CTIPCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTIPCC_Desc");

/// 代码表类型
Property CTIPCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCC_CodesystemCode");

/// 备注
Property CTIPCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTIPCC_Remarks");

/// 最后更新日期
Property CTIPCCUpdateDate As %Library.Date(XMLNAME = "CTIPCC_UpdateDate");

/// 最后更新时间
Property CTIPCCUpdateTime As %Library.Time(XMLNAME = "CTIPCC_UpdateTime");

/// 最后更新人
Property CTIPCCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCC_UpdateUserCode");

/// 创建日期
Property CTIPCCCreatDate As %Library.Date(XMLNAME = "CTIPCC_CreatDate");

/// 创建时间
Property CTIPCCCreatTime As %Library.Time(XMLNAME = "CTIPCC_CreatTime");

/// 原代码
Property CTIPCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCC_OriginalCode");

/// 原描述
Property CTIPCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTIPCC_OriginalDesc");

/// 有效开始日期
Property CTIPCCStartDate As %Library.Date(XMLNAME = "CTIPCC_StartDate");

/// 有效开始日期
Property CTIPCCEndDate As %Library.Date(XMLNAME = "CTIPCC_EndDate");

/// 医院代码
Property CTIPCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCC_HosCode");

/// 状态
Property CTIPCCStatus As %Library.String(MAXLEN = 100, XMLNAME = "CTIPCC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
