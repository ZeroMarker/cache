Class EPRservice.BOTableRtf Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TableRtfInfo";

ClassMethod AddTableRtfInfos(Nameinfos As %String, TableRtfInfos As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EPRinstance.TableRtf).AddTableRtfInfos(Nameinfos,TableRtfInfos)	
	Quit result
}

ClassMethod DeleteTableRtfInfos(AID As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EPRinstance.TableRtf).DeleteTableRtfInfos(AID)	
	Quit result
}

ClassMethod UpdateTableRtfInfos(AID As %String, TableRtf As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EPRinstance.TableRtf).UpdateTableRtfInfos(AID,TableRtf)	
	Quit result
}

ClassMethod SelectAllTableRtf() As EPRservice.dataset.ETableRtfDataset [ WebMethod ]
{
    Set result=##class(EPRservice.dataset.ETableRtfDataset).%New()
    do result.SetArgs()
	Quit result
}

ClassMethod GetTableRtfStramToString(AID As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EPRinstance.TableRtf).GetTableRtfStramToString(AID)	
	Quit result
}

}
