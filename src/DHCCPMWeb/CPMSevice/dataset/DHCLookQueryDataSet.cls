/// 查找一个类包含的Query
Class DHCCPMWeb.CPMSevice.dataset.DHCLookQueryDataSet Extends %XML.DataSet [ ClassType = "", Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "%Library.CompiledQuery";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM/DHCLookQueryDataSet";

Parameter QUERYNAME = "QueryInfo";

}
