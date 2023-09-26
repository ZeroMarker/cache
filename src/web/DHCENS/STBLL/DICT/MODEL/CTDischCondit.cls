Class web.DHCENS.STBLL.DICT.MODEL.CTDischCondit Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTDCCode As %Library.String(MAXLEN = 20, XMLNAME = "CTDC_Code");

/// 代码表类型
Property CTDCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDC_CodesystemCode");

/// 描述
Property CTDCDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTDC_Desc");

/// 备注
Property CTDCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDC_Remarks");

/// 状态（1启用0停用-1删除）
Property CTDCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDC_Status");

/// 最后更新日期
Property CTDCUpdateDate As %Library.Date(XMLNAME = "CTDC_UpdateDate");

/// 最后更新时间
Property CTDCUpdateTime As %Library.Time(XMLNAME = "CTDC_UpdateTime");

/// 最后更新人编码
Property CTDCUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTDC_UpdateUserCode");

Parameter XMLNAME = "CT_DischCondit";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

}
