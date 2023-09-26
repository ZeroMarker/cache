/// 数据类型对照，分为简单数据类型，复杂数据类型
Class DHCCPMWeb.CPMSevice.DHCBORepDataCont Extends %SOAP.WebService [ ClassType = "", CompileAfter = DHCCPMWeb.CPMBL.DHCBLRepDataCont, Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCBORepDataCont";

/// Parameter LOCATION = "http://127.0.0.1/trakcare68/trak/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// 删除数据类型对照 Success=0  fail<>0
ClassMethod DELRepDC(RowID As %String) As %String [ WebMethod ]
{
	n (RowID)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).DELETE(RowID)
	
	QUIT myrtn
}

/// 新增数据对照 Success=0  fail<>0
ClassMethod INSERT(RepDataCont As DHCCPMWeb.CPMSevice.entity.DHCERepDataCont) As %String [ WebMethod ]
{
	n (RepDataCont)
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).INSERT(RepDataCont)
	
	QUIT myrtn
}

/// 获取全部的数据类型对照 返回DataSet
ClassMethod SelectByDBType(DBType As %String) As DHCCPMWeb.CPMSevice.dataset.DHCDSRepDataContDataSet [ WebMethod ]
{
 New result
 s DBType=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(DBType)
 
 Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCDSRepDataContDataSet).%New()
 Do result.SetArgs(DBType)
 Quit result
}

/// 更新数据类型对照 Success=0  fail<>0
ClassMethod UPDATE(RepDataCont As DHCCPMWeb.CPMSevice.entity.DHCERepDataCont) As %String [ WebMethod ]
{
	n (RepDataCont)
	;判断是否存在
	;否则更新失败
	;$IsObject
	;RepDataCont.RowID
	s $ZT="ERROR^DHCSSERR"
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepDataCont).UPDATE(RepDataCont)
	
	q myrtn
}

}
