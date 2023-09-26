Class web.DHCENS.STBLL.DICT.MODEL.CTARCItmMast Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_ARCItmMast";

/// 代码
Property CTARCIMCode As %Library.String(MAXLEN = 50, XMLNAME = "CTARCIM_Code");

/// 描述
Property CTARCIMDesc As %Library.String(MAXLEN = 300, XMLNAME = "CTARCIM_Desc");

/// 医嘱子类代码
Property CTARCIMChildCategory As %Library.String(MAXLEN = 20, XMLNAME = "CTARCIM_ChildCategory");

/// 代码表类型 CT_CodeSystem.CTCSCode
Property CTARCIMCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTARCIM_CodesystemCode");

/// 状态（1启用,0停用,-1删除）
Property CTARCIMStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTARCIM_Status");

/// 最后更新人编码
Property CTARCIMUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTARCIM_UpdateUserCode");

/// 最后更新日期
Property CTARCIMUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTARCIM_UpdateDate");

/// 最后更新时间
Property CTARCIMUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTARCIM_UpdateTime");

/// 备注
Property CTARCIMRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTARCIM_Remarks");

}
