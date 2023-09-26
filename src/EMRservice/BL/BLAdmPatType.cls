Class EMRservice.BL.BLAdmPatType Extends %RegisteredObject
{

/// 设置患者病种
ClassMethod SaveAdmPatType(AEpisodeID As %String, ADiseaseCode As %String, AUserID As %String) As %String
{


	s curAdmPatTypeRowID = $o(^DHCEMRI.AdmPatTypeI("IdxEpisodeID", " "_AEpisodeID, 0))
	if (curAdmPatTypeRowID = "")
	{
		s curObjAdmPatType = ##Class(EMRinstance.AdmPatType).%New()
	}
	else
	{
		s curObjAdmPatType = ##Class(EMRinstance.AdmPatType).%OpenId(curAdmPatTypeRowID)
	}
	q:(curObjAdmPatType = "")
	
	s curObjAdmPatType.EpisodeID = AEpisodeID
	s curObjAdmPatType.DiseaseCode = ADiseaseCode
	s curObjAdmPatType.AppointUserID = AUserID
	d curObjAdmPatType.%Save()
	d curObjAdmPatType.%Close()
	s curObjAdmPatType = ""
	
	q "1"
}

/// 设置获取患者病种
/// w ##class(EMRservice.BL.BLAdmPatType).GetAdmPatType(26)
ClassMethod GetAdmPatType(AEpisodeID As %String) As %String
{

	s ret="{}"
	s curAdmPatTypeRowID = $o(^DHCEMRI.AdmPatTypeI("IdxEpisodeID", " "_AEpisodeID, 0))
	q:(curAdmPatTypeRowID = "") ret

	s curObjAdmPatType = ##Class(EMRinstance.AdmPatType).%OpenId(curAdmPatTypeRowID)
	s diseaseCode = curObjAdmPatType.DiseaseCode
	s diseaseName = ..GetDiseaseInfoByCode(diseaseCode)
	
	//q:(diseaseName="") ret
	
	s diseaseInfo = "{""Code"":"""_diseaseCode_""",""Name"":"""_diseaseName_"""}"
	q diseaseInfo
}

ClassMethod GetDiseaseInfoByCode(ADiseaseCode As %String)
{
	s RowId=""
	
	s RowId = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_ADiseaseCode,RowId))
	q:(RowId = "") ""
	
	s DiseaseName = ""

	s obj = ##class(EMRmeta.Diagnos).%OpenId(RowId)
	s DiseaseName = obj.DiagnosName
	q DiseaseName
}

/// 清除病种
ClassMethod ClearAdmPatType(AEpisodeID As %String, AUserID As %String) As %String
{
	s curAdmPatTypeRowID = $o(^DHCEMRI.AdmPatTypeI("IdxEpisodeID", " "_AEpisodeID, 0))
	q:(curAdmPatTypeRowID = "") "0"
	
	s curObjAdmPatType = ##Class(EMRinstance.AdmPatType).%OpenId(curAdmPatTypeRowID)
	s curObjAdmPatType.DiseaseCode = ""
	s curObjAdmPatType.AppointUserID = AUserID
	d curObjAdmPatType.%Save()
	d curObjAdmPatType.%Close()
	s curObjAdmPatType = ""
	
	q "1"
}

}
