Class web.DHCENS.STBLL.DICT.MODEL.CTRoom Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Room";

/// 代码
Property CTRCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_Code");

/// 描述
Property CTRDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTR_Desc");

/// 代码表类型 
Property CTRCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTR_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTRStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTR_Status");

/// 最后更新人编码
Property CTRUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTR_UpdateUserCode");

/// 最后更新日期
Property CTRUpdateDate As %Library.Date(XMLNAME = "CTR_UpdateDate");

/// 最后更新时间
Property CTRUpdateTime As %Library.Time(XMLNAME = "CTR_UpdateTime");

/// 备注
Property CTRRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTR_Remarks");

/// 医院编号
Property CTRHosCode As %Library.String(MAXLEN = 10, XMLNAME = "CTR_HosCode");

}
