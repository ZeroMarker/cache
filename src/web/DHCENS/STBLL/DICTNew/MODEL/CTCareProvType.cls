Class web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_CareProvType";

/// 代码
Property CTCPTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPT_Code");

/// 代码表类型 
Property CTCPTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPT_CodesystemCode");

/// 描述
Property CTCPTDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCPT_Desc");

/// 备注
Property CTCPTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCPT_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTCPTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCPT_Status");

/// 最后更新日期
Property CTCPTUpdateDate As %Library.Date(XMLNAME = "CTCPT_UpdateDate");

/// 最后更新时间
Property CTCPTUpdateTime As %Library.Time(XMLNAME = "CTCPT_UpdateTime");

/// 最后更新人编码
Property CTCPTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPT_UpdateUserCode");

/// 有效开始日期
Property CTCPTStartDate As %Library.Date(XMLNAME = "CTCPT_StartDate");

/// 原代码
Property CTCPTOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPT_OriginalCode");

/// 原描述
Property CTCPTOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCPT_OriginalDesc");

/// 医院代码
Property CTCPTHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPT_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
