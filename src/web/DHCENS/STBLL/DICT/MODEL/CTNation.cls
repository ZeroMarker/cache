Class web.DHCENS.STBLL.DICT.MODEL.CTNation Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

/// 代码
Property CTNCode As %Library.String(MAXLEN = 2, XMLNAME = "CTN_Code");

/// 代码表类型
Property CTNCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTN_CodesystemCode");

/// 描述
Property CTNDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTN_Desc");

/// 备注
Property CTNRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTN_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTNStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTN_Status");

/// 最后更新日期
Property CTNUpdateDate As %Library.Date(XMLNAME = "CTN_UpdateDate");

/// 最后更新时间
Property CTNUpdateTime As %Library.Time(XMLNAME = "CTN_UpdateTime");

/// 最后更新人编码
Property CTNUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTN_UpdateUserCode");

Index CTNationPKey On CTNCode [ PrimaryKey, Type = index, Unique ];

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "CT_Nation";

}
