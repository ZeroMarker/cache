Class EPRservice.BOEPRQuotePage Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRQuotePage";

//查询

ClassMethod GetData() As EPRservice.dataset.EPRPageURLAllDataset [ WebMethod ]
{
	Set result = ##class(EPRservice.dataset.EPRPageURLAllDataset).%New()
	quit result
	
	/*
	Set result = ##class(%XML.DataSet).%New()
	Do result.Prepare("select ID, Title, URL, Paras, Num from EPRmeta.EPRPageURL")
	Quit result
	*/
}

//更新

ClassMethod UpdateData(rowID As %String, URL As %String, Paras As %String, Title As %String, Num As %String) As %String [ WebMethod ]
{
	set EPRPageURL = ##class(EPRmeta.EPRPageURL).%OpenId(rowID)
	q:(EPRPageURL="") "0"
	set EPRPageURL.URL = URL
	set EPRPageURL.Paras = Paras
	set EPRPageURL.Title = Title
	set EPRPageURL.Num = Num
	s status = EPRPageURL.%Save()
	q:('$$$ISOK(status)) "0"	
	q "1"
}

//增加

ClassMethod AddData(URL As %String, Paras As %String, Title As %String, Num As %String) As %String [ WebMethod ]
{
	set EPRPageURL = ##class(EPRmeta.EPRPageURL).%New()
	set EPRPageURL.URL = URL
	set EPRPageURL.Paras = Paras
	set EPRPageURL.Title = Title
	set EPRPageURL.Num = Num
	s status = EPRPageURL.%Save()
	q:('$$$ISOK(status)) "0"	
	q "1"
}

//删除

ClassMethod DeleteData(rowID As %String) As %String [ WebMethod ]
{
	set EPRPageURL = ##class(EPRmeta.EPRPageURL).%OpenId(rowID)
	q:(EPRPageURL="") "0"
	s status = EPRPageURL.%DeleteId(rowID)
	q:('$$$ISOK(status)) "0"	
	q "1"
}

}
