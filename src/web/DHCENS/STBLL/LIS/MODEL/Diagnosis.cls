/// 诊断信息
Class web.DHCENS.STBLL.LIS.MODEL.Diagnosis Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Diagnosis";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property DiagDesc As %String;

Property DiagCode As %String;

}
