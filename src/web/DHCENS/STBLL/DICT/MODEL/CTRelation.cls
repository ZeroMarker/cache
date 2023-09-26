Class web.DHCENS.STBLL.DICT.MODEL.CTRelation Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_Relation";

/// 代码
Property CTRCode As %Library.String(COLLATION = "EXACT", MAXLEN = 3, XMLNAME = "CTR_Code") [ Required ];

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTRCodesystemCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50, XMLNAME = "CTR_CodesystemCode") [ Required ];

/// 描述
Property CTRDesc As %Library.String(COLLATION = "EXACT", MAXLEN = 100, XMLNAME = "CTR_Desc") [ Required ];

/// 备注
Property CTRRemarks As %Library.String(COLLATION = "EXACT", MAXLEN = 100, XMLNAME = "CTR_Remarks");

/// 状态（1启用,0停用,-1删除）
Property CTRStatus As %Library.String(COLLATION = "EXACT", MAXLEN = 2, XMLNAME = "CTR_Status") [ Required ];

/// 最后更新日期
Property CTRUpdateDate As %Library.Date(XMLNAME = "CTR_UpdateDate");

/// 最后更新时间
Property CTRUpdateTime As %Library.Time(XMLNAME = "CTR_UpdateTime");

/// 最后更新人编码
Property CTRUpdateUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 10, XMLNAME = "CTR_UpdateUserCode") [ Required ];

}
