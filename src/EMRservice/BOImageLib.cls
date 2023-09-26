Class EMRservice.BOImageLib Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ImageLibInfo";

/// w ##Class(EMRservice.BOImageLib).GetImageLibByID("1")
ClassMethod GetImageLibByID(AImageLibID As %String) As EMRservice.entity.EImageLib [ WebMethod ]
{
	s ret = ""
	s imageLibID = $g(AImageLibID)
	q:(imageLibID = "") ret
	 
	s objImageLib = ##Class(EMRmeta.ImageLib).%OpenId(imageLibID)
	q:(objImageLib = "") ret
	
	s result = ##Class(EMRservice.entity.EImageLib).%New()
	s result.ID = imageLibID
	s result.Name = objImageLib.Name
	s result.CategoryID = objImageLib.CategoryID
	s result.Description = objImageLib.Description
	s result.Sequence = objImageLib.Sequence
	q result
}

ClassMethod GetLibCountByCateID(ACategoryID As %String) As %Integer
{
	s count = 0
	&sql(SELECT COUNT(*) INTO :count FROM EMRmeta.ImageLib WHERE CategoryID =:ACategoryID)
	q count
}

ClassMethod GetImageLibCount() As %String [ WebMethod ]
{
	s count = 0
	&sql(SELECT max(Sequence) INTO :count FROM EMRmeta.ImageLib)
	i (count=$C(0)) s count=0
	i (count="") s count=0
	q count
}

ClassMethod GetImageLibsByCateID(ACategoryID As %String) As EMRservice.dataset.EImageLibDataset [ WebMethod ]
{
	s result = ##Class(EMRservice.dataset.EImageLibDataset).%New()
	d result.SetArgs(ACategoryID)
	q result
}

ClassMethod CreateImageLib(AEImageLib As EMRservice.entity.EImageLib) As %String [ WebMethod ]
{
	s ret = ""
	s objImageLib = ##Class(EMRmeta.ImageLib).%New()
	q:(objImageLib = "") ret
	
	s objImageLib.Name = AEImageLib.Name
	s objImageLib.CategoryID = AEImageLib.CategoryID
	s objImageLib.Description = AEImageLib.Description
	s objImageLib.Sequence = AEImageLib.Sequence 
	
	d objImageLib.%Save()
	
	s ret = objImageLib.%Id()
	q ret
}

ClassMethod DeleteImageLib(AImageLibID As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:(AImageLibID = "") ret
	
	s objImageLib = ##Class(EMRmeta.ImageLib).%OpenId(AImageLibID)
	q:(objImageLib = "") ret
	
	s ret = objImageLib.%DeleteId(AImageLibID)
	q ret
}

ClassMethod UpdateImageLib(AEImageLib As EMRservice.entity.EImageLib) As %String [ WebMethod ]
{
	s ret = 0
	s objImageLib = ##Class(EMRmeta.ImageLib).%OpenId(AEImageLib.ID)
	q:(objImageLib = "") ret
	
	s objImageLib.Name = AEImageLib.Name
	s objImageLib.CategoryID = AEImageLib.CategoryID
	s objImageLib.Description = AEImageLib.Description
	s objImageLib.Sequence = AEImageLib.Sequence 
	
	d objImageLib.%Save()
	
	s ret = objImageLib.%Id()
	q ret
}

/// Debug:	w ##Class(EMRservice.BOImageLib).GetPatientNameByEpisodeID("201871")
ClassMethod GetPatientNameByEpisodeID(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ""
	q:($g(AEpisodeID) = "") ret
	
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	s patientID = $p(objPaAdm,"^",1)
	q:(patientID = "") ret
	
	s ret = $p($g(^PAPER(+patientID,"ALL")),"^",1)
	q ret
}

}
