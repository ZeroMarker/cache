Class web.DHCENS.STBLL.DICTNew.MODEL.CTHisUser Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_HisUser";

/// 代码
Property CTHUId As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_Id");

/// 代码表类型
Property CTHUCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_CodesystemCode");

/// 名称
Property CTHUName As %Library.String(MAXLEN = 128, XMLNAME = "CTHU_Name");

/// 备注
Property CTHURemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTHU_Remarks");

/// 最后更新日期
Property CTHUUpdateDate As %Library.Date(XMLNAME = "CTHU_UpdateDate");

/// 最后更新时间
Property CTHUUpdateTime As %Library.Time(XMLNAME = "CTHU_UpdateTime", XMLTIMEZONE = "IGNORE");

/// 最后更新人编码
Property CTHUUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_UpdateUserCode");

/// 创建日期
Property CTHUCreatDate As %Library.Date(XMLNAME = "CTHU_CreatDate");

/// 创建时间
Property CTHUCreatTime As %Library.Time(XMLNAME = "CTHU_CreatTime", XMLTIMEZONE = "IGNORE");

/// 原代码
Property CTHUOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_OriginalCode");

/// 原描述
Property CTHUOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTHU_OriginalDesc");

/// 有效开始日期
Property CTHUStartDate As %Library.Date(XMLNAME = "CTHU_StartDate");

/// 有效结束日期
Property CTHUEndDate As %Library.Date(XMLNAME = "CTHU_EndDate");

/// 医院代码
Property CTHUHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_HosCode");

/// 状态
Property CTHUStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTHU_Status");

/// 电话号码
Property CTHUPhoneNum As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_PhoneNum");

/// 电子邮箱
Property CTHUEmail As %Library.String(MAXLEN = 100, XMLNAME = "CTHU_Email");

/// 默认登录科室
Property CTHUDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_DeptCode");

/// 默认登录安全组
Property CTHUSecuGroupCode As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_SecuGroupCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

/// 对应医护人员rowid
Property CTHUCareProvID As %Library.String(MAXLEN = 50, XMLNAME = "CTHU_CareProvID");

}
