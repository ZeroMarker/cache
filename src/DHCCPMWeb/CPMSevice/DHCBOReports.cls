/// ///专门针对于报表的逻辑关系
Class DHCCPMWeb.CPMSevice.DHCBOReports Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// 包含的接口是：
/// 插入Reps
/// 加入Panel
/// 加入自定义的Fields
/// 加入自定义的Parameters
/// 设计态加载当前版本的报表  返回Reps
/// 数据打印加载发布的版本    返回Reps
/// 返回报表的DataSet（是否考虑权限）
/// 在Net端增加一个新的报表时，需要返回一个空的EReps对象
/// 
/// Name of the WebService.
Parameter SERVICENAME = "DHCBOReports";

/// Parameter LOCATION = "http://192.168.0.1/trakcare/trak/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CPM/DHCCPM";

/// 增加新的版本的报表体
/// 要求不能新增加Panel对象 
/// 丁浩： 可以理解为增加一个样式表，而Panel 都是从属于Report对象
/// 程序在实现时可能有些变化；在打开报表时 优先加载发布的样式表，其他版本的样式表，可以点击加载
/// 但是在一个报表中的
ClassMethod AddNewVerReps(NRepVer As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion) As %String
{
	;
	n (NRepVer)
	s myrtn=0
	
	QUIT myrtn
}

/// 增加报表
/// 返回: Rtn^myCurRepRowID(当前报表的RowID)
/// DHCCPMWeb.CPMSevice.entity.DHCEReports
ClassMethod AddNewRep(Reps As DHCCPMWeb.CPMSevice.entity.DHCEReports) As %String [ WebMethod ]
{
	n (Reps)
	s myrtn=0
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).INSERT(Reps)
	QUIT myrtn
}

/// 验证报表名称是否存在
/// 不存在=0
/// 否则<>0
ClassMethod CheckRepName(RepName As %String) As %String [ WebMethod ]
{
	;w ##class(DHCCPMWeb.CPMSevice.DHCBOReports).CheckRepName(RepName)
	n (RepName)
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).CheckRepName(RepName)
	
	QUIT myrtn
}

/// 删除本报表(包含版本，Panels)  Success=0  fail<>0
/// 此操作同时自动删除对应的报表样式
ClassMethod DELCurRep(RowID As %String) As %String [ WebMethod ]
{
	n (RowID)
	
	s myrtn=0
	
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).DELETE(RowID)
	QUIT myrtn
}

/// 根据报表名称 获取发布的模板对象 return DHCEReports 对象
/// RepName  报表名称 这个在 创建报表时已经验证
/// 
ClassMethod GetPublicVerByRepName(RepName As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports [ WebMethod ]
{
	n (RepName)
	
	s myobj=0
	s myobj=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetPublicVerByRepName(RepName)
	
	QUIT myobj
}

/// 打印数据状态 获取发布的模板对象 return DHCEReports 对象
/// RepRowID 报表RowID
/// VerNum报表版本
/// PublicFlag=Y 取出发布的版本
/// PublicFlag=N表示取出当前选择的版本  PublicFlag As %String
ClassMethod GetCurVerRep(RepRowID As %String, VerNum As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports [ WebMethod ]
{
	n (RepRowID,VerNum)
	
	s myobj=0
	s myobj=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCurVerRep(RepRowID,VerNum)
	
	QUIT myobj
}

/// 在Net端单独生成一个默认的Report对象
/// 返回给客户端一个默认的空白报表，这个报表在数据库中不存在的
/// 需要输入的参数：
/// 名称
/// 标题
/// 描述等
/// 返回 DHCEReports 对象
ClassMethod GetDefaultRep(RepName As %String, RepCaption As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports [ WebMethod ]
{
	n (RepName, RepCaption)
	
	s myobj=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetDefaultRep(RepName, RepCaption)
	
	q myobj
}

/// 根据报表目录获取报表信息DataSet
/// 返回格式：
/// %ID,DateFrom,DateTo,LastVersion,PublishVersion,RepCaption,RepName,RPComponentDR, RepCount
ClassMethod GetRepByCatDRDataSet(RepCatDR As %String) As DHCCPMWeb.CPMSevice.dataset.DHCRepsCatDRDataSet [ WebMethod ]
{
	n result
	s RepCatDR=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RepCatDR)
	
	Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCRepsCatDRDataSet).%New()
	Do result.SetArgs(RepCatDR)
	Quit result
}

/// DHCCPMWeb.CPMSevice.dataset.DHCRepVerByRepDataSet
/// 根据报表获取报表样式表/ 或报表的版本
/// 返回格式：
/// %ID,RV_Author,RV_CreateDate,RV_CreateTime,RV_PublicationDate,RV_PublicationTime,RV_Status,RV_VersionNumber
ClassMethod GetRepVerByRepDataSet(RepRowID As %String) As DHCCPMWeb.CPMSevice.dataset.DHCRepVerByRepDataSet [ WebMethod ]
{
	n result
	s RepRowID=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(RepRowID)
	
	Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCRepVerByRepDataSet).%New()
	Do result.SetArgs(RepRowID)
	Quit result
}

/// 获取报表版本数据列表
/// 返回格式
/// %ID,RV_Author,RV_CreateDate,RV_CreateTime,RV_PublicationDate,RV_PublicationTime,RV_Status,RV_VersionNumber,ParRef
ClassMethod GetRepVerListDataSet() As DHCCPMWeb.CPMSevice.dataset.DHCRepVerListDataSet [ WebMethod ]
{
	New result
	Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCRepVerListDataSet).%New()
	Do result.SetArgs()
	Quit result
}

/// 获取报表的一个列表
/// 返回格式：
/// %ID,DateFrom,DateTo,LastVersion,PublishVersion,RepCaption,RepName,RPComponentDR,RepCategoryDR, RepCount
ClassMethod GetRepsListDataSet() As DHCCPMWeb.CPMSevice.dataset.DHCRepsListDataSet [ WebMethod ]
{
	New result
	Set result=##class(DHCCPMWeb.CPMSevice.dataset.DHCRepsListDataSet).%New()
	Do result.SetArgs()
	Quit result
}

/// 获取一个单独的Report对象  不包含子对象
ClassMethod GetSingleRep(RepRowID As %String) As DHCCPMWeb.CPMSevice.entity.DHCEReports [ WebMethod ]
{
	n (RepRowID)
	
	s myobj=##class(DHCCPMWeb.CPMBL.DHCBLReports).GetSingleRep(RepRowID)
	
	QUIT myobj
}

/// 发布报表的版本
ClassMethod PublishVersion(RepVer As DHCCPMWeb.CPMSevice.entity.DHCEReportsVersion) As %String [ WebMethod ]
{
	n (RepVer)
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).PublishVersion(RepVer)
	q myrtn
}

/// 更新当前的报表
/// DHCCPMWeb.CPMSevice.entity.DHCEReports
ClassMethod UpdateCurRep(Reps As DHCCPMWeb.CPMSevice.entity.DHCEReports) As %String [ WebMethod ]
{
	n (Reps)
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLReports).UPDATE(Reps)
	
	Quit myrtn
}

/// 删除存在的Panel
ClassMethod DELPanel(RPRowID As %String) As %String [ WebMethod ]
{
	n (RPRowID)
	s myrtn=""
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).DELETE(RPRowID)
	
	q myrtn
}

/// 加入Panel
ClassMethod AddNewPanel(RepRowID As %String, myPanel As DHCCPMWeb.CPMSevice.entity.DHCERepPanels) As %String [ WebMethod ]
{
	n (RepRowID,myPanel)
	s myrtn=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).AddNewPanel(RepRowID,myPanel)
	q myrtn
}

/// 利用一个 类名称和Query名称生成一个Panel
/// 可以作为新增也可以作为 报表加载
/// 返回  DHCCPMWeb.CPMSevice.entity.DHCERepPanels 对象
ClassMethod GetNewPanelByClsQuery(ClsName As %String, QueryName As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels [ WebMethod ]
{
	n (ClsName, QueryName, ExpStr)
	
	s PanelRowID=""
	s mypanel=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByClsQuery(PanelRowID, ClsName, QueryName, ExpStr)
	QUIT mypanel
}

/// 根据组件加载成为一个Panel
/// 可以作为新增也可以作为 报表加载
/// 返回  DHCCPMWeb.CPMSevice.entity.DHCERepPanels 对象
ClassMethod GetNewPanelByCompDR(CompDR As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels [ WebMethod ]
{
	n (CompDR, ExpStr)
	
	s myPanelRowID=""
	
	s mypanel=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByCompDR(myPanelRowID, CompDR,ExpStr)
	
	QUIT mypanel
}

ClassMethod GetNewPanelByCompName(CompName As %String, ExpStr As %String) As DHCCPMWeb.CPMSevice.entity.DHCERepPanels [ WebMethod ]
{
	n (CompName, ExpStr)
	
	s CompName=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(CompName)
	s ExpStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).TransNICPara(ExpStr)
	
	s myPanelRowID=""
	
	s mypanel=##class(DHCCPMWeb.CPMBL.DHCBLRepPanels).GetPanelByCompName(myPanelRowID, CompName,ExpStr)
	
	QUIT mypanel
}

}
