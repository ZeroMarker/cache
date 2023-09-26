/// 打印任务
Class web.DHCEntity.OPGS.GSPrintTask Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 对应的设备指针
Property HardEquipDR As %String(TRUNCATE = 1);

/// 打印模式：1XML 2Bar Code
Property PrintMode As %String(TRUNCATE = 1);

Property ClassName As %String(TRUNCATE = 1);

Property GSPTRowID As %String(TRUNCATE = 1);

Property GSRowID As %String(TRUNCATE = 1);

Property MethodName As %String(TRUNCATE = 1);

Property TaskType As %String(TRUNCATE = 1);

Property XmlTemplateName As %String(TRUNCATE = 1);

}
