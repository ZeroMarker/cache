Import SQLuser

Class web.DHCOPDOCLog Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod DHCOPDOCLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCOPDOCLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCOPDOCLogExecute(ByRef qHandle As %Binary, DocNo As %String, OpDate As %String) As %Status
{
	
	// w ##class(web.DHCOPDOCLog).DHCOPDOCLogExecute("","","")
		
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if OpDate="" d
	.s admdate=$h //判断日期是否为空,为空则赋值
	else  d
	.s admdate=OpDate  
	
	if $g(DocNo)'=""  d
	.s userid=""
	.s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",DocNo,""))
	.s caredr=$p(^SSU("SSUSR",userid),"^",14)
	.q:($g(caredr)="")
	.s xuhao=0
	
	.s admrowid="" f  s admrowid=$o(^PAADMi("PAADM_AdmDate",admdate,admrowid)) q:admrowid=""  d //根据日期取id
	..
	..s admstatus=$p(^PAADM(admrowid),"^",20)
	..//s ^lgltest(xuhao)=admrowid_"^"_admstatus
	..q:(admstatus'="A")
	..s admre=0,admfir=1
	..s admre=$p(^PAADM(admrowid),"^",56)
	..if (admre="R") d
	... s admre=1
	... s admfir=0	
	..
	..;s ctpcpdr=$p(^PAADM(admrowid),"^",9) 
	..s QueueDr=$o(^User.DHCQueueI("QuePaadmDrIndex",admrowid,""))
	..q:QueueDr=""
	..s QueDocDr=$list(^User.DHCQueueD(QueueDr),5)
	..s ctpcpdr=QueDocDr
    ..q:(ctpcpdr'=caredr)
	..s ctdesc=$p($g(^CTPCP(ctpcpdr,1)),"^",2)
	..s papmidr=$p(^PAADM(admrowid),"^",1) 
	..s papmiCardNo=""
	..s cardrowid="" f  s cardrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmidr,cardrowid)) q:cardrowid=""  d //根据病人信息指针取卡id
	...s cardflag=$p(^DHCCARD("CF",cardrowid),"^",10) //根据卡id取卡有效标志
	...q:(cardflag'="N") //为否则离开
	...
	...s papmiCardNo=$p(^DHCCARD("CF",cardrowid),"^",2) //卡号
	..s papminame=$p(^PAPER(papmidr,"ALL"),"^",1)   //取姓名
	..s papmidob=$p(^PAPER(papmidr,"ALL"),"^",6)    //取出生日期
	..s papmiage=($Horolog-papmidob)\365.25 
	..s papmisexid=$p(^PAPER(papmidr,"ALL"),"^",7) //取性别id
	..s papmigender=$p(^CT("SEX",papmisexid),"^",2) //取性别的描述
	..;s papmiwork=$p(^PAPER(papmidr,"ALL"),"^",18) //取职业 
	..s papmiwork=$p($g(^PAPER(papmidr,"PER","ADD",1)),"^",1) 
	..//if papmiwork="" s papmiwork="未填" 
	..s subrowid=1 
	..s papmidiagnose=""
	..s mrrowid=$p(^PAADM(admrowid),"^",61)
	..f  s subrowid=$o(^MR(mrrowid,"DIA",subrowid)) q:subrowid=""  d 
	...s diagid=$p(^MR(mrrowid,"DIA",subrowid),"^",1) //取诊断id
	...i diagid'="" d  s papmidiagnose=papmidiagnose_"/"_$p(^MRC("ID",diagid),"^",2) //取诊断的描述追加
 ...s paadmmrdesc=$p($g(^MR(mrrowid,"DIA",subrowid,"DES",1)),"^",1)
 ...s papmidiagnose=papmidiagnose_"/"_paadmmrdesc
	..//i papmidiagnose="" d  s papmidiagnose="未填"
 ..s xuhao=xuhao+1
 ..; xp 2008-09-21 Start
 ..s InfectionStr=##class(DHCMed.EPDService.Service).GetEpdDiagFromCasesX(admrowid) //##Class(web.DHCMedEpidemicCtl).CheckPaadm(admrowid)  ;传染病相关信息
 ..//s InfectionStr=##class(DHCMed.CCService.Ctrl.Interface).GetEpdCtrlResult(admrowid,3)  ;传染病相
 ..i InfectionStr'["已报"  s InfectFlag="否"
 ..e  s InfectFlag="是"
 ..s LocalFlagDr=""
 ..s LocalFlagDesc=""
 ..s DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",papmidr,""))
 ..i DHCPersonDr'=""  d 
 ...i $d(^DHCPERSON(DHCPersonDr))  d 
 ....s LocalFlagDr=$p(^DHCPERSON(DHCPersonDr),"^",12)
 ....i LocalFlagDr=2  s LocalFlagDesc="外埠"
 ....e  s LocalFlagDesc="本市"
 ..s PAPERTelH=$p($g(^PAPER(papmidr,"PER",1)),"^",11)
 ..; xp 2008-09-21 End
 ..Do OutputRow1
 ..;w ##class(web.DHCOPDOCLog).DHCOPDOCLogExecute("","2006-06-30")
	..;d ##class(%ResultSet).RunQuery("web.DHCAlloc","Querytest","9210") 
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
 set Data=$lb(paadmrowid,papmiCardNo,papminame,papmiage,papmigender,papmiwork,papmidiagnose,xuhao,admfir,admre,ctdesc,InfectFlag,LocalFlagDesc,PAPERTelH,InfectionStr)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod DHCOPDOCLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCOPDOCLogExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod DHCOPLocLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCOPLocLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCOPLocLogExecute(ByRef qHandle As %Binary, Gsearchmessage As %String, SearchConditions As %String, SPatientAge As %String, EPatientAge As %String, FindByDoc As %String, RLocID As %String, SerCon As %String, DocNo1 As %String, OpDate As %String, OpDate2 As %String, SearhLoc As %String, MRDiagnos As %String = "", MRDIAICDCodeID As %String = "", Time As %String, Time2 As %String, PatientID As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCOPDOCLog","DHCOPLocLog","","","35","","","","","ys01","14/08/2018","16/08/2018","","","","","")
	k ^DHCOPDOCLogTEMP
	s DocNo=""
	s depid=%session.Get("LOGON.CTLOCID")
	//兼容组件版本
	if (SerCon=depid){
		s SerCon=%request.Get("SerCon")
	}
	s EastYard=%request.Get("EastYard")
	s WestYard=%request.Get("WestYard")
	i ((SearhLoc'="on")&&(RLocID="")&&(WestYard="")&&(EastYard="")) s DocNo=DocNo1   
	if (Time[":") s Time=..%ZTH(Time)
	if (Time2[":") s Time2=..%ZTH(Time2)
	Set langid=..%LanguageID()
	//EastYard As %String,WestYard As %String,AllYard As %String
	i ((SearchConditions=1)&&($g(Gsearchmessage)'="")) s Desc=$$ALPHAUP^SSUTIL4(Gsearchmessage)  s len=$l(Desc)
	Set repid=$I(^CacheTemp)
	Set ind=1
	if OpDate2<OpDate s OpDate2=OpDate
	if SPatientAge>EPatientAge,EPatientAge'="" s Age=SPatientAge s SPatientAge=EPatientAge s EPatientAge=Age
	s currctpcpdr=..GetCareProv(DocNo)
	s xuhao=0,sum=0,Zsum=0
	i OpDate'="" s OpDate=..%ZDH(OpDate)
    i OpDate2'="" s OpDate2=..%ZDH(OpDate2)
	f admdate=OpDate:1:OpDate2 d
	.s paadmrowid="" f  s paadmrowid=$o(^PAADMi("PAADM_AdmDate",admdate,paadmrowid)) q:paadmrowid=""  d
	     ..s depcodeid=$p(^PAADM(paadmrowid),"^",4)
	     ..s papmidr=$p(^PAADM(paadmrowid),"^",1)
	     ..q:(PatientID'="")&&(PatientID'=papmidr)
	     ..s CTLOCHospitalDR=$P(^CTLOC(depcodeid),"^",22)
	     ..s HOSPDesc=""
	     ..i (CTLOCHospitalDR'=""){s HOSPDesc=$P(^CT("HOSP",CTLOCHospitalDR),"^",2)}
	     ..//选择了科室则本科打沟也无效  当选择科室为空且本科不为空
	     ..q:((depcodeid'=depid)&&(RLocID="")&&(WestYard="")&&(EastYard=""))
	     ..//查询科室与条件科室不相同退出
	     ..q:((RLocID'="")&&(depcodeid'=RLocID))
	     ..q:((EastYard="on")&&(HOSPDesc="西院")&&(WestYard=""))
	     ..q:((WestYard="on")&&(HOSPDesc="东院")&&(EastYard=""))
	     ..s CTLOCDesc=$P(^CTLOC(depcodeid),"^",2)
	     ..s CTLOCDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTLOCDesc,langid)
	     ..//s CTLOCDesc=$P(CTLOCDesc,"-",2)
	     ..s admstatus=$p(^PAADM(paadmrowid),"^",20)
	     ..q:(admstatus'="A")
	     ..s date=$p(^PAADM(paadmrowid),"^",6)
	     ..s time=$p(^PAADM(paadmrowid),"^",7)
	     ..//发病日期 PAADM_TriageDate
	     ..s PAADMTriageDat=$P(^PAADM(paadmrowid,1),"^",30)
	     ..i (Time'="")&&(date=OpDate)   q:time<Time
	     ..i (Time2'="")&&(date=OpDate2) q:time>Time2
	     ..s time=..%ZT(time)
	     ..s AdmWay=""
	     ..s AdmWayID=$p($g(^PAADM(paadmrowid,2)),"^",47)
         ..I AdmWayID'="" S AdmWay=$P(^PAC("RTR",AdmWayID),"^",1)
	     ..s admfir=1,admre=0,jz="初诊"
	     ..s admre=$p($g(^PAADM(paadmrowid)),"^",56)
	     ..if (admre="R") s jz="门诊复诊",admfir=0,admre=1
	     ..s FirstAdm=$p($g(^PAADM(paadmrowid)),"^",72)
	     ..i FirstAdm="F" s jz="初诊",admfir=1,admre=0
	     ..e  i FirstAdm="R",AdmWay="CYFZ" s jz="出院复诊",admfir=0,admre=1
	     ..s TransAdm=$p($g(^PAADM(paadmrowid,"DHC")),"^",5)
	     ..i TransAdm="Y" s jz="转诊" //,admfir=0,admre=0
	     ..s jz=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",jz)
	     ..s QueueDr=$o(^User.DHCQueueI("QuePaadmDrIndex",paadmrowid,""))
	     ..;为适配应急系统,按应急系统规则判断患者队列状态,无需门诊日志查应急系统就诊记录项目使用以下注释行即可
	     ..s AdmQueStatInfo=##Class(DHCDoc.Interface.StandAlone.Service).GetCESAdmQueStatInfo(paadmrowid,QueueDr)
	     ..q:AdmQueStatInfo=""
	     ..s QueState=$p(AdmQueStatInfo,"^",3)
	     ..;q:QueueDr=""
	     ..s QueDocDr=$list(^User.DHCQueueD(QueueDr),5)
	     ..;s QueStateDr=$list(^User.DHCQueueD(QueueDr),14)
	     ..;s QueState=$list(^User.DHCPerStateD(QueStateDr),4)
	     ..s PAADMAdmDocCodeDR=$p($g(^PAADM(paadmrowid)),"^",9)
	     ..s ctpcpdr=PAADMAdmDocCodeDR
		 ..i QueDocDr'="" s ctpcpdr=QueDocDr
	     ..//if ($d(^SSU("SSUSR",0,"CTPCP",PAADMAdmDocCodeDR)))&&(PAADMAdmDocCodeDR'="") s ctpcpdr=PAADMAdmDocCodeDR
	     ..//e  s ctpcpdr=QueDocDr
	     ..//s ctpcpdr=QueDocDr
	     ..//根据下医嘱找医生，影响速度
	     ..s PAADMType=$p($g(^PAADM(paadmrowid)),"^",2)
	     ..if (PAADMType="E")||(ctpcpdr="") d
         ...q:'$d(^OEORD(0,"Adm",paadmrowid))
         ...s OrdId1=$o(^OEORD(0,"Adm",paadmrowid,0))
         ...s papmidr=$P(^PAADM(paadmrowid),"^",1)
         ...q:OrdId1=""
         ...s OrdId2=0
         ...s doctor=""
         ...f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:(OrdId2="")||(doctor'="")  d
         ....s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
         ....s doctor=$p(ordstr1,"^",11)
         ...i QueState="到达",ctpcpdr="" s ctpcpdr=doctor
         ...if ctpcpdr="" d
         ....s mrrowid=$p(^PAADM(paadmrowid),"^",61)
         ....s subrowid=""
         ....f  s subrowid=$o(^MR(mrrowid,"DIA",subrowid)) q:(subrowid="")||(ctpcpdr'="")  d //循环
         .....s ctpcpdr=$p(^MR(mrrowid,"DIA",subrowid),"^",4)	
	    ..Q:(currctpcpdr'="")&&(ctpcpdr'=currctpcpdr)
	    ..s ctdesc=""  s CTPCPId=""
	    ..Q:(FindByDoc'="")&&(ctpcpdr'=FindByDoc)
	    ..if ctpcpdr'=""  d
	    ...s ctdesc=$p(^CTPCP(ctpcpdr,1),"^",2) //医生姓名
	    ...Set ctdesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ctdesc,langid)
	    ...s CTPCPId=$p(^CTPCP(ctpcpdr,1),"^",1)	//医生工号
	    ..s papmiCardNo=$p(^PAPER(papmidr,"PAT",1),"^",2)
	     
	    ..if (SearchConditions=2)&&(Gsearchmessage'=papmiCardNo)&&(Gsearchmessage'="") q   //添加对病人ID的判断。
	    ..s MedType=##class(web.DHCDocOrderEntry).GetPAAdmType(paadmrowid)
		..s ErrMsg=""
		..s Mdeicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadmrowid,MedType,.ErrMsg)
	    ..if (SearchConditions=3)&&(Gsearchmessage'=Mdeicare&&(Gsearchmessage'="")) q //添加病案号查询并对病案号进行判断
	    ..s papminame=$p(^PAPER(papmidr,"ALL"),"^",1)   //取姓名
	    ..s CTOCCDesc=""
	     ..s PAPEROccupationDR=$p($G(^PAPER(papmidr,"PER",2)),"^",6)  //职业PAPER_Occupation_D  "PER",2________  6_______  "^"_______PAADM_Occupation_D  1__  36______  "^"_______ 
	     ..i (PAPEROccupationDR'=""){ s CTOCCDesc=$P(^CT("OCC",PAPEROccupationDR),"^",2) }  //CT_Occupation CT_Occupation
	 	..Set CTOCCDesc= ##class(User.CTOccupation).GetTranByDesc("CTOCCDesc",CTOCCDesc,langid)
	    ..if (SearchConditions=1)&&(Gsearchmessage'="")  s desc1=$$ALPHAUP^SSUTIL4(papminame) s desc1=$e(desc1,1,len) q:desc1'=Desc   //加入对姓名条件的判断。 s desc1=$$ALPHAUP^SSUTIL4(papminame) s desc1=$e(desc1,1,len)  q:desc1'=Gsearchmessage
	    ..s papmidob=$p(^PAPER(papmidr,"ALL"),"^",6)    //取出生日期
	    ..s papmiage=($Horolog-papmidob)\365.25 
	    ..//添加对年龄条件的判断(EPatientAge'="")&&(SPatientAge<=EPatientAge)&&
	    ..if SPatientAge'="" q:papmiage<SPatientAge
	    ..if EPatientAge'="" q:papmiage>EPatientAge
		..s papmiage=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",papmidr,paadmrowid,CTLOCHospitalDR)
	    ..s papmisexid=$p(^PAPER(papmidr,"ALL"),"^",7) //取性别id
	    ..s papmigender=$p(^CT("SEX",papmisexid),"^",2) //取性别的描述
	    ..s papmigender=##class(User.CTSex).GetTranByDesc("CTSEXDesc",papmigender,langid) 
        ..s PapmiSocialStatus=$p($g(^PAPER(papmidr,"PER",1)),"^",10) //取医保类型 取值为2 为医保 取值为3 为公疗
	    ..s zfyb=0,zfgl=0,zfqt=1
	    ..i PapmiSocialStatus="2" s zfyb=1,zfgl=0,zfqt=0
	    ..i PapmiSocialStatus="3" s zfyb=0,zfgl=1,zfqt=0
	    ..q:PapmiSocialStatus=""
	    ..s SocialStatus=$p(^CT("SS",PapmiSocialStatus),"^",2) 		//社会属性
	    ..s papmiwork=$p($g(^PAPER(papmidr,"PER","ADD",1)),"^",1)   //地址
	    ..s subrowid=0 
	    ..s papmidiagnose=##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(paadmrowid)
	    ..s MRDIAICDCodeDR=""
	    ..s mrrowid=$p(^PAADM(paadmrowid),"^",61)
	    ..f  s subrowid=$o(^MR(mrrowid,"DIA",subrowid)) q:subrowid=""  d //循环	
       	...s MRDIAICDCodeDRSub=$P(^MR(mrrowid,"DIA",subrowid),"^",1) //ICD MR_Diagnos-> MRC_ICDDx
       	...i MRDIAICDCodeDRSub'="" d
       	....if MRDIAICDCodeDR="" s MRDIAICDCodeDR=$P(^MRC("ID",MRDIAICDCodeDRSub),"^",4)
       	....else  s MRDIAICDCodeDR=MRDIAICDCodeDR_";"_$P(^MRC("ID",MRDIAICDCodeDRSub),"^",4)
       	...if PAADMTriageDat="" d
       	....s PAADMTriageDat=$P(^MR(mrrowid,"DIA",subrowid),"^",35) 
       	....s PAADMTriageDat=..%ZD(PAADMTriageDat)
       ..q:(MRDiagnos'="")&&(papmidiagnose'[MRDiagnos)
	   ..s papmidiagnose=##class(ext.util.String).EvalJSON(papmidiagnose)
       ..s admdate2=..%ZD(admdate) //$zd(admdate,3)
       ..s IliFlag=$p($g(^PAADM(paadmrowid,"DHC")),"^",13)
       ..i IliFlag="Y"  s IliFlag="on"
       ..e  s IliFlag=""
       ..s InfectionStr=##class(DHCMed.EPDService.Service).GetEpdDiagFromCasesX(paadmrowid) //##Class(web.DHCMedEpidemicCtl).CheckPaadm(paadmrowid)  			;传染病相关信息
       ..s EpdFlag=##class(DHCMed.EPDService.Service).GetEpdRepDiagnosNew(paadmrowid)
       ..i +EpdFlag=0  s InfectFlag="否"
       ..e  s InfectFlag="是",sum=sum+1       //sum表示上报的总数
       ..//*************************************
       ..s LocalFlagDr=""
       ..s LocalFlagDesc=""
       ..s DHCPersonDr=$o(^DHCPERSON(0,"PAPERSON",papmidr,""))
       ..i DHCPersonDr'=""  d 
       ...i $d(^DHCPERSON(DHCPersonDr))  d 
       ....s LocalFlagDr=$p(^DHCPERSON(DHCPersonDr),"^",12)
       ....i LocalFlagDr=2  s LocalFlagDesc="外埠"
       ....e  s LocalFlagDesc="本市"
       ..s PAPERTelH=$p($g(^PAPER(papmidr,"PER",1)),"^",11)
       ..s DVANumber=$p($g(^PAPER(papmidr,"PAT",3)),"^",6)
       ..s Zsum=Zsum+1
       ..//加入状态条件控制  SerCon 与 FindInfoExecute 同步取值
       ..q:((SerCon=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",$g(^STUDENT(1))))&&(admfir'=1))
       ..q:((SerCon=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",$g(^STUDENT(2))))&&(admre'=1))
       ..q:(SerCon=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",$g(^STUDENT(3))))&&(InfectFlag'="是")
       ..q:((SerCon=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",$g(^STUDENT(4))))&&(IliFlag'="on")) 
       ..s TPAPMICardTypeDR=$p($g(^PAPER(papmidr,"PAT",3)),"^",7)
	   ..s TPAPMICardType=$s(+$p($g(^PAPER(papmidr,"PAT",3)),"^",7)'=0:$p($g(^PAC("CARD",$p($g(^PAPER(papmidr,"PAT",3)),"^",7))),"^",2),1:"")
	   ..Set TPAPMICardType= ##class(User.DHCCredType).GetTranByDesc("CRTDesc",TPAPMICardType,langid)
	   ..s AdmReason=##class(DHCDoc.OPDoc.AjaxInterface).GetAdmReason($g(paadmrowid))
       ..Do OutputRow
    s ^DHCOPDOCLogTEMP("InfectSum")=sum_"^"_Zsum
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
  
OutputRow
 s xuhao=xuhao+1
 s admfir=$case(admfir,1:"是",:"否")
 s admre=$case(admre,1:"是",:"否")
 s InfectFlag=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",InfectFlag)
 s admfir=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",admfir)
 s admre=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",admre)
 set Data=$lb(paadmrowid,papmiCardNo,Mdeicare,papminame,papmiage,papmigender,papmiwork,papmidiagnose,xuhao,ctdesc,admfir,admre,admdate2,zfyb,zfgl,zfqt,SocialStatus,jz,InfectFlag,LocalFlagDesc,PAPERTelH,InfectionStr,IliFlag,time,CTLOCDesc,CTOCCDesc,PAADMTriageDat,MRDIAICDCodeDR,CTPCPId,papmidr,DVANumber,TPAPMICardType,AdmReason)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod DHCOPLocLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCOPLocLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

// w ##class(web.DHCOPDOCLog).GetInfectStr()

ClassMethod GetInfectStr() As %String
{
	s Str=$g(^DHCOPDOCLogTEMP("InfectSum"))
	Q Str
}

ClassMethod GetCareProv(UserInitials As %String) As %String
{
	Q:$g(UserInitials)="" ""
	s UserInitials=$ZCVT(UserInitials,"U")
	s UserRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserInitials,""))
	s ^zhou("doclog")=UserInitials_"^"_UserRowid
	s CareProvRowid=$p($G(^SSU("SSUSR",UserRowid)),"^",14)
	Q $g(CareProvRowid)
}

Method GetPAPMIRowId(OpDate As %String)
{
	i OpDate="" d
	.s OpDate=$zdh($Horolog,4)
	e  d
	.s OpDate=$zdh(OpDate,4)
	&SQL(select PAADM_RowId into :PAPMRId
	from PA_ADM
	where paadm_admdate=:OpDate)
}

ClassMethod GetInfectSum()
{
	Q $g(^DHCOPDOCLogTEMP("InfectSum"))
}

Query DHCOPDOCLog(DocNo As %String, OpDate As %String) As %Query(ROWSPEC = "paadmrowid:%String,papmiCardNo:%String,papminame:%String,papmiage:%String,papmigender:%String,papmiwork:%String,papmidiagnose:%String,xuhao:%String,admfir:%String,admre:%String,ctdesc:%String,InfectFlag:%String,LocalFlagDesc:%String,PAPERTelH:%String,InfectionStr:%String")
{
}

Query DHCOPLocLog(Gsearchmessage As %String, SearchConditions As %String, SPatientAge As %String, EPatientAge As %String, FindByDoc As %String, RLocID As %String, SerCon As %String, DocNo1 As %String, OpDate As %String, OpDate2 As %String, SearhLoc As %String, MRDiagnos As %String = "", MRDIAICDCodeID As %String = "", Time As %String, Time2 As %String, PatientID As %String = "") As %Query(ROWSPEC = "paadmrowid:%String,papmiCardNo:%String,Mdeicare:%String,papminame:%String,papmiage:%String,papmigender:%String,papmiwork:%String,papmidiagnose:%String,xuhao:%String,ctdesc:%String,admfir:%String,admre:%String,admdate:%String,zfyb:%String,zfgl:%String,zfqt:%String,SocialStatus:%String,jz:%String,InfectFlag:%String,LocalFlagDesc:%String,PAPERTelH:%String,InfectionStr:%String,IliFlag:%String,time:%String,CTLOCDesc:%String,CTOCCDesc:%String,PAADMTriageDat:%String,MRDIAICDCodeDR:%String,CTPCPId:%String,PatientID:%String,papmicredno:%String,TPAPMICardType:%String,AdmReason:%String")
{
}

// w ##class(web.DHCOPDOCLog).GetUserTP(600)

ClassMethod GetUserTP(UserID As %String) As %String
{
	s CTCptDesc="",CarPrvTp=""
	s CTPcpDr=$p(^SSU("SSUSR",UserID),"^",14)
	if CTPcpDr'="" s CarPrvTp=$p($g(^CTPCP(CTPcpDr,1)),"^",4)
	if CarPrvTp'="" s CTCptDesc=$p(^CT("CPT",CarPrvTp),"^",2)
	
	Q CTCptDesc
}

Query DHCLogReport(StDate As %String, EdDate As %String, HospId As %String = "") As %Query(ROWSPEC = "LocName:%String,InfectAllNum:%String,PatAllNum:%String")
{
}

ClassMethod DHCLogReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCLogReportExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DHCLogReportExecute(ByRef qHandle As %Binary, StDate As %String, EdDate As %String, HospId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCOPDOCLog","DHCLogReport","24/02/2020","07/04/2020")
	Set repid=$I(^CacheTemp)
	Set ind=1
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	k ^DHCLogReportTEMP
	if $l(StDate,"-")=3 s StDate=$zdh(StDate,3)
    if $l(EdDate,"-")=3 s EdDate=$zdh(EdDate,3)
    if $l(StDate,"/")=3 s StDate=$zdh(StDate,4)
    if $l(EdDate,"/")=3 s EdDate=$zdh(EdDate,4)
	s Allsum=0,AllZsum=0
	s OpDate2=EdDate,OpDate=StDate
    if (OpDate2="")||(OpDate="") s OpDate=..%SysDate(),OpDate2=..%SysDate()
	;if OpDate2<OpDate s OpDate2=OpDate
	f admdate=OpDate:1:OpDate2 d
	.s paadmrowid="" f  s paadmrowid=$o(^PAADMi("PAADM_AdmDate",admdate,paadmrowid)) q:paadmrowid=""  d
	..s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(paadmrowid)
	..Q:AdmHospitalId'=HospId
	..s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(paadmrowid)
	..Q:AdmType="I"
	..Q:AdmType="H"
	..s depcodeid=$p(^PAADM(paadmrowid),"^",4)
	..s admstatus=$p(^PAADM(paadmrowid),"^",20)
	..q:(admstatus'="A")
	..s papmidr=$p(^PAADM(paadmrowid),"^",1) 
 	..s sum=0
 	..s EpdFlag=##class(DHCMed.EPDService.Service).GetEpdRepDiagnosNew(paadmrowid)
	..if EpdFlag=1 s InfectFlag="是",sum=1,Allsum=Allsum+1
 	..else   s InfectFlag="否"
 	..s Zsum=1
 	..s AllZsum=AllZsum+1      //AllZsum代表一天全院病人的人数
 	..if '$d(^DHCLogReportTEMP("LogReport",depcodeid)) d
 	...s ^DHCLogReportTEMP("LogReport",depcodeid)=sum_"^"_Zsum
 	..else  d
 	...s sumTemp=$p($g(^DHCLogReportTEMP("LogReport",depcodeid)),"^",1)+sum
 	...s ZsumTemp=$p($g(^DHCLogReportTEMP("LogReport",depcodeid)),"^",2)+Zsum
 	...s ^DHCLogReportTEMP("LogReport",depcodeid)=sumTemp_"^"_ZsumTemp
 	Set langid=..%LanguageID()
	 s LocID=""
	 f  s LocID=$O(^DHCLogReportTEMP("LogReport",LocID)) q:LocID=""  d
	 .s LocName=$p(^CTLOC(LocID),"^",2) //$p($p(^CTLOC(LocID),"^",2),"-",2)
	 .s LocName=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocName,langid)
	 .s sum=$p($g(^DHCLogReportTEMP("LogReport",LocID)),"^",1)
	 .s Zsum=$p($g(^DHCLogReportTEMP("LogReport",LocID)),"^",2)
	 .Do OutputRow
	 s LocName=##class(websys.Translation).Get("opdoc.recadmlogamount.hui.csp","全院合计")
	 s sum=Allsum
	 s Zsum=AllZsum
	 d OutputRow
	 Set qHandle=$lb(0,repid,0)
	//c f
	Quit $$$OK

OutputRow
	set Data=$lb(LocName,sum,Zsum)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod DHCLogReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCLogReportExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

Query condition() As %Query(ROWSPEC = "name:%String,ID:%String,PID:%String")
{
}

ClassMethod conditionExecute(ByRef qHandle As %Binary) As %Status
{
	Quit $$$OK
}

ClassMethod conditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = conditionExecute ]
{
	Quit $$$OK
}

ClassMethod conditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = conditionExecute ]
{
	Quit $$$OK
}

// 加入状态条件取值的放大镜

Query FindInfo() As %Query(ROWSPEC = "NO:%String,state:%String")
{
}

ClassMethod FindInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s NO1="0"
 	s ^STUDENT(1)="初诊"
  	s ^STUDENT(2)="复诊"
  	s ^STUDENT(3)="传报"
  	s ^STUDENT(4)="流感样"
  	for  s NO1=$O(^STUDENT(NO1))  q:NO1=""  d
	.s state=$G(^STUDENT(NO1))
	.s state=##class(websys.Translation).Get("opdoc.recadmlog.hui.csp",state)
	.s NO=NO1
 	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NO,state)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod FindInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
