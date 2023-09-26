Class web.DHCENS.STBLL.BOOKREG.MODEL.RBChildScheduleType Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "RBChildScheduleType";

/// 排班资源ID
Property RBASId As %String(TRUNCATE = 1);

/// 序号
Property RBASNum As %String(TRUNCATE = 1);

/// 号源类别代码
Property RBScheduleTypeCode As %String(TRUNCATE = 1);

/// 号源类别
Property RBScheduleType As %String(TRUNCATE = 1);

/// 起始号
Property FirstNumber As %String(TRUNCATE = 1);

/// 预约限额
Property AvailableNum As %String(TRUNCATE = 1);

/// 可用预约数
Property AvailableLeftNum As %String(TRUNCATE = 1);

}
