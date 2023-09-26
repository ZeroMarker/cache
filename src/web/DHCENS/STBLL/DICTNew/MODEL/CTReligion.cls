Class web.DHCENS.STBLL.DICTNew.MODEL.CTReligion Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_Religion";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 代码
Property CTRCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_Code");

/// 描述
Property CTRDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTR_Desc");

/// 原代码
Property CTROriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_OriginalCode");

/// 原描述
Property CTROriginalDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTR_OriginalDesc");

/// 代码表类型
Property CTRCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTRStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTR_Status");

/// 最后更新人编码
Property CTRUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_UpdateUserCode");

/// 创建日期
Property CTRCreatDate As %Library.Date(XMLNAME = "CTR_CreatDate");

/// 创建时间
Property CTRCreatTime As %Library.Time(XMLNAME = "CTR_CreatTime");

/// 有效开始日期
Property CTRStartDate As %Library.Date(XMLNAME = "CTR_StartDate");

/// 有效结束日期
Property CTREndDate As %Library.Date(XMLNAME = "CTR_EndDate");

/// 最后更新日期
Property CTRUpdateDate As %Library.Date(XMLNAME = "CTR_UpdateDate");

/// 最后更新时间
Property CTRUpdateTime As %Library.Time(XMLNAME = "CTR_UpdateTime");

/// 备注
Property CTRRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTR_Remarks");

/// 医院代码
Property CTRHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_HosCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
