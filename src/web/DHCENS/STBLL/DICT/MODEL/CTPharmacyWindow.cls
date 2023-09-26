Class web.DHCENS.STBLL.DICT.MODEL.CTPharmacyWindow Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_PharmacyWindow";

/// 代码表类型
Property CTPWCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPW_CodesystemCode");

/// 科室代码
Property CTPWDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPW_DeptCode");

/// 科室描述
Property CTPWDeptDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPW_DeptDesc");

/// 备注
Property CTPWRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTPW_Remarks");

/// 状态
Property CTPWStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTPW_Status");

/// 最后更新日期
Property CTPWUpdateDate As %Library.String(MAXLEN = 20, XMLNAME = "CTPW_UpdateDate");

/// 最后更新时间
Property CTPWUpdateTime As %Library.String(MAXLEN = 20, XMLNAME = "CTPW_UpdateTime");

/// 最后更新人编码
Property CTPWUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTPW_UpdateUserCode");

/// 窗口代码
Property CTPWWindowCode As %Library.String(MAXLEN = 50, XMLNAME = "CTPW_WindowCode");

/// 窗口描述
Property CTPWWindowDesc As %Library.String(MAXLEN = 100, XMLNAME = "CTPW_WindowDesc");

}
