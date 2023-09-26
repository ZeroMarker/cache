/// 名称 : DHCMed.DCEns.LIS.BTSpecimen
/// 说明 : 检验标本
Class DHCMed.DCEns.LIS.BTSpecimen Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Specimen";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 代码
Property Code As %String(MAXLEN = 32767, XMLNAME = "Code");

/// 名称
Property CName As %String(MAXLEN = 32767, XMLNAME = "CName");

/// 医院代码
Property HospCode As %String(MAXLEN = 32767, XMLNAME = "HospCode");

/// 英文名称
Property EName As %String(MAXLEN = 32767, XMLNAME = "EName");

/// Whonet码
Property WCode As %String(MAXLEN = 32767, XMLNAME = "WCode");

/// 索引码
Property XCode As %String(MAXLEN = 32767, XMLNAME = "XCode");

/// 是否有效
Property Active As %String(MAXLEN = 32767, XMLNAME = "Active");

}
