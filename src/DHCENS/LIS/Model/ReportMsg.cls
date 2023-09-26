Class DHCENS.LIS.Model.ReportMsg Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱号
Property OrdID As %String(MAXLEN = 32767);

/// 接收者
Property RecUser As %String(MAXLEN = 32767);

/// 接收日期
Property RecDate As %String(MAXLEN = 32767);

/// 接收时间
Property RecTime As %String(MAXLEN = 32767);

/// 录入者
Property EntryUser As %String(MAXLEN = 32767);

/// 录入日期
Property EntryDate As %String(MAXLEN = 32767);

/// 录入时间
Property EntryTime As %String(MAXLEN = 32767);

/// 审核者
Property AuthUser As %String(MAXLEN = 32767);

/// 审核日期
Property AuthDate As %String(MAXLEN = 32767);

/// 审核时间
Property AuthTime As %String(MAXLEN = 32767);

/// 报告备注
Property Notes As %String(MAXLEN = 32767);

/// 图像的路径
Property ImageFile As %String(MAXLEN = 32767);

/// 危急值说明
Property MainWarnDesc As %String(MAXLEN = 32767);

Property ResultMsgs As list Of DHCENS.LIS.Model.ResultMsg;

}
