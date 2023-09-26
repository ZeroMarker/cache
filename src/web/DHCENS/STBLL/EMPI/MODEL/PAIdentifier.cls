Class web.DHCENS.STBLL.EMPI.MODEL.PAIdentifier Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PATIdentity";

/// 患者证件号码
Property PATIdentityNum As %Library.String(MAXLEN = 18, XMLNAME = "PATIdentityNum");

/// 患者证件类别代码
Property PATIdTypeCode As %Library.String(MAXLEN = 2, XMLNAME = "PATIdTypeCode");

/// 患者证件类别描述
Property PATIdTypeDesc As %Library.String(MAXLEN = 20, XMLNAME = "PATIdTypeDesc");

}
