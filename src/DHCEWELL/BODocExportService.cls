/// 名称：		DHCEWELL.BODocExportService
/// 描述：		宁医大总院慢病管理系统EMR接口
/// 编写者：	yejian
/// 编写时间：	2017-2-5
Class DHCEWELL.BODocExportService Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DocExportService";

/// 取新版模板数据
/// w ##Class(DHCEWELL.BODocExportService).EmrDocument("324","HDSD00.11")
ClassMethod EmrDocument(EncounterId As %String, EhrType As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s reselut =  ##Class(DHCEWELL.BL.BLDocExportService).EmrDocument(EncounterId,EhrType)
	q reselut
}

ClassMethod SelectAllDataElement() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEWELL.BL.BLDocExportService:SelectAllDataElement")
	d result.SetArgs()
	q result
}

//ClassMethod FirstPageInfo(EncountId As %String, EhrType As %String) As %ListOfObjects(ELEMENTTYPE="EMRservice.entity.EViewEMRTemplate") [ WebMethod ]

//{

//	s stute =  ##Class(EMRservice.BL.BLDocExportService).EmrDocument(paraA,paraB)

//	q stute

//}

}
