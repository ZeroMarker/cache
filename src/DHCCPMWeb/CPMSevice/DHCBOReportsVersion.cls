/// 对于不同版本报表格式提供的操作
Class DHCCPMWeb.CPMSevice.DHCBOReportsVersion Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

Parameter SERVICENAME = "DHCBOReportsVersion";

/// Parameter LOCATION = "http://127.0.0.1/trakcare68/trak/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// 删除选择的报表格式
ClassMethod DELSelRepVer(RVRowID As %String) As %String [ WebMethod ]
{
	n (RVRowID)
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).DELETE(RVRowID)
	
	q myrtn
}

/// 得到当前的报表格式
ClassMethod GetSelRepVer(RVRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion [ WebMethod ]
{
	n (RVRowID)
	;w ##class(DHCCPMWeb.CPMSevice.DHCBOReportsVersion).GetSelRepVer(RVRowID)
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).GetSelRepVer(RVRowID)
	
	q myrtn
}

/// 获得一个新的报表格式
/// 
ClassMethod GetNewRepVer(RepRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion [ WebMethod ]
{
	n (RepRowID)
	;
	s myRepVer=""
	
	s myRepVer=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).GetNewRepVer(RepRowID)
	
	q myRepVer
}

/// 新增报表版本
ClassMethod AddNewVer(RepRowID As %String, RepVer As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion) As %String [ WebMethod ]
{
	n (RepRowID, RepVer)
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).AddNewVer(RepRowID, RepVer)
	
	q myrtn
}

}
