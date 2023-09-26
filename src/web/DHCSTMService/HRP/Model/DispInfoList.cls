Class web.DHCSTMService.HRP.Model.DispInfoList Extends XmlCommon
{

Parameter XMLNAME = "MateAdviceList";

/// 流水号(唯一)
Property InfoModes As list Of web.DHCSTMService.HRP.Model.DispInfo(XMLNAME = "data", XMLPROJECTION = "element");

}
