Class DHCCPMWeb.CPMSevice.DHCBORepImportAndExport Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCBORepImportAndExport";

/// Parameter LOCATION = "http://192.168.0.132/trakcare/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// 导出报表的版本信息，根据版本RowID
ClassMethod GetVerXMLExport(VersionID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	n (VersionID)
	
	s myOBJ = ##class(DHCCPMWeb.CPMBL.DHCBLReportsVersion).GetSelRepVer(VersionID)
	d myOBJ.XMLExportToStream(.myXMLExport)
	
	QUIT myXMLExport
}

/// 导出报表模版信息，根据模版RowID
ClassMethod GetXMLExport(RepRowID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	n (RepRowID)
	;w ##class(DHCCPMWeb.CPMSevice.DHCBOReports).GetXMLExport(2)
	s myOBJ = ##class(DHCCPMWeb.CPMBL.DHCBLReports).GetSingleRep(RepRowID)
	d myOBJ.XMLExportToStream(.myXMLExport)
	
	QUIT myXMLExport
}

/// 导出报表模版的版本信息，根据模版报表RowID和报表的版本号。
/// 返回GlobalCharacterStream类型，把Stream类型转换到Net端。
ClassMethod GetCurVerXMLExport(RepRowID As %String, VerNum As %String) As %GlobalCharacterStream [ WebMethod ]
{
	n (RepRowID,VerNum)
	;w ##class(DHCCPMWeb.CPMSevice.DHCBOReports).GetXMLExport(2)
	s myOBJ = ##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCurVerRep(RepRowID,VerNum)
	d myOBJ.XMLExportToStream(.myXMLExport)
	
	QUIT myXMLExport
}

/// 导入报表，如果报表不存在，则添加报表，如果存在则更新报表（在原有版本信息上再添加
/// 一个版本。原报表模版如果存在Query类型的Panel，就判断它们是否与导入的Query类型的Panel
/// 相同，如果相同就不添加，不同就添加。）
ClassMethod AddImportRepTest(Reps As DHCCPMWeb.CPMSevice.entity.DHCEReports) As DHCCPMWeb.CPMSevice.entity.DHCEReports [ WebMethod ]
{
	n (Reps)
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepImportAndExport).IMPORTINSERTTest(Reps)

	QUIT myrtn
}

/// 根据报表名称判断要导入的报表是否存在。
ClassMethod CheckRep(RepName As %String, RepCatDR As %String) As %String [ WebMethod ]
{
	n (RepName,RepCatDR)
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepImportAndExport).CheckImportRep(RepName,RepCatDR)
	QUIT myrtn
}

}
