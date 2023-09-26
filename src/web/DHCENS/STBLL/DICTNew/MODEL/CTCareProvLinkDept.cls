/// 医护人员科室关联表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvLinkDept Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_CareProvLinkDept";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 关联id
Property CTCPLDLinkId As %Library.String(MAXLEN = 50, XMLNAME = "CTCPLD_LinkId");

/// 人员代码
Property CTCPLDStaffCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPLD_StaffCode");

/// 科室代码
Property CTCPLDDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPLD_DeptCode");

/// 代码表类型
Property CTCPLDCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPLD_CodesystemCode");

/// 描述
Property CTCPLDDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTCPLD_Desc");

/// 备注
Property CTCPLDRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTCPLD_Remarks");

/// 最后更新人编码
Property CTCPLDUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPLD_UpdateUserCode");

/// 最后更新日期
Property CTCPLDUpdateDate As %Library.String(XMLNAME = "CTCPLD_UpdateDate");

/// 最后更新时间
Property CTCPLDUpdateTime As %Library.String(XMLNAME = "CTCPLD_UpdateTime");

/// 原人员代码
Property CTCPLDOriginalStaffCode As %Library.String(XMLNAME = "CTCPLD_OriginalStaffCode");

/// 原科室代码
Property CTCPLDOriginalDeptCode As %Library.String(XMLNAME = "CTCPLD_OriginalDeptCode");

/// 医院编号
Property CTCPLDHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPLD_HosCode");

/// 状态（1启用0停用-1删除）
Property CTCPLDStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCPLD_Status");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTCPLDOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCPLD_OriginalCode");

/// 原描述
Property CTCPLDOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCPLD_OriginalDesc");

/// 有效开始日期
Property CTCPLDStartDate As %Library.String(XMLNAME = "CTCPLD_StartDate");

/// 有效结束日期
Property CTCPLDEndDate As %Library.String(XMLNAME = "CTCPLD_EndDate");

/// 创建日期
Property CTCPLDCreatDate As %Library.Date(XMLNAME = "CTCPLD_CreatDate");

/// 创建时间
Property CTCPLDCreatTime As %Library.Time(XMLNAME = "CTCPLD_CreatTime");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
