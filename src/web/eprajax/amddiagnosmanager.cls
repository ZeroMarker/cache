Class web.eprajax.amddiagnosmanager Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $g(%request.Data("EpisodeID",1),"-1")
	s curAction = $g(%request.Data("CurAction",1),"-1")
	
	s parentID = $Get(%request.Data("node",1),"-1")

	q:(episodeID = "-1") $$$OK
	q:(curAction = "-1") $$$OK
	
	if (curAction = "List")
	{
		//List--获取该病人所在科室的所有疾病类型
		s ctLocID = %session.Get("LOGON.CTLOCID")
		s userID = %session.Get("LOGON.USERID")
		
		do ##Class(EPRservice.BOKBDiagnos).AutoBindKBDiagnos(episodeID,ctlocID,userID) //根据诊断自动绑定病种
		
		w ##Class(EPRservice.BOKBDiagnos).GetDiagnosJSONByCtLocID(episodeID,ctLocID)
	}
	elseif (curAction = "Tree")
	{
		//Tree--获取该病人所在科室的所有疾病类型，分组显示
		s ctLocID = %session.Get("LOGON.CTLOCID")
		d ##Class(EPRservice.BOKBDiagnos).GetDiagnosJSONTreeByCtLocID(episodeID,ctLocID,parentID)
	}
	elseif (curAction = "Get")
	{
		//获取现在关联的疾病
		s ctLocID = %session.Get("LOGON.CTLOCID")
		s userID = %session.Get("LOGON.USERID")
		
		do ##Class(EPRservice.BOKBDiagnos).AutoBindKBDiagnos(episodeID,ctLocID,userID) //根据诊断自动绑定病种
		
		w ##Class(EPRservice.BOKBDiagnos).GetCurrentDiagnosByCtLocID(episodeID,ctLocID)
	}
	elseif (curAction = "Check")
	{
		//获取现在关联的疾病
		s ctLocID = %session.Get("LOGON.CTLOCID")
		w ##Class(EPRservice.BOKBDiagnos).ChecktDiagnosByCtLocID(episodeID,ctLocID)
		//w ##Class(EPRservice.BOKBDiagnos).ChecktDiagnosByCtLocID(201868,34)
	}
	elseif (curAction = "Select")
	{
		//s ^CacheTemp("input") = episodeID
		//Appoint--主管医生指定该病人的疾病类型
		s result = ..SaveEpisodeDiagnos(episodeID)
		if (result = "Y")
		{
			w "{success:true}"
		}
		else
		{
			w "{success:false}"	
		}
	}
	
	q $$$OK
}

/// 名称: 		保存选定的疾病类型的信息
/// 描述: 	
/// 编写者：	Zuoxiang Xie
/// 编写日期: 	09/08/12
/// Debug: w ##class(web.eprajax.amddiagnosmanager).SaveEpisodeDiagnos("201868")
ClassMethod SaveEpisodeDiagnos(episodeID As %String) As %String
{
	s diagnosID  = $g(%request.Data("KBDiagnos",1),"-1")
	q:(diagnosID = "-1") "N"

	//修改病历科室表
	s userID = %session.Get("LOGON.USERID")
	s curAdmPatTypeRowID = $o(^DHCEPRI.AdmPatTypeI("EpisodeIDIdx", " "_episodeID, 0))
	if (curAdmPatTypeRowID = "")
	{
		s curObjAdmPatType = ##Class(EPRinstance.AdmPatType).%New()
	}
	else
	{
		s curObjAdmPatType = ##Class(EPRinstance.AdmPatType).%OpenId(curAdmPatTypeRowID)
	}
	q:(curObjAdmPatType = "") $$$OK
	
	s curObjAdmPatType.EpisodeID = episodeID
	s curObjAdmPatType.EPRKBDiagnosID = diagnosID
	s curObjAdmPatType.AppointUserID = userID
	d curObjAdmPatType.%Save()
	d curObjAdmPatType.%Close()
	s curObjAdmPatType = ""
	
	q "Y"
}

}
