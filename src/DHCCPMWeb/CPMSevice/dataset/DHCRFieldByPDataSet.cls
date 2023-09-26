/// ///使用Panel查询字段
/// ///需要传入ClassName, QueryName
Class DHCCPMWeb.CPMSevice.dataset.DHCRFieldByPDataSet Extends %XML.DataSet [ ClassType = "", Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "DHCCPMWeb.CPMBL.DHCBLRepPanels";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM/DHCRFieldByPDataSet";

Parameter QUERYNAME = "ReadPFieldsByQuery";

}
