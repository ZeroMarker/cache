Class web.DHCENS.STBLL.EMPI.MODEL.VitalSignInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "VitalSignInfo";

/// 体重
Property Weight As %Library.String(MAXLEN = 30, XMLNAME = "Weight");

/// 脉搏
Property Pulse As %Library.String(MAXLEN = 30, XMLNAME = "Pulse");

/// 收缩压
Property SystolicBP As %Library.String(MAXLEN = 30, XMLNAME = "SystolicBP");

/// 舒张压
Property DiastolicBP As %Library.String(MAXLEN = 30, XMLNAME = "DiastolicBP");

/// 体温
Property Temperature As %Library.String(MAXLEN = 30, XMLNAME = "Temperature");

/// 出量
Property OutputQuantity As %Library.String(MAXLEN = 30, XMLNAME = "OutputQuantity");

/// 入量
Property InputQuantity As %Library.String(MAXLEN = 30, XMLNAME = "InputQuantity");

/// 测量人编码
Property MeasureUserCode As %Library.String(MAXLEN = 30, XMLNAME = "MeasureUserCode");

/// 测量日期
Property MeasureDate As %Library.String(MAXLEN = 30, XMLNAME = "MeasureDate");

/// 测量时间
Property MeasureTime As %Library.String(MAXLEN = 30, XMLNAME = "MeasureTime");

/// 身高
Property Height As %Library.String(MAXLEN = 30, XMLNAME = "Height");

}
