/// Creator: Candyxu
/// Creatdeta :20120410
Class EPRservice.BOCustomDictory Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CustomDictoryInfo";

/// Ceator:Candyxu
/// Deat:2012-04-10
/// Desc:根据模板获得可重复模板标题
ClassMethod GetTitleBYTid(TID As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLCustomDictory).GetDateByTID(TID)
}

/// Ceator:Candyxu
/// Date:2012-04-11
/// Desc:诊断类型与可重复模板标题的对应关系
ClassMethod GetAllDiagnosTypeByTitle() As EPRservice.dataset.EDiagnosTypeByTitle [ WebMethod ]
{
	Set DiagnsTypeByTitle = ##class(EPRservice.dataset.EDiagnosTypeByTitle).%New()
	do DiagnsTypeByTitle.SetArgs()
	Quit DiagnsTypeByTitle
}

/// Ceator:Candyxu
/// Date:2012-05-15
/// Desc: 牙位信息
ClassMethod GetTeethPestion() As EPRservice.dataset.ETeethPestion [ WebMethod ]
{
	s dsObj = ##Class(EPRservice.dataset.ETeethPestion).%New()
	d dsObj.SetArgs()
	q dsObj
}

}
