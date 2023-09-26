Import SQLUser

Class web.DHCNurseBlood Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 78;

/// w ##class(web.DHCNurseBlood).GetPatientInfo("0001629442")
ClassMethod GetPatientInfo(patCardNo As %String = "") As %String
{
	s retInfoStr=""
	i patCardNo["=" s patCardNo=$P(patCardNo,"=")
	q:patCardNo="" retInfoStr
	s papmiDr=""
	s ind=""
	s ind=$O(^DHCCARDi("CF",0,"CardNo",patCardNo,""),-1) //卡号
	i ($G(ind)'="")&&($G(^DHCCARD("CF",ind))'="")&&($p($G(^DHCCARD("CF",ind)),"^",10)="N") s papmiDr=$p($G(^DHCCARD("CF",ind)),"^",4)
	i papmiDr="" s papmiDr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(patCardNo),"")) //登记号
	i papmiDr="" s papmiDr=$o(^PAPERi("PAPMI_ICPPBC",$$ALPHAUP^SSUTIL4(patCardNo)_"Z",""))  //身份证号
	q:papmiDr="" retInfoStr
	s regNo=$p(^PAPER(papmiDr,"PAT",1),"^",2)
	s patName=$p($g(^PAPER(papmiDr,"ALL")),"^",1)
	s admId=""
	s admIdO=$O(^PAPERdr(papmiDr,"ADM","O",""),-1)
	s:admIdO="" admIdO=0
	s admIdE=$O(^PAPERdr(papmiDr,"ADM","E",""),-1) //add by linyuxu
	s:admIdE="" admIdE=0
	i admIdO>admIdE s admId=admIdO
	e  s admId=admIdE
	q:admId="" retInfoStr
	i admId'="" s patCtLocDr=$P($G(^PAADM(admId)),"^",4)
	i admId'="" s patAdmDate=$P($G(^PAADM(admId)),"^",6)
	i $G(patCtLocDr)'="" s patCtLocDesc=$P($G(^CTLOC(patCtLocDr)),"^",2)
	e  s patCtLocDesc=""
	s retInfoStr=patCardNo_"^"_regNo_"^"_patName_"^"_admId_"^"_patCtLocDr_"^"_patCtLocDesc
	q retInfoStr
}

/// 取病人检验医嘱，如果没有检验医嘱返回空
/// w ##class(web.DHCNurseBlood).GetPatientOrder("0000002202")
ClassMethod GetPatientOrder(patCardNo As %String = "") As %String
{
	n (patCardNo)
	//q "不判断费用!"
	s labOrderStr1="",labOrderStr2="",labOrderStr3=""
	s wardId="",gap="",locId="",admType="OE",exeFlag=0,queryTypeCode="JYDO",tempId="11"
	s startDate=+$H-100 //检验科要求一周之内有检验医嘱患者进行叫号
	s endDate=+$H
	s patInfoStr=..GetPatientInfo(patCardNo)
	q:patInfoStr="" labOrderStr
	s regNo=$P(patInfoStr,"^",2)
	s rset=##class(%ResultSet).%New("web.DHCNurCom:FindOrditem")
	do rset.Execute(wardId,regNo,tempId,startDate,endDate,queryTypeCode,gap,locId,admType,"0","0","2")
	while (rset.Next()) {
		continue:(rset.GetData(22)="未收费")
		continue:(rset.GetData(1)="P")
		i (rset.GetData(41)'="")  d
		.i labOrderStr1=""  s labOrderStr1=rset.GetData(9)
		.e  s labOrderStr1=labOrderStr1_","_rset.GetData(9)
	}	
	d rset.Close()
	q labOrderStr1
}

/// 新产品组： 取病人检验医嘱
/// Return:已收费医嘱检验号^未收费检验医嘱信息
/// w ##class(web.DHCNurseBlood).GetPatientOrderNew("0000001104","2")
ClassMethod GetPatientOrderNew(patCardNo As %String = "", lgHospId = "") As %String
{
	n (patCardNo,lgHospId)
	s papmiDr="",ind="",labOrderStr1="",noPayMoneyOrderStr=""
	s ind=$O(^DHCCARDi("CF",0,"CardNo",patCardNo,""),-1) //卡号
	i ($G(ind)'="")&&($G(^DHCCARD("CF",ind))'="")&&($p($G(^DHCCARD("CF",ind)),"^",10)="N") s papmiDr=$p($G(^DHCCARD("CF",ind)),"^",4)
	i papmiDr="" s papmiDr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(patCardNo),"")) //登记号
	i papmiDr="" s papmiDr=$o(^PAPERi("PAPMI_ICPPBC",$$ALPHAUP^SSUTIL4(patCardNo)_"Z",""))  //身份证号
	q:papmiDr="" ""
	
	s admType="OE",exeFlag=0,queryTypeCode="JYDO"
	s:lgHospId="" lgHospId=2
	
	s startDate=+$H-6,endDate=+$H	//7天内
	
	s rset=##class(%ResultSet).%New("web.DHCEMInterfaceCom:QueryPatLisOrd")
	
	do rset.Execute(papmiDr,startDate,endDate,queryTypeCode,admType,lgHospId)
	while (rset.Next()) {
		s LabNo=rset.Data("LabNo")
		s OrdBilled=rset.Data("OrdBilled")
		s OrdItmId=rset.Data("OrdItmId")
		i (OrdBilled'="P") d
		.i noPayMoneyOrderStr=""  s noPayMoneyOrderStr=LabNo
		.e  s noPayMoneyOrderStr=noPayMoneyOrderStr_","_LabNo
		continue:(OrdBilled'="P")
		i (LabNo'="")  d
		.i labOrderStr1=""  s labOrderStr1=LabNo
		.e  s labOrderStr1=labOrderStr1_","_LabNo
	}	
	d rset.Close()
	q labOrderStr1_"^"_noPayMoneyOrderStr
}

/// w ##class(web.DHCNurseBlood).GetWaitNum(76,26)
ClassMethod GetWaitNum(locDr As %String = "", serverId As %String = "") As %String
{
	s nowDate=+$H
	s clientId=0
	//获取等候人数
	s DHCBQNo="",num=0
	f  s DHCBQNo=$O(^User.DHCNurTreatQueueI("QueDateLocCat",nowDate," "_locDr," T"_clientId," 2"," "_DHCBQNo)) q:(DHCBQNo="")  d
	.s DHCBQNo=$P(DHCBQNo," ",2)
	.s DHCBQDr=""
	.s DHCBQDr=$O(^User.DHCNurTreatQueueI("QueDateLocCat",nowDate," "_locDr," T"_clientId," 2"," "_DHCBQNo,""))
	.s DHCBQState=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),7)
	.i ((DHCBQState="Wait")||(DHCBQState="Call")||(DHCBQState="Ready")) s num=num+1
	q num
}

/// w ##class(web.DHCNurseBlood).InsertQueue("0000001104","0","","","10.1.30.144")
ClassMethod InsertQueue(patCardNo As %String = "", vipPat As %String = "0", serverId As %String = "", locDr As %String = "", clientIp = "") As %String
{
	s clientId="",serverId=""
	s:clientIp'="" clientId=$O(^DHCVISClienti(0,"ClientIP",clientIp,""))
	s:clientId'="" serverId=$P($G(^DHCVISClient(clientId)),"^",1)
	s:serverId'="" locDr=$p(^DHCVISServer(serverId),"^",8)
	s:(serverId="")||(clientId="") serverId="13",locDr="185",clientId="91"
	s retStr="报道失败",noticeStr=""
	i patCardNo["=" s patCardNo=$P(patCardNo,"=")
	q:patCardNo="" "卡号不能为空!"
	s patInfoStr=..GetPatientInfo(patCardNo)
	q:patInfoStr="" "根据卡号未找到患者信息"
	s regNo=$P(patInfoStr,"^",2)
	s patName=$P(patInfoStr,"^",3)
	s admId=$P(patInfoStr,"^",4)
	s hospId=$p($g(^CTLOC(serverId)),"^",22)
	s labOrderList=..GetPatientOrderNew(patCardNo,hospId)
	s payMoneyOrderList=$p(labOrderList,"^",1)
	s noPayMoneyOrderList=$p(labOrderList,"^",2)
	;没有需要采血医嘱时的提示
	q:(payMoneyOrderList="")&&(noPayMoneyOrderList="") "没有检验医嘱"
	q:(payMoneyOrderList="")&&(noPayMoneyOrderList'="") "检验医嘱未交费!"
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	s preQueueNo=""
	s DHCBQDr=$o(^User.DHCNurTreatQueueI("Adm"," "_admId,""),-1)
	if DHCBQDr'="" d
	.s preQueueDate=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),4)
	.s preQueueState=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),7)
	.i ((preQueueDate=+$h)&((preQueueState="Wait")||(preQueueState="Call"))) s preQueueNo=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),5)
	q:preQueueNo'="" "已取号!序号"_preQueueNo
	s DHCBQDr=""
	//获取队列信息
	s waitInfo=..GetWaitInfo(locDr,serverId,clientId)
	s clientId=$p(waitInfo,"^",1)
	s queueNo=$p(waitInfo,"^",2)
	s queueNum=$p(waitInfo,"^",3)
	q:clientId=0 "服务器客户端未能成功设置，请联系信息科^0^0^0"
	s clientName=$p($g(^DHCVISClient(clientId)),"^",3)
	
	TSTART
	s ResultFlag=##class(User.DHCNurTreatQueue).Save("","TreatLocDr|"_locDr_"^TreatAdmDr|"_admId_"^TreatQueNo|"_queueNo_"^TreatQueState|Wait^TreatQuePrior|2^TreatQueDate|"_nowDate_"^TreatQueTime|"_nowTime_"^TreatQueueCat|"_clientId_"^TreatReportType|JYDO^RegNo|"_regNo_"^SeatFlag|3")
	i $p(ResultFlag,"^",1)'=0 TROLLBACK
	e  TCOMMIT
	s retStr=ResultFlag_"^"_queueNo_"^"_vipPat_"^"_queueNum
	q retStr
}

/// w ##class(web.DHCNurseBlood).GetWaitInfo(109,26)
ClassMethod GetWaitInfo(locDr As %String = "", serverId As %String = "", ClientID As %String = "") As %String
{
	s nowDate=+$H
	//获取窗口
	s clientId="",clientIdBak=0,numBak=10000
	f  s clientId=$o(^DHCVISClienti(0,"ServerID",serverId,clientId)) q:(clientId="")  d
	.q:clientId'=ClientID
	.s QueNo="",num=0
	.f  s QueNo=$o(^User.DHCNurTreatQueueI("QueDateLocCat",nowDate," "_locDr," T"_clientId," 2"," "_QueNo)) q:QueNo=""  d
	..s QueNo=$P(QueNo," ",2)
	..s DHCBQDr=$O(^User.DHCNurTreatQueueI("QueDateLocCat",nowDate," "_locDr," T"_clientId," 2"," "_QueNo,""))
	..q:DHCBQDr=0
	..s DHCBQState=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),7)
	..i ((DHCBQState="Wait")||(DHCBQState="Call")||(DHCBQState="Ready")) s num=num+1
	.i numBak>num d
	..s numBak=num
	..s clientIdBak=clientId
	//获取等候人数
	s DHCBQNo="",maxQueNo=0,maxQueNobak=0,num=0
	f  s DHCBQNo=$O(^User.DHCNurTreatQueueI("QueDateLocCat",nowDate," "_locDr," T"_clientIdBak," 2"," "_DHCBQNo)) q:(DHCBQNo="")  d
	.s DHCBQNo=$P(DHCBQNo," ",2)
	.s DHCBQDr=""
	.s DHCBQDr=$O(^User.DHCNurTreatQueueI("QueDateLocCat",nowDate," "_locDr," T"_clientIdBak," 2"," "_DHCBQNo,""))
	.s DHCBQState=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),7)
	.i ((DHCBQState="Wait")||(DHCBQState="Call")||(DHCBQState="Ready")) s num=num+1
	.s maxQueNo=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),5)
	.s:maxQueNobak<maxQueNo maxQueNobak=maxQueNo
	q clientIdBak_"^"_(maxQueNobak+1)_"^"_num
}

/// Input:ShowAllClient(1:遍历所有客户端队列,"":只获取当前客户端队列,影响到了取排队号)
/// w ##class(web.DHCNurseBlood).InsertQueueNew("0000000999","10.1.30.144","1","2")
ClassMethod InsertQueueNew(PatCardNo, ClientIp, ShowAllClient = "1", HospId = "") As %String
{
	
	s ServerId="",ServerLocId="",ClientId=""
	i ClientIp'="" d
	.s ClientId=$o(^DHCVISClienti(0,"ClientIP",ClientIp,""))
	.s ServerId=$p($g(^DHCVISClient(+ClientId)),"^",1)
	.s ServerLocId=$p($g(^DHCVISServer(+ServerId)),"^",8)
	i ClientIp="" d
	.s ServerId="13",ServerLocId="185",ClientId="91"
	q:ClientId="" "数字媒体配置,未配置客户端!"
	q:ServerId="" "数字媒体配置,未关联服务器!"
	q:ServerLocId="" "数字媒体配置,采血服务器需关联科室!"
	s:PatCardNo["=" PatCardNo=$p(PatCardNo,"=")
	q:PatCardNo="" "卡号不能为空!"
	s PatInfoStr=##class(web.DHCNurseBlood).GetPatientInfo(PatCardNo)
	q:PatInfoStr="" "根据卡号未找到患者信息!"
	s RegNo=$P(PatInfoStr,"^",2)
	s PatName=$P(PatInfoStr,"^",3)
	s AdmId=$P(PatInfoStr,"^",4)  ;最新门急诊就诊
	s:HospId="" HospId=$p($g(^CTLOC(ServerLocId)),"^",22)
	s LabOrderList=..GetPatientOrderNew(PatCardNo,HospId)
	s PayMoneyOrderList=$p(LabOrderList,"^",1)
	s NoPayMoneyOrderList=$p(LabOrderList,"^",2)
	
	;没有需要采血医嘱时的提示
	q:(PayMoneyOrderList="")&&(NoPayMoneyOrderList="") "没有检验医嘱"
	q:(PayMoneyOrderList="")&&(NoPayMoneyOrderList'="") "检验医嘱未交费!"
	s PreQueueNo=##class(web.DHCNurseBlood).GetBloodPreQueueNo(AdmId)
	q:PreQueueNo'="" "已处于队列中,队列号:"_PreQueueNo
	
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	
	//获取队列信息
	s InClientId=$case(ShowAllClient,"":ClientId,:"")
	
	s WaitInfo=##class(web.DHCNurseBlood).GetBloodWaitInfoNew(ServerLocId,ServerId,InClientId)
	s QueueNo=$p(WaitInfo,"^",1)
	s QueueNum=$p(WaitInfo,"^",2)
	b ;QueueNo
	ts
	s Err=##class(User.DHCNurTreatQueue).Save("","TreatLocDr|"_ServerLocId_"^TreatAdmDr|"_AdmId
		_"^TreatQueState|Wait^TreatQuePrior|2^TreatQueDate|"_NowDate_"^TreatQueTime|"_NowTime
		_"^TreatQueueCat|"_ClientId_"^TreatReportType|JYDO^RegNo|"_RegNo_"^SeatFlag|",ShowAllClient)
	tro:+Err'=0 
	q:+Err'=0 "插入队列失败,原因:"_Err
	tc
	s VipPat=""
	
	q Err_"^"_QueueNo_"^"_VipPat_"^"_QueueNum
}

/// w ##class(web.DHCNurseBlood).GetBloodPreQueueNo("2651")
ClassMethod GetBloodPreQueueNo(AdmId)
{
	s PreQueueNo=""
	s DHCBQDr=$o(^User.DHCNurTreatQueueI("Adm"," "_AdmId,""),-1)
	if DHCBQDr'="" d
	.s PreQueueDate=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),4)
	.s PreQueueState=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),7)
	.s SeatFlag=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),16)
	.q:SeatFlag'=""
	.i ((PreQueueDate=+$h)&((PreQueueState="Wait")||(PreQueueState="Call"))) s PreQueueNo=$List($G(^User.DHCNurTreatQueueD(DHCBQDr)),5)
	q PreQueueNo
}

/// w ##class(web.DHCNurseBlood).GetBloodWaitInfoNew(85,107,141)
ClassMethod GetBloodWaitInfoNew(ServerLocId, InServerId, InClientId = "") As %String
{
	n ServerId,ClientId
	//获取等候人数
	s DHCBQNo="",MaxQueNo=0,MaxQueNobak=0,Num=0
	
	;只所以这么写,数字媒体写死的91,可能是不存在ClientId
	i InClientId="" d
	.s ClientId=0	;循环
	.f  s ClientId=$o(^DHCVISClienti(0,"ServerID",InServerId,ClientId)) q:(ClientId="")  d
	..d SetBloodWaitInfo
	i InClientId'="" d
	.s ClientId=InClientId
	.d SetBloodWaitInfo
	q (MaxQueNo+1)_"^"_Num
	
SetBloodWaitInfo
	f k=1:1:3 d
	.s CurId=0
	.f  s CurId=$O(^User.DHCNurTreatQueueI("QueDateLoc",+$H," "_ServerLocId," T"_ClientId," "_k,CurId)) q:(CurId="")  d
	..s DHCBQState=$List($G(^User.DHCNurTreatQueueD(CurId)),7)
	..i ((DHCBQState="Wait")||(DHCBQState="Call")||(DHCBQState="Ready")) s Num=Num+1
	..s ThisQueNo=$List($G(^User.DHCNurTreatQueueD(CurId)),5)
	..s:MaxQueNo<ThisQueNo MaxQueNo=ThisQueNo
	..s:MaxQueNobak<MaxQueNo MaxQueNobak=MaxQueNo
	q ""
}

}
