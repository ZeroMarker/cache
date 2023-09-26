/// 名称: web.eprajax.ConsultationAction
/// 描述: 会诊病历浏览授权
/// 编写者: Zuoxiang Xie
/// 编写日期:2011-03-08
Class web.eprajax.ConsultationAction Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	s patientID = $g(%request.Data("PatientID",1),"")
	s consultID = $g(%request.Data("ConsultID",1),"")
	s requestCateCharpter = $g(%request.Data("RequestCateCharpter",1),"")
	s authorizeUserID = $g(%request.Data("AuthorizeUserID",1),"")
	s authorizeLocID = $g(%request.Data("AuthorizeLocID",1),"")	
	s epraction = $g(%request.Data("EPRAction",1),"")
	s appointUserID = $g(%request.Data("AppointUserID",1),"")
	s consultType = $g(%request.Data("ConsultType",1),"")
	s appointType = $g(%request.Data("AppointType",1),"")
	
	/*
	s ^CacheTempXZX("EPRBrowser","EpisodeID") = episodeID
	s ^CacheTempXZX("EPRBrowser","PatientID") = patientID
	s ^CacheTempXZX("EPRBrowser","ConsultID") = consultID
	s ^CacheTempXZX("EPRBrowser","RequestCateCharpter") = requestCateCharpter
	s ^CacheTempXZX("EPRBrowser","AuthorizeUserID") = authorizeUserID
	s ^CacheTempXZX("EPRBrowser","AuthorizeLocID") = authorizeLocID
	s ^CacheTempXZX("EPRBrowser","EPRAction") = epraction
	s ^CacheTempXZX("EPRBrowser","AppointUserID") = appointUserID
	s ^CacheTempXZX("EPRBrowser","ConsultType") = consultType
	s ^CacheTempXZX("EPRBrowser","AppointType") = appointType
	*/
	
	w ..AddAuthorize(episodeID,requestCateCharpter,authorizeUserID,authorizeLocID,epraction,appointUserID,consultID,consultType,appointType)
	
	q $$$OK
}

ClassMethod AddAuthorize(AEpisodeID As %String, ARequestCateCharpter As %String, ARequestUserID As %String, ARequestDept As %String, AEPRAction As %String, AUserID As %String, AConsultID As %String, AConsultType As %String, AAppointType As %String) As %String
{
	s ret = -1
	
	TSTART
	
	s appoint = ##Class(EPRinstance.EPRActionAppoint).%New()
	q:(appoint = "") ret
	
	s appoint.EpisodeID = AEpisodeID
	
	//取当前系统时间
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	s appoint.AppointDate = date
	s appoint.AppointTime = time
	
	//默认为截止日期增加一个月
	s appoint.AppointEndDate = date + 30
	s appoint.AppointEndTime = time
	
	s appoint.RequestCateCharpter = ARequestCateCharpter
	
	//默认批准的打印ID集合与申请的一样
	s appoint.AppointCateCharpter = ARequestCateCharpter
	
	//申请人
	s appoint.AppointUserID = AUserID
	
	//授权的会诊医生及其所在科室
	s appoint.RequestUserID = ARequestUserID
	s appoint.RequestDept = ARequestDept
	
	//发出申请的日期和时间默认为当前系统日期时间
	s appoint.RequestDate = date
	s appoint.RequestTime = time
	
	//授权给个人或科室
	s appoint.AppointType = AAppointType
	
	//病历权限
	s appoint.EPRAction = AEPRAction
	
	//授权状态
	s appoint.AppointStatus = "N"
	
	if '(appoint.%Save())
 	{
	 	s ret = -2
 		TROLLBACK
 	}
 	else
 	{ 
 		s appointID = appoint.%Id()
 		
 		s appointSub = ##Class(EPRinstance.EPRActionAppointSub).%New()
 		s appointSub.AppointID = appointID
 		s appointSub.ConsultationID = AConsultID
 		s appointSub.ConsultationType = AConsultType
 		
 		if '(appointSub.%Save())
 		{
	 		s ret = -3
	 		TROLLBACK
	 	}
	 	else
	 	{
			TCOMMIT
			s ret = 1		
		}
 	}
	
	q ret
}

}
