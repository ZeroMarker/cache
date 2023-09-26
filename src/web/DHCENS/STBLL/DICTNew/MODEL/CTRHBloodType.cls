Class web.DHCENS.STBLL.DICTNew.MODEL.CTRHBloodType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_RHBloodType";

/// 代码
Property CTRHBTCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRHBT_Code");

/// 代码表类型
Property CTRHBTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRHBT_CodesystemCode");

/// 描述
Property CTRHBTDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTRHBT_Desc");

/// 备注
Property CTRHBTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTRHBT_Remarks");

/// 最后更新日期
Property CTRHBTUpdateDate As %Library.Date(XMLNAME = "CTRHBT_UpdateDate");

/// 最后更新时间
Property CTRHBTUpdateTime As %Library.Time(XMLNAME = "CTRHBT_UpdateTime");

/// 最后更新人编码
Property CTRHBTUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRHBT_UpdateUserCode");

/// 创建日期
Property CTRHBTCreatDate As %Library.Date(XMLNAME = "CTRHBT_CreatDate");

/// 创建时间
Property CTRHBTCreatTime As %Library.Time(XMLNAME = "CTRHBT_CreatTime");

/// 原代码
Property CTRHBTOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRHBT_OriginalCode");

/// 原描述
Property CTRHBTOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTRHBT_OriginalDesc");

/// 有效开始日期
Property CTRHBTStartDate As %Library.Date(XMLNAME = "CTRHBT_StartDate");

/// 有效结束日期
Property CTRHBTEndDate As %Library.Date(XMLNAME = "CTRHBT_EndDate");

/// 医院代码
Property CTRHBTHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTRHBT_HosCode");

/// 状态
Property CTRHBTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTRHBT_Status");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
