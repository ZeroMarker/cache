Class web.DHCENS.STBLL.DICTNew.MODEL.CTStaffType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTSTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTST_Code");

/// 代码表类型 
Property CTSTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTST_CodesystemCode");

/// 描述
Property CTSTDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTST_Desc");

/// 备注
Property CTSTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTST_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTSTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTST_Status");

/// 最后更新日期
Property CTSTUpdateDate As %Library.Date(XMLNAME = "CTST_UpdateDate");

/// 最后更新时间
Property CTSTUpdateTime As %Library.Time(XMLNAME = "CTST_UpdateTime");

/// 最后更新人编码
Property CTSTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTST_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTSTCreatDate As %Library.Date(XMLNAME = "CTST_CreatDate");

/// 创建时间
Property CTSTCreatTime As %Library.Time(XMLNAME = "CTST_CreatTime");

/// 原代码
Property CTSTOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTST_OriginalCode");

/// 原描述
Property CTSTOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTST_OriginalDesc");

/// 有效开始日期
Property CTSTStartDate As %Library.Date(XMLNAME = "CTST_StartDate");

/// 有效结束日期
Property CTSTEndDate As %Library.Date(XMLNAME = "CTST_EndDate");

/// 医院代码
Property CTSTHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTST_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_StaffType";

}
