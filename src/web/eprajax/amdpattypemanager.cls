/// 名称: 与前台交付,设置病历类型相关操作的类
/// 描述: 
/// 编写者：chenwenjun
/// 编写日期: 09/08/12
Class web.eprajax.amdpattypemanager Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID  = $Get(%request.Data("EpisodeID",1),"-1")
	s appType = $Get(%request.Data("AppType",1),"null")		//操作类型 List--获取该病人所在科室的病人类型  Select--指定该病人的病历类型
	q:(appType = "null") $$$OK
	q:(episodeID = "-1") $$$OK

	if (appType = "List")
	{
		//List--获取该病人所在科室的所有病人类型
		w ##class(EPRservice.EPRDoc.DocCategoryFunSet).GetPatientTypeList(episodeID)
	}
	elseif (appType = "Select")
	{
		//Appoint--主管医生指定该病人的病历所在科室
		s result = ..SltPatType(episodeID)
		if (result = "Y")
		{
			w "{success:true}"
		}
		else
		{
			w "{success:false}"	
		}
	}
	
	Quit $$$OK
}

/// 名称: 保存选定的病历类型的信息
/// 描述: 
/// 编写者：chenwenjun
/// 编写日期: 09/08/12
ClassMethod SltPatType(episodeID As %String) As %String
{
	s patTypeCode  = $Get(%request.Data("PatType",1),"-1")
	
	q:(patTypeCode = "-1") "N"
	//
	
	//修改病历科室表
	s userID = %session.Get("LOGON.USERID")
	s curAdmPatTypeRowID = $o(^DHCEPRI.AdmPatTypeI("EpisodeIDIdx", " "_episodeID, 0))
	if (curAdmPatTypeRowID = "")
	{
		s curObjAdmPatType = ##class(EPRinstance.AdmPatType).%New()
	}
	else
	{
		s curObjAdmPatType = ##class(EPRinstance.AdmPatType).%OpenId(curAdmPatTypeRowID)
	}
	q:(curObjAdmPatType = "") $$$OK
	
	s curObjAdmPatType.EpisodeID = episodeID
	s curObjAdmPatType.PatType = patTypeCode
	s curObjAdmPatType.AppointUserID = userID
	d curObjAdmPatType.%Save()
	d curObjAdmPatType.%Close()
	s curObjAdmPatType = ""
	//

	
	//返回
	q "Y"
}

}
