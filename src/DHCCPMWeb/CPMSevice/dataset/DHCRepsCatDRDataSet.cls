/// 使用报表目录获取报表DataSet
Class DHCCPMWeb.CPMSevice.dataset.DHCRepsCatDRDataSet Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCCPM.DHCReports";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM/DHCRepsCatDRDataSet";

Parameter QUERYNAME = "GetRepsByCatDR";

}
