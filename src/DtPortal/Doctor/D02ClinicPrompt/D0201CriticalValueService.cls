/// creator    : shp
/// date       : 20140714
/// description: 危急值相关服务
Class DtPortal.Doctor.D02ClinicPrompt.D0201CriticalValueService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*
*获取危急值列表
*d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0201CriticalValueService","D020101GetCVinfo","P","ys01","false")
*
*/
Query D020101GetCVinfo(QueryType As %String, UserCode As %String, IfUsePushData As %String = "false") As DtPortal.Query(ROWSPEC = "index:%String,bedNo:%String,patName:%String,patSex:%String,EpisodeID:%String,ReportID:%String,Summary:%String,RType:%String,Age:%String,MedicareNo:%String,AdmReason:%String,PatientID:%String,ctloc:%String,TestSet:%String,paadmType:%String,EMRDocID:%String,EMRInstanceID:%String,locID:%String,EMREpisodeID:%String,UserId:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.ClinicPrompt.CriticalValueService","GetCVinfo","1772")
ClassMethod D020101GetCVinfoExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String, IfUsePushData As %String = "false") As %Status
{
	n (qHandle,QueryType,UserCode,IfUsePushData)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	set UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	i UserId="" 	Quit $$$OK
	Set qHandle=$lb(0,repid,0)
	if (IfUsePushData="true"){
		set messageData=##class(DtPortal.Doctor.ClinicPrompt.CommonService).GetMessageDataByType(UserId,"1000")
		set strId=messageData.GetValue("bizObjId")
		s length=$l(strId,"^")
		f i=1:1:length d
		.s id=$p(strId,"^",i)
		.q:id=""
		.s ReportType=$p(id,"||",1)
		.s labId=$p(id,"||",2)
		.s ord=$p(id,"||",3)
		.q:(ReportType="")||(labId="")||(ord="")
	  	.s EpisodeID=$p($g(^DHCAntCVReport(ReportType,labId,ord)),"\",7)
	  	.q:+EpisodeID=0
	  	.s ReportID=labId_"||"_ord
	  	.s RType=ReportType
	  	.set OEOrdItemID=$p(^DHCAntCVReport(ReportType,labId,ord),"\",14)
		.set TSName=##class(DtPortal.Common.Interface.CriticalValue).GetOrdItemName(OEOrdItemID)
		.if TSName="",ReportType=1 s TSName=##class(DtPortal.Common.Interface.CriticalValue).GetTSName(labId)
		.s TestSet=TSName
		.S Summary=##class(web.DHCCVCommon).GetPanicReportResult(RType,ReportID)
		.s Summary=$tr(Summary,$c(13,10),"")
		.set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
		.quit:PatInfo=""
		.set patName=$p(PatInfo,"^",2)											//姓名
		.set patSex=$p(PatInfo,"^",3)											//性别
		.set age=$p(PatInfo,"^",4)											//年龄
		.set MedicareNo=$p(PatInfo,"^",5)									//病案号
		.set admreason=$p(PatInfo,"^",6)										//费用类别
		.set bedno=$p(PatInfo,"^",1)										//床号
		
		.s patientID=$p(^PAADM(EpisodeID),"^",1)
		.s depdr=$p(^PAADM(EpisodeID),"^",4)   //科室
		.s ctloc=""
		.i depdr'="" d
		..s CtLoc=$p(^CTLOC(depdr),"^",2)
		..i CtLoc["-"  s ctloc=$p(CtLoc,"-",2)
		.s paadmType=$p($g(^PAADM(EpisodeID)),"^",2)
		.//获取打开电子病历所需要的参数
		.set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
		.set EMRDocID=$p(EMRinfo,"^",1)
		.set EMRInstanceID=$p(EMRinfo,"^",2)
		.set locID=$p(EMRinfo,"^",3)
		.set PatientID=$p(EMRinfo,"^",4)
		.set EMREpisodeID=$p(EMRinfo,"^",5)
		.d GetCVinfo

	
	}else{
		//配置
		s days=##Class(DtPortal.Common.PublicService).getValueByCode("CRITICALVALUEQUERYDAYS")
		s stdate=$zd(((+$h)-days),3)
		s edate=$zd(+$h,3) 
	  	if UserCode="" Set qHandle=$lb(0,repid,0) q $$$OK
		Set LocStr=##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode(UserCode)
		if LocStr=""  Set qHandle=$lb(0,repid,0) q $$$OK
		
		s docId=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)
		
		set MUDocIDs=""
		if QueryType="PG" SET MUDocIDs=##Class(DtPortal.Common.PublicService).GetMUDocList(docId)
		else  set MUDocIDs="^"_docId_"^"
		
		for i=1:1:$length(LocStr,"^") d
		.s locid=$p(LocStr,"^",i)
		.f reporttype=1:1:6  d
		..set obj=##class(%ResultSet).%New("DtPortal.Common.Interface.CriticalValue:GetPanicReport")
		..d obj.Execute(stdate,edate,locid,"C","I",reporttype)
		..f  Quit:'obj.Next()  d
		...s EpisodeID=obj.Data("adm")
		...s admDocDr=$p(^PAADM(EpisodeID),"^",9)  //主治医生
		...;q:cpId'=admDocDr
		...q:+admDocDr=0
		...q:MUDocIDs'[("^"_admDocDr_"^")
		...s ReportID=obj.Data("ReportId")
		...s RType=obj.Data("ReportType")
		...S TestSet=obj.Data("TSName")
		...s Summary=obj.Data("DPRPResult")			//危急值报告信息
		...set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
		...quit:PatInfo=""
		...set patName=$p(PatInfo,"^",2)											//姓名
		...set patSex=$p(PatInfo,"^",3)											//性别
		...set age=$p(PatInfo,"^",4)											//年龄
		...set MedicareNo=$p(PatInfo,"^",5)									//病案号
		...set admreason=$p(PatInfo,"^",6)										//费用类别
		...set bedno=$p(PatInfo,"^",1)										//床号
		
		...s patientID=$p(^PAADM(EpisodeID),"^",1)
		...s depdr=$p(^PAADM(EpisodeID),"^",4)   //科室
		...s ctloc=""
		...i depdr'="" d
		....s CtLoc=$p(^CTLOC(depdr),"^",2)
		....i CtLoc["-"  s ctloc=$p(CtLoc,"-",2)
		...//获取打开电子病历所需要的参数
		...set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
		...set EMRDocID=$p(EMRinfo,"^",1)
		...set EMRInstanceID=$p(EMRinfo,"^",2)
		...set locID=$p(EMRinfo,"^",3)
		...set PatientID=$p(EMRinfo,"^",4)
		...set EMREpisodeID=$p(EMRinfo,"^",5)
		...d GetCVinfo
		..d obj.Close()
	
	}
	
	
	
	
	
  	
	
	
	Quit $$$OK
GetCVinfo	

	Set ^||CacheTemp(repid,ind)=$lb(ind,bedno,patName,patSex,EpisodeID,ReportID,Summary,RType,age,MedicareNo,admreason,patientID,ctloc,TestSet,paadmType,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserId)
	Set ind=ind+1
	Quit
}

/// creator     :shp
/// description :向危急值平台发送消息确认已读
/// date        :20140715  
/// debug        :W ##class(DtPortal.Doctor.D02ClinicPrompt.D0201CriticalValueService).D020102UpdateCV(601,"B3456965||2",2)
ClassMethod D020102UpdateCV(usercode, RepId, ReportType) As DtPortal.OutPut
{
	n (usercode,RepId,ReportType)
	
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	Set $ZT = "ErrSendMessage1"
	TStart
	
	s Status="F"
	s TransStr="^^^"
	s reportID=ReportType_"||"_RepId
	s rtn=$$save(reportID,usercode,TransStr,Status)
	TCommit
	Set ret.status = 1
	Set ret.errMSG = ""
	
	//增加确认危急值报告消息推送 update by chengpeng
	//start
	//set LabNo=$p(RepId,"||",1)
	//set Order=$p(RepId,"||",2)
	//set epsoidID=$p(^DHCAntCVReport(ReportType,LabNo,Order),"\",7)
	//set rtnNew=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000020",reportID,2,epsoidID)
	//end
	//处理对外消息 byzl
	d ##class(web.DHCAntCVSend).SendAntCVTrans(reportID,usercode,TransStr,Status)
	
	// 可以是简单类型
	Set ret.data = rtn
	// 也可以是一个对象
	// Set ret.data = objMessage
		
	Quit ret
	
ErrSendMessage1
	
	TRollBack
	Set ret.status = -1
	Set ret.errMSG = "更新失败"
	Set ret.data = ""
	Quit ret
	
save(reportID,User,TransStr,Status)
	
	s NoticeTime=$p(TransStr,"^",1)
  	s NoticeName=$p(TransStr,"^",2)
  	s PhoneNo=$p(TransStr,"^",3)
  	s TransMemo=$p(TransStr,"^",4)
  	k PLIST
  	S PLIST(0)=reportID
  	s PLIST(3)=+$h
  	s PLIST(4)=$p($h,",",2)
  	s PLIST(5)=User
  	s PLIST(6)=NoticeTime
  	s PLIST(7)=NoticeName
  	s PLIST(8)=PhoneNo
  	s PLIST(9)=TransMemo
  	s PLIST(10)=Status
	i '$l($g(PLIST(2))) s PLIST(2)=$o(^DHCAntCVReport($p(PLIST(0),"||",1),$p(PLIST(0),"||",2),$p(PLIST(0),"||",3),"TR",""),-1)+1
	&SQL(insert into SQLUser.DHC_AntCVReportTrans values :PLIST())
	I SQLCODE d ErrSendMessage1
	&sql(update SQLUser.DHC_AntCVReport set DPRP_Status=:Status where DPRP_RowID=:reportID)
 	I SQLCODE  d ErrSendMessage1
	q SQLCODE
}

}
