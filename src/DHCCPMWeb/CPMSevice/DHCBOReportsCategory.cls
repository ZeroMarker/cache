/// 报表目录的数据传输
Class DHCCPMWeb.CPMSevice.DHCBOReportsCategory Extends %SOAP.WebService [ ClassType = "", CompileAfter = DHCCPMWeb.CPMBL.DHCBLReportsCategory, Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCReportsCategory";

/// Parameter LOCATION = "http://172.21.21.1/trakcare68/trak/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM/DHCBOReportsCategory";

/// 删除报表目录 Success=0  fail<>0
ClassMethod DELRepCat(RowID As %String) As %String [ WebMethod ]
{
	n (RowID)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).DELETE(RowID)
	
	QUIT myrtn
}

/// DataSet类型； 格式
/// %ID:%String, RC_Caption:%String,RC_Name:%String,RC_CategoryDR:%String, RepCount:%String
ClassMethod GetRepCatDataSet() As DHCCPMWeb.CPMSevice.dataset.DHCReportsCategoryDataSet [ WebMethod ]
{
	New result
	Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCReportsCategoryDataSet).%New()
	Do result.SetArgs()
	Quit result
}

/// 新增报表目录 Success=0  fail<>0
/// 返回：rtn^myCurCatRowID
ClassMethod INSERT(RepCat As DHCCPMWeb.CPMSevice.entity.DHCEReportsCategory) As %String [ WebMethod ]
{
	n (RepCat)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).INSERT(RepCat)
	
	QUIT myrtn
}

/// 更新报表目录 Success=0  fail<>0
ClassMethod UPDATE(RepCat As DHCCPMWeb.CPMSevice.entity.DHCEReportsCategory) As %String [ WebMethod ]
{
	n (RepCat)
	;判断是否存在
	;否则更新失败
	;$IsObject
	;RepCat.RowID
	n (RepCat)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReportsCategory).UPDATE(RepCat)
	
	q myrtn
}

}
