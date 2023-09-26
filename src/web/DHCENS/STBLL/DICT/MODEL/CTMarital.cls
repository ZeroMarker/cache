Class web.DHCENS.STBLL.DICT.MODEL.CTMarital Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTMCode As %Library.String(MAXLEN = 2, XMLNAME = "CTM_Code");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTM_CodesystemCode");

/// 描述
Property CTMDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTM_Desc");

/// 备注
Property CTMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTM_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTM_Status");

/// 最后更新日期
Property CTMUpdateDate As %Library.Date(XMLNAME = "CTM_UpdateDate");

/// 最后更新时间
Property CTMUpdateTime As %Library.Time(XMLNAME = "CTM_UpdateTime");

/// 最后更新人编码
Property CTMUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTM_UpdateUserCode");

Index CTMaritalPKey On CTMCode [ PrimaryKey, Type = index, Unique ];

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_Marital";

}
