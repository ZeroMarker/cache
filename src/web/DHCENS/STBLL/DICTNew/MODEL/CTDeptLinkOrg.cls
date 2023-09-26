Class web.DHCENS.STBLL.DICTNew.MODEL.CTDeptLinkOrg Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DeptLinkOrg";

/// 关联id
Property CTDLORowId As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_RowId");

/// 科室代码
Property CTDLODeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_DeptCode");

/// 组织代码
Property CTDLOOrgCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_OrgCode");

/// 代码表类型
Property CTDLOCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_CodesystemCode");

/// 备注
Property CTDLORemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDLO_Remarks");

/// 最后更新日期
Property CTDLOUpdateDate As %Library.Date(XMLNAME = "CTDLO_UpdateDate");

/// 最后更新时间
Property CTDLOUpdateTime As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_UpdateTime");

/// 最后更新人编码
Property CTDLOUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_UpdateUserCode");

/// 创建日期
Property CTDLOCreatDate As %Library.Date(XMLNAME = "CTDLO_CreatDate");

/// 创建时间
Property CTDLOCreatTime As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_CreatTime");

/// 原科室代码
Property CTDLOOriginalDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_OriginalDeptCode");

/// 原组织代码
Property CTDLOOriginalOrgCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_OriginalOrgCode");

/// 有效开始日期
Property CTDLOStartDate As %Library.Date(XMLNAME = "CTDLO_StartDate");

/// 有效结束日期
Property CTDLOEndDate As %Library.Date(XMLNAME = "CTDLO_EndDate");

/// 医院代码
Property CTDLOHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDLO_HosCode");

/// 状态
Property CTDLOStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDLO_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
