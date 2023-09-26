Class web.DHCENS.STBLL.DICTNew.MODEL.CTDeptDepartmentGroup Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DeptDepartmentGroup";

/// 代码
Property CTDDGCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDDG_Code");

/// 代码表类型
Property CTDDGCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDDG_CodesystemCode");

/// 描述
Property CTDDGDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDDG_Desc");

/// 备注
Property CTDDGRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDDG_Remarks");

/// 最后更新日期
Property CTDDGUpdateDate As %Library.Date(XMLNAME = "CTDDG_UpdateDate");

/// 最后更新时间
Property CTDDGUpdateTime As %Library.Time(XMLNAME = "CTDDG_UpdateTime");

/// 最后更新人编码
Property CTDDGUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDDG_UpdateUserCode");

/// 创建日期
Property CTDDGCreatDate As %Library.Date(XMLNAME = "CTDDG_CreatDate");

/// 创建时间
Property CTDDGCreatTime As %Library.Time(XMLNAME = "CTDDG_CreatTime");

/// 原代码
Property CTDDGOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDDG_OriginalCode");

/// 原描述
Property CTDDGOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDDG_OriginalDesc");

/// 有效开始日期
Property CTDDGStartDate As %Library.Date(XMLNAME = "CTDDG_StartDate");

/// 有效结束日期
Property CTDDGEndDate As %Library.Date(XMLNAME = "CTDDG_EndDate");

/// 医院代码
Property CTDDGHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDDG_HosCode");

/// 状态
Property CTDDGStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDDG_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
