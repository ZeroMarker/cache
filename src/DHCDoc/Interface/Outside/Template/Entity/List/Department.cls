Class DHCDoc.Interface.Outside.Template.Entity.List.Department Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Department";

/// 科室代码
Property DepartmentCode As %String(TRUNCATE = 1);

/// 科室名称
Property DepartmentName As %String(TRUNCATE = 1);

}
