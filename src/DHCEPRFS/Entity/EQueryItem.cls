/// Desc:查询符合条件格式
/// Creator:Candy
Class DHCEPRFS.Entity.EQueryItem Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 参数对象
Parameter XMLNAME = "OperationItem";

Parameter XMLSEQUENCE = 1;

Property Items As list Of DHCEPRFS.Entity.EQuerySubItem(XMLNAME = "Items", XMLPROJECTION = "ELEMENT") [ Required ];

}
