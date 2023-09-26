/// 针对于Panel的操作
Class DHCCPMWeb.CPMSevice.DHCBORepPanels Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

Parameter SERVICENAME = "DHCBORepPanels";

//Parameter LOCATION = "http://192.168.0.132/trakcare/web";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// 删除存在的Panel
ClassMethod DELPanel1(RPRowID As %String) As %String [ WebMethod ]
{
	n (RPRowID)
	s myrtn=""
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).DELETE(RPRowID)
	
	q myrtn
}

/// 加入Panel
ClassMethod AddNewPanel1(RepRowID As %String, myPanel As DHCCPMWeb.CPMSevice.entity.DHCERepPanels) As %String [ WebMethod ]
{
	n (RepRowID,myPanel)
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).AddNewPanel(RepRowID,myPanel)
	q myrtn
}

/// 利用一个 类名称和Query名称生成一个Panel
/// 可以作为新增也可以作为 报表加载
/// 返回  DHCCPMWeb.CPMSevice.entity.DHCERepPanels 对象
ClassMethod GetNewPanelByClsQuery1(ClsName As %String, QueryName As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels [ WebMethod ]
{
	n (ClsName, QueryName, ExpStr)
	
	s PanelRowID=""
	s mypanel=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByClsQuery(PanelRowID, ClsName, QueryName, ExpStr)
	QUIT mypanel
}

/// 根据组件加载成为一个Panel
/// 可以作为新增也可以作为 报表加载
/// 返回  DHCCPMWeb.CPMSevice.entity.DHCERepPanels 对象
ClassMethod GetNewPanelByCompDR1(CompDR As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels [ WebMethod ]
{
	n (CompDR, ExpStr)
	
	s myPanelRowID=""
	
	s mypanel=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByCompDR(myPanelRowID, CompDR,ExpStr)
	
	QUIT mypanel
}

}
