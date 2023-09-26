Class DHCENS.BaseCode.DictList Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "DictList";

/// 代码
Property Code As %String(TRUNCATE = 1);

/// 描述
Property Desc As %String(TRUNCATE = 1);

/// 助记符
Property Alias As %String(TRUNCATE = 1);

}
