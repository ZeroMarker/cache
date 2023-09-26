/// 科室病区关联表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTDeptLinkWard Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_DeptLinkWard";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 关联id
Property CTDLWLinkId As %Library.String(MAXLEN = 50, XMLNAME = "CTDLW_LinkId");

/// 科室代码
Property CTDLWDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLW_DeptCode");

/// 病区代码
Property CTDLWWardCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLW_WardCode");

/// 代码表类型
Property CTDLWCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLW_CodesystemCode");

/// 描述
Property CTDLWDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDLW_Desc");

/// 备注
Property CTDLWRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDLW_Remarks");

/// 最后更新人编码
Property CTDLWUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLW_UpdateUserCode");

/// 最后更新日期
Property CTDLWUpdateDate As %Library.Date(XMLNAME = "CTDLW_UpdateDate");

/// 最后更新时间
Property CTDLWUpdateTime As %Library.Time(XMLNAME = "CTDLW_UpdateTime");

/// 创建日期
Property CTDLWCreatDate As %Library.Date(XMLNAME = "CTDLW_CreatDate");

/// 创建时间
Property CTDLWCreatTime As %Library.Date(XMLNAME = "CTDLW_CreatTime");

/// 原科室代码
Property CTDLWOriginalDeptCode As %Library.String(XMLNAME = "CTDLW_OriginalDeptCode");

/// 原病区代码
Property CTDLWOriginalWardCode As %Library.String(XMLNAME = "CTDLW_OriginalWardCode");

/// 有效开始日期
Property CTDLWStartDate As %Library.Date(XMLNAME = "CTDLW_StartDate");

/// 有效结束日期
Property CTDLWEndDate As %Library.Date(XMLNAME = "CTDLW_EndDate");

/// 医院编号
Property CTDLWHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLW_HosCode");

/// 状态（1启用0停用-1删除）
Property CTDLWStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDLW_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
