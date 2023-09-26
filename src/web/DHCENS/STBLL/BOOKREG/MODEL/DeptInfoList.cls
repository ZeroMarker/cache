Class web.DHCENS.STBLL.BOOKREG.MODEL.DeptInfoList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "deptInfos";

/// 交易码
Property TradeCode As %String;

/// 单次发送数量
Property DeptCount As %String;

/// 科室
Property DeptInfo As list Of web.DHCENS.STBLL.BOOKREG.MODEL.DeptInfo(XMLNAME = "DeptInfos");

}
