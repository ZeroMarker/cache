Class web.DHCENS.STBLL.BOOKREG.MODEL.HospitalInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "HospitalInfo";

/// 交易码
Property TradeCode As %String;

/// 医院ID
Property HospitalId As %String;

/// 医院名称
Property HospitalName As %String;

/// 医院地址
Property Addr As %String;

/// 医院电话
Property Tel As %String;

/// 医院网址
Property WebSite As %String;

/// 医院等级
Property HospLevel As %String;

/// 所在区域
Property HospArea As %String;

/// 医院简介
Property Desc As %String;

/// 最大预约天数
Property MaxRegDays As %String;

/// 开始预约时间
Property StartRegTime As %String;

/// 停止预约时间
Property StopRegTime As %String;

/// 上午停止取号时间
Property StopBookTimeM As %String;

/// 下午停止取号时间
Property StopBookTimeA As %String;

}
