Class web.DHCENS.STBLL.DICTNew.MODEL.CTAllergyCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_AllergyCategory";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTACCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAC_Code");

/// 代码表类型
Property CTACCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAC_CodesystemCode");

/// 描述
Property CTACDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTAC_Desc");

/// 备注
Property CTACRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTAC_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTACStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTAC_Status");

/// 最后更新日期
Property CTACUpdateDate As %Library.Date(XMLNAME = "CTAC_UpdateDate");

/// 最后更新时间
Property CTACUpdateTime As %Library.Time(XMLNAME = "CTAC_UpdateTime");

/// 最后更新人编码
Property CTACUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTAC_UpdateUserCode");

/// 业务域内rowid
Property businessrowid As %Library.String(MAXLEN = 10, XMLNAME = "businessrowid");

}
