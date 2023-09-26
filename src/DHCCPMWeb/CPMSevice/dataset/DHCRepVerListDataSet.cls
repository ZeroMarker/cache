/// 获取报表版本的查询列表记录
Class DHCCPMWeb.CPMSevice.dataset.DHCRepVerListDataSet Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCCPM.DHCReportsVersion";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM/DHCRepVerListDataSet";

Parameter QUERYNAME = "GetRepVerList";

}
