Class web.DHCENS.STBLL.DICTNew.MODEL.CTDeptClass Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CT_DeptClass";

/// 代码
Property CTDCCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDC_Code");

/// 代码表类型
Property CTDCCodesystemCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDC_CodesystemCode");

/// 描述
Property CTDCDesc As %Library.String(MAXLEN = 128, XMLNAME = "CTDC_Desc");

/// 备注
Property CTDCRemarks As %Library.String(MAXLEN = 100, XMLNAME = "CTDC_Remarks");

/// 最后更新人编码
Property CTDCUpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "CTDC_UpdateUserCode");

/// 状态
Property CTDCStatus As %Library.String(MAXLEN = 2, XMLNAME = "CTDC_Status");

/// 业务域
Property BusinessFieldCode As %Library.String(MAXLEN = 10, XMLNAME = "BusinessFieldCode");

}
