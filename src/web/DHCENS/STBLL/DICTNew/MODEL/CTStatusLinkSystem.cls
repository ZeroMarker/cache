Class web.DHCENS.STBLL.DICTNew.MODEL.CTStatusLinkSystem Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_StatusLinkSystem";

/// 关联ID
Property CTSLSLinkId As %Library.String(MAXLEN = 50, XMLNAME = "CTSLS_LinkId");

/// 状态
Property CTSLSStatusCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSLS_StatusCode");

/// 序号
Property CTSLSSubOrder As %Library.String(MAXLEN = 50, XMLNAME = "CTSLS_SubOrder");

/// 代码表类型
Property CTSLSCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSLS_CodesystemCode");

/// 系统
Property CTSLSSystem As %Library.String(MAXLEN = 50, XMLNAME = "CTSLS_System");

/// 备注
Property CTSLSRemarks As %Library.String(MAXLEN = 1000, XMLNAME = "CTSLS_Remarks");

/// 最后更新日期
Property CTSLSUpdateDate As %Library.Date(XMLNAME = "CTSLS_UpdateDate");

/// 最后更新时间
Property CTSLSUpdateTime As %Library.Time(XMLNAME = "CTSLS_UpdateTime");

/// 最后更新人编码
Property CTSLSUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSLS_UpdateUserCode");

/// 创建日期
Property CTSLSCreatDate As %Library.Date(XMLNAME = "CTSLS_CreatDate");

/// 创建时间
Property CTSLSCreatTime As %Library.Time(XMLNAME = "CTSLS_CreatTime");

/// 原代码
Property CTSLSOriginalCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSLS_OriginalCode");

/// 原描述
Property CTSLSOriginalDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTSLS_OriginalDesc");

/// 有效开始日期
Property CTSLSStartDate As %Library.Date(XMLNAME = "CTSLS_StartDate");

/// 有效结束日期
Property CTSLSEndDate As %Library.Date(XMLNAME = "CTSLS_EndDate");

/// 医院代码
Property CTSLSHosCode As %Library.String(MAXLEN = 50, XMLNAME = "CTSLS_HosCode");

/// 状态
Property CTSLSStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTSLS_Status");

}
