/// 查找一个组件的DataSet
Class DHCCPMWeb.CPMSevice.dataset.DHCLookCompDataSet Extends %XML.DataSet [ ClassType = "", Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "websys.Component";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM/DHCLookCompDataSet";

Parameter QUERYNAME = "VBFind";

}
