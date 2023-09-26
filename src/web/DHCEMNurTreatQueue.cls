Class web.DHCEMNurTreatQueue Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 根据日期(默认当天)查询治疗队列中病人
/// w ##class(web.DHCEMNurTreatQueue).TreatPat(10,1)
ClassMethod TreatPat(limit, offset, serverName = "") As %String
{
	n (%session,limit,offset,serverName)
    
    s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	s start=offset+1 //(page-1)*rows+1
    s end=offset+limit //page*rows
	//s serverName="222.132.155.195"
	s ^ZXZX=serverName
	s LocId=+%session.Data("LOGON.CTLOCID")
	s serverIP=%session.Data("REMOTE_ADDR")
	s StartDate=+$h
	s serverId="",clientId=""
	i serverName'="" d
	.s serverId=$O(^DHCVISServeri(0,"ServerIP",serverName,""))
	.s:serverId'="" serverDesc="服务端:"_serverName
	
	i serverId="" d
	.s serverId=$O(^DHCVISServeri(0,"ServerIP",serverIP,""))
	.s:serverId'="" serverDesc="服务端:"_serverIP
	
	i serverId="" d
	.s serverId=$O(^DHCVISServeri(0,"LinkLoc",LocId,""))
	.s:$g(serverId)'="" serverDesc="服务端:"_$p(^CTLOC(LocId),"^",2)
	
	i serverId="" d
	.s clientId=$O(^DHCVISClienti(0,"ClientIP",serverName,""))
	.s:clientId'="" serverDesc="客户端:"_serverName

	i (serverId="")&&(clientId="") d
	.s clientId=$O(^DHCVISClienti(0,"ClientIP",serverIP,""))
	.s:clientId'="" serverDesc="客户端:"_serverIP
	

	
	f date=(StartDate-1):1:StartDate d
    .i ($G(serverId)="")&&($G(clientId)="") d
	..D ##class(web.DHCEMNurTreatQueue).QueryEmTreatPatListByLoc(pid,LocId,date)
	.e  d
	..D ##class(web.DHCEMNurTreatQueue).QueryEmTreatPatListByType(pid,$g(serverId),$g(clientId),date)
	
	S ListTitle="QueueNo^PatName^PatSex^PatAge^RegNo^QueueState^QueuePrior^EpisodeID^TreatId^ClientName"
	s count=0
	w "{""rows"":["
	s seq="" f  s seq=$o(^TMP("DHCST","web.DHCEMNurTreatQueue","TreatPat",pid,seq)) q:seq=""  d
	.s count=count+1
	.q:count<start
  	.q:count>end
    .w $case(count,start:"",:",")
	.s ListData=^TMP("DHCST","web.DHCEMNurTreatQueue","TreatPat",pid,seq)
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "],""total"":"_count_",""serverDesc"":"""_$g(serverDesc)_"""}"
	
	k ^TMP("DHCST","web.DHCEMNurTreatQueue","TreatPat",pid)
	q ""
}

ClassMethod QueryEmTreatPatListByLoc(pid, LocId, StartDate) As %String
{
	
	n (pid,LocId,StartDate)
	f i=1:1:3 d
   	.s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueLocDate"," "_LocId,StartDate," "_i,curQueNo)) q:(curQueNo="")  d
	..s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("QueLocDate"," "_LocId,StartDate," "_i,curQueNo,curId)) q:(curId="")  d
	...d ..SetSortGlobal(pid,curId,i)
}

ClassMethod QueryEmTreatPatListByType(pid, serverId, clientId, StartDate) As %String
{
	
	n (pid,serverId,clientId,StartDate)
	f i=1:1:3 d
	.s parList=""
	.s clientRowId=$G(clientId)
	.i clientRowId'="" d
	..s queueTypeId=$P($G(^DHCVISClient(clientRowId)),"^",12)
	..i queueTypeId'="" s queueTypeId="T"_queueTypeId
	..i queueTypeId="" s queueTypeId=clientRowId
	..i parList'[queueTypeId s parList=parList_","_queueTypeId
	.i ($G(serverId)'="")&&(clientRowId="") d
	..s clientId="" f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:clientId=""  d
	...s queueTypeId=$P($G(^DHCVISClient(clientId)),"^",12)
	...i queueTypeId'="" s queueTypeId="T"_queueTypeId
	...i queueTypeId="" s queueTypeId=clientId
	...i parList'[queueTypeId s parList=parList_","_queueTypeId
	.i ($G(serverId)'="")&&(clientRowId'="")&&(serverFlag) d
	..s clientId="" f  s clientId=$O(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:clientId=""  d
	...q:(clientId=clientRowId)
	...s queueTypeId=$P($G(^DHCVISClient(clientId)),"^",12)
	...i queueTypeId'="" s queueTypeId="T"_queueTypeId
	...i queueTypeId="" s queueTypeId=clientId
	...i parList'[queueTypeId s parList=parList_","_queueTypeId
	.f j=1:1:$L(parList,",") d
	..s queueTypeId=$P(parList,",",j)
	..q:queueTypeId=""
	..b
	..s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueDateCat",StartDate," "_queueTypeId," "_i,curQueNo)) q:(curQueNo="")  d
	...s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("QueDateCat",StartDate," "_queueTypeId," "_i,curQueNo,curId)) q:(curId="")  d
	....d ..SetSortGlobal(pid,curId,i)
}

ClassMethod SetSortGlobal(pid, curId, i) As %String
{
	
	n (curId,pid,i)
	s QueueNo=$ListGet(^User.DHCNurTreatQueueD(curId),5)
	
	s TreatAdmDr=$ListGet(^User.DHCNurTreatQueueD(curId),2)
	q:TreatAdmDr=""
	s Papmidr=$P($G(^PAADM(TreatAdmDr)),"^",1)
	q:Papmidr=""
	s PatName=$P($G(^PAPER(Papmidr,"ALL")),"^",1)
	s PatSexId=$p($g(^PAPER(Papmidr,"ALL")),"^",7)
	i PatSexId'="" s PatSex=$p($g(^CT("SEX",PatSexId)),"^",2)
	e  s PatSex=""
	s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(TreatAdmDr)
	s RegNo=$P($G(^PAPER(Papmidr,"PAT",1)),"^",2)
	s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	q:(QueueState="Finish")||(QueueState="Skip")	//完成治疗的不显示
	s QueueState=$S(QueueState="Wait":"等候",QueueState="Ready":"准备",QueueState="Call":"呼叫",QueueState="Skip":"过号",QueueState="Finish":"完成",1:"")
	s QueuePrior=$ListGet(^User.DHCNurTreatQueueD(curId),6)
	q:QueuePrior=3
	s QueuePrior=$S(QueuePrior="1":"优先",QueuePrior="2":"正常",QueuePrior="3":"过号",1:"")
	s EpisodeID=TreatAdmDr 
	s TreatId=curId
	s ClientName=""
	s ClientId=$ListGet(^User.DHCNurTreatQueueD(curId),12)
	i ClientId'="" d
	.i ClientId["T"  s ClientName=$P($G(^DHCVISQueueType($TR(ClientId,"T"))),"^")
	.e  s ClientName=$P($G(^DHCVISClient(ClientId)),"^",3)
	i QueueNo<10 s Seq=i_"000"_QueueNo
	i (QueueNo>9)&&(QueueNo<100) s Seq=i_"00"_QueueNo
	i (QueueNo>99)&&(QueueNo<1000) s Seq=i_"0"_QueueNo
	i (QueueNo>999) s Seq=i_QueueNo
	s ^TMP("DHCST","web.DHCEMNurTreatQueue","TreatPat",pid,Seq)=QueueNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_RegNo_"^"_QueueState_"^"_QueuePrior_"^"_EpisodeID_"^"_TreatId_"^"_ClientName
}

/// "61.178.118.39"
/// w ##class(web.DHCEMNurTreatQueue).GetClientStr("61.178.118.39")
ClassMethod GetClientStr(serverIP As %String = "") As %String
{
	s LocId=""
	i $D(%session) s LocId=$G(%session.Data("LOGON.CTLOCID"))
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
		i ret=""  s ret=clientId_$C(1)_clientName //_"-"_queueType
		e  s ret=ret_"^"_clientId_$C(1)_clientName //_"-"_queueType
	}	
	d rset.Close()
	q ret
}

ClassMethod getClientId(client As %String = "") As %String
{
	n (client,%session)
	s clientId=""
	i client'="" d
	.s clientId=$O(^DHCVISClienti(0,"ClientIP",client,""))
	i client="" d
	.s client=%session.Data("REMOTE_ADDR")
	.s clientId=$O(^DHCVISClienti(0,"ClientIP",client,""))
	q clientId
}

/// w ##class(web.DHCEMNurTreatQueue).saveOrUpdate("User.DHCNurTreatQueue",)
ClassMethod saveOrUpdate(tableName As %String = "", jsonStr As %String = "") As %String
{
	n (tableName,jsonStr)
	
	s obj = ##class(ext.util.JsonObject).%New() 
	s obj.ContainNullValue=1
	s obj.ContainNullArray=1
	s obj.ContainNullObject=1
	s PO=obj.ObjectFromJSON(jsonStr,tableName)
	s sc=PO.%Save() 
	d obj.Clear()
	d obj.%Close()
	s obj = ""
	q ""
}

}
