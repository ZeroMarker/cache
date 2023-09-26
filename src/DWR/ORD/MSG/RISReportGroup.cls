/// 检查报告分组
Class DWR.ORD.MSG.RISReportGroup Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "RISReportGroup";

/// 分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 检查报告列表
Property RISReportList As list Of DWR.ORD.MSG.RISReport(XMLNAME = "RISReportList");

}
