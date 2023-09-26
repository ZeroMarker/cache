Class web.DHCENS.STBLL.ORDER.MODEL.OEOrder Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "OE_OrdItem";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 病人ID
Property PATPatientID As %Library.String(XMLNAME = "PATPatientID");

/// 就诊号
Property PAADMVisitNumber As %Library.String(XMLNAME = "PAADMVisitNumber");

/// 就诊类型
Property PAADMEncounterTypeCode As %Library.String(XMLNAME = "PAADMEncounterTypeCode");

/// 医嘱信息
Property ordItems As list Of web.DHCENS.STBLL.ORDER.MODEL.OEOrdItem(XMLNAME = "OEORIInfoList");

/// 医嘱信息
Property ordStatus As list Of web.DHCENS.STBLL.ORDER.MODEL.OEOrdStatus(XMLNAME = "OEORIInfoList");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserCode");

/// 最后更新人描述
Property UpdateUserDesc As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserDesc");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 10, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 10, XMLNAME = "UpdateTime");

}
