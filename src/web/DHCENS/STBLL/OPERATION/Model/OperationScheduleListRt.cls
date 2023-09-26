/// 类名：web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRt
/// 描述：手术排班申请信息查询条件Request
/// 编写者：WuXianPu
/// 编写日期：2012-10-31
Class web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 开始日期时间
Property ScheduleDateStart As %String;

/// 停止日期时间
Property ScheduleDateStop As %String;

/// 手术科室
Property PerformedCode As %String;

/// 状态
Property OperStatus As %String;

}
