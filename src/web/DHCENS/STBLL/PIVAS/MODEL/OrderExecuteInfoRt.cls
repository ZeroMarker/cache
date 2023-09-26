Class web.DHCENS.STBLL.PIVAS.MODEL.OrderExecuteInfoRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "OrderExecuteInfoRt";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 病人ID
Property PATPatientID As %Library.Integer(XMLNAME = "PATPatientID");

/// 就诊号
Property PAADMVisitNumber As %Library.Integer(XMLNAME = "PAADMVisitNumber");

/// 院区代码
Property HospitalCode As %Library.String(XMLNAME = "HospitalCode");

/// 医嘱执行信息(领药审核)
Property ordExeItems As list Of web.DHCENS.STBLL.PIVAS.MODEL.ordExeItem(XMLNAME = "OEORIInfoList");

}
