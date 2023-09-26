Class web.DHCSTMService.HRP.Model.ManfData Extends XmlCommon
{

Parameter XMLNAME = "ManfData";

Property HospitalCode As %Library.String(MAXLEN = "", XMLNAME = "HospitalCode");

/// 生产厂家Code
Property ManfCode As %Library.String(MAXLEN = "", XMLNAME = "ManfCode");

/// 生产厂家名称
Property ManfDesc As %Library.String(MAXLEN = "", XMLNAME = "ManfDesc");

/// 是否使用
Property ManfUseFlag As %Library.String(MAXLEN = "", XMLNAME = "ManfUseFlag");

/// 生产厂家地址
Property ManfAdd As %Library.String(MAXLEN = "", XMLNAME = "ManfAdd");

/// 生产厂家电话
Property ManfPhone As %Library.String(MAXLEN = "", XMLNAME = "ManfPhone");

}
