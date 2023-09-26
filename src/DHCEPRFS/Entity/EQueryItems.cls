Class DHCEPRFS.Entity.EQueryItems Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 参数对象
Parameter XMLNAME = "QueryItem";

Parameter XMLSEQUENCE = 1;

Property QueryItems As list Of DHCEPRFS.Entity.EQueryItem(XMLNAME = "OperationItem", XMLPROJECTION = "ELEMENT") [ Required ];

}
