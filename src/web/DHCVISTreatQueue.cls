Import SQLUser

Class web.DHCVISTreatQueue Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// "10.10.146.57"
/// w ##class(web.DHCVISTreatQueue).GetClientStr("10.10.146.57")
ClassMethod GetClientStr(serverIP As %String = "") As %String
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
	do rset.Execute("",serverId)
	while (rset.Next()) {
		s clientId=rset.GetData(1)
		s clientName=rset.GetData(3)
		s queueTypeId=rset.GetData(11)
		s queueType=""
		/*
		i queueTypeId'="" d
		.s queueType=$P($G(^DHCVISQueueType(queueTypeId)),"^")
		.s clientId="T"_queueTypeId
		.i ret=""  s ret=clientId_$C(1)_clientName_"-"_queueType
		.e  s ret=ret_"^"_clientId_$C(1)_clientName_"-"_queueType
		*/
		i ret=""  s ret=clientId_$C(1)_clientName_"-"_queueType
		e  s ret=ret_"^"_clientId_$C(1)_clientName_"-"_queueType
	}	
	d rset.Close()
	q ret
}

ClassMethod GetQueueTypeStr(serverIP As %String = "") As %String
{
	s ret=""
	i $G(serverIP)="" d
	.i $D(%session) s serverIP=$G(%session.Data("REMOTE_ADDR"))
	q:serverIP="" ""
	s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	i serverId="" d
	.s clientId=$O(^DHCVISClienti(0,"ClientIP",serverIP,""))
	.q:clientId=""
	.s serverId=$P($G(^DHCVISClient(clientId)),"^",1)
	q:serverId="" ""
	s rset=##class(%ResultSet).%New("web.DHCVISVoiceSet:LookUpClient")
	do rset.Execute(serverId)
	k ^DHCTempDHCVisQueueType($j)
	while (rset.Next()) {
		s clientId=rset.GetData(1)
		s clientName=rset.GetData(3)
		s queueTypeId=rset.GetData(11)
		s queueType=clientName
		i queueTypeId'="" d
		.s queueType=$P($G(^DHCVISQueueType(queueTypeId)),"^")
		.s clientId="T"_queueTypeId
		.i $G(^DHCTempDHCVisQueueType($j,clientId))'="" s ^DHCTempDHCVisQueueType($j,clientId)=^DHCTempDHCVisQueueType($j,clientId)  //_"/"_clientName
		.e  s ^DHCTempDHCVisQueueType($j,clientId)=queueType //_"-"_clientName
	}	
	d rset.Close()
	s clientId=""
	f  s clientId=$O(^DHCTempDHCVisQueueType($j,clientId)) q:clientId=""  d
	.s queueType=$G(^DHCTempDHCVisQueueType($j,clientId))
	.q:queueType=""
	.i ret=""  s ret=clientId_$C(1)_queueType
	.e  s ret=ret_"^"_clientId_$C(1)_queueType
	q ret
}

ClassMethod InsertQueue(ServerIP As %String, TreatQueueCat As %String, TreatAdmDr As %String) As %String
{
	s WaitNum=0
 	i $G(ServerIP)="" d
	.i $D(%session) s ServerIP=$G(%session.Data("REMOTE_ADDR"))
	i ServerIP'="" d
	.s serverId=$O(^DHCVISServeri(0,"ServerIP",ServerIP,""))
	.i serverId="" d
	..s clientId=$O(^DHCVISClienti(0,"ClientIP",ServerIP,""))
	..q:clientId=""
	..s serverId=$P($G(^DHCVISClient(clientId)),"^",1)
	.s TreatLocDr=$P($G(^DHCVISServer(serverId)),"^",8)
	q:$G(TreatLocDr)="" "取号服务不存在科室!"
	s CheckFlag=..CheckQueueCondition(TreatAdmDr,TreatQueueCat)
	q:CheckFlag'="OK" CheckFlag
	s curId=..GetIdByAdm(TreatAdmDr,TreatLocDr,TreatQueueCat)
	i curId'="" d
	.s obj=##class(User.DHCNurTreatQueue).%OpenId(curId)
	.s obj.TreatQueState="Wait"
	.s obj.TreatQuePrior=2
	.s curQueNo=obj.TreatQueNo
	.d obj.%Save()
	.s WaitNum=..GetCurWaitNum(TreatLocDr,TreatQueueCat,curQueNo)
	i curId'="" q "0"_"^"_$G(curQueNo)_"^"_WaitNum
	s TreatRecUser=3901
	s TreatQueNo=..GetMaxQueNoByLoc(TreatLocDr,TreatQueueCat)
	s QueueLimits=..GetQueueLimits(TreatQueueCat)
	q:(QueueLimits>0)&&(TreatQueNo>QueueLimits) "超最大限号数,不能取号!"
	s obj=##class(User.DHCNurTreatQueue).%New()
	s obj.TreatLocDr=$G(TreatLocDr)
	s obj.TreatAdmDr=$G(TreatAdmDr)
	s obj.TreatQueNo=$G(TreatQueNo)
	s obj.TreatQueState="Wait"
	s obj.TreatQuePrior=2
	s obj.TreatQueDate=+$H
	s obj.TreatQueTime=$P($H,",",2)
	s obj.TreatRecUser=TreatRecUser
	s obj.TreatQueueCat=TreatQueueCat
	s obj.TreatReportType=""
	d obj.%Save()
	s curId=obj.%Id()
	s curId=+curId
	q:curId=0 "队列插入失败!"
	s WaitNum=..GetCurWaitNum(TreatLocDr,TreatQueueCat,TreatQueNo)
	s TreatQueNo="0"_"^"_TreatQueNo_"^"_WaitNum
	q TreatQueNo
}

/// /取队列限额
/// /
ClassMethod GetQueueLimits(TreatQueueCat As %String) As %String
{
	s QueueLimits=0
	i $P(TreatQueueCat,"T",2)'="" s TreatQueueCat=$P(TreatQueueCat,"T",2)
	s QueueLimits=+$P($G(^DHCVISQueueType(TreatQueueCat)),"^",3)
	q QueueLimits
}

/// 取当前队列等候人数
/// w ##Class(web.DHCVISTreatQueue).GetCurWaitNum(799,"T1",1)
ClassMethod GetCurWaitNum(LocId, TreatQueueCat As %String = "", TreatQueNo As %String = "") As %String
{
	s NowDate=+$H
	s WaitNum=0
	&SQL(select count(*) into :WaitNum from DHCNurTreatQueue where TreatQueDate=:NowDate and TreatLocDr=:LocId and TreatQueueCat=:TreatQueueCat and TreatQueState<>'Finish' and TreatQueNo<:TreatQueNo)
	q WaitNum
}

/// 取登陆科室排队分类最大的排队号
ClassMethod GetMaxQueNoByLoc(LocId, TreatQueueCat As %String = "") As %String
{
	//w ##class(User.DHCNurTreatQueue).GetMaxQueNoByLoc(799)
	q:LocId="" ""
	i TreatQueueCat="" d
	.s retQueNo=0
	.f i=1:1:3 d
	..s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueLocDate"," "_LocId,+$h," "_i,curQueNo)) q:(curQueNo="")  d
	...i retQueNo<$TR(curQueNo," ","") s retQueNo=$TR(curQueNo," ","")
	e  d
	.s retQueNo=0
	.f i=1:1:3 d
	..s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueDateLocCat",+$h," "_LocId," "_TreatQueueCat," "_i,curQueNo)) q:(curQueNo="")  d
	...i retQueNo<$TR(curQueNo," ","") s retQueNo=$TR(curQueNo," ","")
  	q retQueNo+1
}

/// 判断病人当前科室当天是否已在治疗病人列表中
ClassMethod GetIdByAdm(Adm, LocId, TreatQueueCat As %String = "") As %String
{
	//w ##class(User.DHCNurTreatQueue).GetIdByAdm(1,18)
	q:Adm="" ""
	s papmiDr=$P($G(^PAADM(Adm)),"^",1)
	q:papmiDr="" ""
	s ret=""
	s admType=""
	f  s admType=$O(^PAPERdr(papmiDr,"ADM",admType)) q:(admType="")!(ret'="")  d
	.s admId="" f  s admId=$O(^PAPERdr(papmiDr,"ADM",admType,admId)) q:(admId="")!(ret'="")  d
	..s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("Adm"," "_admId,curId)) q:(curId="")!(ret'="")  d
	...s curLocId=$ListGet(^User.DHCNurTreatQueueD(curId),3)
	...q:(LocId'="")&(LocId'=curLocId)
	...s curQueDate=$ListGet(^User.DHCNurTreatQueueD(curId),4)
	...q:curQueDate'=(+$h)
	...s QueueTypeId=$ListGet(^User.DHCNurTreatQueueD(curId),12)
	...q:(TreatQueueCat'="")&&(TreatQueueCat'=QueueTypeId)
	...s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	...q:(QueueState="Finish")||(QueueState="Skip")	//完成治疗的不显示
	...s ret=curId
  	q ret
}

/// 取打印数据
ClassMethod GetPrintInfo(Adm, LocId, TreatQueueCat As %String = "") As %String
{
	s (PrintInfo,QueueType,WaitRoom,CurrQueueNo,PatName,WaitSum)=""
	q:Adm="" ""
	s papmiDr=$P($G(^PAADM(Adm)),"^",1)
	q:papmiDr="" ""
	s PatName=$p($g(^PAPER(papmiDr,"ALL")),"^",1) 
	s QueueType=$P($G(^DHCVISQueueType($TR(TreatQueueCat,"T"))),"^")
	s admType="",CurrId=""
	f  s admType=$O(^PAPERdr(papmiDr,"ADM",admType)) q:(admType="")!(CurrId'="")  d
	.s admId="" f  s admId=$O(^PAPERdr(papmiDr,"ADM",admType,admId)) q:(admId="")!(CurrId'="")  d
	..s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("Adm"," "_admId,curId)) q:(curId="")!(CurrId'="")  d
	...s curLocId=$ListGet(^User.DHCNurTreatQueueD(curId),3)
	...q:(LocId'="")&(LocId'=curLocId)
	...s curQueDate=$ListGet(^User.DHCNurTreatQueueD(curId),4)
	...q:curQueDate'=(+$h)
	...s QueueTypeId=$ListGet(^User.DHCNurTreatQueueD(curId),12)
	...q:(TreatQueueCat'="")&&(TreatQueueCat'=QueueTypeId)
	...s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	...q:(QueueState="Finish")||(QueueState="Skip")	//完成治疗的不显示
	...s CurrId=curId
	i CurrId'="" d
	.s obj=##class(User.DHCNurTreatQueue).%OpenId(CurrId)
	.s CurrQueueNo=obj.TreatQueNo
	.d obj.%Close()
	s WaitSum=..GetCurWaitNum(LocId,TreatQueueCat,CurrQueueNo)
	s PrintInfo=QueueType_"^"_WaitRoom_"^"_CurrQueueNo_"^"_PatName_"^"_WaitSum
  	q PrintInfo
}

// w ##Class(web.DHCVISTreatQueue).CheckQueueCondition(7809,"T8")

ClassMethod CheckQueueCondition(EpisodeID As %String = "", QueueTypeId As %String = "") As %String
{
	q:(EpisodeID="")||(QueueTypeId="") "入参不完整!"
	s ReportCodeStr=""
	s AdmLocStr=""
	s RecLocStr=""
	s OrdCatStr=""
	s OrdSubCatStr=""
	s ArcStr=""
	i $P(QueueTypeId,"T",2)'="" s QueueTypeId=$P(QueueTypeId,"T",2)
	s TypeDtlId="" f  s TypeDtlId=$O(^DHCVISQueueTypeDi(0,"TypeID",QueueTypeId,TypeDtlId)) q:TypeDtlId=""  d
	.s DtlStr=$G(^DHCVISQueueTypeD(TypeDtlId))
	.s DtlStr=$TR(DtlStr," ")
	.q:DtlStr=""
	.s ReportCode=$P(DtlStr,"^",2)
	.i ReportCode'="" d
	..i ReportCodeStr="" s ReportCodeStr=ReportCode
	..e  d
	...i ReportCodeStr'[ReportCode s ReportCodeStr=ReportCodeStr_"^"_ReportCode
	.s AdmLoc=$P(DtlStr,"^",3)
	.i AdmLoc'="" d
	..i AdmLocStr="" s AdmLocStr=AdmLoc
	..e  d
	...i AdmLocStr'[AdmLoc s AdmLocStr=AdmLocStr_"^"_AdmLoc
	.s RecLoc=$P(DtlStr,"^",4)
	.i AdmLoc'="" d
	..i RecLocStr="" s RecLocStr=RecLoc
	..e  d
	...i RecLocStr'[RecLoc s RecLocStr=RecLocStr_"^"_RecLoc
	.s ArcId=$P(DtlStr,"^",7)
	.i ArcId'="" d
	..i ArcStr="" s ArcStr=ArcId
	..e  d
	...i ArcStr'[ArcId s ArcStr=ArcStr_"^"_ArcId
	.q:ArcId'=""
	.s OrdSubCat=$P(DtlStr,"^",6)
	.i OrdSubCat'="" d
	..i OrdSubCatStr="" s OrdSubCatStr=OrdSubCat
	..e  d
	...i OrdSubCatStr'[OrdSubCat s OrdSubCatStr=OrdSubCatStr_"^"_OrdSubCat
	.q:OrdSubCat'=""
	.s OrdCat=$P(DtlStr,"^",5)
	.i OrdCat'="" d
	..i OrdCatStr="" s OrdCatStr=OrdCat
	..e  d
	...i OrdCatStr'[OrdCat s OrdCatStr=OrdCatStr_"^"_OrdCat
	.q:OrdCat=""
	s ReportFlag=""
	i ReportCodeStr'="" d
	.s ReportLen=$L(ReportCodeStr,"^")
	.f i=1:1:ReportLen d
	..s ReportCode=$P(ReportCodeStr,"^",i)
	..s ReportFlag=..GetOrderByReport(EpisodeID,ReportCode)
	..i ReportFlag'="" s i=ReportLen
	//q:ReportFlag'="" "OK"
	s CheckLocOrderFlag=""
	i (AdmLocStr'="")||(OrdCatStr'="")||(OrdSubCatStr'="")||(ArcStr'="") d
	.s regNo=..GetPatRegNobyEpisodeID(EpisodeID)
	.q:regNo=""
	.s CheckLocOrderFlag=..CheckAdmLocAndOrder(regNo,AdmLocStr,OrdCatStr,OrdSubCatStr,ArcStr)
	q:CheckLocOrderFlag'="" "OK"
	q "不符合取号条件!"
}

ClassMethod CheckAdmLocAndOrder(regNo As %String = "", AdmLocList As %String = "", OrdCatStr As %String = "", OrdSubCatStr As %String = "", ArcStr As %String = "") As %String
{
	s ret=""
    s startDate=+$H-14
    s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
    q:papmiId="" ""
    s AdmType="" f  s AdmType=$o(^PAPERdr(papmiId,"ADM",AdmType)) q:((AdmType="")||(ret=1))  d
    .s EpisodeID=""
    .f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM",AdmType,EpisodeID)) q:((EpisodeID="")||(ret=1))  d
    ..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..q:pavisit'="A"
    ..s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
    ..q:admDate<startDate
    ..s admLoc=$p($g(^PAADM(EpisodeID)),"^",4)
    ..q:(AdmLocList'="")&&(AdmLocList'[admLoc)
    ..i (AdmLocList'="")&&(AdmLocList[admLoc)&&(OrdCatStr="")&&(OrdSubCatStr="")&&(OrdSubCatStr="")
    ..//q:ArcStr=""
    ..s orderId=$O(^OEORD(0,"Adm",EpisodeID,""))
    ..q:orderId=""
    ..s orderStartDate=+$H-14
    ..f  s orderStartDate=$O(^OEORDi(0,"NotExecE",orderId,orderStartDate)) q:((orderStartDate="")||(ret=1))  d
    ...s orderStartTime="" f  s orderStartTime=$O(^OEORDi(0,"NotExecE",orderId,orderStartDate,orderStartTime)) q:((orderStartTime="")||(ret=1))  d
    ....s orderSubId=""  f  s orderSubId=$O(^OEORDi(0,"NotExecE",orderId,orderStartDate,orderStartTime,orderSubId)) q:((orderSubId="")||(ret=1))  d
    .....s orderExecId="" f  s orderExecId=$O(^OEORDi(0,"NotExecE",orderId,orderStartDate,orderStartTime,orderSubId,orderExecId)) q:((orderExecId="")||(ret=1))  d
	......s OrderBilled=$P($G(^OEORD(orderId,"I",orderSubId,3)),"^",5)
	......q:OrderBilled'="P"
    ......s ArcItemRowId=$P($G(^OEORD(orderId,"I",orderSubId,1)),"^",2)
    ......q:ArcItemRowId=""
    ......i (ArcStr'="")&&(ArcStr[ArcItemRowId) s ret=1
    ......s OrdsubRowId=$P($G(^ARCIM($P(ArcItemRowId,"||"),$P(ArcItemRowId,"||",2),1)),"^",10)
    ......q:OrdsubRowId=""
    ......i (OrdSubCatStr'="")&&(OrdSubCatStr[OrdsubRowId) s ret=1
    ......s OrdCatRowId=$P($G(^ARC("IC",OrdsubRowId)),"^",8)
    ......i (OrdCatStr'="")&&(OrdCatStr[OrdCatRowId) s ret=1
    ..q:ret=1
    ..s orderSubId="" f  s orderSubId=$O(^OEORD(orderId,"I",orderSubId)) q:orderSubId=""  d
	...q:$O(^OEORD(orderId,"I",orderSubId,"X",""))'=""
	...s OrderBilled=$P($G(^OEORD(orderId,"I",orderSubId,3)),"^",5)
	...q:OrderBilled'="P"
    ...s ArcItemRowId=$P($G(^OEORD(orderId,"I",orderSubId,1)),"^",2)
    ...q:ArcItemRowId=""
    ...i (ArcStr'="")&&(ArcStr[ArcItemRowId) s ret=1
    ...s OrdsubRowId=$P($G(^ARCIM($P(ArcItemRowId,"||"),$P(ArcItemRowId,"||",2),1)),"^",10)
    ...q:OrdsubRowId=""
    ...i (OrdSubCatStr'="")&&(OrdSubCatStr[OrdsubRowId) s ret=1
    ...s OrdCatRowId=$P($G(^ARC("IC",OrdsubRowId)),"^",8)
    ...i (OrdCatStr'="")&&(OrdCatStr[OrdCatRowId) s ret=1
    ...s ret=1
	q ret
}

ClassMethod CheckAdmLoc(regNo As %String = "", AdmLocList As %String = "") As %String
{
	s ret=""
    s startDate=+$H-7
    s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
    q:papmiId="" ""
    s AdmType="" f  s AdmType=$o(^PAPERdr(papmiId,"ADM",AdmType)) q:((AdmType="")||(ret=1))  d
    .s EpisodeID=""
    .f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM",AdmType,EpisodeID)) q:((EpisodeID="")||(ret=1))  d
    ..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..q:pavisit'="A"
    ..s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
    ..q:admDate<startDate
    ..s admLoc=$p($g(^PAADM(EpisodeID)),"^",4)
    ..i AdmLocList[admLoc s ret=1
	q ret
}

ClassMethod GetOrderByReport(EpisodeID As %String = "", Report As %String = "ZLDO") As %String
{
	q:EpisodeID="" ""
	s ret=""
	s wardId="",gap="",locId="",admType="OE",exeFlag=0,queryTypeCode=Report,tempId=$j
	s startDate=+$H-3
	s endDate=+$H
	s regNo=..GetPatRegNobyEpisodeID(EpisodeID)
	q:regNo="" ret
	s rset=##class(%ResultSet).%New("web.DHCNurCom:FindOrditem")
	do rset.Execute(wardId,regNo,tempId,startDate,endDate,queryTypeCode,gap,locId,admType,exeFlag,0)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetDataByName("arcimDesc")
		e  s ret=ret_","_rset.GetDataByName("arcimDesc")
	}	
	d rset.Close()
	q ret
}

ClassMethod GetPatRegNobyEpisodeID(EpisodeID)
{
 	q:$g(EpisodeID)="" ""
 	q:'$d(^PAADM(EpisodeID)) ""
 	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 	s admType=$p(^PAADM(EpisodeID),"^",2)
 	q:$g(PaitentID)="" ""
 	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
 	q:admType="I" $p(^PAPER(PaitentID,"PAT",1),"^",1)
 	s regNo=$p(^PAPER(PaitentID,"PAT",1),"^",2)
 	q regNo
}

ClassMethod UpdateQueueState(ClientIP As %String, TreatAdmDr As %String, QueueState As %String, LocId As %String, UserId As %String) As %String
{
	s Ret=0
 	i $G(ClientIP)="" d
	.i $D(%session) s ClientIP=$G(%session.Data("REMOTE_ADDR"))
	i ClientIP'="" d
	.s ClientId=$O(^DHCVISClienti(0,"ClientIP",ClientIP,""))
	.q:ClientId=""
	.s TreatQueueCat=$P($G(^DHCVISClient(ClientId)),"^",12)
	.q:TreatQueueCat=""
	.s CurId=..GetIdByAdm(TreatAdmDr,LocId,"T"_TreatQueueCat)
	.q:CurId=""
	.s ParStr="^TreatRecUser|"_UserId_"^TreatQueState|"_QueueState
	.s Ret=##Class(User.DHCNurTreatQueue).Save(CurId,ParStr)
	q Ret
}

/// 查询治疗队列
Query FindTreatPat(LocId As %String, serverIP As %String, queState As %String) As %Query(ROWSPEC = "QueueNo:%String,PatName:%String,PatSex:%String,PatAge:%String,RegNo:%String,QueueState:%String,QueuePrior:%String,EpisodeID:%String,TreatId:%String,ClientName:%String")
{
}

ClassMethod FindTreatPatExecute(ByRef qHandle As %Binary, LocId As %String = "", serverIP As %String = "", queState As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i $G(serverIP)="" d
	.i $D(%session) s serverIP=%session.Data("REMOTE_ADDR")
	s serverFlag=0
	i serverIP'="" d
	.s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	.i serverId'="" s serverFlag=1
	.s clientId=$O(^DHCVISClienti(0,"ClientIP",serverIP,""))
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	s UserId=%session.Data("LOGON.USERID")
	i (serverId="")&&(LocId'="") d
	.s serverId=$O(^DHCVISServeri(0,"LinkLoc",LocId,""))
 	s StartDate=+$h
 	i ($G(serverId)="")&&($G(clientId)="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s parList=""
	s clientRowId=$G(clientId)
	i clientRowId'="" d
	.s queueTypeId=$P($G(^DHCVISClient(clientRowId)),"^",12)
	.i queueTypeId'="" s queueTypeId="T"_queueTypeId
	.i queueTypeId="" s queueTypeId=clientRowId
	.i parList'[queueTypeId s parList=parList_","_queueTypeId
	i ($G(serverId)'="")&&(clientRowId="") d
	.s clientId="" f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:clientId=""  d
	..s queueTypeId=$P($G(^DHCVISClient(clientId)),"^",12)
	..i queueTypeId'="" s queueTypeId="T"_queueTypeId
	..i queueTypeId="" s queueTypeId=clientId
	..i parList'[queueTypeId s parList=parList_","_queueTypeId
	i ($G(serverId)'="")&&(clientRowId'="")&&(serverFlag) d
	.s clientId="" f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:clientId=""  d
	..q:(clientId=clientRowId)
	..s queueTypeId=$P($G(^DHCVISClient(clientId)),"^",12)
	..i queueTypeId'="" s queueTypeId="T"_queueTypeId
	..i queueTypeId="" s queueTypeId=clientId
	..i parList'[queueTypeId s parList=parList_","_queueTypeId
	f j=1:1:$L(parList,",") d
	.s queueTypeId=$P(parList,",",j)
	.q:queueTypeId=""
	.d OutPutByClient
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
	...s PatAge=##class(web.DHCDTHealthCommon).GetAgeDesc(birth,+$h)
	...s RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	...s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	...q:((QueueState="Finish")||(QueueState="Skip"))&&(queState="")
	...q:(QueueState'="Finish")&&(QueueState'="Skip")&&(queState="F")
	...s QueueState=$S(QueueState="Wait":"等候",QueueState="Ready":"准备",QueueState="Call":"呼叫",QueueState="Skip":"过号",QueueState="Finish":"完成",1:"")
	...s QueuePrior=$ListGet(^User.DHCNurTreatQueueD(curId),6)
	...s QueuePrior=$S(QueuePrior="1":"优先",QueuePrior="2":"正常",QueuePrior="3":"过号",1:"")
	...s EpisodeID=TreatAdmDr
	...s TreatId=curId
	...s ClientName=""
	...s RecUserId=$ListGet(^User.DHCNurTreatQueueD(curId),11)
	...Q:((QueueState="呼叫")||(QueueState="准备"))&&(UserId'=RecUserId)
	...i queueTypeId'="" d
	....i queueTypeId["T"  s ClientName=$P($G(^DHCVISQueueType($TR(queueTypeId,"T"))),"^")
	....e  s ClientName=$P($G(^DHCVISClient(queueTypeId)),"^",3)
	...i QueueNo<10 s Seq=i_"000"_QueueNo
	...i (QueueNo>9)&&(QueueNo<100) s Seq=i_"00"_QueueNo
	...i (QueueNo>99)&&(QueueNo<1000) s Seq=i_"0"_QueueNo
	...i (QueueNo>999) s Seq=i_QueueNo
	...set Data=$lb(QueueNo,PatName,PatSex,PatAge,RegNo,QueueState,QueuePrior,EpisodeID,TreatId,ClientName)
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
	set Data=$lb(QueueNo,PatName,PatSex,PatAge,RegNo,QueueState,QueuePrior,EpisodeID,TreatId,ClientName)
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
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
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

ClassMethod GetQueueInfomation(LocId As %String, serverIP As %String) As %String
{
	s WaitPatNum=0,FinshPatNum=0
	s rset=##Class(%ResultSet).%New("web.DHCVISTreatQueue:FindTreatPat")
	i rset.QueryIsValid() { 
		s Status=rset.Execute(LocId, serverIP)
		i Status
		{
			While (rset.Next()) {
	    	    s WaitPatNum=WaitPatNum+1
			}	
		}
		s Status=rset.Execute(LocId, serverIP,"F")
		i Status
		{
			While (rset.Next()) {
	    	    s FinshPatNum=FinshPatNum+1
			}	
		}
	}
	d rset.Close()
	q "完成:"_FinshPatNum_"人,等候:"_WaitPatNum_"人"
}

ClassMethod GetTipShow(computerIP As %String = "") As %String
{
	s ret=""
	q:computerIP="" ""
	s clientId=$O(^DHCVISClienti(0,"ClientIP",computerIP,""))
	q:clientId="" ret
	s ret=$P($G(^DHCVISClient(clientId)),"^",17)
	q ret
}

}
