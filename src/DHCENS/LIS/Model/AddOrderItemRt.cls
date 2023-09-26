Class DHCENS.LIS.Model.AddOrderItemRt Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "AddOrderItem";

/// 就诊号
Property AdmNo As %String(MAXLEN = 32767);

/// 医嘱字典代码
Property ArcimCode As %String(MAXLEN = 32767);

/// 医嘱字典名称
Property ArcimDesc As %String(MAXLEN = 32767);

/// 医嘱状态
Property OrderStatus As %String(MAXLEN = 32767);

/// 数量	
Property OrderQty As %String(MAXLEN = 32767);

/// 开医嘱科室代码
Property OrderDeptCode As %String(MAXLEN = 32767);

/// 接受科室代码
Property OrderRecDepCode As %String(MAXLEN = 32767);

/// 开医嘱人
Property OrderDoctor As %String(MAXLEN = 32767);

/// 录入人代码
Property OrderUserCode As %String(MAXLEN = 32767);

/// 要求执行医嘱日期
Property OrderSttDat As %String(MAXLEN = 32767);

/// 要求执行医嘱时间
Property OrderSttTim As %String(MAXLEN = 32767);

/// 费别
Property FeeType As %String(MAXLEN = 32767);

}
