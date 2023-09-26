/// 运算逻辑参数对象
Class EPRservice.Quality.OperationLogic.OperationItem Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 参数对象
Parameter XMLNAME = "OperationItem";

Parameter XMLSEQUENCE = 1;

Property Items As list Of EPRservice.Quality.OperationLogic.OperationSubItem(XMLNAME = "Items", XMLPROJECTION = "ELEMENT") [ Required ];

}
