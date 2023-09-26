/// 入院情况字典表
Class web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitCondit Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_AdmitCondit";

/// 代码
Property CTACCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAC_Code");

/// 代码表类型
Property CTACCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAC_CodesystemCode");

/// 描述
Property CTACDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAC_Desc");

/// 备注
Property CTACRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTAC_Remarks");

/// 最后更新日期
Property CTACUpdateDate As %Library.Date(XMLNAME = "CTAC_UpdateDate");

/// 最后更新时间
Property CTACUpdateTime As %Library.Time(XMLNAME = "CTAC_UpdateTime");

/// 最后更新人编码
Property CTACUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAC_UpdateUserCode");

/// 创建日期
Property CTACCreatDate As %Library.Date(XMLNAME = "CTAC_CreatDate");

/// 创建时间
Property CTACCreatTime As %Library.Time(XMLNAME = "CTAC_CreatTime");

/// 原代码
Property CTACOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAC_OriginalCode");

/// 原描述
Property CTACOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTAC_OriginalDesc");

/// 有效开始日期
Property CTACStartDate As %Library.Date(XMLNAME = "CTAC_StartDate");

/// 有效结束日期
Property CTACEndDate As %Library.Date(XMLNAME = "CTAC_EndDate");

/// 医院代码
Property CTACHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAC_HosCode");

/// 状态
Property CTACStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTAC_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
