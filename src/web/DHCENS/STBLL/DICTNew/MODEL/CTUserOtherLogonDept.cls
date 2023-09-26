/// 其他登录科室
Class web.DHCENS.STBLL.DICTNew.MODEL.CTUserOtherLogonDept Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_UserOtherLogonDept";

/// id
Property CTUOLDRowId As %Library.String(MAXLEN = 50, XMLNAME = "CTUOLD_RowId");

/// 代码表类型
Property CTUOLDCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUOLD_CodesystemCode");

/// 用户代码
Property CTUOLDUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUOLD_UserCode");

/// 安全组代码
Property CTUOLDSecuGroupCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUOLD_SecuGroupCode");

/// 科室代码
Property CTUOLDDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUOLD_DeptCode");

/// 备注
Property CTUOLDRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTUOLD_Remarks");

/// 最后更新日期
Property CTUOLDUpdateDate As %Library.Date(XMLNAME = "CTUOLD_UpdateDate");

/// 最后更新时间
Property CTUOLDUpdateTime As %Library.Time(XMLNAME = "CTUOLD_UpdateTime");

/// 最后更新人编码
Property CTUOLDUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUOLD_UpdateUserCode");

/// 创建日期
Property CTUOLDCreatDate As %Library.Date(XMLNAME = "CTUOLD_CreatDate");

/// 创建时间
Property CTUOLDCreatTime As %Library.Time(XMLNAME = "CTUOLD_CreatTime");

/// 原代码
Property CTUOLDOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUOLD_OriginalCode");

/// 原描述
Property CTUOLDOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTUOLD_OriginalDesc");

/// 有效开始日期
Property CTUOLDStartDate As %Library.Date(XMLNAME = "CTUOLD_StartDate");

/// 有效结束日期
Property CTUOLDEndDate As %Library.Date(XMLNAME = "CTUOLD_EndDate");

/// 医院代码
Property CTUOLDHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTUOLD_HosCode");

/// 状态
Property CTUOLDStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTUOLD_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
