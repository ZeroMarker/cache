Class DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 记录数量
Property RecordCount As %String(TRUNCATE = 1);

/*
关于标签格式的更多内容请参考
http://localhost:57772/csp/docbook/DocBook.UI.Page.cls?KEY=GXMLPROJ_basics#GXMLPROJ_B19885
*/
/// 科室列表（XML下带有主标签）
Property Departments As list Of DHCDoc.Interface.Outside.Template.Entity.List.Department(XMLITEMNAME = "Department", XMLNAME = "Departments", XMLPROJECTION = "COLLECTION");

/// 科室列表（XML下不带有主标签）
/// Property Departments As list Of DHCDoc.Interface.Outside.Template.Entity.List.Department(XMLPROJECTION = "ELEMENT");

}
