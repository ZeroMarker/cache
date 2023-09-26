Class web.DHCENS.STBLL.EMPI.MODEL.VitalSignInfoRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "VitalSignInfoRt";

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 50, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 50, XMLNAME = "PAADMVisitNumber");

/// 院区代码
Property HospitalCode As %Library.String(MAXLEN = 50, XMLNAME = "HospitalCode");

/// 体征信息
Property VitalSignInfoList As list Of web.DHCENS.STBLL.EMPI.MODEL.VitalSignInfo(XMLITEMNAME = "VitalSignInfo", XMLNAME = "VitalSignInfoList", XMLPROJECTION = "COLLECTION");

}
