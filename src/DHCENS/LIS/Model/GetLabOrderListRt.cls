Class DHCENS.LIS.Model.GetLabOrderListRt Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "GetLabOrderList";

/// 卡号
Property CardNo As %String(MAXLEN = 32767);

/// 登记号
Property RegisterNo As %String(MAXLEN = 32767);

/// 开始日期
Property StartDate As %String(MAXLEN = 32767);

/// 结束日期
Property EndDate As %String(MAXLEN = 32767);

/// 就诊类别
Property EpsiodeType As %String(MAXLEN = 32767);

/// 医嘱状态
Property OrderStatus As %String(MAXLEN = 32767);

/// 开单科室
Property OrderDept As %String(MAXLEN = 32767);

}
