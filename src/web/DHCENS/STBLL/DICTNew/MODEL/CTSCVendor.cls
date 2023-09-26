Class web.DHCENS.STBLL.DICTNew.MODEL.CTSCVendor Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_SCVendor";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTSCVCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCV_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTSCVCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCV_CodesystemCode");

/// 描述
Property CTSCVDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSCV_Desc");

/// 备注
Property CTSCVRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTSCV_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTSCVStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSCV_Status");

/// 最后更新日期
Property CTSCVUpdateDate As %Library.Date(XMLNAME = "CTSCV_UpdateDate");

/// 最后更新时间
Property CTSCVUpdateTime As %Library.Time(XMLNAME = "CTSCV_UpdateTime");

/// 最后更新人编码
Property CTSCVUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCV_UpdateUserCode");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
/// 创建日期
Property CTSCVCreatDate As %Library.Date(XMLNAME = "CTSCV_CreatDate");

/// 创建时间
Property CTSCVCreatTime As %Library.Time(XMLNAME = "CTSCV_CreatTime");

/// 原代码
Property CTSCVOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSCV_OriginalCode");

/// 原描述
Property CTSCVOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSCV_OriginalDesc");

/// 有效开始日期
Property CTSCVStartDate As %Library.String(XMLNAME = "CTSCV_StartDate");

/// 有效结束日期
Property CTSCVEndDate As %Library.String(XMLNAME = "CTSCV_EndDate");

/// 医院代码
Property CTSCVHosCode As %Library.String(XMLNAME = "CTSCV_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
