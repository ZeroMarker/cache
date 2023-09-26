Class web.DHCAntUseInformation Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：     shp
/// CreatDate：   2012-11-29
/// Description:  抗菌药物使用情况。
/// Table：       DHCDocInfPos
/// Input：       
/// D ##class(%ResultSet).RunQuery("web.DHCAntUseInformation","QryAntiUseInfo",+$h,+$h,"")
Query QryAntiUseInfo(StDate As %String, EndDate As %String, LocID As %String, PriorID As %String = "", OrderPoison As %String = "") As %Query(ROWSPEC = "PatNo:%String,PatName:%String,OrderLoc:%String,ArcimDesc:%String,FormInstrDesc:%String,FormFreqDesc:%String,FormDurDesc:%String,OrdDoctor:%String,OrdTime:%String,AuditDoctor:%String,AuditTime:%String,ConsultDep:%String,ConsultDoctor:%String,ConTime:%String,PoisonDesc:%String,UsePurpose:%String,Evaluetion:%String,Audit24:%String,OrderStatus:%String,Attitude:%String,Tid:%String,OrderPrior:%String,EpisodeID:%String,UseReasonID:%String,AARowid:%String")
{
}

ClassMethod QryAntiUseInfoExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, LocID As %String, PriorID As %String = "", OrderPoison As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1


	s UserID=%session.Data("LOGON.USERID")
 	k ^DHCTempAntGlobal("AntiUseInfo",UserID)
	s date="",num=0
	s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	for cdate=StDate:1:EndDate d 
		.s Rowid=0
		.for  s Rowid=$o(^DAUP("Date",cdate,Rowid)) q:Rowid=""  d
			..s oeori=$p(^DAUP("DAUP",Rowid),"^",3)
			..Q:oeori=""
			..q:'$d(^OEORD(+oeori,"I",$P(oeori,"||",2)))
			..s PatNo="",patName="",OrderLoc="",ArcimDesc="",FormInstrDesc="",FormFreqDesc="",FormDurDesc="",OrdDoctor="",OrdTime="",AuditDoctor="",auditTime="",ConsultDep="",ConsultDoctor="",ConTime="",PoisonDesc="",UsePurpose="",Evaluetion="",Audit24="",OrderStatus="",Attitude="",OrderPrior=""
			..s OrderStatusCode=$p(^OEC("OSTAT",$p(^OEORD(+oeori,"I",$P(oeori,"||",2),1),"^",13)),"^",1)
			..q:OrderStatusCode="I"
			..S OrderStatus=$p(^OEC("OSTAT",$p(^OEORD(+oeori,"I",$P(oeori,"||",2),1),"^",13)),"^",2)
			..s DTAUPDr=$p(^DAUP("DAUP",Rowid),"^",20)
			..s UsePurpose=$p(^DTAUP("AUP",DTAUPDr),"^",2)
			..s adm=$p(^DAUP("DAUP",Rowid),"^",2)
			..s papmi=$p(^PAADM(adm),"^",1)
			..s patName=$p(^PAPER(papmi,"ALL"),"^",1)
			..s PatNo=""
			..s PatNo=$P(^PAPER(papmi,"PAT",1),"^",1)                //住院
			..i PatNo=""  s PatNo=$P(^PAPER(papmi,"PAT",1),"^",2)    //门诊
			..s ow=+oeori,chl=$p(oeori,"||",2)
			..s ArcimRowid=$p($g(^OEORD(ow,"I",chl,1)),"^",2)
			..q:ArcimRowid=""
			..s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimRowid)
			..q:PoisonRowid=""
	  		..s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	  		..S PoisonDesc=$P(^PHCPO(PoisonRowid),"^",2)
	  		..q:(OrderPoison'="")&&(PoisonRowid'=OrderPoison)
	  		..;q:(PoisonCode'="KSS1")&&(PoisonCode'="KSS2")&&(PoisonCode'="KSS3")
			..s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
			..s OrderDocDr=$p(^OEORD(ow,"I",chl,1),"^",11)
			..s OrdDoctor=$p(^CTPCP(OrderDocDr,1),"^",2)            //医嘱医生
			..s OrderDep=$p(^OEORD(ow,"I",chl,7),"^",2)
			..q:((LocID'="")&&(OrderDep'=LocID))
			..s OrderLoc=$p(^CTLOC(OrderDep),"^",2)           //科室
			..s PHFreqDR=$p(^OEORD(ow,"I",chl,2),"^",4)
			..i PHFreqDR'=""  s FormFreqDesc=$P($g(^PHCFR(PHFreqDR)),"^",3)   //频次
			..s DuratDR=$p(^OEORD(ow,"I",chl,2),"^",6)
			..i DuratDR'="" s FormDurDesc=$P($g(^PHCDU(DuratDR)),"^",3)   //疗程
			..s InstrDR=$p(^OEORD(ow,"I",chl,2),"^",7)
			..i InstrDR'="" s FormInstrDesc=$P($g(^PHCIN(InstrDR)),"^",2) //用法
			..s OrderDate=$p(^OEORD(ow,"I",chl,3),"^",7)     
			..s OrderTime=$p(^OEORD(ow,"I",chl,1),"^",17)      //医嘱录入时间
			..;s OrderDate=$zd(OrderDate,3)
			..s OrderDate=##class(websys.Conversions).DateLogicalToHtml(OrderDate)
			..s OrderTime=$zt(OrderTime,2)
			..s OrdTime=OrderDate_" "_OrderTime                //开医嘱时间 QP
			..s OrderPriorDr=$p(^OEORD(ow,"I",chl,1),"^",8)
			..q:(PriorID'="")&&(OrderPriorDr'=PriorID)
			..s:OrderPriorDr'="" OrderPrior=$p(^OECPR(OrderPriorDr),"^",2)
			..;I $D(^User.DHCAntEvaluationI("OEORI"," "_oeori))  D
			..S EvalueID=$O(^User.DHCAntEvaluationI("OEORI"," "_oeori,0))
			..i EvalueID'=""  d
				...S Evalue=$list(^User.DHCAntEvaluationD(EvalueID),3)              //疗效
				...s Evaluetion=$s(Evalue="":"",Evalue="Y":"有效",Evalue="N":"无效",Evalue="NS":"不确定")
			..s AARowid=$o(^DHCDAAi(0,"OEORI",oeori,0))
			..if AARowid'=""  d
				...s Status=$p(^DHCDAA("ANT",AARowid),"^",12)
				...q:(Status'="U")&&(Status'="R")
				...s AuditUser=$p(^DHCDAA("ANT",AARowid,1),"^",10)  
				...S CPDr=$p(^SSU("SSUSR",AuditUser),"^",14)
				...s AuditDoctor=$p(^CTPCP(CPDr,1),"^",2)        //审核医生
				...s AppDate=$p(^DHCDAA("ANT",AARowid),"^",10)
				...s AppTime=$p(^DHCDAA("ANT",AARowid),"^",11)
				...s AuditDate=$p(^DHCDAA("ANT",AARowid,1),"^",11)
				...s AuditTime=$p(^DHCDAA("ANT",AARowid,1),"^",12)
				...s app=##class(web.DHCDocAntibioticReason).GetAbsTime(AppDate_","_AppTime)
				...s aud=##class(web.DHCDocAntibioticReason).GetAbsTime(AuditDate_","_AuditTime)
				...i (aud>(app+86400))  s Audit24="否"
				...i (aud<=(app+86400))  s Audit24="是"
				...;s AuditDate=$zd(AuditDate,3)
				...s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
				...s AuditTime=$zt(AuditTime,2)
				...s auditTime=AuditDate_" "_AuditTime
				...;会诊信息
				...s ConsultID=$p(^DHCDAA("ANT",AARowid,1),"^",22)   //指向DHC_Consultation
				...i ConsultID'=""  d
					....S ConsultationDep=$list(^User.DHCConsultationD(ConsultID),11)  //会诊科室
					....s ConsultDep=$p(^CTLOC(ConsultationDep),"^",2)
					....S ConsultationDoc=$list(^User.DHCConsultationD(ConsultID),12)   //会诊医生
					....S ConsultDoctor=$p(^CTPCP(ConsultationDoc,1),"^",2)      ;$p(^SSU("SSUSR",ConsultationDoc),"^",2)
					....S ConsultDate=$list(^User.DHCConsultationD(ConsultID),10)
					....S ConsultTime=$list(^User.DHCConsultationD(ConsultID),13)
					....s ConsultAtitude=$list(^User.DHCConsultationD(ConsultID),25)
					....s Attitude=$S(ConsultAtitude="":"无会诊结果",ConsultAtitude="1":"同意",ConsultAtitude="2":"不同意")
					....;s ConsultDate=$zd(ConsultDate,3)
					....s ConsultDate=##class(websys.Conversions).DateLogicalToHtml(ConsultDate)
					....s ConsultTime=$zt(ConsultTime,2)
					....s ConTime=ConsultDate_" "_ConsultTime
			..s data1=PatNo_"^"_patName_"^"_OrderLoc_"^"_ArcimDesc_"^"_FormInstrDesc_"^"_FormFreqDesc_"^"_FormDurDesc_"^"_OrdDoctor_"^"_OrdTime_"^"_AuditDoctor_"^"_auditTime_"^"_ConsultDep_"^"_ConsultDoctor_"^"_ConTime_"^"_PoisonDesc_"^"_UsePurpose_"^"_Evaluetion_"^"_Audit24_"^"_OrderStatus_"^"_Attitude_"^"_OrderPrior
			..s num=num+1
			..s ^DHCTempAntGlobal("AntiUseInfo",UserID,$j,num)=data1  
			..d output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
	Set Data=$lb(PatNo,patName,OrderLoc,ArcimDesc,FormInstrDesc,FormFreqDesc,FormDurDesc,OrdDoctor,OrdTime,AuditDoctor,auditTime,ConsultDep,ConsultDoctor,ConTime,PoisonDesc,UsePurpose,Evaluetion,Audit24,OrderStatus,Attitude,$j,OrderPrior,adm,Rowid,AARowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryAntiUseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiUseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntiUseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiUseInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetExecuteLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExecuteLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetExecuteLocExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCAntiConsultLocInfo","GetExecuteLoc","b")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s code=$$ALPHAUP^SSUTIL4(code)
 Set CTLOCRowid=""
	Set RetStr=""
	F  s CTLOCRowid=$O(^CTLOC(CTLOCRowid)) q:CTLOCRowid=""  d
	.Set CTLOCType=$P($G(^CTLOC(CTLOCRowid)),"^",13)
	.Q:CTLOCType'="E"
	.Set CTLOCDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)
	.Quit:(code'="")&&($p($$ALPHAUP^SSUTIL4(CTLOCDesc),code)'="")
	.Set CTLOCDescQuickCode=$P(CTLOCDesc,"-",1)
	.Set CTLOCCode=CTLOCDesc     //$P(CTLOCDesc,"-",2)
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(CTLOCCode,CTLOCRowid,CTLOCDescQuickCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetExecuteLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExecuteLocExecute ]
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

Query GetExecuteLoc(code As %String) As %Query(ROWSPEC = "Desc:%String,Rowid:%String,Code:%String")
{
}

Query QryUnAuditApp(LocID As %String) As %Query(ROWSPEC = "ArcIMName:%String,PoisonDesc:%String,AppUser:%String,loc:%String,ATime:%String,Sta:%String,TPatNo:%String,TPatName:%String,TFormInstrDesc:%String,TFormFreqDesc:%String,TFormDurDesc:%String,TUsePurpose:%String,isEmergency:%String,Exce24H:%String,Tid:%String,EpisodeID:%String,UseReasonID:%String,AARowid:%String")
{
}

/// D ##class(%ResultSet).RunQuery("web.DHCAntUseInformation","QryUnAuditApp","")
ClassMethod QryUnAuditAppExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s UserID=1 ;%session.Data("LOGON.USERID")
 	k ^DHCTempAntGlobal("UnAuditApp",UserID)
 	s num=0
 	
 	s date=62991        ;上线时间   +$h-2
 	f  s date=$o(^DHCDAAi("ApplyDate",date))  q:date=""   d
 	.s aarowid=""
 	.f  s aarowid=$o(^DHCDAAi("ApplyDate",date,aarowid))  q:aarowid=""  d
 	..s oeori=$p(^DHCDAA("ANT",aarowid,1),"^",6)
 	..q:(oeori'="")&&('$d(^OEORD(+oeori,"I",$p(oeori,"||",2))))  
 	..s adm=$p(^DHCDAA("ANT",aarowid),"^",1)
 	..s papmi=$p(^PAADM(adm),"^",1)
	..s TPatName=$p(^PAPER(papmi,"ALL"),"^",1) //姓名
	..s TPatNo=$P(^PAPER(papmi,"PAT",1),"^",1) //登记号 
 	..s isEmergency=$p(^DHCDAA("ANT",aarowid,1),"^",23)
	..q:(isEmergency=1)&&(oeori="")                  //测试垃圾数据
	..I isEmergency=1  S isEmergency="是"
	..e  s isEmergency="否"
	..s OrderStatus=""
	..if oeori'=""  s OrderStatus=$p(^OEC("OSTAT",$p(^OEORD(+oeori,"I",$P(oeori,"||",2),1),"^",13)),"^",1)
	..q:(OrderStatus="D")||(OrderStatus="I")||(OrderStatus="U")
	..s AppTime=$p(^DHCDAA("ANT",aarowid),"^",11)
	..s curTime=##class(web.DHCDocAntibioticReason).GetAbsTime($h)
	..s applyTime=##class(web.DHCDocAntibioticReason).GetAbsTime(date_","_AppTime)
	..q:date>+$h   
	..s Exce24H=""
	..I curTime>(applyTime+86400)  S Exce24H="是"
	..e  s Exce24H="否"
	..s htmlDate=##class(websys.Conversions).DateLogicalToHtml(date)
	..s ATime=htmlDate_"  "_$zt(AppTime,2)
	..s status=$p(^DHCDAA("ANT",aarowid),"^",12)
	..q:status'="A"
	..s Sta="未审核"
	..s apploc=$p(^DHCDAA("ANT",aarowid,1),"^",25)
	..q:apploc=""
	..q:(LocID'="")&&(LocID'=apploc)
	..s loc=$p(^CTLOC(apploc),"^",2)
	
	..s PHFreqDR="",DuratDR="",InstrDR=""
	..s TFormFreqDesc="",TFormDurDesc="", TFormInstrDesc="",TUsePurpose=""
	..s ow=+oeori
	..s chl=$p(oeori,"||",2)
	..s:oeori'="" PHFreqDR=$p(^OEORD(ow,"I",chl,2),"^",4)
	..i PHFreqDR'=""  s TFormFreqDesc=$P($g(^PHCFR(PHFreqDR)),"^",3)   //频次
	..s:oeori'="" DuratDR=$p(^OEORD(ow,"I",chl,2),"^",6)
	..i DuratDR'="" s TFormDurDesc=$P($g(^PHCDU(DuratDR)),"^",3)   //疗程
	..s:oeori'="" InstrDR=$p(^OEORD(ow,"I",chl,2),"^",7)
	..i InstrDR'="" s TFormInstrDesc=$P($g(^PHCIN(InstrDR)),"^",2) //用法
	..s DTAUPDr=$p(^DHCDAA("ANT",aarowid,1),"^",20)
	..I DTAUPDr'="" D
	...S daupDr=$p(^DAUP("DAUP",DTAUPDr),"^",20)
	...s TUsePurpose=$p(^DTAUP("AUP",daupDr),"^",2) // 使用目的
	
	..s arcimdr=$p(^DHCDAA("ANT",aarowid),"^",2)
	..i arcimdr'=""  S ArcIMName=$p(^ARCIM(+arcimdr,$P(arcimdr,"||",2),1),"^",2)
	..s appuser=$p(^DHCDAA("ANT",aarowid),"^",9)
	..s AppUser=$p(^SSU("SSUSR",appuser),"^",2)
	..s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcimdr)
	..s ConsultDr=$p(^DHCDAA("ANT",aarowid,1),"^",22)
	..s ConsultStatus=""
	..i ConsultDr'=""  d
	...s A=##class(User.DHCConsultation).%OpenId(ConsultDr)
	...s ConsultStatus=A.Status
	..q:(ConsultStatus="C")||(ConsultStatus="R")    //撤销,退回
	..s PoisonDesc=""
	..i PoisonRowid'="" s PoisonDesc=$P($g(^PHCPO(PoisonRowid)),"^",2)
	
	..s num=num+1
	..s data2=ArcIMName_"^"_PoisonDesc_"^"_AppUser_"^"_loc_"^"_ATime_"^"_Sta_"^"_TPatNo_"^"_TPatName_"^"_TFormInstrDesc_"^"_TFormFreqDesc_"^"_TFormDurDesc_"^"_TUsePurpose_"^"_isEmergency_"^"_Exce24H
	..s ^DHCTempAntGlobal("UnAuditApp",UserID,$j,num)=data2
	
	..d output2
	
	Quit $$$OK
output2
	Set Data=$lb(ArcIMName,PoisonDesc,AppUser,loc,ATime,Sta,TPatNo,TPatName,TFormInstrDesc,TFormFreqDesc,TFormDurDesc,TUsePurpose,isEmergency,Exce24H,$j,adm,DTAUPDr,aarowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryUnAuditAppClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUnAuditAppExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUnAuditAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUnAuditAppExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(web.DHCAntUseInformation).GetAntUseInfo()
ClassMethod GetAntUseInfo(Tid, num)
{
	s string=""
	s UserID=%session.Data("LOGON.USERID")
	s string=$g(^DHCTempAntGlobal("AntiUseInfo",UserID,Tid,num))
	q string
}

/// w ##class(web.DHCAntUseInformation).GetAntUseInfo()
ClassMethod GetAntUseInfoNum(Tid)
{
	s num=""
	s UserID=%session.Data("LOGON.USERID")
	s num=$o(^DHCTempAntGlobal("AntiUseInfo",UserID,Tid,""),-1)
	q num
}

/// w ##class(web.DHCAntUseInformation).GetOrderPriorStr()
ClassMethod GetOrderPriorStr()
{
	n priorarr
	s ret=""
	s rowid=0 f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
	.s Desc=$p(^OECPR(rowid),"^",2)
	.s Priority=$p(^OECPR(rowid),"^",2)
	.s priorarr(Priority)=rowid_$c(2)_Desc
	s priorarr(0)=""_$c(2)_""
	s Priority=""  f  s Priority=$o(priorarr(Priority))  q:Priority=""  d
	.i ret=""  s ret=priorarr(Priority)
	.e   s ret=ret_"^"_priorarr(Priority)
	q ret
}

/// description: 取得药品管制分类 
/// output:      药品管制分类信息
/// w ##class(web.DHCAntUseInformation).GetPHCPoison()
ClassMethod GetPHCPoison() As %String
{
	n
	s ret=""_$C(2)_""
	S RowId=0 
	f  s RowId=$O(^PHCPO(RowId)) Q:(RowId="")  d
	.s PHCPOCode=$P(^PHCPO(RowId),"^",1)
	.q:PHCPOCode'["KSS"
	.s PHCPODesc=$P(^PHCPO(RowId),"^",2)
	.s ret=ret_"^"_RowId_$C(2)_PHCPODesc
	Q ret
}

/// DATE :      2013-7-16
/// DESCRIPTION  : 得到24h未审核信息的num
/// DEBUG        : w ##class(web.DHCAntUseInformation).GetAnt24hNum()
ClassMethod GetAnt24hNum(tid)
{
	s num=""
	s UserID=%session.Data("LOGON.USERID")
	s num=$o(^DHCTempAntGlobal("UnAuditApp",UserID,tid,""),-1)
	q num
}

/// DATE :      2013-7-16
/// DESCRIPTION  : 提供24h未审核导出功能的信息查询
/// DEBUG        : w ##class(web.DHCAntUseInformation).GetAnt24hNum()
ClassMethod GetDetail24h(tid, num)
{
	s string=""
	s UserID=%session.Data("LOGON.USERID")
	s string=$g(^DHCTempAntGlobal("UnAuditApp",UserID,tid,num))
	q string
}

}
