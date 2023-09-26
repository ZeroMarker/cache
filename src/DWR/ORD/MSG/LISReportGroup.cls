/// 检验报告分组
Class DWR.ORD.MSG.LISReportGroup Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "LISReportGroup";

/// 分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 检验报告列表
Property LISReportList As list Of DWR.ORD.MSG.LISReport(XMLNAME = "LISReportList");

}
