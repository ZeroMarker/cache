Class web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatusList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "OEORIInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 10, XMLNAME = "PAADMVisitNumber");

/// 就诊类型代码
Property PAADMEncounterTypeCode As %Library.String(MAXLEN = 10, XMLNAME = "PAADMEncounterTypeCode");

Property OEORIInfoList As list Of web.DHCENS.STBLL.ORDER.MODEL.OrdersBillStatus(XMLNAME = "OEORIInfoList");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserCode");

/// 最后更新人描述
Property UpdateUserDesc As %Library.String(MAXLEN = 50, XMLNAME = "UpdateUserDesc");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 10, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 10, XMLNAME = "UpdateTime");

}
