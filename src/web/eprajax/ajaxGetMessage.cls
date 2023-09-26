/// Class Name:		web.eprajax.ajaxGetMessage
/// Description:	与前台交互的webservice服务
/// Creator:	    YHY
/// Create Date:	2012-10-28
Class web.eprajax.ajaxGetMessage Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"-1")
	s pateintID = $Get(%request.Data("PateintID",1),"-1")
	s action = $Get(%request.Data("Action",1),"1")
	s templateID = $Get(%request.Data("TemplateID",1),"1")
	s instanceDataID = $Get(%request.Data("InstanceDataID",1),"1")
	s event = action_"|"_templateID
	d ..GetSubjectMessage(episodeID,pateintID,event,instanceDataID)
	Quit $$$OK
}

/// Creator:	    YHY
/// Create Date:	2012-10-28
/// Description:	获取json数据
/// Return:         按照规定格式拼的string类型数据串
/// Debug:  d ##class(web.eprajax.ajaxGetMessage).GetSubjectMessage("58","9","SAVE|155")
ClassMethod GetSubjectMessage(ArgEpisodeID As %String, ArgpateintID As %String, Argevent As %String, AInstanceDataID As %String) As %String
{
	
	s json = "["
	s count=0
	s event = Argevent
	s result = ##class(EPRservice.Observer.Subject).GetSubjectInfo(event)
	s key=""
	for i=1:1:result.Count()
	{
		s entity = result.GetNext(.key)
    	s code = entity.Code
    	s desc= entity.Description
	    s glossary= entity.Glossary
	    s type = entity.Type
	    s current = ..GetSubjectValue(ArgpateintID,ArgEpisodeID,entity,AInstanceDataID)
	    s observer = ..GetObserverValue(ArgpateintID,ArgEpisodeID,entity)
	    
	    s actionInfo = ..GetObserverAction(ArgpateintID,ArgEpisodeID,current,observer,entity)
	    continue:(actionInfo = "") 
	    
	    s count=count+1
	    if (count > 1) { s json = json_"," }
		s json = json_"{Code:'"_code_"',"
		s json = json_"Desc:'"_desc_"',"
		s json = json_"Current:'"_current_"',"	
		s json = json_"Original:'"_observer_"',"
		s json = json_"Glossary:'"_glossary_"',"
		s json = json_"Type:'"_type_"',"
		s json = json_"CodeAction:'"_actionInfo_"'}"
	}
    s json = json_"]"
    
    w "{"
    w "TotalCount:'"_count_"'"
    w ",data:"_json_"}"
}

/// Desc:	获取被订阅项目值
ClassMethod GetSubjectValue(APatientID As %String, AEpisodeID As %String, AESubject As EPRservice.entity.ESubject, AInstanceDataID As %String) As %String
{
	q:(AESubject="") ""
	
	if (AESubject.Type = "PaPatMas")
	{
		s value = ##Class(EPRservice.BOScatterData).GetDataByGlossary(AEpisodeID,AESubject.Glossary)
	}
	elseif (AESubject.Type = "WMRInfection")
	{
		s value = ##Class(EPRservice.Observer.CustomEPRInfo).GetCustomInfo(AEpisodeID, AESubject.Type, AESubject.Event, AInstanceDataID)
	}
	else
	{
		s value = ""
	}
	
	q value
}

/// Desc:	获取观察者项目值
ClassMethod GetObserverValue(APatientID As %String, AEpisodeID As %String, AESubject As EPRservice.entity.ESubject) As %String
{
	q:(AESubject="") ""
	
	if (AESubject.Type = "PaPatMas")
	{
		s value = ##class(EPRservice.Observer).BLGetData(AESubject.Code,APatientID)
	}
	elseif (AESubject.Type = "WMRInfection")
	{
		s value = ""
	}
	else
	{
		s value = ""
	}
	q value
}

/// Desc:	观察者根据被订阅项目值、自身项目值及自身业务逻辑判断是否需要附加操作
ClassMethod GetObserverAction(APatientID As %String, AEpisodeID As %String, ASubjectValue As %String, AObserverValue As %String, AESubject As EPRservice.entity.ESubject) As %String
{
	
	if (AESubject.Type = "PaPatMas")
	{
		q:(ASubjectValue '= AObserverValue) "1"
	}
	elseif (AESubject.Type = "WMRInfection")
	{
		s actionInfo = ##Class(EPRservice.Observer.WMRInfection).GetInfectionInfo(AEpisodeID,ASubjectValue)
		q actionInfo
	}
	
	q ""
}

}
