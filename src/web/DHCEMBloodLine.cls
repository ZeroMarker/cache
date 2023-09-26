Class web.DHCEMBloodLine Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEMBloodLine).GetPageData("10.1.30.144")
ClassMethod GetPageData(ComputerIp)
{
	n (ComputerIp)
	s ClientName="",ServerName=""
	i ComputerIp'="" d
	.s ClientId=$O(^DHCVISClienti(0,"ClientIP",ComputerIp,""))
	.q:ClientId=""
	.s ClientName=$p($g(^DHCVISClient(ClientId)),"^",3)
	.s ServerId=$p($g(^DHCVISClient(ClientId)),"^",1)
	.q:ServerId=""
	.s ServerName=$p(^DHCVISServer(ServerId),"^",2)
	q ClientName_"^"_ServerName
}

/// Input:StDate,EndDate,ClientIP(本机IP)
/// w ##class(web.DHCEMBloodLine).ListBloodPat("10","1","","","11.11.11.11",1)
ClassMethod ListBloodPat(rows, page, Params)
{
	n (rows, page , Params,%session)
	
	s StDate=$p(Params,"^",1) 
	s EndDate=$p(Params,"^",2)
	s PatNo=$p(Params,"^",3)
	s Status=$p(Params,"^",4)
	s:Status="全部" Status=""
	s ClientIp=$p(Params,"^",5)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	s:StDate'="" StDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StDate="" StDate=+$H	
	s:EndDate="" EndDate=+$H
	i ClientIp="" d
	.s LocId=185,ClientId=91,ServerId=13   ;插入队列在无配置情况下固定的参数
	i ClientIp'="" d
	.s ClientId=$o(^DHCVISClienti(0,"ClientIP",ClientIp,""))
	.s ServerId=$p($g(^DHCVISClient(+ClientId)),"^",1)
	.s LocId=$p($g(^DHCVISServer(+ServerId)),"^",8)
	q:(LocId="")||(ClientId="")||(ServerId="") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	;只所以这么写,数字媒体写死的91,可能是不存在ClientId
	f Index=1:1:3 d	
	.f ThisDate=StDate:1:EndDate d
	..s ClientId=0	;循环
	..f  s ClientId=$o(^DHCVISClienti(0,"ServerID",ServerId,ClientId)) q:(ClientId="")  d
	...s CurId="" f  s CurId=$O(^User.DHCNurTreatQueueI("QueDateLoc",ThisDate," "_LocId," T"_ClientId," "_Index,CurId)) q:(CurId="")  d
	....s CallUser=$lg(^User.DHCNurTreatQueueD(CurId),14)
	....s:CallUser'="" CallUser=$p(^SSU("SSUSR",CallUser),"^",2)
	....s QueueNo=$lg(^User.DHCNurTreatQueueD(CurId),5)
	....s TreatAdmDr=$lg(^User.DHCNurTreatQueueD(CurId),2)
	....q:TreatAdmDr=""
	....s Papmidr=$p($G(^PAADM(TreatAdmDr)),"^",1)
	....q:Papmidr=""
	....s PatName=$p($G(^PAPER(Papmidr,"ALL")),"^",1)
	....s PatSexId=$p($G(^PAPER(Papmidr,"ALL")),"^",7)
	....i PatSexId'="" s PatSex=$p($G(^CT("SEX",PatSexId)),"^",2)
	....e  s PatSex=""
	....s Birth=$p($G(^PAPER(Papmidr,"ALL")),"^",6)
#;	....s PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmidr,TreatAdmDr)
	....s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(TreatAdmDr)
	....s RegNo=$p($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	....q:(PatNo'="")&&(PatNo'=RegNo)
	....s QueueState=$lg(^User.DHCNurTreatQueueD(CurId),7)
	....;q:(QueueState="Finish")||(QueueState="Skip")||(QueueState="Cancel")	//完成治疗的不显示
#;	....s QueueState=$S(QueueState="Wait":"等候",QueueState="Ready":"准备",QueueState="Call":"呼叫",QueueState="Skip":"过号",QueueState="Finish":"完成",1:"")
	....s QueuePrior=$lg(^User.DHCNurTreatQueueD(CurId),6)
#;	....s QueuePrior=$S(QueuePrior="1":"优先",QueuePrior="2":"正常",QueuePrior="3":"过号",1:"")
	....q:(Status'="")&&(Status'=QueuePrior)&&(Status'=QueueState)
	....s EpisodeID=TreatAdmDr
	....s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
	....s EncryptLevel=$p(PatEncryptLevel,"^",1)  
	....s PatLevel=$p(PatEncryptLevel,"^",2) 
	....i ClientIp="" d
	.....s ClientIp=$lg(^User.DHCNurTreatQueueD(CurId),17)
	.....s ClientId=$O(^DHCVISClienti(0,"ClientIP",ClientIp,""))
	....s PatRoom=$P($G(^DHCVISClient(ClientId)),"^",3)
	....s ClientName=$P($G(^DHCVISClient(ClientId)),"^",3)
	....s QueueDate=$lg(^User.DHCNurTreatQueueD(CurId),9)
	....s QueueTime=$lg(^User.DHCNurTreatQueueD(CurId),10)
	....s:QueueDate'="" QueueDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(QueueDate)
	....s:QueueTime'="" QueueTime=$zt(QueueTime,1)
	....;s:ClientName'="" PatName=ClientName_"-"_PatName
	....s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-25 st
	....s CallUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",CallUser) //ed
	....s ListData=CurId_"^"_QueueNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_RegNo_"^"_QueueState_"^"_QueuePrior_"^"_EpisodeID
	....s ListData=ListData_"^"_ClientName_"^"_EncryptLevel_"^"_PatLevel_"^"_PatRoom_"^"_CallUser_"^"_QueueDate_"^"_QueueTime
	....s OrdIndex=CurId_"^"_QueueNo
	....s TMPData(OrdIndex)=ListData
	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s Count=0
	s ListTitle="CurId^QueueNo^PatName^PatSex^PatAge^RegNo^QueueState^QueuePrior^EpisodeIDCurId^ClientName^EncryptLevel^PatLevel^PatRoom"
	s ListTitle=ListTitle_"^CallUser^QueueDate^QueueTime"
	s OrdIndex=""
	f  s OrdIndex=$o(TMPData(OrdIndex)) q:OrdIndex=""  d
	.s ListData=TMPData(OrdIndex)
	.s Count = Count+1
	.q:(Count<Start)||(Count>End)
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	q ""
}

}
