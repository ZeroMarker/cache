Class web.DHCAntCVReportAdmLog Extends %RegisteredObject
{

/// w ##class(web.DHCAntCVReportAdmLog).OnNewAdm("27581","12798")
ClassMethod OnNewAdm(Adm = "", UserID = "")
{
	q ..OnEvent("NewAdm",Adm,UserID)
}

ClassMethod OnTransLoc(Adm = "", UserID = "")
{
	q ..OnEvent("TransLoc",Adm,UserID)
}

/// w ##class(web.DHCAntCVReportAdmLog).OnNewAdm("27581","12798")
ClassMethod OnNewAdmV2(Adm = "", UserID = "")
{
	s count=0
	s ret= ..OnEvent("NewAdm",Adm,UserID,.count)
	if ret=1 q count
	else  q ret
}

ClassMethod OnTransLocV2(Adm = "", UserID = "")
{
	s count=0
	s ret= ..OnEvent("TransLoc",Adm,UserID,.count)
	if ret=1 q count
	else  q ret
}

ClassMethod OnEvent(EventType = "", pAdm = "", UserID = "", Output Count)
{
	s $zt="OnEventErr"
	s Count=0
	q $$$OK
	
	q:(pAdm="")||'$d(^PAADM(pAdm)) $$$OK
	s PatientID=$p(^PAADM(pAdm),"^",1)
	q:PatientID="" $$$OK
	
	s repType=0
	for {
		s repType=$o(^DHCAntCVReport(0,"PatEnd",PatientID,0,repType))
		q:repType=""
		s repTypeDesc=##class(web.DHCAntCVReportNameQuery).GetPanicName(repType)
		s repLabno=""
		for {
			s repLabno=$o(^DHCAntCVReport(0,"PatEnd",PatientID,0,repType,repLabno))
			q:repLabno=""
			s repOrder=""
			for {
				s repOrder=	$o(^DHCAntCVReport(0,"PatEnd",PatientID,0,repType,repLabno,repOrder))
				q:repOrder=""
				s repInfo=$g(^DHCAntCVReport(repType,repLabno,repOrder))
				
				s Status=$p(repInfo,"\",9)
				
				continue:Status="D" //删除状态
				
				s reportID=repType_"||"_repLabno_"||"_repOrder
				
				s oneRet= ..SaveReportAdmLog(reportID,EventType,pAdm,UserID)
				s ^cryze("cv","onnewadmv2",$i(^cryze("cv","onnewadmv2")) )=$lb(reportID,EventType,pAdm,UserID,oneRet)
				s Count=Count+1
			}
		}
	}
	
	Q $$$OK
OnEventErr
	q "-1^"_$ze
}

/// 当提前结束被拒绝 要判断患者是否转科或者新就诊 将危急值转到新科室或新就诊记录
ClassMethod OnRejectEnd(reportID, userid)
{
	q $$$OK
	
	s repType=$p(reportID,"||",1),repLabno=$p(reportID,"||",2),repOrder=$p(reportID,"||",3)
	set cvExtInfo=$g(^DHCAntCVReport(repType,repLabno,repOrder,"EXTD"))
	set EpisodeID=$p(cvExtInfo,"\",4)  //使用FinalAdm去做
	if EpisodeID="" s EpisodeID=$p(^DHCAntCVReport(repType,repLabno,repOrder),"\",7)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s maxID=EpisodeID
	for admType="I","E","O","H" {
		s t=$o(^PAPERdr(PatientID,"ADM",admType,""),-1) 
		if t>maxID s maxID=t
	}
	
	if maxID>EpisodeID { //产生了新的就诊记录
		
	}elseif maxID=EpisodeID{
		s obj=##class(User.DHCAntCVReport).%OpenId(reportID,0)
		
		s SrcLoc=obj.DPRPFinalLoc
		s SrcWard=obj.DPRPFinalWard
		
		s DestLoc=$p(^PAADM(maxID),"^",4)
		s DestWard=$p(^PAADM(maxID),"^",70)
		s obj=""
		if (SrcLoc=DestLoc)&&(SrcWard=DestLoc) q "-1^科室或病区未发生改变"
	}else{
		q "-1^未获取到之后就诊"	
	}
	d ..SaveReportAdmLog(reportID,"RejectEnd",maxID,userid)
	q 1
}

ClassMethod SaveReportAdmLog(reportID, type, adm, userid)
{
	
	s obj=##class(User.DHCAntCVReport).%OpenId(reportID)
	if '$IsObject(obj) q "-1^reportID="_reportID_"不正确"
		
	s SrcAdm=obj.DPRPFinalAdm
	s SrcLoc=obj.DPRPFinalLoc
	s SrcWard=obj.DPRPFinalWard
	
	s DestAdm=adm
	s DestLoc=$p(^PAADM(adm),"^",4)
	s DestWard=$p(^PAADM(adm),"^",70)
	
	if SrcAdm=DestAdm,SrcLoc=DestLoc,SrcWard=DestWard {
		q "-1^reportID="_reportID_"就诊、科室、病区均未发生改变"	
	}
	
	s alRet=..SaveOneAdmLog(reportID,type,"",SrcAdm,SrcLoc,SrcWard,DestAdm,DestLoc,DestWard,userid)
	if $e(alRet,1,2)="-1" {
		s obj="" 
		q alRet	
	}
	
	s obj.DPRPFinalAdm=DestAdm
	s obj.DPRPFinalLoc=DestLoc
	s obj.DPRPFinalWard=DestWard
	s sc=obj.%Save()
	
	if $$$ISERR(sc){
		s ret="-1^"_$system.Status.GetErrorText(sc)
	}else{
		s Status=obj.DPRPStatus
		// 消息提醒
		if (Status'="D") {  //(Status'="F")&&  只要未闭环 已处理状态 也重新发消息
			s MesgRet=##class(websys.DHCMessageInterface).Exec("","1000","","",reportID,userid,"","")
			d ##class(web.DHCAntCVSend).SendHISMsgByCfg(reportID,1,type)
		}
		
		
		
		s ret=obj.%Id()
	}
	
	if (SrcAdm'=DestAdm)||(SrcLoc'=DestLoc) {  //就诊改变 或者科室改变  需要将复查提醒消息计划终止
		d ##class(web.DHCAntCVReportTrans).StopReePlan(reportID,userid)
	}
	
	s obj=""
	q ret
}

ClassMethod SaveOneAdmLog(reportID, type, srcProcess, srcAdm, srcLoc, srcWard, destAdm, destLoc, destWard, userid)
{
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	s alOrder=$i(^DHCAntCVReport(repType,repLabno,repOrder,"AdmLog"))	
	s obj=##class(User.DHCAntCVReportAdmLog).%New(reportID)
	d obj.DPRALParRefSetObjectId(reportID)
	s obj.DPRALOrder=alOrder
	s obj.DPRALSrcAdm=srcAdm
	s obj.DPRALSrcLoc=srcLoc
	s obj.DPRALType=type
	s obj.DPRALSrcProcess=srcProcess
	s obj.DPRALDestAdm=destAdm
	s obj.DPRALDestLoc=destLoc
	s obj.DPRALUserID=userid
	s obj.DPRALSrcWard=srcWard
	s obj.DPRALDestWard=destWard
	
	s now=$h
	s obj.DPRALDate=+$p(now,",",1)
	s obj.DPRALTime=+$p(now,",",2)
	
	s sc=obj.%Save()
	
	if $$$ISERR(sc){
		s ret="-1^"_$system.Status.GetErrorText(sc)
	}else{
		s ret=obj.%Id()
	}
	s obj=""
	q ret
}

ClassMethod GetLatestAdmLogDateTime(reportID)
{
	s ret=""
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	s sub=$o(^DHCAntCVReport(repType,repLabno,repOrder,"AdmLog",""),-1)
	if sub>0 {
		
		s aDate=$p(^DHCAntCVReport(repType,repLabno,repOrder,"AdmLog",sub),"\",10)
		s aTime=$p(^DHCAntCVReport(repType,repLabno,repOrder,"AdmLog",sub),"\",10)
		s ret=aDate_","_aTime
	}
	q ret
}

}
