/// Creator:Candyxu
/// CreateDate:2013-04-26
/// Desc:存储病人基本信息
Class DHCEPRFS.Srv.SrvPatInformation Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvPatInformation";

/// Creator:Candyxu
/// CreateDate:2013-04-27
/// Desc:增加病人基本及就诊信息
ClassMethod SetPatientInformation(AEpisodeID As %String) As %String [ WebMethod ]
{
  s result = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).SetPatientInfomation(AEpisodeID)
  q result
}

ClassMethod GetPatientInfromation(Apara As DHCEPRFS.Entity.EPatientInfoQueryPara) As DHCEPRFS.DataSet.PatientInfoDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.PatientInfoDS).%New()
	d result.SetArgs(Apara)
	q result
}

ClassMethod GetPatientInfo(Apara As DHCEPRFS.Entity.EPatientInfoQueryPara) As DHCEPRFS.DataSet.EPatientInfoDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.EPatientInfoDS).%New()
	d result.SetArgs(Apara)
	q result
}

ClassMethod GetRegNo(APatientID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(APatientID)
	q ret
}

ClassMethod GetNameByAlias(AAlias As %String) As DHCEPRFS.DataSet.ENameAlias [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.ENameAlias).%New()
	d result.SetArgs(AAlias)
	q result
}

ClassMethod GetPatInfo4Print(Apara As DHCEPRFS.Entity.EPatientInfoQueryPara) As DHCEPRFS.DataSet.EPrintPatInfoDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.EPrintPatInfoDS).%New()
	d result.SetArgs(Apara)
	q result
}

ClassMethod GetPatientInfoByAdm(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientInfoByAdm(AEpisodeID)
	q ret
}

ClassMethod GetDisLocByAlias(AAlias As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLNameAlias:GetDisLocByAlias")
	d ds.SetArgs(AAlias)
	q ds
}

ClassMethod GetPatInfoUserControl(AEpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.HISInfo.BLPatientInfo:GetPatInfoUserControl")
	d ds.SetArgs(AEpisodeID)
	q ds
}

}
