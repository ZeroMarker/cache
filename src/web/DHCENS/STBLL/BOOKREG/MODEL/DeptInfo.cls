Class web.DHCENS.STBLL.BOOKREG.MODEL.DeptInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "DeptInfo";

/// 科室id
Property DeptId As %String;

/// 科室代码
Property DeptCode As %String;

/// 科室名称
Property DeptName As %String;

/// 上级科室代码
Property ParentId As %String;

/// 科室简介
Property Desc As %String;

}
