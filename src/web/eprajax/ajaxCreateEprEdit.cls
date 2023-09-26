Class web.eprajax.ajaxCreateEprEdit Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	if (%session.Get("LOGON.USERID") = "")
  	{
		w "sessionTimedOut"
		q $$$OK
	}
	
	
	s episodeID = $Get(%request.Data("episodeID",1),"")
	s printTemplateDocId = $Get(%request.Data("printTemplateDocId",1),"")
	s bindPrintTemplateID = ..GetBindPrintTemplateID(printTemplateDocId)
	s currState = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, printTemplateDocId, "1")	

	//根据唯一界面模板所属病历类型判断其EPRNum,
	//1 表示属于科研病历和可重复打印病历
	//2 表示属于唯一打印病历
	s eprNum = ##class(EPRservice.BOEPRLogs).GetSingleEPRNumByDocType(printTemplateDocId)

	//权限
    s userid = %session.Get("LOGON.USERID")  	
    s patientID = $Get(%request.Data("patientID",1),"-1")
    s ctlocid=%session.Get("LOGON.CTLOCID")  
    s ssgroupid = %session.Get("LOGON.GROUPID")
  	
    s templateDocID = $Get(%request.Data("templateDocId",1),"-1")
    s category = ##class(EPRmeta.EPRTemplate).%OpenId(templateDocID)	
	s bindTemplateCategoryID = category.BindTemplateCategoryID	
	s bindTemplateID = category.BindTemplateID
	d category.%Close()
	s category = ""	
	s arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(userid, episodeID, patientID, ctlocid, bindTemplateID, ssgroupid, bindTemplateCategoryID, printTemplateDocId, eprNum)

	//隐私级别
	s privacyLevel = ##class(EPRservice.Privilege.BOPrivRule).GetPrivacyLevel2(userid, episodeID, patientID, ctlocid, bindTemplateID, ssgroupid, bindTemplateCategoryID, printTemplateDocId, eprNum)
	
	//是否是必填模板
 	s necessaryTemplate = "-1"
 	s templateDocId = $Get(%request.Data("templateDocId",1),"-1")
 	if (templateDocId '= "-1")
 	{
 		s template = ##class(EPRmeta.EPRTemplate).%OpenId(templateDocId)
 		s necessaryTemplate = template.NecessaryTemplate
 		d template.%Close()
 	}
	

	//日志记录状态
	s divStateServer = ##class(EPRinstance.EPRLogs).GetCurrStatus(episodeID, printTemplateDocId, eprNum)
	
	//病人信息
	s patientInfo = ..GetPatientInfo(episodeID, printTemplateDocId,privacyLevel)
	s json = ""
	s json = json_"canView:'"_arr.GetAt("canView")_"',canSave:'"_arr.GetAt("canSave")_"',canPrint:'"_arr.GetAt("canPrint")_"',canCommit:'"_arr.GetAt("canCommit")_"',canSwitch:'"_arr.GetAt("canSwitch")_"',canSwitchTemplate:'"_arr.GetAt("canSwitchTemplate")_"',canChiefCheck:'"_arr.GetAt("canChiefCheck")_"',canAttendingCheck:'"_arr.GetAt("canAttendingCheck")_"',printAfterCommit:'"_arr.GetAt("canPrintAfterCommit")_"',canReference:'"_arr.GetAt("canReference")_"',canExport:'"_arr.GetAt("canExport")
	s json = json_"',necessaryTemplate:'"_necessaryTemplate_"',bindTemplateID:'"_bindTemplateID_"',bindPrintTemplateID:'"_bindPrintTemplateID_"',currState:'"_currState_"',divStateServer:'"_divStateServer_"',EPRNum:'"_eprNum_"',"_patientInfo
	w json
	q $$$OK
}

/// 根据打印模板docID找到相关的打印模板id
ClassMethod GetBindPrintTemplateID(printTemplateDocId As %String) As %String
{
	s curPrintTemplateID = "" 		
 	s objPrintTemplateDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(printTemplateDocId)
 	if (objPrintTemplateDoc '= "")
 	{
		s curPrintTemplateID = objPrintTemplateDoc.BindPrnTemplateID
		d objPrintTemplateDoc.%Close()
		s objPrintTemplateDoc = ""
		if ((curPrintTemplateID = $c(0)) || (curPrintTemplateID = " "))
		{
			s curPrintTemplateID = ""	
		}
	}
	
 	q curPrintTemplateID
}

/// 病人信息
ClassMethod GetPatientInfo(episodeID As %String, printTemplateDocId As %String = "", privacyLevel As %String = "") As %String
{
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	
	s patientInfo = ..GetPatientInfoInBrowser(patientID, episodeID, printTemplateDocId,privacyLevel)
	
	q patientInfo
}

/// Creator:loo
/// CreatDate:2010-9-6
/// Desc:	取病人基本信息,
/// 		若EpisodeID信息不为空，取病人信息+就诊信息，
/// 		若EpisodeID为空，取病人信息
/// Table:
/// Input:	patientID As %String, episodeID As %String, printTemplateDocId As %String
/// Output:
/// Return:	格式为Json的病人基本信息字符串
/// Others:	病历浏览页面上病人基本信息加载
ClassMethod GetPatientInfoInBrowser(patientID As %String, episodeID As %String, printTemplateDocId As %String, privacyLevel As %String = "") As %String
{
	s patientInfo = ""
	
	s papmiNo = ""		//登记号
	s name = ""			//姓名
	s age = ""			//年龄
	s gender = ""		//性别
	s disBed = ""		//出院床位
	s payType = ""		//付费类型
	s admDate = ""		//入院日期
	s mainDiagnos = ""	//主要诊断
	s ipRecordNo = "" 	//病案号
	
	//取就诊信息
	if (episodeID '= "")&&(episodeID '= $C(0))
	{
		//取患者指针
		s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
		
		//年龄
		s birthday = ##class(EPRservice.HISInterface.PatientInfoAssist).Birthday(patientID)
		s admDate = ##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID, "")
		s admDate = $P(admDate, ",", 1)
		s age = ##class(EPRservice.HISInterface.PatientInfoAssist).Age(episodeID,birthday,admDate,4)
		
		//出院床位
		s disBed = ##class(EPRservice.HISInterface.PatientInfoAssist).DisBed(episodeID)
		
		//付费类型
		s payType =  ##class(EPRservice.HISInterface.PatientInfoAssist).PayType(episodeID)
		
		//入院日期
		s admDateTime = ##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
		s admDate = $P(admDateTime, ",", 1)
		if (admDate '= "") s admDate = $zd(admDate,3)
		
		//主要诊断
		//s mainDiagnos = ##class(EPRservice.HISInterface.PatientInfoAssist).MainDiagnos(episodeID)
		s mainDiagnos = ##class(EPRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
		if (mainDiagnos '= "")
		{	
			s mainDiagnos = $P(mainDiagnos,"^",3)
			s mainDiagnos = $tr(mainDiagnos,"'","\'")
		}
		
		s hospital = ##class(EPRservice.HISInterface.PatientInfoAssist).HospitalName()
		//不能直接使用病案号新接口，很多老项目没有此接口，需要使用新接口时，请在 IPRecordNoInfo 中使用医院兼容
		s ipRecordNo = ##class(EPRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(episodeID, hospital)
		//add by YHY 病案号新接口
		//s ipRecordNo = ##class(web.DHCWMRService).IGetMrNoByEpisodeID(episodeID)
	}
	
			
	//用patientID取病人信息
	if (patientID '= "")&&(patientID '= $C(0))
	{
		//登记号
		s papmiNo = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
		
		//姓名
		s name = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(patientID)
		s name = $tr(name,"'","’")
		if privacyLevel '= ""
		{
			s name = "***"
		}
		
		//性别
		s gender = ##class(EPRservice.HISInterface.PatientInfoAssist).Gender(patientID, "")
		s gender = $P(gender, "^", 3)
	}
		
	s patientInfo = "papmiNo:'"_papmiNo_"',name:'"_name_"',gender:'"_gender_"',disBed:'"_disBed_"',age:'"_age_"',mainDiagnos:'"_mainDiagnos_"',payType:'"_payType_"',admDate:'"_admDate_"',ipRecordNo:'"_$g(ipRecordNo)_"'"
	
	//转换特殊字符
	s patientInfo = $tr(patientInfo,$c(10),"")	//<+ added on 2010-12-31 by houj>
	s patientInfo = $tr(patientInfo,$c(13),"")	//<+ added on 2010-12-31 by houj>
	s patientInfo = $tr(patientInfo,"""","")  	//<+ added on 2011-11-18 by xiezx>
	
	q patientInfo
}

}
