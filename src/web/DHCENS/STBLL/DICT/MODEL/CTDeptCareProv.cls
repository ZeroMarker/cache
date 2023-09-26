Class web.DHCENS.STBLL.DICT.MODEL.CTDeptCareProv Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "CT_DeptCareProv";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 人员代码
Property CTDCPCareProvCode As %Library.String(MAXLEN = 20, XMLNAME = "CTDCP_CareProvCode");

/// 科室代码
Property CTDCPDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDCP_DeptCode");

/// 最后更新日期
Property CTDCPUpdateDate As %Library.Date(XMLNAME = "CTDCP_UpdateDate");

/// 最后更新时间
Property CTDCPUpdateTime As %Library.Time(XMLNAME = "CTDCP_UpdateTime");

/// 最后更新人编码
Property CTDCPUpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "CTDCP_UpdateUserCode");

}
