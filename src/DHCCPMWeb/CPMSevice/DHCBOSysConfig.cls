/// 
/// 提供系统参数传输的统一配置
/// 
Class DHCCPMWeb.CPMSevice.DHCBOSysConfig Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCBOSysConfig";

/// Parameter LOCATION = "http://192.168.0.1/trakcare/trak/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// 获取Cache端数据类型列表
/// 返回: No:%String,DataType:%String
ClassMethod GetCacheADataTypeDataSet() As DHCCPMWeb.CPMSevice.dataset.DHCSFADataTypeDataSet [ WebMethod ]
{
 New result	
 Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCSFADataTypeDataSet).%New()
 Do result.SetArgs()
 Quit result
}

/// 获取查询类的列表
/// 返回: ClassName:%String,TableName:%String
ClassMethod GetClassListDataSet(ClassName As %String = "") As DHCCPMWeb.CPMSevice.dataset.DHCLookClassDataSet [ WebMethod ]
{
	n (ClassName, ExpStr)
	
	s ClassName=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(ClassName)
	
	Set result=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetClassList(ClassName)
	Quit result
}

/// 利用类获取Query的列表
/// 返回： Name:%String, ContainId:%String
ClassMethod GetClsQueryListDataSet(ClsName As %String) As DHCCPMWeb.CPMSevice.dataset.DHCLookQueryDataSet [ WebMethod ]
{
	n (ClsName)
	
	s ClsName=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(ClsName)
	
	Set result=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQueryList(ClsName, "")
	Quit result
}

/// 获取组件列表
/// 返回： ID:%String, Name:%String
/// 这些暂时不用 :  , ClassName:%String, QueryName:%String, DisplayType:%String
ClassMethod GetCompListDataSet(CompName As %String) As DHCCPMWeb.CPMSevice.dataset.DHCLookCompDataSet [ WebMethod ]
{
	n (CompName)
	
	s CompName=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(CompName)
	
	Set result=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetCompList(CompName, "")
	Quit result
}

}
