Class DHCENS.BC.Model.CancelReportRt Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CancelReport";

/// 医嘱号
Property Rowid As %String(MAXLEN = 32767);

/// 检查号
Property StudyNo As %String(MAXLEN = 32767);

/// 申请取消医生
Property CancelDoc As %String(MAXLEN = 32767);

/// 取消日期
Property CancelDate As %String(MAXLEN = 32767);

/// 取消时间
Property CancelTime As %String(MAXLEN = 32767);

}
