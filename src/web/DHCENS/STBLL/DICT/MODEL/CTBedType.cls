Class web.DHCENS.STBLL.DICT.MODEL.CTBedType Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_BedType";

/// 代码
Property CTBTCode As %Library.String(MAXLEN = 10, XMLNAME = "CTBT_Code");

/// 描述
Property CTBTDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTBT_Desc");

/// 代码表类型 
Property CTBTCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTBT_CodesystemCode");

/// 状态（1启用0停用-1删除）
Property CTBTStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTBT_Status");

/// 最后更新人编码
Property CTBTUpdateUserCode As %Library.String(MAXLEN = 10, XMLNAME = "CTBT_UpdateUserCode");

/// 最后更新日期
Property CTBTUpdateDate As %Library.Date(XMLNAME = "CTBT_UpdateDate");

/// 最后更新时间
Property CTBTUpdateTime As %Library.Time(XMLNAME = "CTBT_UpdateTime");

/// 备注
Property CTBTRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTBT_Remarks");

/// 医院编号
Property CTBTHosCode As %Library.String(MAXLEN = 10, XMLNAME = "CTBT_HosCode");

}
