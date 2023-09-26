/// 病种业务操作接口
Class EMRservice.Ajax.kbDisease Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeID = $g(%request.Data("EpisodeID",1),"-1")
	s curAction = $g(%request.Data("CurAction",1),"-1")
	s diagnosID  = $g(%request.Data("KBDiagnos",1),"-1")

	q:(episodeID = "-1") $$$OK
	q:(curAction = "-1") $$$OK
	
	if (curAction = "List")
	{
		//List--获取该病人所在科室的所有疾病类型
		s ctLocID = $g(%request.Data("UserLocID",1),"")
		//w ##Class(EMRservice.BL.BLKBDiagnos).GetDiagnosJSONByCtLocID(episodeID,ctLocID)
		w ##Class(EMRservice.BL.BLDiseases).GetDiseasesList(episodeID,ctLocID)
	}
	elseif (curAction = "Select")
	{
		//Appoint--主管医生指定该病人的疾病类型
		s result = ##Class(EMRservice.BL.BLDiseases).SaveEpisodeDiagnos(episodeID,diagnosID)
		if (result = "Y")
		{
			w "success"
		}
		else
		{
			w "failed"	
		}
	}
	
	q $$$OK
}

}
