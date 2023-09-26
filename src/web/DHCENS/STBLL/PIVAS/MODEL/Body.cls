Class web.DHCENS.STBLL.PIVAS.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property OrderExecuteInfoRt As web.DHCENS.STBLL.PIVAS.MODEL.OrderExecuteInfoRt(XMLNAME = "OrderExecuteInfoRt");

Property OrderNurExecutes As web.DHCENS.STBLL.PIVAS.MODEL.OrdNurExeItemInfo(XMLNAME = "OrderExecuteInfo");

Property PeiWuCheckAppInfoRt As web.DHCENS.STBLL.PIVAS.MODEL.SendPeiWuCheckAppInfo(XMLNAME = "PeiWuCheckAppInfoRt", XMLPROJECTION = "ELEMENT");

}
