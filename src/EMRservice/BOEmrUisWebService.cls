Class EMRservice.BOEmrUisWebService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EmrUisWebService";

/// 取新版模板数据
/// w ##Class(EMRservice.BOEmrUisWebService).EMRUISviewEMRTemplate("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod EMRUISviewEMRTemplate(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRTemplate") [ WebMethod ]
{
	s stute =  ##Class(EMRservice.BL.BLEmrUisWebService).getEmrTemplates(paraA,paraB)
	q stute
}

/// 取新版病历数据
/// w ##Class(EMRservice.BOEmrUisWebService).EMRUISEMRDoc("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod EMRUISEMRDoc(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRDoc") [ WebMethod ]
{
	s stute =  ##Class(EMRservice.BL.BLEmrUisWebService).getEmrDocs(paraA,paraB)
	q stute
}

/// 取新版模板数据
/// w ##Class(EMRservice.BOEmrUisWebService).EMRUISviewEMRTemplate("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod EMRUISviewEMRTemplateNew(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRTemplate") [ WebMethod ]
{
	s stute =  ##Class(EMRservice.BL.BLEmrUisWebService).getEmrDocsSimbs(paraA,paraB)
	q stute
}

/// 取新版病历数据
/// w ##Class(EMRservice.BOEmrUisWebService).EMRUISEMRDoc("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod EMRUISEMRDocNew(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRDoc") [ WebMethod ]
{
	s stute =  ##Class(EMRservice.BL.BLEmrUisWebService).getEmrDocsSimbs(paraA,paraB)
	q stute
}

/// 取旧版模板数据
/// w ##Class(EMRservice.BOEmrUisWebService).EMRUISviewEMRTemplate("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod EPRUISviewEMRTemplate(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRTemplate") [ WebMethod ]
{
	s stute =  ##Class(EMRservice.BL.BLEmrUisWebService).getEprTemplates(paraA,paraB)
	q stute
}

/// 取旧版病历数据
/// w ##Class(EMRservice.BOEmrUisWebService).EMRUISEMRDoc("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod EPRUISEMRDoc(paraA As %String, paraB As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRDoc") [ WebMethod ]
{
	s stute =  ##Class(EMRservice.BL.BLEmrUisWebService).getEprDocs(paraA,paraB)
	q stute
}

/// 取旧版病历数据
/// w ##Class(EMRservice.BOEmrUisWebService).EMRUISEMRDoc("2015-1-5 15:57:47","2015-2-28 15:57:47")
ClassMethod EPRUISEMRDocByID(AEpisodeID As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRDoc") [ WebMethod ]
{
	s stute =  ##Class(EMRservice.BL.BLEmrUisWebService).getEprDocsByID(AEpisodeID)
	q stute
}

/// 提供给上海今创的接口(华西二院)
/// w ##Class(EMRservice.BOEmrUisWebService).GetEMRDataByDate("2016-5-5 15:57:47","2016-7-25 15:57:47")
ClassMethod GetEMRDataByDate(paraA As %String, paraB As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEmrUisWebService:GetEMRDataByDate")
	d result.SetArgs(paraA,paraB)
	q result
}

}
