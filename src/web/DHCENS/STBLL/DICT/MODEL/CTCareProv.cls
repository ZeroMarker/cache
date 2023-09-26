Class web.DHCENS.STBLL.DICT.MODEL.CTCareProv Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_CareProv";

Property CTCPCode As %Library.String(MAXLEN = 20, XMLNAME = "CTCP_Code");

/// 描述
Property CTCPDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCP_Desc");

/// 姓名
Property CTCPName As %Library.String(MAXLEN = 100, XMLNAME = "CTCP_Name");

/// 性别
Property CTCPSexCode As %Library.String(MAXLEN = 1, XMLNAME = "CTCP_SexCode");

/// 出生日期
Property CTCPBirthDate As %Library.String(XMLNAME = "CTCP_BirthDate");

/// 身份证号
Property CTCPIDCardNO As %Library.String(MAXLEN = 30, XMLNAME = "CTCP_IDCardNO");

/// 职务
Property CTCPJobCode As %Library.String(MAXLEN = 10, XMLNAME = "CTCP_JobCode");

/// 所属科室
Property CTCPDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCP_DeptCode");

/// 出生地
Property CTCPBirthPlace As %Library.String(MAXLEN = 200, XMLNAME = "CTCP_BirthPlace");

/// 有效开始日期
Property CTCPStartDate As %Library.String(MAXLEN = 20, XMLNAME = "CTCP_StartDate");

/// 有效结束日期
Property CTCPEndDate As %Library.String(MAXLEN = 20, XMLNAME = "CTCP_EndDate");

/// 代码表类型
Property CTCPCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCP_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTCPStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTCP_Status");

/// 最后更新人编码
Property CTCPUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTCP_UpdateUserCode");

/// 最后更新日期
Property CTCPUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTCP_UpdateDate");

/// 最后更新时间
Property CTCPUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTCP_UpdateTime");

/// 备注
Property CTCPRemarks As %Library.String(MAXLEN = 1000, XMLNAME = "CTCP_Remarks");

/// 医疗机构代码
Property CTCPHosCode As %Library.String(MAXLEN = 10, XMLNAME = "CTCP_HosCode");

/// 医护人员类型
Property CTCPStaffType As %Library.String(MAXLEN = 10, XMLNAME = "CTCP_StaffType");

/// 医护人员照片外网URL
Property CTCPExtranetURL As %Library.String(MAXLEN = 100, XMLNAME = "CTCP_ExtranetURL");

/// 医护人员照片内网URL
Property CTCPIntranetURL As %Library.String(MAXLEN = 100, XMLNAME = "CTCP_IntranetURL");

}
