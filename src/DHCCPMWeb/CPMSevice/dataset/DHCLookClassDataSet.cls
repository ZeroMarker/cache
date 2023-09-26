/// 利用模糊查询获取类对象列表
Class DHCCPMWeb.CPMSevice.dataset.DHCLookClassDataSet Extends %XML.DataSet [ ClassType = "", Not ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
/// DHCCPMWeb.CPMSysFun.DHCConversions
Parameter CLASSNAME = "DHCCPMWeb.CPMSysFun.DHCConversions";

/// Parameter CLASSNAME = "websys.Conversions";
/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM/DHCLookClassDataSet";

Parameter QUERYNAME = "LookUpClassName";

}
