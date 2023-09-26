/// 诊断信息
Class web.DHCENS.STBLL.EMPI.MODEL.PADiagnose Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PAADMDiagnose";

/// 诊断id
Property PADDiagId As %Library.String(MAXLEN = 10, XMLNAME = "PADDiagId");

/// 诊断代码
Property PADDiagCode As %Library.String(MAXLEN = 10, XMLNAME = "PADDiagCode");

/// 诊断描述
Property PADDiagDesc As %Library.String(MAXLEN = 50, XMLNAME = "PADDiagDesc");

/// 诊断类型代码
Property PADDiagTypeCode As %Library.String(MAXLEN = 20, XMLNAME = "PADDiagTypeCode");

/// 诊断类型描述
Property PADDiagTypeDesc As %Library.String(MAXLEN = 20, XMLNAME = "PADDiagTypeDesc");

/// 诊断状态
Property PADDiagStatus As %Library.String(MAXLEN = 50, XMLNAME = "PADDiagStatus");

/// 诊断医生代码
Property PADDiagDocCode As %Library.String(MAXLEN = 50, XMLNAME = "PADDiagDocCode");

/// 诊断医生描述
Property PADDiagDocDesc As %Library.String(MAXLEN = 50, XMLNAME = "PADDiagDocDesc");

/// 诊断级别代码  第一条为主要诊断，其他为次要诊断
Property PADDiagCategory As %Library.String(MAXLEN = 10, XMLNAME = "PADDiagCategory");

/// 诊断日期
Property PADDiagDate As %Library.String(MAXLEN = 20, XMLNAME = "PADDiagDate");

/// 诊断时间
Property PADDiagTime As %Library.String(MAXLEN = 20, XMLNAME = "PADDiagTime");

/// 备注
Property PADRemarks As %Library.String(MAXLEN = 100, XMLNAME = "PADRemarks");

}
