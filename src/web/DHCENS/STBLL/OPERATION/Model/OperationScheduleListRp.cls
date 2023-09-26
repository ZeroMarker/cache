/// 类名：web.DHCENS.STBLL.OPERATION.Model.OperationSchedule
/// 描述：手术排班申请信息返回Response
/// 编写者：WuXianPu
/// 编写日期：2012-10-31
Class web.DHCENS.STBLL.OPERATION.Model.OperationScheduleListRp Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String;

Property ResultContent As %String;

Property Operations As list Of web.DHCENS.STBLL.OPERATION.Model.OperationSchedule;

}
