Class web.DHCENS.STBLL.DICTNew.MODEL.CTPHCPoison Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_PHCPoison";

/// 代码
Property CTPHCPCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCP_Code");

/// 描述
Property CTPHCPDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPHCP_Desc");

/// 代码表类型
Property CTPHCPCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCP_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTPHCPStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPHCP_Status");

/// 最后更新人编码
Property CTPHCPUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCP_UpdateUserCode");

/// 最后更新日期
Property CTPHCPUpdateDate As %Library.Date(XMLNAME = "CTPHCP_UpdateDate");

/// 最后更新时间
Property CTPHCPUpdateTime As %Library.Time(XMLNAME = "CTPHCP_UpdateTime");

/// 备注
Property CTPHCPRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPHCP_Remarks");

/// 创建时间
Property CTPHCPCCreatTime As %Library.Time(XMLNAME = "CTPHCPC_CreatTime");

/// 原代码
Property CTPHCPCOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCPC_OriginalCode");

/// 原描述
Property CTPHCPCOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTPHCPC_OriginalDesc");

/// 有效开始日期
Property CTPHCPCStartDate As %Library.Date(XMLNAME = "CTPHCPC_StartDate");

/// 有效结束日期
Property CTPHCPCEndDate As %Library.Date(XMLNAME = "CTPHCPC_EndDate");

/// 医院代码
Property CTPHCPCHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPHCPC_HosCode");

/// 状态
Property CTPHCPCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPHCPC_Status");

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 50, XMLNAME = "BusinessFieldCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
