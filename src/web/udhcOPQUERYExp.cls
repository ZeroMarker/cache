Class web.udhcOPQUERYExp Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query INVQUERY(sFlag As %String, ChargeUserID As %String, ReceipNO As %String, PatientNO As %String, PatientName As %String, StartDate As %String, EndDate As %String, INVFlag As %String, AuditFlag As %String, INVStatus As %String, gLocDR As %String, ULoadLocDR As %String, ChargeUser As %String, INVFootFlag As %String, Fairtype As %String, Audit As %String) As websys.Query(ROWSPEC = "Tind:%String,TINVRowid:%String,TINVNO:%String,TPatID:%String,TPatName:%String,TAcount:%String,TAbort:%String,TRefund:%String,THandin:%String,TUser:%String,TDate:%String,TTime:%String,TParkDate:%String,TParkTime:%String,TParUName:%String,TotSum:%String,TPayMode:%String,TabFlag:%String,TYBSum:%String, AdmDeptDesc:%String, AdmDocName:%String,TEncryptLevel,TPatLevel")
{
}

/// sFlag=INV		;票据查询
/// sFlag=ALL		;所有纪录(DHC_INVPRT+DHC_AccPayINV)查询
/// sFlag=PRT		;只查询DHC_INVPRT表所有纪录，而不查询DHC_AccPayINV表
/// sFlag=API		;只查询DHC_AccPayINV表中的纪录
/// d ##class(%ResultSet).RunQuery("web.udhcOPQUERYExp","INVQUERY","ALL","","000277","","",64371,64371,"","ALL","N",6,231,"","","F","")
ClassMethod INVQUERYExecute(ByRef qHandle As %Binary, sFlag As %String, ChargeUserID As %String, ReceipNO As %String, PatientNO As %String, PatientName As %String, StartDate As %String, EndDate As %String, INVFlag As %String, AuditFlag As %String, INVStatus As %String, gLocDR As %String, ULoadLocDR As %String, ChargeUser As %String, INVFootFlag As %String, Fairtype As %String, Audit As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	kill ^TMPOPRefData($j)
	if ((sFlag="")||(StartDate="")||(EndDate=""))  quit $$$OK
	
	set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)

	set ExpStr=gLocDR_"^"_ULoadLocDR
	
	set UserDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(ULoadLocDR)
		
	if ($g(Fairtype)="") set Fairtype="ALL"
	if (PatientNO'="") set PatientNO=##class(web.UDHCJFBaseCommon).regnocon(PatientNO)

	if (ReceipNO'="") do
	.quit:(sFlag="API")
	.set PrtRowid=0
	.for  set PrtRowid=$o(^DHCINVPRT(0,"INV",ReceipNO,PrtRowid)) quit:(PrtRowid="")  do
	..set RequestFlag=..CheckRefundPrtInv(PrtRowid, "PRT", ExpStr)
	..quit:((RequestFlag'=1)&&(Audit="on"))
	..do GetPrtInfo(PrtRowid)
	.set PrtRowid=0
	.for  set PrtRowid=$o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,PrtRowid)) quit:(PrtRowid="")  do
	..set RequestFlag=..CheckRefundPrtInv(PrtRowid, "API", ExpStr)
	..quit:((RequestFlag'=1)&&(Audit="on"))
	..do GetApiInfo(PrtRowid)
	
	if (ReceipNO'="")  quit $$$OK
	
	//+2016-11-21 ZhYW 根据病人主索引查找
	if (PatientNO'="") do
	.set Papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNO),""))
	.quit:(sFlag="API")
	.set PrtRowid=""
	.for  set PrtRowid=$o(^DHCINVPRT(0,"PAPMI",Papmi,PrtRowid),-1) quit:(PrtRowid="")  do
	..set prtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	..set prtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	..quit:((prtDate<StartDate)||(prtDate>EndDate))
	..set RequestFlag=..CheckRefundPrtInv(PrtRowid, "PRT", ExpStr)
	..quit:((RequestFlag'=1)&&(Audit="on"))
	..do GetPrtInfo(PrtRowid)
	else  do
	.for PRTDate=(EndDate):-1:StartDate  do
	..quit:(sFlag="API")
	..set PrtRowid=""
	..for  set PrtRowid=$o(^DHCINVPRT(0,"Date",PRTDate,PrtRowid),-1) quit:(PrtRowid="")  do
	...set RequestFlag=..CheckRefundPrtInv(PrtRowid, "PRT", ExpStr)
	...quit:((RequestFlag'=1)&&(Audit="on"))
	...do GetPrtInfo(PrtRowid)
	
	if (sFlag="PRT") quit $$$OK
	
	if (PatientNO'="") do
	.set Papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientNO),""))
	.set PrtRowid=""
	.for  set PrtRowid=$o(^DHCINVPRTAPi(0,"PAPMI",Papmi,PrtRowid),-1) quit:(PrtRowid="")  do
	..set prtDate=$p(^DHCINVPRTAP(PrtRowid),"^",3)
	..set prtTime=$p(^DHCINVPRTAP(PrtRowid),"^",4)
	..quit:((prtDate<StartDate)||(prtDate>EndDate))
	..set RequestFlag=..CheckRefundPrtInv(PrtRowid, "API", ExpStr)
	..quit:((RequestFlag'=1)&&(Audit="on"))
	..do GetApiInfo(PrtRowid)
	else  do
	.for PRTDate=EndDate:-1:StartDate  do
	..set PrtRowid=""
	..for  set PrtRowid=$o(^DHCINVPRTAPi(0,"Date",PRTDate,PrtRowid),-1) quit:(PrtRowid="")  do
	...set RequestFlag=..CheckRefundPrtInv(PrtRowid, "API", ExpStr)
	...quit:((RequestFlag'=1)&&(Audit="on"))
	...do GetApiInfo(PrtRowid)
	
	kill ^TMPOPRefData($j)
	
	quit $$$OK
	
GetPrtInfo(PrtRowid)
	set InvHospDr=$p(^DHCINVPRT(PrtRowid),"^",39)
	quit:((UserDepHosDr'=InvHospDr)&&(InvHospDr'="")&&(UserDepHosDr'=""))
	set InvDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	set InvTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	set Abortflag=0, refundflag=0, handflag=0
	set PrtUsrDR=$p(^DHCINVPRT(PrtRowid),"^",21)
	quit:((ChargeUserID'="")&&(PrtUsrDR'=ChargeUserID))
	
	set SsusrName=""
	if (PrtUsrDR'="") set SsusrName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2)
	set PrtNO=$p(^DHCINVPRT(PrtRowid),"^",14)
	quit:((PrtNO'=ReceipNO)&&(ReceipNO'="")&&(PrtNO'=""))

	set InvFair=$p($g(^DHCINVPRT(PrtRowid)),"^",34)
	quit:((Fairtype'="ALL")&&(Fairtype'=InvFair))

	set PapmiNo="", PapmiName=""
	set EncryptLevel="", PatLevel=""
	set PrtPapmiDR=$p($g(^DHCINVPRT(PrtRowid)),"^",15)
	if (PrtPapmiDR'="")  do
	.set PapmiNo=$p($g(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	.set PapmiName=$p($g(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	.;add by wangjian 2015-01-15 增加病人密级和级别
    .set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PrtPapmiDR,"")
    .set EncryptLevel=$p(PatEncryptLevel,"^",1)
    .set PatLevel=$p(PatEncryptLevel,"^",2)
    .;end
	quit:((PapmiNo'=PatientNO)&&(PatientNO'=""))
	quit:((PapmiName'=PatientName)&(PatientName'=""))

	set Acount=$fn(+$p($g(^DHCINVPRT(PrtRowid)),"^",16),"",2)
	set TotSum=$fn(+$p($g(^DHCINVPRT(PrtRowid)),"^",1),"",2)
	set Flag=$p($g(^DHCINVPRT(PrtRowid)),"^",8)
	set Handin=$p($g(^DHCINVPRT(PrtRowid)),"^",10)
	set sTime=$p($g(^DHCINVPRT(PrtRowid)),"^",20)
	set myInvDR=$p($g(^DHCINVPRT(PrtRowid)),"^",13)
	quit:((PrtNO="")&&(myInvDR="")&&(sFlag="INV"))			;被作废的小票退出
	
	set myInvNo=$p($g(^DHCINVPRT(PrtRowid)),"^",14)
	set myPayMode=""
	set myPMSub=$o(^DHCINVPRT(PrtRowid,"P",0))
	set myPMDR=""
	if (myPMSub'="") set myPMDR=$p($g(^DHCINVPRT(PrtRowid,"P",myPMSub)),"^",1)
	if (myPMDR'="") set myPayMode=$p(^CT("CTPM",myPMDR),"^",2)
	;quit:((myInvDR'="")&&(myInvNo=""))
	quit:((INVFlag'="")&&(INVFlag'=Flag))
	if (Flag="A")  set Abortflag=1
	if (Flag="S")  set refundflag=1
	quit:((INVStatus'="")&&(INVStatus'=Flag))
	if (Handin="Y")  set handflag=1
	set myHandin=Handin
	if (myHandin="") set myHandin="N"
	quit:((INVFootFlag'="")&&(INVFootFlag'=myHandin))
	set PRTParkDate=""
	set sParkTime=""
	set ParkUserName=""
	if (Flag'="N") do
	.set ParkINVDR=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,0))
	.quit:(ParkINVDR="")
	.set PRTParkDate=$p($g(^DHCINVPRT(ParkINVDR)),"^",5)
	.set sParkTime=$p($g(^DHCINVPRT(ParkINVDR)),"^",20)
	.set ParkUserDR=$p($g(^DHCINVPRT(ParkINVDR)),"^",21)
	.set:(ParkUserDR'="") ParkUserName=$p($g(^SSU("SSUSR",ParkUserDR)),"^",2)
	
	set PRTParkDate=##class(websys.Conversions).DateLogicalToHtml(PRTParkDate)
	set sParkTime=##class(websys.Conversions).TimeLogicalToHtml(sParkTime, 1)
	
	set TabFlag="PRT"
	set myYBPaySum=+$p($g(^DHCINVPRT(PrtRowid)),"^",31)
	set myYBPaySum=$fn(myYBPaySum,"",2)
	set myAllRefundUser=$p($g(^DHCINVPRT(PrtRowid)),"^",25)
	set myAuditFlag="C"
	;接口配置参数
	set myExpStr=gLocDR_"^"_ULoadLocDR
	set myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(PrtRowid, myExpStr)
	set myAF=$p(myrtn,"^",1)
	set myOEMixFlag=$p(myrtn,"^",2)
	set myINVAuditLimit=$p(myrtn,"^",3)
	quit:(myINVAuditLimit="Y")			  ;对于安全组受限发票配置
	if (myAF="Y")  set myAuditFlag="A"
	;增加处方科室和处方医生  专门针对大同来做
	set myBillConINVDR=$o(^DHCBCI(0,"INV",PrtRowid,0))
	set myAdmDR=$p(^DHCBCI(myBillConINVDR),"^",3)
	set AdmDept=$p($g(^PAADM(myAdmDR)),"^",4)
	set AdmDeptDesc=""
	if (AdmDept'="") set AdmDeptDesc=$p($g(^CTLOC(AdmDept)),"^",2)
	;查找OE_OrdItem表的Doctor
	set AdmDocName=##class(web.UDHCOEORDOPIF).ReadDOCByPRTRowID(PrtRowid, "")
	if (AdmDeptDesc["-") set AdmDeptDesc=$p(AdmDeptDesc,"-",2)
	set allowRefund=$p($g(^DHCINVPRT(PrtRowid)),"^",22)
	;quit:((AuditFlag'="")&&(AuditFlag'="ALL")&&(allowRefund'="Y"))
	quit:((AuditFlag'="")&&(AuditFlag'=myAuditFlag)&&(AuditFlag'="ALL"))
	set AllRefundDate=$p(^DHCINVPRT(PrtRowid),"^",23)
	set AllRefundDate=##class(websys.Conversions).DateLogicalToHtml(AllRefundDate)
	set AllRefundTime=$p(^DHCINVPRT(PrtRowid),"^",24)
	set AllRefundTime=##class(websys.Conversions).TimeLogicalToHtml(AllRefundTime, 1)
	set TConfirmDate=""
	if (AllRefundDate'="") set TConfirmDate=AllRefundDate_" "_AllRefundTime

	set AllRefundUserDr=$p(^DHCINVPRT(PrtRowid),"^",25)
	set AllRefundUser=""
	if (AllRefundUserDr'="") set AllRefundUser=$p(^SSU("SSUSR",AllRefundUserDr),"^",2)
	set TConfrimUser=AllRefundUser
	do BulidAPIData(sFlag, PrtRowid)
	set myINVNo=$p(^DHCINVPRT(PrtRowid),"^",14)
	set myINVPRTFlag=$p(^DHCINVPRT(PrtRowid),"^",3)
	;被集中打印的发票,不能在此办理退费
	quit:((myINVPRTFlag="P")&&(myINVNo=""))
	set InvDate=##class(websys.Conversions).DateLogicalToHtml(InvDate)
	set sTime=##class(websys.Conversions).TimeLogicalToHtml(sTime, 1)
	
	do OutputRowINVQUERY
	quit
	
GetApiInfo(PrtRowid)
	set AccpHospDr=$p($g(^DHCINVPRTAP(PrtRowid)),"^",30)
	quit:((UserDepHosDr'=AccpHospDr)&&(AccpHospDr'="")&&(UserDepHosDr'=""))
	set InvDate=$p($g(^DHCINVPRTAP(PrtRowid)),"^",3)
	set Abortflag=0, refundflag=0, handflag=0
	set PrtUsrDR=$p($g(^DHCINVPRTAP(PrtRowid)),"^",5)
	quit:((ChargeUserID'="")&&(PrtUsrDR'=ChargeUserID))
	
	set SsusrName=""
	if (PrtUsrDR'="")  set SsusrName=$p($g(^SSU("SSUSR",PrtUsrDR)),"^",2)
	set PrtNO=$p($g(^DHCINVPRTAP(PrtRowid)),"^",6)
	quit:((PrtNO'=ReceipNO)&&(ReceipNO'=""))
	set EncryptLevel="",PatLevel=""
	set PapmiNo="",PapmiName=""
	set PrtPapmiDR=$p($g(^DHCINVPRTAP(PrtRowid)),"^",11)
	if (PrtPapmiDR'="")  do
	.set PapmiNo=$p($g(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
	.set PapmiName=$p($g(^PAPER(PrtPapmiDR,"ALL")),"^",1)
	.;add by wangjian 2015-01-15 增加病人密级和级别
    .set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PrtPapmiDR, "")
    .set EncryptLevel=$p(PatEncryptLevel,"^",1)
    .set PatLevel=$p(PatEncryptLevel,"^",2)
    .;end
	quit:((PapmiNo'=PatientNO)&&(PatientNO'=""))
	quit:((PapmiName'=PatientName)&&(PatientName'=""))
	set Acount=$fn(+$p(^DHCINVPRTAP(PrtRowid),"^",13),"",2)
	set TotSum=$fn(+$p(^DHCINVPRTAP(PrtRowid),"^",1),"",2)
	set Flag=$p(^DHCINVPRTAP(PrtRowid),"^",2)
	;set Handin=$p(^DHCINVPRTAP(PrtRowid),"^",10)
	set myCheckDate=$p(^DHCINVPRTAP(PrtRowid),"^",7)
	set sTime=$p(^DHCINVPRTAP(PrtRowid),"^",4)
	set myInvDR=$p(^DHCINVPRTAP(PrtRowid),"^",10)
	quit:((PrtNO="")&&(myInvDR=""))			    ;被作废的小票退出
	set myInvNo=$p($g(^DHCINVPRTAP(PrtRowid)),"^",6)
	set myPayMode=""
	set myPMSub=$o(^DHCINVPRTAP(PrtRowid,"P",0))
	set myPMDR=""
	set:(myPMSub'="") myPMDR=$p($g(^DHCINVPRTAP(PrtRowid,"P",myPMSub)),"^",1)
	if (myPMDR'="") set myPayMode=$p(^CT("CTPM",myPMDR),"^",2)
	quit:((myInvDR'="")&&(myInvNo=""))
	if (Flag="A")  set Abortflag=1
	if (Flag="S")  set refundflag=1
	quit:((INVStatus'="")&&(INVStatus'=Flag))
	if (myCheckDate'="") set handflag=1
	set myHandin="N"
	if (myCheckDate'="") set myHandin="Y"
	quit:((INVFootFlag'="")&&(INVFootFlag'=myHandin))
	set PRTParkDate=""
	set sParkTime=""
	set ParkUserName=""
	if (Flag'="N") do
	.set ParkINVDR=$o(^DHCINVPRTAPi(0,"APIDR",PrtRowid,0))
	.quit:(ParkINVDR="")
	.set PRTParkDate=$p($g(^DHCINVPRTAP(ParkINVDR)),"^",3)
	.set sParkTime=$p($g(^DHCINVPRTAP(ParkINVDR)),"^",4)
	.set ParkUserDR=$p($g(^DHCINVPRTAP(ParkINVDR)),"^",5)
	.if (ParkUserDR'="") set ParkUserName=$p($g(^SSU("SSUSR",ParkUserDR)),"^",2)
	set PRTParkDate=##class(websys.Conversions).DateLogicalToHtml(PRTParkDate)
	set sParkTime=##class(websys.Conversions).TimeLogicalToHtml(sParkTime, 1)
	set TabFlag="API"
	set myYBPaySum=$p($g(^DHCINVPRTAP(PrtRowid)),"^",17)	;API_SelfYBPay
	set myYBPaySum=$fn(myYBPaySum,"",2)
	set AdmDocName=""
	set AdmDeptDesc=""
	set InvDate=##class(websys.Conversions).DateLogicalToHtml(InvDate)
	set sTime=##class(websys.Conversions).TimeLogicalToHtml(sTime, 1)
	
	do OutputRowINVQUERY
	quit
	
OutputRowINVQUERY
	set Data=$lb(ind,PrtRowid,PrtNO,PapmiNo,PapmiName,Acount,Abortflag,refundflag,handflag,SsusrName,InvDate,sTime,PRTParkDate,sParkTime,ParkUserName,TotSum,myPayMode,TabFlag,myYBPaySum,AdmDeptDesc,AdmDocName,EncryptLevel,PatLevel)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
	
BulidAPIData(myINVFlag, myPRTRowID)
	;建立集中打印的发票RowID临时Global
	new (myINVFlag, myPRTRowID)
	quit:((myINVFlag'="ALL")&&(myINVFlag'="API"))
	
	set ^TMPOPRefData($j)=+$g(^TMPOPRefData($j))+1
	
	set myINVNo=$p(^DHCINVPRT(myPRTRowID),"^",14)
	quit:(myINVNo'="")
	
	set myINVPRTFlag=$p(^DHCINVPRT(myPRTRowID),"^",3)
	quit:(myINVPRTFlag'="P")
	
	set myACPRowID=$o(^DHCINVPRTCAPi(0,"INVPRTDR",myPRTRowID,""),-1)
	quit:(myACPRowID="")
	
	set myAPIRowID=$p(^DHCINVPRTCAP(myACPRowID),"^",2)
	
	set ^TMPOPRefData($j,myAPIRowID)=myAPIRowID
	
	quit
}

Query FindInvUsr(desc As %String) As websys.Query(ROWSPEC = "UsrName:%String,UsrID:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.udhcOPQUERYExp","FindInvUsr", "REG")
ClassMethod FindInvUsrExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

	set job=$j
	kill ^||TMP(job)
	set upDesc=$zcvt(desc,"U")
	
	set usr="0"
	for  set usr=$o(^DHCINVPRT(0,"User",usr))  quit:(usr="")  do
	.set userInfo=$g(^SSU("SSUSR",usr))
	.quit:(userInfo="")
	.set ^||TMP(job,usr)=""
	.set code=$p(userInfo,"^",1)
	.set name=$p(userInfo,"^",2)
	.set upCode=$zcvt(code,"U")
	.set upName=$zcvt(name,"U")
	.quit:((upDesc'="")&&(upCode'[upDesc)&&(upName'[upDesc))
	.do OutputInvUsr
	
	set usr="0"
	for  set usr=$o(^DHCINVPRTAPi(0,"UseDR",usr))  quit:(usr="")  do
	.set userInfo=$g(^SSU("SSUSR",usr))
	.quit:(userInfo="")
	.quit:($d(^||TMP(job,usr)))       //去重
	.set code=$p(userInfo,"^",1)
	.set name=$p(userInfo,"^",2)
	.set upCode=$zcvt(code,"U")
	.set upName=$zcvt(name,"U")
	.quit:((upDesc'="")&&(upCode'[upDesc)&&(upName'[upDesc))
	.do OutputInvUsr
	
	kill ^||TMP(job)

	quit $$$OK
OutputInvUsr
	set Data=$lb(name,usr)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: Lid
/// CreatDate: 2011-09-28
/// Description: 验证该发票是否含有可退费医嘱?
/// Input: ReceipRowid:发票表Rowid,ExpStr:扩展信息(格式:"^^^^^^^")
/// Return: 0:不含可退费医嘱,1:包含可退费医嘱
/// Other: w ##class(web.udhcOPQUERYExp).CheckRefundPrtInv("222227","PRT","238^303")
ClassMethod CheckRefundPrtInv(ReceipRowid As %String = "", TabFlag As %String, ExpStr As %String = "")
{
	new (ReceipRowid, TabFlag, ExpStr)
	set rtn=0
	
	if (TabFlag="PRT") do
	.set rtn=$$AuditSelFlag(ReceipRowid)
	else  do
	.set PCInv=0
    .for  set PCInv=$o(^DHCINVPRTCAPi(0,"APINVDR",ReceipRowid,PCInv))  quit:((PCInv="")||(+rtn=1))  do
    ..set InvPrtDR=$p($g(^DHCINVPRTCAP(PCInv)),"^",1)
    ..set rtn=$$AuditSelFlag(InvPrtDR)
    
	quit rtn
	
AuditSelFlag(ReceipRowid)
	s HospDR=$p(^DHCINVPRT(ReceipRowid),"^",39)
	s conRowid=0
	f  s conRowid=$o(^DHCBCI(0,"INV",ReceipRowid,conRowid)) q:((conRowid="")||(rtn=1))  d
	.s bill=$p($g(^DHCBCI(conRowid)),"^",2)
	.s PBOChildsub=0
	.f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:(PBOChildsub="")  d
	..s PBOData=$g(^DHCPB(bill,"O",PBOChildsub))
	..q:(PBOData="")
	..s Arcim=$p(PBOData,"^",3)                ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2)   ;名称
	..s OEORI=$p(PBOData,"^",4)                ;DHC_PatBillOrder->PBO_OEORI_DR
	..//新版检查申请单
    ..s isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
	..s Executflag=0
  	..//+2017-08-28 ZhYW 判断是否走门诊物资发放流程
	..s matDispGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(OEORI)
	..s Billreturnqty=+$p(PBOData,"^",6)		 //PBO_RefundQty
	..s OrderBillQty=$p(PBOData,"^",5)		     //PBO_BillQty
	..s confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
	..s OrderBillQty=(OrderBillQty+Billreturnqty)/confac
	..q:(OrderBillQty=0)
	..s PatSum=$p(PBOData,"^",11)
	..s PatSum=$fn(PatSum,"",2)
	..s myrtn=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(ReceipRowid, OEORI, "")
	..s myAuditFlag=$p(myrtn,"^",1)         //判断是否审批
	..s myAuditCheckDis=$p(myrtn,"^",2)		//判断选择项目是否Disable
	..s myAuditSelFlag=$p(myrtn,"^",3)		//判断选择项目是否被选中
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..s returnqty=0
	..i (ARCOrdType="R")  d
	...s Executflag=##class(web.UDHCOEORDOPIF).CheckPhDispRet(OEORI)
	...;此处的部分退药 有个小Bug
	...s returnqty=##class(PHA.FACE.OUT.Com).GetRetOrdQty(OEORI, ReceipRowid)
	...s confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
	...s returnqty=returnqty/confac
	...i (Executflag=0) d
	....//药物医嘱?没有发药的
	....s selflag=0
	...e  d
	....//药物医嘱?已经发药的?Executflag=1
	....s selflag=0
	....//已经退药的
	....i (+returnqty'=0) d 
	.....s selflag=1		//全部退
	..//+2017-06-21 ZhYW
    ..e  i (matDispGrant="Y") d
    ...//判断物资是否已发放
    ...s Executflag=##class(BILL.Interface.Inside.Invoke).CheckDispStaByOeori(OEORI)    //0 未发, 1 已发, 2 已退
    ...i (Executflag=0) d
    ....s selflag=0
    ...e  d
    ....s selflag=0
    ....s myExpStr=ReceipRowid
    ....s ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, myExpStr)   //物资实际退费数量
    ....s ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
    ....i (+ApplyRefQty'=0) d
    .....s myAuditSelFlag=1
    .....s selflag=1
    .....s returnqty=ApplyRefQty
   	..//
	..e  d
	...s OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
	...s OrdStatdesc=$p(^OEC("OSTAT",OrdStat),"^",2)
	...i ($p(^OEC("OSTAT",OrdStat),"^",1)="E") d
	....i (isAppRepFlag="Y") d
	.....//判断是否是部分执行
	.....s isPartExecFlag=##class(web.DHCOPBillRefund).IsPartExecut(OEORI)
	.....i (isPartExecFlag=0) d
	......s Executflag=0
	......s selflag=0
	....e  d
	.....//被执行的非药物医嘱?
	.....s Executflag=1
	.....s selflag=0
	...e  d
	....//没有被执行的非药物医嘱?
	....//对于部分执行医嘱的退费
	....s Executflag=0
	....s selflag=0
	...//
	...//申请退费数量不为0时, 按申请退费数量退费
    ...s ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, "")
    ...s ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
    ...i (+ApplyRefQty'=0) d
    ....//mdoify 2014-05-29 退费申请不为0是可退费
    ....s myAuditSelFlag=1
    ....s Executflag=1
    ..//
	..i (+selflag=1)&(+Executflag=1) d
	...s myAuditSelFlag=1
	..q:(+PatSum=0)
	..s:(+myAuditSelFlag=1) rtn=1				;包含可退费医嘱
	..//2016-02-03 chenxi 整张发票如果已经审核了，则也返回审核状态
	..s AllowRefund=$p(^DHCINVPRT(ReceipRowid),"^",22)
	..i (AllowRefund="Y") d
	...s rtn=1
	
	q rtn
}

/// Creator: ZhYW
/// CreatDate: 2017-05-27
/// Description: 初始化组件Table上每行的"退费"单元格
/// w ##class(web.udhcOPQUERYExp).InitOperationCell()
ClassMethod InitOperationCell() As %String
{
	set ind=rs.GetDataByName("Tind")
	set btnPRTRef="btnPRTRef_"_ind
	set btnAccPRef="btnAccPRef_"_ind
	set prtRowId=rs.GetDataByName("TINVRowid")
	quit:(+prtRowId=0) ""
	set tabFlag=rs.GetDataByName("TabFlag")
	set:(tabFlag="") tabFlag = """"""
	set prtInvNo=rs.GetDataByName("TINVNO")
	set prtInvNo=""""_prtInvNo_""""
	set active="", color="blue"
	set title=""
	if (tabFlag="API") {
		set cppPayFlag=..CheckWriteOffAPI(prtRowId)
		if (+cppPayFlag'=0){
			set title="请先【撤销集中打印发票】后再退费."
			set active="disabled"
			set color="gray"
		}
	}
	
	if (tabFlag="PRT"){
		set stayCharge=##class("web.UDHCJFBaseCommon").GetPrtInvStat(prtRowId)
		write "<input type='button' id='"_btnPRTRef_"' name='"_btnPRTRef_"' "_active
		
		if (stayCharge="Y") {
			write " style='width: 100px; height: 24px; color: "_color_"'"
			write " value='撤销留观结算' onclick='BtnCancleStayChargeOnClick(this,"_prtRowId_","_prtInvNo_")'/>"
		}else{
			write " style='width: 40px; height: 24px; color: "_color_"'"
			write " value='退费' onclick='BtnPRTRefOnClick(this,"_prtRowId_","_prtInvNo_")'/>"
		}
		
	}else {
		write "<input type='button' id='"_btnAccPRef_"' name='"_btnAccPRef_"' title='"_title_"' "_active
		write " style='width: 90px; height: 24px; color: "_color_"'"
		write " value='卡支付退费' onclick='BtnAccPRefOnClick(this,"_prtRowId_","_prtInvNo_")'/>"
	}
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2017-05-27
/// Decription: 判断集中打印发票退费是否需要先撤销集中打印发票
///             1. 门诊收费实时医保结算时, 未将医保结算的DHC_INVPRT.PRT_InsDiv_DR更新到DHC_AccPayINV.API_InsDiv_DR时,需要先撤销再退费
///             2. 非卡支付集中打印发票时, 需要先撤销再退费
/// Input: accPInvRowID: DHC_AccPayINV.RowID
/// Return: flag(=0 不需要撤销, <>0需要撤销)
/// Table: DHC_AccPayINV, DHC_AccPayINVMode
/// Debug: w ##class(web.udhcOPQUERYExp).CheckWriteOffAPI(21865)
ClassMethod CheckWriteOffAPI(accPInvRowId As %String) As %String
{
	new (accPInvRowId)
	set flag=0
	quit:((+accPInvRowId=0)||('$d(^DHCINVPRTAP(accPInvRowId)))) 1
	
	set accInsuDivDR=$p($g(^DHCINVPRTAP(accPInvRowId)),"^",19)

	set accPConPrtId=0
	for  set accPConPrtId=$o(^DHCINVPRTCAPi(0,"APINVDR",accPInvRowId,accPConPrtId))  quit:(accPConPrtId="")  do
	.set prtRowId=$p($g(^DHCINVPRTCAP(accPConPrtId)),"^",1)
	.quit:((+prtRowId=0)||('$d(^DHCINVPRT(prtRowId))))
	.set insuDivDR=$p(^DHCINVPRT(prtRowId),"^",30)
	.if ((+insuDivDR'=0)&&(+accInsuDivDR=0)) do          //未将医保实时结算的DHC_INVPRT.PRT_InsDiv_DR更新到DHC_AccPayINV.API_InsDiv_DR时,需要先撤销再退费
	..set flag=1
	.quit:(+flag'=0)
	.set prtPaymSub=0
	.for  set prtPaymSub=$o(^DHCINVPRT(prtRowId,"P",prtPaymSub))  quit:((prtPaymSub="")||(flag'=0))  do
	..set paymInfo=$g(^DHCINVPRT(prtRowId,"P",prtPaymSub))
	..quit:(paymInfo="")
	..set paymSelfFlag=$p(paymInfo,"^",12)   //IPM_Note3
	..quit:(+paymSelfFlag=0)                 //过滤医保支付的
	..set myAccPLDR=$p(paymInfo,"^",8)
	..if (myAccPLDR="") do
	...set flag=1
	
	quit flag
}

}
