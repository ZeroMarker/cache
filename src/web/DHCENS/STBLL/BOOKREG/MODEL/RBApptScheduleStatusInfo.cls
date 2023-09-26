Class web.DHCENS.STBLL.BOOKREG.MODEL.RBApptScheduleStatusInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "RBASRec";

/// 门诊排班标识
Property RBASId As %String(TRUNCATE = 1);

/// 状态(S：停诊)
Property RBASStatusCode As %String(TRUNCATE = 1);

}
