Class web.DHCENS.STBLL.EMPI.MODEL.PaCard Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "CreateCardRt";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 患者卡类型
Property PATCardType As %Library.String(MAXLEN = 30, XMLNAME = "PATCardType");

/// 患者卡号
Property PATCardNum As %Library.String(MAXLEN = 30, XMLNAME = "PATCardNum");

/// 患者卡校验码
Property PATCardCheckNum As %Library.String(MAXLEN = 30, XMLNAME = "PATCardCheckNum");

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 30, XMLNAME = "UpdateUserCode");

/// 最后更新日期
Property UpdateDate As %Library.String(XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(XMLNAME = "UpdateTime");

}
