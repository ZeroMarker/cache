Class web.DHCENS.STBLL.BOOKREG.MODEL.RBChildApptSchedule Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "TimeRange";

/// 时间段信息
Property Time As %String(TRUNCATE = 1);

/// 总数量
Property TotalNumber As %String(TRUNCATE = 1);

/// 剩余数量
Property SurplusNumber As %String(TRUNCATE = 1);

/// 剩余预约序号
Property SerialNumbers As %String(TRUNCATE = 1);

}
