/// 双屏界面展示，数据获取方法相关类
/// lixu
/// 2021-09-14
Class DHCDoc.GetInfo.Second.ScreenMethod Extends %RegisteredObject
{

/// 通过医嘱ID获取检验报告ID
/// w ##Class(DHCDoc.GetInfo.Second.ScreenMethod).GetLabReportByOrd("178||236")
ClassMethod GetLabReportByOrd(OrderId)
{
	s OrdId=+OrderId
	s SubId=$p(OrderId,"||",2)
	s VisitNumberReportId=""
	
	;获取检验报告ID
	s LabEpisode=$p($g(^OEORD(OrdId,"I",SubId,3)),"^",20)	
	i (LabEpisode'="") d
	.s OutPutReportId=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISRptIDByLabNo",LabEpisode)
	.i (OutPutReportId'="") d
	..f reportIndex=1:1:$l(OutPutReportId,",") d
	...s oneReportId=$p(OutPutReportId,",",reportIndex)
	...s result=##class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")
	...s sc=result.Execute(oneReportId)
	...q:$$$ISERR(sc)
	...s OrdRowIds=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISOrdIDByRpt",oneReportId)
	...q:OrderId'=OrdRowIds
	...s VisitNumberReportId=oneReportId
	
	s Obj={}
	s Obj."VisitNumberReportId"=VisitNumberReportId
	q Obj
}

/// 通过医嘱ID获取检查报告ID
/// w ##Class(DHCDoc.GetInfo.Second.ScreenMethod).GetExamReportByOrd("178||285")
ClassMethod GetExamReportByOrd(OrderId)
{
	s OrdId=+OrderId
	s SubId=$p(OrderId,"||",2)
	s EpisodeID=$p($g(^OEORD(OrdId)),"^",1)
	s PatientId=$p(^PAADM(EpisodeID),"^",1)
	s RegNo=$p(^PAPER(PatientId,"PAT",1),"^",1)   
	
	s ExamPortUrl=""
	
	s RecLocId=$p($g(^OEORD(OrdId,"I",SubId,3)),"^",6)
	s ARRowID=$o(^DHCAPREP(0,"OrdItem",OrderId,"")) 
	i (ARRowID'="")&&(RecLocId'="") d
	.s PacsSetInfo = ##class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo(RecLocId)
	.s ARSubId=$o(^DHCAPREP(0,"OrdItem",OrderId,ARRowID,"")) 
	.i (ARSubId'="") d
	..i ('$d(^DHCAPREP(ARRowID,"AR",ARSubId,"PA"))) d
	...s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OrderId,"")
	..e  d
	...s RepPartID=""
	...f  s RepPartID= $o(^DHCAPREP(ARRowID,"AR",ARSubId,"PA",RepPartID)) q:RepPartID=""  d
	....s PartID = $p(^DHCAPREP(ARRowID,"AR",ARSubId,"PA",RepPartID),"^",1)
	....s ReqPartStatus = $p(^DHCAPREP(ARRowID,"AR",ARSubId,"PA",RepPartID),"^",2)
	....q:ReqPartStatus="D"           ;D为停止状态	
	....s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OrderId,PartID)
	....s hasBooked=##class(web.DHCRisResApptSchudleSystem).HasBooked(OrderId,PartID) 
	....s:(hasBooked="Y")&&(StudyNo="") StudyNo=-1	
	..s ExamID = $case(StudyNo,-1:"",0:"",:StudyNo)
	..s ExamStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(OrderId,ExamID,"")
	..;默认检查完成后才能查看报告和图像
	..i ((ExamStatus="RP")||(ExamStatus="RD")) d   
	...s UrlParams = RegNo_"^"_StudyNo_"^"_OrderId
	...s ExamPortUrl = ##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsSetInfo,UrlParams) 
	
	s Obj={}
	s Obj."ExamPortUrl"=ExamPortUrl
	q Obj
}

/// 通过医嘱ID获取病理报告ID
/// Tab:DHC_AppPisArc
/// w ##Class(DHCDoc.GetInfo.Second.ScreenMethod).GetPisReportByOrd("178||285")
ClassMethod GetPisReportByOrd(OrderId)
{
	s OrdId=+OrderId
	s SubId=$p(OrderId,"||",2)
	s EpisodeID=$p($g(^OEORD(OrdId)),"^",1)
	s PatientId=$p(^PAADM(EpisodeID),"^",1)
	s RegNo=$p(^PAPER(PatientId,"PAT",1),"^",1)   
	s RecLocId=$p($g(^OEORD(OrdId,"I",SubId,3)),"^",6)
	
	s (PortUrl,ImgUrl)=""
	s PisID=$o(^DHCAPPPM(0,"OrdItem",OrderId,""))
	i PisID'=""{
		s PisNo=##class(web.DHCAPPSeePatPacs).GetTmInfoByOrderRowId(OrderId)
		s PacsSetInfo = ##class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo(RecLocId)
		s UrlParams = RegNo_"^"_PisNo_"^"_OrderId
		s PortUrl=##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsSetInfo,UrlParams)				//报告路径
		s ImgUrl =##class(web.DHCAPPSeePatPacs).GetImgUrl(PacsSetInfo,UrlParams)
	}
	s Obj={}
	s Obj."PisPortUrl"=PortUrl
	s Obj."PisImgtUrl"=ImgUrl
	q Obj
}

/// 设置超融合跳转参数(json串用基础平台方法传递时，信息会不完整)
/// w ##Class(DHCDoc.GetInfo.Second.ScreenMethod).SetScreenParam()
ClassMethod SetScreenParam(JsonStr)
{
	i '$d(^TempDHCDoc("Screen",+$h)){
		k ^TempDHCDoc("Screen")
	}
	s Index=$i(^TempDHCDoc("Screen",+$h))
	s ^TempDHCDoc("Screen",+$h,Index)=JsonStr
	Q Index
}

/// 获取超融合跳转参数(json串用基础平台方法传递时，信息会不完整)
/// w ##Class(DHCDoc.GetInfo.Second.ScreenMethod).GetScreenParam()
ClassMethod GetScreenParam(Index)
{
	s JsonStr=$g(^TempDHCDoc("Screen",+$h,+Index))
	Q:JsonStr="" "[]"
	Q JsonStr
}

}
