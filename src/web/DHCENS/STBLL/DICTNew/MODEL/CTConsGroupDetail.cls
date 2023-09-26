Class web.DHCENS.STBLL.DICTNew.MODEL.CTConsGroupDetail Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ConsGroupDetail";

/// 明细ID
Property CTCGDRowId As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_RowId");

/// 序号
Property CTCGDSubOrder As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_SubOrder");

/// 代码表类型
Property CTCGDCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_CodesystemCode");

/// 组代码
Property CTCGDGroupCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_GroupCode");

/// 科室代码
Property CTCGDDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_DeptCode");

/// 成员代码
Property CTCGDMemberCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_MemberCode");

/// 联系人标识
Property CTCGDContactFlag As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_ContactFlag");

/// 备注
Property CTCGDRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCGD_Remarks");

/// 最后更新日期
Property CTCGDUpdateDate As %Library.Date(XMLNAME = "CTCGD_UpdateDate");

/// 最后更新时间
Property CTCGDUpdateTime As %Library.Time(XMLNAME = "CTCGD_UpdateTime");

/// 最后更新人编码
Property CTCGDUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_UpdateUserCode");

/// 创建日期
Property CTCGDCreatDate As %Library.Date(XMLNAME = "CTCGD_CreatDate");

/// 创建时间
Property CTCGDCreatTime As %Library.Time(XMLNAME = "CTCGD_CreatTime");

/// 原代码
Property CTCGDOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_OriginalCode");

/// 原描述
Property CTCGDOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCGD_OriginalDesc");

/// 有效开始日期
Property CTCGDStartDate As %Library.Date(XMLNAME = "CTCGD_StartDate");

/// 有效结束日期
Property CTCGDEndDate As %Library.Date(XMLNAME = "CTCGD_EndDate");

/// 医院代码
Property CTCGDHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCGD_HosCode");

/// 状态
Property CTCGDStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCGD_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
