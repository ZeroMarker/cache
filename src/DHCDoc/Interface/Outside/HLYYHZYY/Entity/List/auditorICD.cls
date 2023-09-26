Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.auditorICD Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 每次保存时的唯一标识
Property hisUuid As %String(TRUNCATE = 1, XMLNAME = "hisUuid");

/// ICD代码
Property iCDCode As %String(TRUNCATE = 1, XMLNAME = "iCDCode");

/// 诊断名
Property iCDName As %String(TRUNCATE = 1, XMLNAME = "iCDName");

}
