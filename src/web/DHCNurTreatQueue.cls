Class web.DHCNurTreatQueue Extends %RegisteredObject
{

/// 根据日期(默认当天)查询治疗队列中病人
Query FindTreatPat(StartDate As %String, LocId As %String, serverIP As %String, ifSYCall As %String = "", seatFlag As %String = "") As %Query(ROWSPEC = "QueueNo:%String,PatName:%String,PatSex:%String,PatAge:%String,RegNo:%String,QueueState:%String,QueuePrior:%String,EpisodeID:%String,TreatId:%String,ClientName:%String,EncryptLevel:%String,PatLevel:%String,PatRoom:%String")
{
}

ClassMethod FindTreatPatExecute(ByRef qHandle As %Binary, StartDate As %String, LocId As %String = "", serverIP As %String = "", ifSYCall As %String = "", seatFlag As %String = "") As %Status
{
	//s ^sctmpv1("FindTreatPat")=StartDate_","_ LocId_","_serverIP_","_ifSYCall_","_seatFlag_","
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//##class(%ResultSet).RunQuery("web.DHCNurTreatQueue","FindTreatPat","","63","OFFICE-PC",0)
 	//d ##class(%ResultSet).RunQuery("web.DHCNurTreatQueue","FindTreatPat","","","OFFICE-PC",0,2)
 	//d ##class(%ResultSet).RunQuery("web.DHCNurTreatQueue","FindTreatPat","","","10.1.30.144","1","3")
 	s TraWait=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","等候") //hxy 2022-12-23 st
 	s TraReady=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","准备")
 	s TraCall=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","呼叫")
 	s TraSkip=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","过号")
 	s TraFinish=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","完成")
 	s TraPrior=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","优先")
 	s TraNormal=##class(web.DHCEMCommonUtil).GetTrans("dhcem.nur.main.hisui.csp","正常") //ed
 	
 	s UserId=""
 	i $d(%session) d
 	.s:LocId="" LocId=%session.Data("LOGON.CTLOCID")
 	.s UserId=%session.Data("LOGON.USERID") ;
 	i $G(serverIP)="" d
	.i $D(%session) s serverIP=%session.Data("REMOTE_ADDR")
	s serverFlag=0
	i serverIP'="" d
	.s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	.i serverId'="" s serverFlag=1
	.s clientId=$O(^DHCVISClienti(0,"ClientIP",serverIP,""))
 	
	i (serverId="")&&(LocId'="") d
	.s serverId=$O(^DHCVISServeri(0,"LinkLoc",LocId,""))
 	if StartDate="" s StartDate=+$h
 
 	i (ifSYCall=1)&&(seatFlag=3) d
 	.
	.f i=1:1:3 d
	..s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueLocDate"," "_LocId,StartDate," "_i,curQueNo)) q:(curQueNo="")  d
	...s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("QueLocDate"," "_LocId,StartDate," "_i,curQueNo,curId)) q:(curId="")  d
	....s QueueNo=$ListGet(^User.DHCNurTreatQueueD(curId),5)
	....s TreatAdmDr=$ListGet(^User.DHCNurTreatQueueD(curId),2)
	....q:TreatAdmDr=""
	....s TreatSeatFlag=$ListGet(^User.DHCNurTreatQueueD(curId),16)
	....q:TreatSeatFlag'=seatFlag
	....s TreatServerIP=$ListGet(^User.DHCNurTreatQueueD(curId),17)
	....q:TreatServerIP'=serverIP
	....s Papmidr=$P($G(^PAADM(TreatAdmDr)),"^",1)
	....q:Papmidr=""
	....s PatName=$P($G(^PAPER(Papmidr,"ALL")),"^",1)
	....s PatSexId=$p($g(^PAPER(Papmidr,"ALL")),"^",7)
	....i PatSexId'="" s PatSex=$p($g(^CT("SEX",PatSexId)),"^",2)
	....e  s PatSex=""
	....s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
	....s PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmidr,TreatAdmDr)
	....s RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	....s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	....q:(QueueState="Finish")	//完成治疗的不显示
	....s QueueState=$S(QueueState="Wait":TraWait,QueueState="Ready":TraReady,QueueState="Call":TraCall,QueueState="Skip":TraSkip,QueueState="Finish":TraFinish,1:"")
	....s QueuePrior=$ListGet(^User.DHCNurTreatQueueD(curId),6)
	....s QueuePrior=$S(QueuePrior="1":TraPrior,QueuePrior="2":TraNormal,QueuePrior="3":TraSkip,1:"")
	....s EpisodeID=TreatAdmDr
	....s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
 	....s EncryptLevel=$p(PatEncryptLevel,"^",1)  
    ....s PatLevel=$p(PatEncryptLevel,"^",2) 
	....s TreatId=curId
	....s ClientName=""
	....s ClientId=$ListGet(^User.DHCNurTreatQueueD(curId),15)
	....q:ClientId=""
	....i ClientId'="" d
	.....i ClientId["T"  s ClientName=$P($G(^DHCVISQueueType($TR(ClientId,"T"))),"^")
	.....e  s ClientName=$P($G(^DHCVISClient(ClientId)),"^",3)
	....Do OutwardRow
	e  i ($G(serverId)'="")&&($G(clientId)="")  d
	.f i=1:1:3 d
	..s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueLocDate"," "_LocId,StartDate," "_i,curQueNo)) q:(curQueNo="")  d
	...s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("QueLocDate"," "_LocId,StartDate," "_i,curQueNo,curId)) q:(curId="")  d
	....s QueueNo=$ListGet(^User.DHCNurTreatQueueD(curId),5)
	....s TreatAdmDr=$ListGet(^User.DHCNurTreatQueueD(curId),2)
	....q:TreatAdmDr=""
	....s TreatSeatFlag=$ListGet(^User.DHCNurTreatQueueD(curId),16)
	....q:TreatSeatFlag'=seatFlag
	....s TreatServerIP=$ListGet(^User.DHCNurTreatQueueD(curId),17)
	....q:TreatServerIP'=serverIP
	....s Papmidr=$P($G(^PAADM(TreatAdmDr)),"^",1)
	....q:Papmidr=""
	....s PatName=$P($G(^PAPER(Papmidr,"ALL")),"^",1)
	....s PatSexId=$p($g(^PAPER(Papmidr,"ALL")),"^",7)
	....i PatSexId'="" s PatSex=$p($g(^CT("SEX",PatSexId)),"^",2)
	....e  s PatSex=""
	....s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
	....s PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmidr,TreatAdmDr)
	....s RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	....s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	....q:(QueueState="Finish")	//完成治疗的不显示
#;	....s QueueState=$S(QueueState="Wait":"等候",QueueState="Ready":"准备",QueueState="Call":"呼叫",QueueState="Skip":"过号",QueueState="Finish":"完成",1:"")
	....s QueueState=$S(QueueState="Wait":TraWait,QueueState="Ready":TraReady,QueueState="Call":TraCall,QueueState="Skip":TraSkip,QueueState="Finish":TraFinish,1:"")
	....s QueuePrior=$ListGet(^User.DHCNurTreatQueueD(curId),6)
#;	....s QueuePrior=$S(QueuePrior="1":"优先",QueuePrior="2":"正常",QueuePrior="3":"过号",1:"")
	....s QueuePrior=$S(QueuePrior="1":TraPrior,QueuePrior="2":TraNormal,QueuePrior="3":TraSkip,1:"")
	....s EpisodeID=TreatAdmDr
	....s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
 	....s EncryptLevel=$p(PatEncryptLevel,"^",1)  
    ....s PatLevel=$p(PatEncryptLevel,"^",2) 
	....s TreatId=curId
	....s ClientName=""
	....s ClientId=$ListGet(^User.DHCNurTreatQueueD(curId),15)
	....q:ClientId=""
	....i ClientId'="" d
	.....i ClientId["T"  s ClientName=$P($G(^DHCVISQueueType($TR(ClientId,"T"))),"^")
	.....e  s ClientName=$P($G(^DHCVISClient(ClientId)),"^",3)
	.....s PatRoom=$P($G(^DHCVISClient($TR(ClientId,"T"))),"^",3)
	....Do OutwardRow
	e  d
	.s parList=""
	.s clientRowId=$G(clientId)
	.i clientRowId'="" d
	..s queueTypeId=$P($G(^DHCVISClient(clientRowId)),"^",12)
	..s PatRoom=$P($G(^DHCVISClient(clientRowId)),"^",3)
	..i queueTypeId'="" s queueTypeId="T"_queueTypeId
	..i queueTypeId="" s queueTypeId="T"_clientRowId
	..i parList'[queueTypeId s parList=parList_","_queueTypeId
	.i ($G(serverId)'="")&&(clientRowId="") d
	..s clientId="" f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:clientId=""  d
	...s queueTypeId=$P($G(^DHCVISClient(clientId)),"^",12)
	...s PatRoom=$P($G(^DHCVISClient(clientId)),"^",3)
	...i queueTypeId'="" s queueTypeId="T"_queueTypeId
	...i queueTypeId="" s queueTypeId=clientId
	...i parList'[queueTypeId s parList=parList_","_queueTypeId
	.i ($G(serverId)'="")&&(clientRowId'="")&&(serverFlag) d
	..s clientId="" f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:clientId=""  d
	...q:(clientId=clientRowId)
	...s queueTypeId= $P($G(^DHCVISClient(clientId)),"^",12)
	...s PatRoom=$P($G(^DHCVISClient(clientId)),"^",3)
	...i queueTypeId'="" s queueTypeId="T"_queueTypeId
	...i queueTypeId="" s queueTypeId=clientId
	...i parList'[queueTypeId s parList=parList_","_queueTypeId	
	.s clientStr = ..GetClientStr(serverIP) //hxy 2020-07-19 注释放开
	.i parList'[clientStr s parList=parList_","_clientStr //hxy 2020-07-19 注释放开
	.;b //hxy
	.f j=1:1:$L(parList,",") d
	..s queueTypeId=$P(parList,",",j)
	..q:queueTypeId=""
	..d OutPutByClient
	..d OutPutEmByClient
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutByClient
	s i=1
	f i=1:1:3 d
	.s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueDateCat",StartDate," "_queueTypeId," "_i,curQueNo)) q:(curQueNo="")  d
	..s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("QueDateCat",StartDate," "_queueTypeId," "_i,curQueNo,curId)) q:(curId="")  d
	...s QueueNo=$ListGet(^User.DHCNurTreatQueueD(curId),5)
	...s TreatAdmDr=$ListGet(^User.DHCNurTreatQueueD(curId),2)
	...q:TreatAdmDr=""
	...s Papmidr=$P($G(^PAADM(TreatAdmDr)),"^",1)
	...q:Papmidr=""
	...s PatName=$P($G(^PAPER(Papmidr,"ALL")),"^",1)
	...s PatSexId=$p($g(^PAPER(Papmidr,"ALL")),"^",7)
	...i PatSexId'="" s PatSex=$p($g(^CT("SEX",PatSexId)),"^",2)
	...e  s PatSex=""
	...s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
	...s PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmidr,TreatAdmDr)
	...s RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	...s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	...q:(QueueState="Finish")	//完成治疗的不显示
	...s QueueState=$S(QueueState="Wait":TraWait,QueueState="Ready":TraReady,QueueState="Call":TraCall,QueueState="Skip":TraSkip,QueueState="Finish":TraFinish,1:"")
	...s QueuePrior=$ListGet(^User.DHCNurTreatQueueD(curId),6)
	...s QueuePrior=$S(QueuePrior="1":TraPrior,QueuePrior="2":TraNormal,QueuePrior="3":TraSkip,1:"")
	...s TreatSeatFlag=$ListGet(^User.DHCNurTreatQueueD(curId),16)
	...q:(seatFlag'="")&&(TreatSeatFlag'=seatFlag) 
	...s EpisodeID=TreatAdmDr
	...s TreatId=curId
	...s ClientName=""
	...s RecUserId=$ListGet(^User.DHCNurTreatQueueD(curId),11)
#;	...Q:((QueueState="呼叫")||(QueueState="准备"))&&(UserId'=RecUserId)
	...Q:((QueueState=TraCall)||(QueueState=TraReady))&&(UserId'=RecUserId)
	...i queueTypeId'="" d
	....i queueTypeId["T"  s ClientName=$P($G(^DHCVISQueueType($TR(queueTypeId,"T"))),"^")
	....e  s ClientName=$P($G(^DHCVISClient(queueTypeId)),"^",3)
	...i QueueNo<10 s Seq=i_"000"_QueueNo
	...i (QueueNo>9)&&(QueueNo<100) s Seq=i_"00"_QueueNo
	...i (QueueNo>99)&&(QueueNo<1000) s Seq=i_"0"_QueueNo
	...i (QueueNo>999) s Seq=i_QueueNo
	...s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
 	...s EncryptLevel=$p(PatEncryptLevel,"^",1)  
    ...s PatLevel=$p(PatEncryptLevel,"^",2) 
	...set Data=$lb(QueueNo,PatName,PatSex,PatAge,RegNo,QueueState,QueuePrior,EpisodeID,TreatId,ClientName,EncryptLevel,PatLevel,$g(PatRoom))
	...s ^DHCTempTreat($j,Seq)=Data
	Do OutPutRow
    quit
OutPutEmByClient
	s i=1
	f i=1:1:3 d
	.s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueDateCat",StartDate-1," "_queueTypeId," "_i,curQueNo)) q:(curQueNo="")  d
	..s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("QueDateCat",StartDate-1," "_queueTypeId," "_i,curQueNo,curId)) q:(curId="")  d
	...s QueueNo=$ListGet(^User.DHCNurTreatQueueD(curId),5)
	...s TreatAdmDr=$ListGet(^User.DHCNurTreatQueueD(curId),2)
	...q:TreatAdmDr=""
	...s PaAdmType=$P($G(^PAADM(TreatAdmDr)),"^",2)
	...q:PaAdmType'="E"
	...s Papmidr=$P($G(^PAADM(TreatAdmDr)),"^",1)
	...q:Papmidr=""
	...s PatName=$P($G(^PAPER(Papmidr,"ALL")),"^",1)
	...s PatSexId=$p($g(^PAPER(Papmidr,"ALL")),"^",7)
	...i PatSexId'="" s PatSex=$p($g(^CT("SEX",PatSexId)),"^",2)
	...e  s PatSex=""
	...s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
	...s PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmidr,TreatAdmDr)
	...s RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	...s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	...q:(QueueState="Finish")	//完成治疗的不显示
	...s QueueState=$S(QueueState="Wait":TraWait,QueueState="Ready":TraReady,QueueState="Call":TraCall,QueueState="Skip":TraSkip,QueueState="Finish":TraFinish,1:"")
	...s QueuePrior=$ListGet(^User.DHCNurTreatQueueD(curId),6)
	...s QueuePrior=$S(QueuePrior="1":TraPrior,QueuePrior="2":TraNormal,QueuePrior="3":TraSkip,1:"")
	...s EpisodeID=TreatAdmDr
	...s TreatId=curId
	...s ClientName=""
	...s RecUserId=$ListGet(^User.DHCNurTreatQueueD(curId),11)
	...;Q:((QueueState="呼叫")||(QueueState="准备"))&&(UserId'=RecUserId)
	...Q:((QueueState=TraCall)||(QueueState=TraReady))&&(UserId'=RecUserId)
	...i queueTypeId'="" d
	....i queueTypeId["T"  s ClientName=$P($G(^DHCVISQueueType($TR(queueTypeId,"T"))),"^")
	....e  s ClientName=$P($G(^DHCVISClient(queueTypeId)),"^",3)
	...i QueueNo<10 s Seq=i_"000"_QueueNo
	...i (QueueNo>9)&&(QueueNo<100) s Seq=i_"00"_QueueNo
	...i (QueueNo>99)&&(QueueNo<1000) s Seq=i_"0"_QueueNo
	...i (QueueNo>999) s Seq=i_QueueNo
	...s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
 	...s EncryptLevel=$p(PatEncryptLevel,"^",1)  
    ...s PatLevel=$p(PatEncryptLevel,"^",2) 
	...set Data=$lb(QueueNo,PatName,PatSex,PatAge,RegNo,QueueState,QueuePrior,EpisodeID,TreatId,ClientName,EncryptLevel,PatLevel,$g(PatRoom))
	...s ^DHCTempTreat($j,Seq)=Data
	Do OutPutRow
    quit
OutPutRow
	s Seq="" f  s Seq=$O(^DHCTempTreat($j,Seq)) q:Seq=""  d
 	.s ^CacheTemp(repid,ind)=^DHCTempTreat($j,Seq)
 	.s ind=ind+1
	k ^DHCTempTreat($j)
	quit
OutwardRow
	set Data=$lb(QueueNo,PatName,PatSex,PatAge,RegNo,QueueState,QueuePrior,EpisodeID,TreatId,ClientName,EncryptLevel,PatLevel,$g(PatRoom))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTreatPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTreatPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTreatPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTreatPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description: 采血队列
/// Creator:     qqa
/// CreateDate:  2021-06-08
/// Input:  	 StDate,EndDate,ClientIP(本机IP),ShowAllClient(1:遍历所有客户端队列,"":只获取当前客户端队列)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCNurTreatQueue","QueryBloodPat","","","10.1.30.144")
Query QueryBloodPat(StDate, EndDate, ClientIp, LgUserId, ShowAllClient = "1") As %Query(ROWSPEC = "QueueNo:%String,PatName:%String,PatSex:%String,PatAge:%String,RegNo:%String,QueueState:%String,QueuePrior:%String,EpisodeID:%String,TreatId:%String,ClientName:%String,EncryptLevel:%String,PatLevel:%String,PatRoom:%String")
{
}

ClassMethod QueryBloodPatExecute(ByRef qHandle As %Binary, StDate, EndDate, ClientIp, LgUserId, ShowAllClient = "1") As %Status
{
	s repid = $I(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	
	i $d(%session) d
	.s LgUserId= %session.Data("LOGON.USERID")
	
	s LocId="",ClientId="",ServerId=""	;三个主要参数
	i ClientIp="" d
	.s LocId=185,ClientId=91,ServerId=13   ;插入队列在无配置情况下固定的参数
	i ClientIp'="" d
	.s ClientId=$o(^DHCVISClienti(0,"ClientIP",ClientIp,""))
	.s ServerId=$p($g(^DHCVISClient(+ClientId)),"^",1)
	.s LocId=$p($g(^DHCVISServer(+ServerId)),"^",8)
	q:(LocId="")||(ClientId="")||(ServerId="") $$$OK
	
	s:StDate'="" StDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StDate="" StDate=+$H	
	s:EndDate="" EndDate=+$H
	
	;只所以这么写,数字媒体写死的91,可能是不存在ClientId
	f Index=1:1:3 d	
	.f ThisDate=StDate:1:EndDate d
	..i ShowAllClient d
	...s ClientId=0	;循环
	...f  s ClientId=$o(^DHCVISClienti(0,"ServerID",ServerId,ClientId)) q:(ClientId="")  d
	....d OutBloodPatClientRow
	..i 'ShowAllClient d ;各自显示
	...d OutBloodPatClientRow
	
	s OrdIndex=""
	f  s OrdIndex=$o(TMPData(OrdIndex)) q:OrdIndex=""  d
	.set Data=TMPData(OrdIndex)
 	.s ^CacheTemp(repid,ind) = Data
 	.s ind = ind+1
    s qHandle = $lb(0,repid,0)
	Quit $$$OK
OutBloodPatClientRow
	s CurId="" f  s CurId=$O(^User.DHCNurTreatQueueI("QueDateLoc",ThisDate," "_LocId," T"_ClientId," "_Index,CurId)) q:(CurId="")  d
	.s CallUser=$lg(^User.DHCNurTreatQueueD(CurId),14)
	.q:(CallUser'="")&&(CallUser'=LgUserId)
	.s SeatFlag=$lg(^User.DHCNurTreatQueueD(CurId),16)
	.q:SeatFlag'=""	;治疗队列掉
	.s QueueNo=$lg(^User.DHCNurTreatQueueD(CurId),5)
	.s TreatAdmDr=$lg(^User.DHCNurTreatQueueD(CurId),2)
	.q:TreatAdmDr=""
	.s Papmidr=$p($G(^PAADM(TreatAdmDr)),"^",1)
	.q:Papmidr=""
	.s PatName=$p($G(^PAPER(Papmidr,"ALL")),"^",1)
	.s PatSexId=$p($G(^PAPER(Papmidr,"ALL")),"^",7)
	.i PatSexId'="" s PatSex=$p($G(^CT("SEX",PatSexId)),"^",2)
	.e  s PatSex=""
	.s Birth=$p($G(^PAPER(Papmidr,"ALL")),"^",6)
	.s PatAge=##class(web.DHCBillInterface).GetPapmiAge(Papmidr,TreatAdmDr)
	.s RegNo=$p($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	.s QueueState=$lg(^User.DHCNurTreatQueueD(CurId),7)
	.q:(QueueState="Finish")||(QueueState="Skip")||(QueueState="Cancel")	//完成治疗的不显示
	.s QueueState=$S(QueueState="Wait":"等候",QueueState="Ready":"准备",QueueState="Call":"呼叫",QueueState="Skip":"过号",QueueState="Finish":"完成",1:"")
	.s QueuePrior=$lg(^User.DHCNurTreatQueueD(CurId),6)
	.s QueuePrior=$S(QueuePrior="1":"优先",QueuePrior="2":"正常",QueuePrior="3":"过号",1:"")
	.s EpisodeID=TreatAdmDr
	.s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
	.s EncryptLevel=$p(PatEncryptLevel,"^",1)  
	.s PatLevel=$p(PatEncryptLevel,"^",2) 
	.i ClientIp="" d
	..s ClientIp=$lg(^User.DHCNurTreatQueueD(CurId),17)
	..s ClientId=$O(^DHCVISClienti(0,"ClientIP",ClientIp,""))
	.s PatRoom=$P($G(^DHCVISClient(ClientId)),"^",3)
	.s ClientName=$P($G(^DHCVISClient(ClientId)),"^",3)
	.;s:ClientName'="" PatName=ClientName_"-"_PatName
	.s CallIndex=2
	.s:QueueState="呼叫" CallIndex=1
	.s OrdIndex=CallIndex_"^"_QueuePrior_"^"_CurId_"^"_QueueNo
	.s TMPData(OrdIndex)=$lb(QueueNo,PatName,PatSex,PatAge,RegNo,QueueState,QueuePrior,EpisodeID,CurId,ClientName,EncryptLevel,PatLevel,PatRoom)
	quit
}

ClassMethod QueryBloodPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBloodPatExecute ]
{
 s repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryBloodPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBloodPatExecute ]
{
 s AtEnd=$LIST(qHandle,1)
 s repid=$LIST(qHandle,2)
 s ind=$LIST(qHandle,3)
 s ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
 }
 Else {			
 		s Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 取静脉压测定等医嘱的治疗结果
/// 维护^DHCCLSet("Exec","TreatResultArcimDr",医嘱码表ID)=结果单位(如cm水柱)
/// 返回0说明不需要录入结果
ClassMethod GetTreatResultByOrder(oeoriId) As %String
{
	//w ##class(web.DHCNurTreatQueue).GetTreatResultByOrder("297||12||1")
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)
	q:(oeordId="")!(oeoriSub="") 0
	s ArcimDr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	if $G(ArcimDr)="" q 0
	if '$D(^DHCCLSet("Exec","TreatResultArcimDr",ArcimDr)) q 0
	s TreatUom=$G(^DHCCLSet("Exec","TreatResultArcimDr",ArcimDr))
	s TreatResult=""
	s maxIndex=+$G(^OEORD(oeordId,"I",oeoriSub,"DEP",0))
	f i=1:1:maxIndex d
	.s orderNote=$G(^OEORD(oeordId,"I",oeoriSub,"DEP",i))
	.i TreatUom'="",orderNote'[TreatUom q
	.s TreatResult=orderNote
	i TreatResult="" s TreatResult=" "_TreatUom
	q TreatResult
}

/// 修改医嘱备注/静脉压测定等医嘱
ClassMethod UpdateTreatResultNote(oeoriId, orderNote) As %String
{
	i orderNote="" q 0
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)
	s ArcimDr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	i ArcimDr'="" d
	.s TreatUom=$G(^DHCCLSet("Exec","TreatResultArcimDr",ArcimDr))
	e  s TreatUom=""
	i orderNote'="" d
	.s maxIndex=+$G(^OEORD(oeordId,"I",oeoriSub,"DEP",0))
	.s lastNote=$G(^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex))
	.i (lastNote="")!((lastNote[TreatUom)&(TreatUom'="")) d
	..s ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=orderNote
	.e  d
	..s maxIndex=maxIndex+1
	..s ^OEORD(oeordId,"I",oeoriSub,"DEP",0)=maxIndex
	..s ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=orderNote
	q 0
}

/// 通过就诊ID取静脉压测定等医嘱的治疗结果
/// 	web.DHCEmergency中调用,显示在医生站诊疗菜单的顶部基本信息中
/// 	^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
ClassMethod GetTreatResultByEpisodeID(EpisodeID) As %String
{
	//w ##class(web.DHCNurTreatQueue).GetTreatResultByEpisodeID("426")
	q:EpisodeID="" ""
	s oeordId=$O(^OEORD(0,"Adm",EpisodeID,0))
	q:oeordId="" ""
	s retStr=""
	s ArcimDr="" f  s ArcimDr=$O(^DHCCLSet("Exec","TreatResultArcimDr",ArcimDr)) q:ArcimDr=""  d
	.s SttDate="" f  s SttDate=$O(^OEORDi(0,"ARCIM",oeordId,ArcimDr,SttDate)) q:SttDate=""  d
	..s oeoriSub="" f  s oeoriSub=$O(^OEORDi(0,"ARCIM",oeordId,ArcimDr,SttDate,oeoriSub)) q:oeoriSub=""  d
	...s oeoriId=oeordId_"||"_oeoriSub
	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
    ...q:ordStatCode'="V"
	...s OrdBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	...q:OrdBilled'="P"
	...s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s arcimSub=$p(arcimId,"||"),arcimVer=$p(arcimId,"||",2)
	...s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	...s execDateTime=""
	...s oeoreSub="" f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	....q:'$d(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))
 	....s execDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",19)   	//执行日期
 	....i execDate'="" s execDate=$ZD(execDate,3)
 	....s execTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",20)   	//执行时间
	....i execTime s execTime=$ZT(execTime,2)
	....s execDateTime=execDate_" "_execTime
	...s TreatResult=..GetTreatResultByOrder(oeoriId)
	...s retStr=arcimDesc_"(结果:"_TreatResult_" 录入目期:"_execDateTime_")"
	q retStr
}

/// 获取叫号终端配置的ID
/// w ##class(web.DHCNurTreatQueue).GetClientStr("192.168.0.105")
ClassMethod GetClientStr(serverIP As %String = "") As %String
{
	s LocId=115
	//
	i $D(%session) s LocId=$G(%session.Data("LOGON.CTLOCID"))
	//s ^ZXZX=$G(%session.Data("REMOTE_ADDR"))_"^"_$G(%session.Data("LOGON.CTLOCID"))
	i $G(serverIP)="" d
	.i $D(%session) s serverIP=$G(%session.Data("REMOTE_ADDR"))
	q:serverIP="" ""
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	i (serverId="")&&(LocId'="") d
	.s serverId=$O(^DHCVISServeri(0,"LinkLoc",LocId,""))
	q:serverId="" ""
	s rset=##class(%ResultSet).%New("web.DHCVISVoiceSet:LookUpClient")
	s ret=""
	do rset.Execute("",serverId) //hxy 2020-07-19 add "",
	while (rset.Next()) {
		s clientId=rset.GetData(1)
		s clientName=rset.GetData(3)
		i ret=""  s ret="T"_clientId //hxy 2020-07-19 add "T"_
		e  s ret=ret_",T"_clientId //hxy 2020-07-19 add T
	}	
	d rset.Close()
	q ret
}

/// w ##class(web.DHCNurTreatQueue).GetClientAndQueue("OFFICE-PC")
ClassMethod GetClientAndQueue(serverIP As %String = "") As %String
{
	s LocId=67
	//
	i $D(%session) s LocId=$G(%session.Data("LOGON.CTLOCID"))
	//s ^ZXZX=$G(%session.Data("REMOTE_ADDR"))_"^"_$G(%session.Data("LOGON.CTLOCID"))
	i $G(serverIP)="" d
	.i $D(%session) s serverIP=$G(%session.Data("REMOTE_ADDR"))
	q:serverIP="" ""
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	i (serverId="")&&(LocId'="") d
	.s serverId=$O(^DHCVISServeri(0,"LinkLoc",LocId,""))
	q:serverId="" ""
	s rset=##class(%ResultSet).%New("web.DHCVISVoiceSet:LookUpClient")
	s ret=""
	s ret2=""
	s retFlag=0
	s tmpQueueId=""
	do rset.Execute("",serverId)
	while (rset.Next()) {
		s clientId=rset.GetData(1)
		s clientName=rset.GetData(3)
		s queueTypeId=rset.GetData(11)
		s queueType=""
		i queueTypeId'="" d
		.s queueObj=##class(User.DHCVISLinkQueueType).%OpenId(queueTypeId)
		.s queueType=queueObj.linkQueueDesc
		i tmpQueueId[("|"_queueTypeId_"|") d
		.s retFlag=1
		e  d
		.i ret2=""  s ret2=clientId_$C(1)_queueType_"-"
		.e  s ret2=ret2_"^"_clientId_$C(1)_queueType_"-"
		
		s tmpQueueId=tmpQueueId_"|"_queueTypeId_"|^"
		
		/*
		i queueTypeId'="" d
		.s queueType=$P($G(^DHCVISQueueType(queueTypeId)),"^")
		.s clientId="T"_queueTypeId
		.i ret=""  s ret=clientId_$C(1)_clientName_"-"_queueType
		.e  s ret=ret_"^"_clientId_$C(1)_clientName_"-"_queueType
		*/
		i ret=""  s ret=clientId_$C(1)_clientName_"-"_"" ;queueType
		e  s ret=ret_"^"_clientId_$C(1)_clientName_"-"_"" ;queueType
		
		
	}	
	d rset.Close()
	i retFlag=1 s ret=ret2
	q ret
}

/// 新产品排队接口
/// 参数:QueueUserLocDr:当前登录科室，QueueUserId：当前用户，TreatAdmDr：就诊id
/// ClientID:排队客户端ID,TreatReportType:排队单据类型，RegNo：登记号，
/// QueueType：队列类型，2是治疗，3是输液，ServerName:排队服务器计算机名称
/// w ##class(web.DHCNurTreatQueue).InsertQueue("50","18850","22","7","SYDO","0000000024","3","10.1.30.144")
ClassMethod InsertQueue(QueueUserLocDr, QueueUserId, TreatAdmDr, ClientID, TreatReportType, RegNo, QueueType, ServerName) As %String
{
	;s ^qqa("InsertQueue")=$lb(QueueUserLocDr, QueueUserId, TreatAdmDr, ClientID, TreatReportType, RegNo, QueueType, ServerName)
	q:ClientID="" "客户端不能为空"
	q:ServerName="" "服务器名称不能为空"
	q:QueueType="" "队列类型不能为空"
 	s prr = "TreatLocDr|"_QueueUserLocDr_"^TreatRecUser|"_QueueUserId_"^TreatAdmDr|"_TreatAdmDr_"^TreatQueState|Wait^TreatQuePrior|2^TreatQueDate|^TreatQueTime|^TreatQueueCat|"_ClientID_"^TreatReportType|ZSDO^RegNo|"_RegNo_"^SeatFlag|"_QueueType_"^TreatServerIP|"_ServerName
	s ret = ##class(User.DHCNurTreatQueue).Save("",prr)
	q ret
}

}
