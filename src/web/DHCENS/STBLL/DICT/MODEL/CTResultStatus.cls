Class web.DHCENS.STBLL.DICT.MODEL.CTResultStatus Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ResultStatus";

/// 代码
Property CTRSCode As %Library.String(MAXLEN = 20, XMLNAME = "CTRS_Code");

/// 描述
Property CTRSDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTRS_Desc");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTRSCodesystemCode As %Library.String(MAXLEN = 10, XMLNAME = "CTRS_CodesystemCode");

/// 状态（1启用,0停用,-1删除）
Property CTRSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTRS_Status");

/// 最后更新人编码
Property CTRSUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTRS_UpdateUserCode");

/// 最后更新日期
Property CTRSUpdateDate As %Library.Date(XMLNAME = "CTRS_UpdateDate");

/// 最后更新时间
Property CTRSUpdateTime As %Library.Time(XMLNAME = "CTRS_UpdateTime");

/// 备注
Property CTRSRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTRS_Remarks");

}
