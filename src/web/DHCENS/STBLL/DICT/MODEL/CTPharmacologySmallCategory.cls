Class web.DHCENS.STBLL.DICT.MODEL.CTPharmacologySmallCategory Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_PharmacologySmallCategory";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property CTMCode As %Library.String(MAXLEN = 20, XMLNAME = "CTM_Code");

/// 代码表类型
Property CTMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTM_CodesystemCode");

/// 描述
Property CTMDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTM_Desc");

/// 药学分类子类代码
Property CTPharmaChildCategory As %Library.String(MAXLEN = 20, XMLNAME = "CT_PharmaChildCategory");

/// 备注
Property CTMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTM_Remarks");

/// 状态
Property CTMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTM_Status");

/// 最后更新日期
Property CTMUpdateDate As %Library.Date(XMLNAME = "CTM_UpdateDate");

/// 最后更新时间
Property CTMUpdateTime As %Library.Time(XMLNAME = "CTM_UpdateTime");

/// 最后更新人编码
Property CTMUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTM_UpdateUserCode");

}
