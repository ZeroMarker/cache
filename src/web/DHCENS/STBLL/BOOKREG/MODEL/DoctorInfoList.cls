Class web.DHCENS.STBLL.BOOKREG.MODEL.DoctorInfoList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "doctorInfos";

/// 交易码
Property TradeCode As %String;

/// 单次发送数量
Property DoctorCount As %String;

/// 医生
Property DoctorInfo As list Of web.DHCENS.STBLL.BOOKREG.MODEL.DoctorInfo(XMLNAME = "DoctorInfos");

}
