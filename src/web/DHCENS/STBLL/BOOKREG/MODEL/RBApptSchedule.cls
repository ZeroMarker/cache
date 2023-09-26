Class web.DHCENS.STBLL.BOOKREG.MODEL.RBApptSchedule Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "SynScheduleInfoRt";

/// 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// 医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// 医院名称
Property HospitalName As %String(TRUNCATE = 1);

/// 交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// 排班列表
Property RBParentApptSchedule As list Of web.DHCENS.STBLL.BOOKREG.MODEL.RBParentApptSchedule(XMLNAME = "RBAS");

}
