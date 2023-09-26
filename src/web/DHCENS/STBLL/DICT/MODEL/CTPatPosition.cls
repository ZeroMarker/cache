Class web.DHCENS.STBLL.DICT.MODEL.CTPatPosition Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_PatientPosition";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 患者身份代码
Property CTPPCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPP_Code");

/// 患者身份描述
Property CTPPDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPP_Desc");

/// 代码表类型
Property CTPPCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPP_CodesystemCode");

/// 备注
Property CTPPRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPP_Remarks");

/// 状态
Property CTPPStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPP_Status");

/// 最后更新人编码
Property CTPPUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTPP_UpdateUserCode");

/// 最后更新日期
Property CTPPUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTPP_UpdateDate");

/// 最后更新时间
Property CTPPUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTPP_UpdateTime");

}
