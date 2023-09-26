Class DHCENS.BC.Model.RegInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "RegInfo";

/// 医嘱号
Property Rowid As %String(MAXLEN = 32767);

/// 检查号（第三方）
Property StudyNo As %String(MAXLEN = 32767);

/// 设备
Property EQInfo As %String(MAXLEN = 32767);

/// 操作员
Property OperatorInfo As %String(MAXLEN = 32767);

/// 检查医生
Property MainDocInfo As %String(MAXLEN = 32767);

}
