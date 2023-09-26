Class web.DHCENS.STBLL.DICTNew.MODEL.CTCareProv Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_CareProv";

/// 出生日期
Property CTCPBirthDate As %Date(XMLNAME = "CTCP_BirthDate");

/// 出生地
Property CTCPBirthPlace As %String(XMLNAME = "CTCP_BirthPlace");

/// 代码
Property CTCPCode As %String(XMLNAME = "CTCP_Code");

/// 工号
Property CTCPJobNumber As %String(XMLNAME = "CTCP_JobNumber");

/// 代码表类型
Property CTCPCodesystemCode As %String(XMLNAME = "CTCP_CodesystemCode");

/// 所属科室
Property CTCPDeptCode As %String(XMLNAME = "CTCP_DeptCode");

/// 描述
Property CTCPDesc As %String(XMLNAME = "CTCP_Desc");

/// 医护人员照片外网URL
Property CTCPExtranetURL As %String(XMLNAME = "CTCP_ExtranetURL");

/// 医疗机构代码
Property CTCPHosCode As %String(XMLNAME = "CTCP_HosCode");

/// 身份证号
Property CTCPIDCardNO As %String(XMLNAME = "CTCP_IDCardNO");

/// 医护人员照片内网URL 
Property CTCPIntranetURL As %String(XMLNAME = "CTCP_IntranetURL");

/// 姓名
Property CTCPName As %String(XMLNAME = "CTCP_Name");

/// 密码
Property CTCPPassWord As %String(XMLNAME = "CTCP_PassWord");

/// 职位
Property CTCPPosition As %String(XMLNAME = "CTCP_Position");

/// 备注
Property CTCPRemarks As %String(XMLNAME = "CTCP_Remarks");

/// 性别
Property CTCPSexCode As %String(XMLNAME = "CTCP_SexCode");

/// 员工类型 
Property CTCPStaffType As %String(XMLNAME = "CTCP_StaffTypeCode");

/// 状态（1 启用 0 停用 -1 删除）
Property CTCPStatus As %String(XMLNAME = "CTCP_Status");

/// 职称
Property CTCPTitleOfTechCode As %String(XMLNAME = "CTCP_TitleOfTechCode");

/// 最后更新时间
Property CTCPUpdateTime As %Time(XMLNAME = "CTCP_UpdateTime");

/// 最后更新人编码 
Property CTCPUpdateUserCode As %String(XMLNAME = "CTCP_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 原代码
Property CTCPOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTCP_OriginalCode");

/// 原描述
Property CTCPOriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTCP_OriginalDesc");

/// 有效开始日期
Property CTCPStartDate As %Library.Date(XMLNAME = "CTCP_StartDate");

/// 有效结束日期
Property CTCPEndDate As %Library.Date(XMLNAME = "CTCP_EndDate");

/// 创建日期
Property CTCPCreatDate As %Library.String(XMLNAME = "CTCP_CreatDate");

/// 创建时间
Property CTCPCreatTime As %Library.String(XMLNAME = "CTCP_CreatTime");

/// 医护人员类型
Property CTCPCareProvTypeCode As %String(XMLNAME = "CTCP_CareProvTypeCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
