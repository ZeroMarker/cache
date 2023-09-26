/// 住院子类
Class web.DHCENS.STBLL.DICTNew.MODEL.CTIPChargeChildCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_IPChargeChildCategory";

/// 住院大类代码
Property CTIPCCCParentCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCCC_ParentCode");

/// 住院子类代码
Property CTIPCCCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCCC_Code");

/// 住院子类描述
Property CTIPCCCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTIPCCC_Desc");

/// 代码表类型
Property CTIPCCCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCCC_CodesystemCode");

/// 最后更新人代码
Property CTIPCCCUpdateUserCode As %Library.String(MAXLEN = 100, XMLNAME = "CTIPCCC_UpdateUserCode");

/// 最后更新日期
Property CTIPCCCUpdateDate As %Library.Date(XMLNAME = "CTIPCCC_UpdateDate");

/// 最后更新时间
Property CTIPCCCUpdateTime As %Library.Time(XMLNAME = "CTIPCCC_UpdateTime");

/// 创建日期
Property CTIPCCCCreatDate As %Library.Date(XMLNAME = "CTIPCCC_CreatDate");

/// 创建时间
Property CTIPCCCCreatTime As %Library.Time(XMLNAME = "CTIPCCC_CreatTime");

/// 原代码
Property CTIPCCCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCCC_OriginalCode");

/// 原描述
Property CTIPCCCOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTIPCCC_OriginalDesc");

/// 有效开始日期
Property CTIPCCCStartDate As %Library.Date(XMLNAME = "CTIPCCC_StartDate");

/// 有效结束日期
Property CTIPCCCEndDate As %Library.Date(XMLNAME = "CTIPCCC_EndDate");

/// 医院代码
Property CTIPCCCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTIPCCC_HosCode");

/// 状态
Property CTIPCCCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTIPCCC_Status");

/// 备注
Property CTIPCCCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTIPCCC_Remarks");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
