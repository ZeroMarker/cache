/// 报表目录的DataSet
Class DHCCPMWeb.CPMSevice.dataset.DHCReportsCategoryDataSet Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
/// DHCCPM.DHCReportsCategory
Parameter CLASSNAME = "DHCCPMWeb.CPMBL.DHCBLReportsCategory";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM/DHCReportsCategoryDataSet";

Parameter QUERYNAME = "GetRepCatList";

}
