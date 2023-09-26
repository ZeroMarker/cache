Import SQLUser

/// Creator: Lid
/// CreatDate: 2013-10-03
/// Description: 住院收费结算业务类
Class web.DHCIPBillCashier Extends BILL.COM.Abstract
{

/// Creator: Lid
/// CreatDate: 2013-10-03
/// Description: 查询患者账单信息
/// Input: StDate:开始日期,EndDate:结束日期,PatientNO:登记号,MedicareNO:病案号,PatientName:姓名,CardNO:就诊卡号,InvoiceNO:发票号
/// 	   SessionStr:扩展串(格式：收费员^安全组^登陆科室^院区^语种)
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCashier","SearchBill","","","","","","","","","","","",9,"","5816^9^302^2")
Query SearchBill(StDate As %String, EndDate As %String, PatientNO As %String, MedicareNO As %String, PatientName As %String, InvoiceNO As %String, EpisodeID As %String, PayStatus As %String, SessionStr As %String) As websys.Query(ROWSPEC = "patientid:%String:患者ID,patientNo:%String:登记号,mrNo:%String:病案号,patName:%String:患者姓名,admdate:%String:入院日期,admtime:%String:入院时间,admuser:%String:入院办理人,insType:%String:费别,dept:%String:科室,ward:%String:病区,bedCode:%String:床号,deposit:%Float:押金,totalamount:%Float:总金额,discountamount:%Float:折扣金额,payorshare:%Float:记账金额,patientshare:%Float:自付金额,disChgStatus:%String:住院状态,disChgStatusCode:%String:住院状态代码,paidflag:%String:账单状态,dischargedate:%String:出院日期,dischargetime:%String:出院时间,inDays:%String:住院天数,disuser:%String:财务结算人,invNo:%String:发票号,prtdate:%String:财务结算日期,prttime:%String:财务结算时间,episodeid:%String:就诊ID,pbrowid:%String:账单ID,pbflag:%String,prtrowid:%String:发票ID,prtflag:%String:发票状态,disdocname:%String:出院办理人,CodingUPDate:%String:审核日期,CodingUPTime:%String:审核时间,CodingUPUser:%String:审核人,CodingFlag:%String:审核状态,CodingReason:%String:审核原因,transLocFlag:%String:是否转科")
{
}

ClassMethod SearchBillExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, PatientNO As %String, MedicareNO As %String, PatientName As %String, InvoiceNO As %String, EpisodeID As %String, PayStatus As %String, SessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
 	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
 	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	if (StDate="") set StDate=+$h-30	   //默认查询30天
	if (EndDate="") set EndDate=+$h
	
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	set LangId=$p(SessionStr,"^",5)
	
	set (Billed, Discharge, Paid, ToBill)=0     //在院,最终结算,结算历史,新入院
	set (flag1, flag2, flag3, flag4)="N"
 	
 	if (PayStatus="billed") {
	 	set Billed=1
	 	set flag1="Y"
 	}elseif (PayStatus="discharge") {
		set Discharge=1
		set flag4="Y"
 	}elseif (PayStatus="paid") {
		set Paid=1
		set flag2="Y"
 	}elseif (PayStatus="toBill") {
		set ToBill=1
		set flag3="Y"
 	}else {
	 	
 	}
	
	kill BillArray
	//有当前就诊只查就诊不查其他
	kill AdmArray	     //主要用在通过婴儿找母亲时，多个婴儿的情况，使能通过一个婴儿找到另外的婴儿
	if (+EpisodeID'=0) do
	.set Adm=EpisodeID
	.do Billa(Adm)
	.set AdmArray(Adm)=""
	.//通过母亲就诊取婴儿就诊
	.set BabyAdmRowIDStr=..GetBabyAdm(Adm)
	.for idx=1:1:$l(BabyAdmRowIDStr,"^") do
	..set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
	..quit:(+BabyAdmRowID=0)
	..quit:$d(AdmArray(BabyAdmRowID))
	..do Billa(BabyAdmRowID)
	..set AdmArray(BabyAdmRowID)=""
	.//通过婴儿就诊获取母亲就诊,并找到其兄妹
	.set MotherAdmRowID=..GetMotherAdm(Adm)
 	.if (MotherAdmRowID'="") do
	..quit:$d(AdmArray(MotherAdmRowID))
	..do Billa(MotherAdmRowID)
	..set AdmArray(MotherAdmRowID)=MotherAdmRowID
	..set BabyAdmRowIDStr=..GetBabyAdm(MotherAdmRowID)
	..for idx=1:1:$l(BabyAdmRowIDStr,"^") do
	...set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
	...quit:(+BabyAdmRowID=0)
	...quit:$d(AdmArray(BabyAdmRowID))
	...do Billa(BabyAdmRowID)
	...set AdmArray(BabyAdmRowID)=""
	
	quit $$$OK
	
	if (PatientNO'="")  do
   	.set PatientNO=##class(web.UDHCJFBaseCommon).regnocon(PatientNO)
   	.set papmi=$o(^PAPERi("PAPMI_PatNo",PatientNO,""))
   	.quit:(papmi="")
	.set Adm=0
	.for  set Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) quit:(Adm="")  do
	..do Billa(Adm)
   	..set BabyAdmRowIDStr=..GetBabyAdm(Adm)
	..for idx=1:1:$l(BabyAdmRowIDStr,"^") do
	...set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
	...quit:(+BabyAdmRowID=0)
   	...do Billa(BabyAdmRowID)
   	..set MotherAdmRowID=..GetMotherAdm(Adm)
   	..if (MotherAdmRowID'="") do
   	...do Billa(MotherAdmRowID)
   	else  do
   	.kill PatAry
   	.do ##class(BILL.COM.PAPatMas).GetPatientByName(PatientName, .PatAry)
   	.set papmi=0
   	.for  set papmi=$o(PatAry(papmi)) quit:(papmi="")  do
	..set Adm=0
	..for  set Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) quit:(Adm="")  do
   	...//set patAdmDate=$p(^PAADM(+Adm),"^",6)
   	...//quit:(patAdmDate<(+$h-90))      //按姓名查询时，只查询最近三个月的记录
   	...do Billa(Adm)
   	...set BabyAdmRowIDStr=..GetBabyAdm(Adm)
   	...for idx=1:1:$l(BabyAdmRowIDStr,"^") do
   	....set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
	....quit:(+BabyAdmRowID=0)
   	....do Billa(BabyAdmRowID)
   	else  do
   	.if (MedicareNO'="")  do   //按病案号查询
   	..set papmi=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicareNO, "I", HospId, "")
   	..quit:(papmi="")
	..set Adm=0
	..for  set Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) quit:(Adm="")  do
	...do Billa(Adm)
	...set BabyAdmRowIDStr=..GetBabyAdm(Adm)
	...for idx=1:1:$l(BabyAdmRowIDStr,"^") do
	....set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
	....quit:(+BabyAdmRowID=0)
	....do Billa(BabyAdmRowID)
 	...set MotherAdmRowID=..GetMotherAdm(Adm)
 	...if (MotherAdmRowID'="") do
	....do Billa(MotherAdmRowID)
   	else  do
   	.if (InvoiceNO'="") do
   	..set PrtRowId=$o(^DHCINVPRTZY(0,"INV",InvoiceNO,""))
   	..if (PrtRowId'="") do
   	...set Adm=$p(^DHCINVPRTZY(PrtRowId),"^",4)
   	...do Billa(Adm)
   	...set BabyAdmRowIDStr=..GetBabyAdm(Adm)
   	...for idx=1:1:$l(BabyAdmRowIDStr,"^") do
   	....set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
   	....quit:(+BabyAdmRowID=0)
   	....do Billa(BabyAdmRowID)
   	...set MotherAdmRowID=..GetMotherAdm(Adm)
   	...if (MotherAdmRowID'="") do
   	....do Billa(MotherAdmRowID)
	
	if ((PatientNO="")&&(PatientName="")&&(MedicareNO="")&&(InvoiceNO="")&&(+EpisodeID=0))  do
	.if (((flag2'="Y")&&(flag4'="Y"))||(flag1="Y")) do
	..for AdmDate=StDate:1:EndDate  do
	...set AdmTime=""
	...for  set AdmTime=$o(^PAADMi("TypeDate","I",AdmDate,AdmTime)) quit:(AdmTime="")  do
	....set Adm=0
	....for  set Adm=$o(^PAADMi("TypeDate","I",AdmDate,AdmTime,Adm)) quit:(Adm="")  do
	.....do Billa(Adm)
	.....set BabyAdmRowIDStr=..GetBabyAdm(Adm)
	.....for idx=1:1:$l(BabyAdmRowIDStr,"^") do
	......set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
   	......quit:(+BabyAdmRowID=0)
	......do Billa(BabyAdmRowID)
	.....set MotherAdmRowID=..GetMotherAdm(Adm)
   	.....if (MotherAdmRowID'="") do
   	......do Billa(MotherAdmRowID)
   	.else  if ((flag2="Y")&&(+EpisodeID=0)) do
   	..kill ^||TMP("AdmDouble",$j)
   	..for AdmDate=StDate:1:EndDate  do
   	...set PrtRowId=0
   	...for  set PrtRowId=$o(^DHCINVPRTZY(0,"DATE",AdmDate,PrtRowId)) quit:(PrtRowId="")  do
   	....set Adm=$p(^DHCINVPRTZY(PrtRowId),"^",4)
   	....quit:($d(^||TMP("AdmDouble",$j,Adm)))   //过滤重复记录
   	....set ^||TMP("AdmDouble",$j,Adm)=""
   	....do Billa(Adm)
   	....set BabyAdmRowIDStr=..GetBabyAdm(Adm)
   	....for idx=1:1:$l(BabyAdmRowIDStr,"^") do
   	.....set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
   	.....quit:(+BabyAdmRowID=0)
   	.....do Billa(BabyAdmRowID)
   	....set MotherAdmRowID=..GetMotherAdm(Adm)
   	....if (MotherAdmRowID'="") do
   	.....do Billa(MotherAdmRowID)
   	..kill ^||TMP("AdmDouble",$j)
   	.else  if (flag4="Y") do
   	..for DisDate=StDate:1:EndDate  do
   	...set Adm=0
   	...for  set Adm=$o(^PAADMi("DischDate",DisDate,Adm)) quit:(Adm="")  do
   	....do Billa(Adm)
   	....set BabyAdmRowIDStr=..GetBabyAdm(Adm)
   	....for idx=1:1:$l(BabyAdmRowIDStr,"^") do
   	.....set BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
   	.....quit:(+BabyAdmRowID=0)
   	.....do Billa(BabyAdmRowID)
   	....set MotherAdmRowID=..GetMotherAdm(Adm)
   	....if (MotherAdmRowID'="") do
   	.....do Billa(MotherAdmRowID)
   	
   	quit $$$OK
   	
Billa(Adm)
	if ($$valAdm(Adm)=0) {
		set Bill=""
		for  set Bill=$o(^DHCPB(0,"ADM",+Adm,Bill),-1) quit:(Bill="")  do
		.set valBill=$$valBill(Bill)  //1-valid,0-not valid
		.if (valBill) do
		..quit:$d(BillArray(Bill))
		..set BillArray(Bill)=""
		..do selBill(Bill, Adm)
		if (flag3="Y")&&('$d(^DHCPB(0,"ADM",+Adm))) do selBill("", Adm)	  //查询新入院，还未生成账单的就诊记录
		if flag1="N",flag2="N",flag3="N",flag4="N",'$d(^DHCPB(0,"ADM",+Adm)) do selBill("", Adm)
	}
	quit
	
valAdm(adm)
	//check if Admission is valid for search criteria 0-valid,1-not valid
	set admType=$p($g(^PAADM(+adm)),"^",2)
	quit:(admType'="I") 1
	set visitStatus=$p($g(^PAADM(+adm)),"^",20)
	quit:((visitStatus'="D")&&(flag4="Y")) 1
	
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	quit:(HospId'=admHospDR) 1
	
	quit 0
	
valBill(bill)
	set pbData=$g(^DHCPB(+bill))
	set refundflag=$p(pbData,"^",17)
	set fprowid=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(bill)
	set paid=$s((+fprowid'=0):"P",1:"B")
	set prtData=$s((+fprowid'=0):$g(^DHCINVPRTZY(fprowid)),1:"")
	set amount=$p(prtData,"^",6)
	set prtFlag=$p(prtData,"^",8)
    if ((fprowid="")&&(refundflag'="")) quit 0
	if ((prtFlag="A")&&(+amount<0)) quit 0
	
	//if flag1="N",flag2="N",flag4="N" quit 0
	if flag1="N",flag2="N",flag3="N",flag4="N" quit 1
	if flag1="Y",paid="B" quit 1
	if flag2="Y",paid="P" quit 1
	if flag4="Y",paid="B" quit 1
	quit 0
	
selBill(Bill, Adm)
	set visitstatus=$p($g(^PAADM(Adm)),"^",20)
	quit:((" P C ")[(" "_visitstatus_" "))   //+2018-07-03 ZhYW 增加预住院就诊退出
	
	do ##class(web.UDHCJFBILL).BILLN(Adm, 1, "", "")
	
	set patientid=$p($g(^PAADM(Adm)),"^",1)
	set patientNo=$p($g(^PAPER(patientid,"PAT",1)),"^",1)
	set patName=$p($g(^PAPER(patientid,"ALL")),"^",1)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Adm, "I", "")
	set deptDR=$p($g(^PAADM(Adm)),"^",4)
	set dept=$s((+deptDR'=0):$p($g(^CTLOC(deptDR)),"^",2),1:"")
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, LangId)
	set wardDR=$p($g(^PAADM(Adm)),"^",70)
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2),1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, LangId)
	set disdoc=$p($g(^PAADM(Adm)),"^",19)
	set disdocname=$s((+disdoc'=0):$p($g(^CTPCP(disdoc,1)),"^",2),1:"")
	set disdocname=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", disdocname, LangId)
	set admUserDR=$p($g(^PAADM(Adm)),"^",43)
	set admuser=$s((+admUserDR'=0):$p($g(^SSU("SSUSR",admUserDR)),"^",2),1:"")     //办理入院的收费员
	set admuser=##class(User.SSUser).GetTranByDesc("SSUSRName", admuser, LangId)
	
	set PBData=$s((+Bill'=0):$g(^DHCPB(Bill)),1:"")
	set insTypeDR=$p(PBData,"^",4)	   //Lid 取账单上的费别
	if (insTypeDR="") {
		set insTypeDR=$p($g(^PAADM(Adm,1)),"^",7)
	}
	set insType=$s((+insTypeDR'=0):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, LangId)
	set totalamount=$p(PBData,"^",8)         //总费用
	set totalamount=$fn(totalamount,"",2)
	set discountamount=$p(PBData,"^",9)      //折扣费用
	set discountamount=$fn(discountamount,"",2)
	set payorshare=$p(PBData,"^",11)         //记账费用
	set payorshare=$fn(payorshare,"",2)
	set patientshare=$p(PBData,"^",12)       //自付费用
	set patientshare=$fn(patientshare,"",2)
	set payedFlag=$p(PBData,"^",16)          //账单状态
	set prtrowid=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(Bill)
	
	set prtdate=""
	set prttime=""
	set invNo=""
	set paidflag=""
	set disuser=""
	set prtflag=""
	set deposit=0
	if (prtrowid'="") {
		set prtInvData=$g(^DHCINVPRTZY(prtrowid))
		set prtflag=$p(prtInvData,"^",8)
		set paidflag=$case(prtflag,"I":"中途结算","N":"出院结算","A":"发票作废","S":"发票红冲",:"")
		set invNo=$p(prtInvData,"^",1)
		quit:((InvoiceNO'="")&&(InvoiceNO'=invNo))
		set prtdate=$p(prtInvData,"^",2)
		set prttime=$p(prtInvData,"^",3)
		set prtdate=##class(websys.Conversions).DateLogicalToHtml(prtdate)
		set prttime=##class(websys.Conversions).TimeLogicalToHtml(prttime)
		set disUserDR=$p(prtInvData,"^",7)
		set disuser=$s((+disUserDR'=0):$p(^SSU("SSUSR",disUserDR),"^",2),1:"")
		set disuser=##class(User.SSUser).GetTranByDesc("SSUSRName", disuser, LangId)
		set deposit=$p(prtInvData,"^",22)
		set deposit=$fn(deposit,"",2)
	}else {
		set paidflag="未结算"
		set isClosedAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(Bill)
		if (isClosedAcount="Y") set paidflag="已封账"
		//modify 2012-03-01 根据支票是否到账的设置判断交押金金额
		set deposit=##class(web.UDHCJFBaseCommon).depositBankBack(Adm)
	}
	set paidflag=##class(websys.Translation).Get("", paidflag, LangId)
	
	set bedCode=##class(web.DHCBillCommon).GetPatBedCode(Adm)

	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(Adm)
	set inDays=$p(admInOutDateInfo,"^",3)
	set disChgStatus=$p(admInOutDateInfo,"^",4)     //住院状态
	set admdate=$p(admInOutDateInfo,"^",5)
	set admtime=$p(admInOutDateInfo,"^",6)
	set disdate=$p(admInOutDateInfo,"^",7)
	set distime=$p(admInOutDateInfo,"^",8)
	set disChgStatusCode=$p(admInOutDateInfo,"^",9)  //住院状态代码
	set admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
	set admtime=##class(websys.Conversions).TimeLogicalToHtml(admtime)
	set dischargedate=##class(websys.Conversions).DateLogicalToHtml(disdate)
	set dischargetime=##class(websys.Conversions).TimeLogicalToHtml(distime)
	set pbrowid=Bill
	
	set (CodingUPDate, CodingUPTime, CodingUPUser, CodingFlag, CodingReason)=""
	if (Bill'="") {
		set ConRowid=$o(^DHCIPBILLCONFIRM("0","BillNo",Bill,""),-1)
		if (+ConRowid'=0) {
			set ConfData=$g(^DHCIPBILLCONFIRM(ConRowid))
			set CodingFlag=$p(ConfData,"^",3)
			set CodingFlag=$case(CodingFlag, "Y":"审核通过", "N":"审核拒绝", "C":"撤销审核", :CodingFlag)
			set CodingFlag=##class(websys.Translation).Get("", CodingFlag, LangId)
			set CodingUPDate=$p(ConfData,"^",4)
			set CodingUPDate=##class(websys.Conversions).DateLogicalToHtml(CodingUPDate)
			set CodingUPTime=$p(ConfData,"^",5)
			set CodingUPTime=##class(websys.Conversions).TimeLogicalToHtml(CodingUPTime)
			set CodingUPUserDr=$p(ConfData,"^",6)
			set CodingUPUser=$s((+CodingUPUserDr'=0):$p(^SSU("SSUSR",CodingUPUserDr),"^",2),1:"")
			set CodingUPUser=##class(User.SSUser).GetTranByDesc("SSUSRName", CodingUPUser, LangId)
			set CodingReason=$p(ConfData,"^",7)
		}
	}
	
	//2017-08-03 zhangli 取转科标志
	set transLocFlag=..GetTransLocFlag(Adm)
	do OutputBillList
	quit
	
OutputBillList
	set Data=$lb(patientid,patientNo,mrNo,patName,admdate,admtime,admuser,insType,dept,ward,bedCode,deposit,totalamount,discountamount,payorshare,patientshare,disChgStatus,disChgStatusCode,paidflag,dischargedate,dischargetime,inDays,disuser,invNo,prtdate,prttime,Adm,pbrowid,payedFlag,prtrowid,prtflag,disdocname,CodingUPDate,CodingUPTime,CodingUPUser,CodingFlag,CodingReason,transLocFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 患者列表
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCashier","FindPatList","2018-08-06","","","","","","红红","false^false^false^true","671^131^302^2")
Query FindPatList(stDate As %String, endDate As %String, deptId As %String, wardId As %String, insTypeId As %String, invoiceNo As %String, patientName As %String, admStatus As %String, sessionStr As %String) As websys.Query(ROWSPEC = "TPAPMI:%String:患者ID,TPatNo:%String:登记号,TMedicare:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAge:%String:年龄,TAdm:%String:就诊ID,TLoc:%String:科室,TWard:%String:病区,TBed:%String:床号,TAdmDate:%String:入院日期,TAdmTime:%String:入院时间,TDiscDate:%String:出院日期,TDiscTime:%String:出院时间,TAdmReason:%String:费别")
{
}

ClassMethod FindPatListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, deptId As %String, wardId As %String, insTypeId As %String, invoiceNo As %String, patientName As %String, admStatus As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    set ^TMP("FindPatList")=$lb(stDate, endDate, deptId, wardId, insTypeId, invoiceNo, patientName, admStatus, sessionStr)
    
    set userId=$p(sessionStr,"^",1)
    set groupId=$p(sessionStr,"^",2)
    set ctLocId=$p(sessionStr,"^",3)
    set hospId=$p(sessionStr,"^",4)
    set langId=$p(sessionStr,"^",5)

	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	set patientName=$$ALPHAUP^SSUTIL4(patientName)
	
	if (invoiceNo'="") {
		set prtId=0
		while($o(^DHCINVPRTZY(0,"INV",invoiceNo,prtId))) {
			set prtId=$o(^DHCINVPRTZY(0,"INV",invoiceNo,prtId))
			set prtData=$g(^DHCINVPRTZY(prtId))
			set adm=$p(prtData,"^",4)
			do SetInfoList(adm)
		}
		quit $$$OK
	}
	
	if (" 1 2 "[(" "_admStatus_" ")) {
		//当前在院、医生医疗结算
		set adm=0
		while($o(^PAADMi("AdmTypeCurr","I",adm))) {
			set adm=$o(^PAADMi("AdmTypeCurr","I",adm))
			do SetInfoList(adm)
		}
		quit $$$OK
	}
	
	if (admStatus=3) {
		//护士最终结算
		for date=stDate:1:endDate {
			set adm=0
			while($o(^PAADMi("DischDate",date,adm))) {
				set adm=$o(^PAADMi("DischDate",date,adm))
				do SetInfoList(adm)
			}
		}
		quit $$$OK
	}
	
	if (admStatus=4) {
		//财务结算
		for date=stDate:1:endDate {
			set prtId=0
			while($o(^DHCINVPRTZY(0,"DATE",date,prtId))) {
				set prtId=$o(^DHCINVPRTZY(0,"DATE",date,prtId))
				set prtData=$g(^DHCINVPRTZY(prtId))
				set initInvDR=$o(^DHCINVPRTZY(0,"InitInv",prtId,0))
				continue:(+initInvDR'=0)     //过滤取消结算的记录
				set adm=$p(prtData,"^",4)
				do SetInfoList(adm)
			}
		}
	}
	
	quit $$$OK
	
SetInfoList(adm)
	set admType=$p(^PAADM(adm),"^",2)
	quit:(admType'="I")
	set papmi=$p(^PAADM(adm),"^",1)
	set locDR=$p(^PAADM(adm),"^",4)
	quit:((deptId'="")&&(deptId'=locDR))
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(locDR)
	quit:(hospId'=hospDR)
	set dept=$s((locDR'=""):$p(^CTLOC(locDR),"^",2),1:"")
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
	set mradm=$p(^PAADM(adm),"^",61)
	set wardDR=$p(^PAADM(adm),"^",70)
	quit:((wardId'="")&&(wardId'=wardDR))
	set ward=$s((wardDR'=""):$p(^PAWARD(wardDR),"^",2),1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set billFlag=$p(^PAADM(adm),"^",45)
	quit:((admStatus=3)&&(billFlag="Y"))
	set bed=##class(web.DHCBillCommon).GetPatBedCode(adm)
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
	set admDate=$p(admInOutDateInfo,"^",5)
	set admTime=$p(admInOutDateInfo,"^",6)
	set discDate=$p(admInOutDateInfo,"^",7)
	set discTime=$p(admInOutDateInfo,"^",8)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set discDate=##class(websys.Conversions).DateLogicalToHtml(discDate)
	set discTime=##class(websys.Conversions).TimeLogicalToHtml(discTime)
	set meddiscDate=$p(^PAADM(adm),"^",59)
	quit:((admStatus=2)&&((meddiscDate<stDate)||(meddiscDate>endDate)))
	set visitstatus=$p(^PAADM(adm),"^",20)
	quit:(visitstatus="C")
	set insTypeDR=$p(^PAADM(adm,1),"^",7)
	quit:((insTypeId'="")&&(insTypeId'=insTypeDR))
	set admReaDesc=$s((insTypeDR'=""):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	quit:((patientName'="")&&($$ALPHAUP^SSUTIL4(patName)'[patientName))
	set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
	set sex=$s((sexDR'=""):$p(^CT("SEX",sexDR),"^",2),1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	set age=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm)
	set CodingUpdateUser=$p(^PAADM(adm,2),"^",92)
	set ConfirmFlag=$s((CodingUpdateUser=""):"N",1:"Y")

	do OutputPatList
	quit
	
OutputPatList
	set Data=$lb(papmi,regNo,mrNo,patName,sex,age,adm,dept,ward,bed,admDate,admTime,discDate,discTime,admReaDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 根据母亲就诊取婴儿的就诊
ClassMethod GetBabyAdm(MotherAdm As %String) As %String
{
	set babyAdmStr=""
	set babyAdm=0
	while($o(^PAADMi("Mother",MotherAdm,babyAdm))) {
		set babyAdm=$o(^PAADMi("Mother",MotherAdm,babyAdm))
		set babyAdmStr=$s((babyAdmStr=""):babyAdm,1:(babyAdmStr_"^"_babyAdm))
	}
	quit babyAdmStr
}

/// Description: 根据婴儿的就诊取母亲的就诊
ClassMethod GetMotherAdm(BabyAdm As %String) As %String
{
	set MotherAdm=$p(^PAADM(BabyAdm),"^",75)
	quit MotherAdm
}

/// Creator: tangtao
/// CreatDate: 2013-10-08
/// Description: 获取住院病人结算押金
/// Inpu: adm:PA_Adm.RowId, prtRowId:DHC_INVPRTZY.RowId
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCashier","FindDepList","10","23300")
Query FindDepList(adm As %String, prtRowId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TDepAmt:%Float:金额,TDepNo:%String:收据号,TPayMDesc:%String:支付方式,TPrtDate:%String:交款日期,TPrtTime:%String:交款时间,TUserName:%String:收费员,TDepRowId:%String:押金ID,TPrtStatus:%String:押金状态,TBillFlag:%String:是否参与结算,TUn2PayReason:%String:不能参与结算原因,TIsReverseDep:%String:是否取消结算回冲押金")
{
}

ClassMethod FindDepListExecute(ByRef qHandle As %Binary, adm As %String, prtRowId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
    if (adm="")  quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	kill depList($j)

	if (+prtRowId'=0) {
		//+2022-12-22 ZhYW 获取发票关联结算的押金
		set conId=0
		while($o(^DHCINVPRTZYCONDEPi(0,"Inv",prtRowId,conId))) {
			set conId=$o(^DHCINVPRTZYCONDEPi(0,"Inv",prtRowId,conId))
			set conData=$g(^DHCINVPRTZYCONDEP(conId))
			continue:(conData="")
			set depRowId=$p(conData,"^",3)
			do BuildDepList
		}
	}else {
		//未结算押金
		set depRowId=0
		while($o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))) {
			set depRowId=$o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))
			do BuildDepList
		}
	}
	
	set depRowId=0
	while($o(depList($j,depRowId))) {
		set depRowId=$o(depList($j,depRowId))
		set depData=$g(^DHCSFPRINTDETAIL(depRowId))
		set rcptno=$p(depData,"^",1)
		set depAmt=$p(depData,"^",6)
		set depAmt=$fn(depAmt,"",2)
		set prtDate=$p(depData,"^",2)
		set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
		set prtTime=$p(depData,"^",3)
		set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
		set un2PayReason=""   //不能参与结算原因
		set rtnValue=##class(BILL.IP.COM.Method).ChkDepCanToPay(depRowId)   //+2023-04-04 ZhYW 判断押金是否能参与结算
		set billFlag=$p(rtnValue,"^",1)
		if (billFlag=0) {
			set un2PayReason=$p(rtnValue,"^",2)
		}
		set paymSub=$o(^DHCSFPRINTDETAIL(depRowId,"P",0))
		set paymSubData=$g(^DHCSFPRINTDETAIL(depRowId,"P",+paymSub))
		set paymDR=$p(paymSubData,"^",1)
		set paymDesc=$s((+paymDR'=0):$p(^CT("CTPM",paymDR),"^",2), 1:"")
		set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
		set userDR=$p(depData,"^",14)
	 	set userName=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
	 	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		set prtStatus=$p(depData,"^",8)
		set prtRefInvDR=$p(depData,"^",40)    //prt_refinvprtzy_dr
		set isReverseDep=(+prtRefInvDR>0)    //是否回冲押金(1:是, 0:否)
	 	do OutputDepList
	}
 	
	kill depList($j)
	quit $$$OK
    
OutputDepList
	set Data=$lb(depAmt,rcptno,paymDesc,prtDate,prtTime,userName,depRowId,prtStatus,billFlag,un2PayReason,isReverseDep)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit

BuildDepList
	set depData=$g(^DHCSFPRINTDETAIL(depRowId))
	quit:(depData="")
	set depTypeDR=$p(depData,"^",13)
	set depTypeCode=$s((+depTypeDR'=0):$p($g(^ARC("ARCDT",depTypeDR)),"^",1),1:"")
	quit:(depTypeCode'="01")   //住院押金
	set prtStatus=$p(depData,"^",8)
	quit:(+prtStatus'=1)
	set payedFlag=$p(depData,"^",38)
	quit:((+prtRowId=0)&&(payedFlag="Y"))   //查询未结算时，过滤已结算记录
	set depList($j,depRowId)=""
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCashier","ReadPayMList","241","2","")
Query ReadPayMList(groupId As %String, hospId As %String, prtRowId As %String, langId As %String = "") As websys.Query(ROWSPEC = "CTPMRowID:%String,CTPMCode:%String,CTPMDesc:%String,CTPMAmt:%String,CTPMBankRowID:%String,CTPMBank:%String,CTPMCheckNo:%String,CTPMUnitRowID:%String,CTPMUnit:%String,CTPMAccount:%String,CTPMTransFlag:%String,CTPMInsuFlag:%String")
{
}

ClassMethod ReadPayMListExecute(ByRef qHandle As %Binary, groupId As %String, hospId As %String, prtRowId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (langId="")&&($d(%session)) {
	 	set langId=%session.Get("LOGON.LANGID")
	}
	
	kill PMList
	if (+prtRowId'=0) {
		//已结算
		set myPMSequence=0
		set myPMSub=0
		while($o(^DHCINVPRTZY(prtRowId,"P",myPMSub))) {
			set myPMSub=$o(^DHCINVPRTZY(prtRowId,"P",myPMSub))
			set myPMData=$g(^DHCINVPRTZY(prtRowId,"P",myPMSub))
			continue:(myPMData="")
			do ResetVariables
			set myPayMDR=$p(myPMData,"^",1)
			continue:(myPayMDR="")
			set myPayMAmt=$p(myPMData,"^",3)
			set myInsuFlag=$p(myPMData,"^",9)
			set myBankDR=$p(myPMData,"^",2)
			set myCheckNo=$p(myPMData,"^",4)
			set myTransFlag=$p(myPMData,"^",10)
			set myUnitDR=$p(myPMData,"^",8)         //IPM_Unit_DR 公费单位
			set myAccount=$p(myPMData,"^",6)        //IPM_PayAccNo 账户号
			set PMList($i(myPMSequence))=$lb(myPayMDR, myPayMAmt, myBankDR, myCheckNo, myUnitDR, myAccount, myTransFlag, myInsuFlag)
		}
	}else {
		//未结算
		set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(groupId, hospId)
		if (+myGSRowID=0) quit $$$OK
		
		set maxIndex=9999
		set myPMSub=0
		while($o(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))) {
			set myPMSub=$o(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))
			set myGSPMData=$g(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))
			continue:(myGSPMData="")
			do ResetVariables
			set myPMRowID=myGSRowID_"||"_myPMSub
			set myPayMDR=$p(myGSPMData,"^",1)
			continue:(myPayMDR="")
			set myPMOPCFlag=$p(myGSPMData,"^",8)         //收费
			continue:(myPMOPCFlag'="Y")
			set myPMSequence=$p(myGSPMData,"^",11)       //顺序号
			if (myPMSequence="") set myPMSequence=$i(maxIndex)
			set PMList(myPMSequence)=$lb(myPayMDR, myPayMAmt, myBankDR, myCheckNo, myUnitDR, myAccount, myTransFlag, myInsuFlag)
		}
	}

	set seqIdx=0
	while($o(PMList(seqIdx))) {
		set seqIdx=$o(PMList(seqIdx))
		set data=$g(PMList(seqIdx))
		set myCTPMRowID=$lg(data,1)
		set myCTPMCode=$p($g(^CT("CTPM",myCTPMRowID)),"^",1)
		set myCTPMDesc=$p($g(^CT("CTPM",myCTPMRowID)),"^",2)
		set myCTPMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", myCTPMDesc, langId)
		set myPayMAmt=$lg(data,2)
		set myPayMAmt=$s((+myPayMAmt'=0):$fn(myPayMAmt,"",2),1:"")    //这里加判断是为了未结算的支付金额显示为空，而不显示0.00
		set myBankDR=$lg(data,3)
		set myBank=$s((+myBankDR'=0):$p(^CMC("CMCBM",myBankDR),"^",2),1:"")
		set myBank=##class(User.CMCBankMas).GetTranByDesc("CMCBMDesc", myBank, langId)
		set myCheckNo=$lg(data,4)
		set myUnitDR=$lg(data,5)
		set myUnit=$s((+myUnitDR'=0):$p($g(^CT("HCP",myUnitDR)),"^",2),1:"")
		set myUnit=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", myUnit, langId)
		set myAccount=$lg(data,6)
		set myTransFlag=$lg(data,7)
		set myInsuFlag=$lg(data,8)
		do OutputPMSequence
	}
	
	kill PMList
	
	quit $$$OK
	
ResetVariables
	set (myPayMDR, myPayMAmt, myBankDR, myCheckNo, myUnitDR, myAccount)=""
	set (myTransFlag, myInsuFlag)="N"
	quit

OutputPMSequence
	set Data=$lb(myCTPMRowID,myCTPMCode,myCTPMDesc,myPayMAmt,myBankDR,myBank,myCheckNo,myUnitDR,myUnit,myAccount,myTransFlag,myInsuFlag)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: Lid
/// CreatDate: 2013-10-08
/// Description: 获取病人信息
/// Input: EpisodeID:就诊ID, PBRowID:账单ID
/// Return: 
/// Other: 注意：如果有需求需要扩展信息时，一定要在后边追加
/// Debug: w ##class(web.DHCIPBillCashier).GetPatInfo("7852","14038")
ClassMethod GetPatInfo(EpisodeID As %String, PBRowID As %String) As %String
{
	set ^TMP("GetPatInfo")=$lb(EpisodeID, PBRowID)
	//取病人基本信息，就诊信息
	quit:((EpisodeID="")&&(PBRowID="")) ""
	
	set AdmJsonStr=##class(BILL.COM.PAAdm).GetAdmInfo(EpisodeID)
	set AdmJson=##class(%DynamicObject).%FromJSON(AdmJsonStr)
	
	set PatientId=$p(^PAADM(EpisodeID),"^",1)
	set PatJsonStr=##class(BILL.COM.PAPatMas).GetPatientInfo(PatientId)
	set PatJson=##class(%DynamicObject).%FromJSON(PatJsonStr)
	
	set MrNo=AdmJson.MedicareNo
	set PatNo=PatJson.PatientNo
	
	set PatName=PatJson.PatName
	set PatID=PatJson.ID
	set DOB=$p($g(^PAPER(PatientId,"ALL")),"^",6)       //生日
	set DOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
	set Age=##class(web.DHCBillInterface).GetPapmiAge(PatientId, EpisodeID)
	set Sex=PatJson.Sex
	set SecondPhone=$p($g(^PAPER(PatientId,"PER",4)),"^",18)         //工作单位                              
	set linkMan=$p($g(^PAPER(PatientId,"PER",2)),"^",13)             //联系人姓名
	set linkRelation=$p($g(^PAPER(PatientId,"ALL")),"^",4)           //联系人关系
	set linkAddress=$p($g(^PAPER(PatientId,"PER",1)),"^",1)          //联系人地址
	set linkPhone=$p($g(^PAPER(PatientId,"ALL")),"^",4)              //联系人电话
	set Address=PatJson.Address
	set PatInfo=PatNo_"^"_PatName_"^"_MrNo_"^"_PatID_"^"_Sex_"^"_DOB_"^"_Age_"^"_Address_"^"_SecondPhone_"^"_linkMan_"^"_linkRelation_"^"_linkAddress_"^"_linkPhone
	
	//人员就诊信息
	set WardDesc=AdmJson.Ward
	set LocDesc=AdmJson.Dept
	if (+PBRowID=0) {
		set AdmReasonId=$p(^PAADM(EpisodeID,1),"^",7)	  //取就诊上的费别
	}else {
		set AdmReasonId=$p($g(^DHCPB(PBRowID)),"^",4)	  //取账单上的费别
	}
	set AdmReason=$s((+AdmReasonId'=0):$p($g(^PAC("ADMREA",AdmReasonId)),"^",2),1:"")
	
	set BedCode=AdmJson.Bed
	if (+PBRowID'=0) {
		set AdmInDays=##class(web.UDHCJFBaseCommon).GetPatAdmInDays(EpisodeID, PBRowID)
		set AdmDate=$p(AdmInDays,"^",1)
		set DisDate=$p(AdmInDays,"^",2)
		set StayDate=$p(AdmInDays,"^",3)
	}else {
		set AdmDate=AdmJson.AdmDate
		set DisDate=AdmJson.DiscDate
		set StayDate=AdmJson.InDays
	}
	
	set AdmInfo=AdmDate_"^"_DisDate_"^"_AdmReason_"^"_LocDesc_"^"_WardDesc_"^"_BedCode_"^"_StayDate

	//取费用信息
	//押金$c(2)总金额^自付金额^折扣金额^记账金额$c(2)应收/应退金额$c(2)医保金额
	if (+PBRowID'=0) {
		set tmp1=##class(web.UDHCJFBaseCommon).GetPatFeeByBillNO(PBRowID, "")
		set Deposit=$p(tmp1,$c(2),1)
		set TotalAmt=$p($p(tmp1,$c(2),2),"^",1)
		set ShareAmt=$p($p(tmp1,$c(2),2),"^",2)
		set DiscAmt=$p($p(tmp1,$c(2),2),"^",3)
		set PayorAmt=$p($p(tmp1,$c(2),2),"^",4)
		
		set YSAmt=0, YTAmt=0
		set STAmt=$p(tmp1,$c(2),3)
		if (STAmt>0) set YSAmt=STAmt	 //大于0为应收
		else  set YTAmt=STAmt		     //小于0为应退
		
		//此处先留个接口，如果需要显示医保金额就在##class(web.UDHCJFBaseCommon).GetPatFeeByBillNO()类方法中调用医保接口,
		//在用$c(2)分割的第四位传出
		set YBAmt=+$p(tmp1,$c(2),4)
		set ZFAmt=ShareAmt-YBAmt	    //自费金额=费用-医保
		set yeAmt=Deposit-ZFAmt
	} else {
		set Deposit=##class(web.UDHCJFBaseCommon).depositBankBack(EpisodeID)
		set TotalAmt=0
		set ShareAmt=0
		set DiscAmt=0
		set PayorAmt=0
		set STAmt=0

		set YSAmt=0
		set YTAmt=0
		set YBAmt=0
		set ZFAmt=0	   //自费金额=费用-医保
		set yeAmt=0	
	}
	set FeeInfo=$fn(Deposit,"",2)_"^"_$fn(TotalAmt,"",2)_"^"_$fn(ShareAmt,"",2)_"^"_$fn(DiscAmt,"",2)_"^"_$fn(PayorAmt,"",2)_"^"_$fn(STAmt,"",2)_"^"_$fn(YSAmt,"",2)_"^"_$fn(YTAmt,"",2)_"^"_$fn(YBAmt,"",2)_"^"_$fn(ZFAmt,"",2)_"^"_$fn(yeAmt,"",2)
	
	quit PatInfo_"$"_AdmInfo_"$"_FeeInfo
}

/// Creator: hujunbin
/// CreatDate: 2014-06-10
/// Description: 获取费别信息
/// Input: EpisodeID:就诊ID, BillNo:账单ID
/// Return: 
/// Debug: w ##class(web.DHCIPBillCashier).GetInsTypeInfo()
ClassMethod GetInsTypeInfo(EpisodeID As %String, BillNo As %String) As %String
{
	quit:((+EpisodeID=0)&&(+BillNo=0)) ""
	if (BillNo'="") {
		set AdmReaRowId=$p(^DHCPB(BillNo),"^",4)
	}else {
		set AdmReaRowId=$p(^PAADM(EpisodeID,1),"^",7)
	}
	quit:(+AdmReaRowId=0) ""
	
	set admReaInfo=$g(^PAC("ADMREA",AdmReaRowId))
	set code=$p(admReaInfo,"^",1)
	set desc=$p(admReaInfo,"^",2)
	set dateFrom=$p(admReaInfo,"^",3)
	set dateTo=$p(admReaInfo,"^",4)
	set nationalCode=$p(admReaInfo,"^",5)
	set admSource=$p(admReaInfo,"^",9)
	set qualifStatus=$p(admReaInfo,"^",10)
	set careType=$p(admReaInfo,"^",11)
	
	quit AdmReaRowId_"^"_code_"^"_desc_"^"_dateFrom_"^"_dateTo_"^"_nationalCode_"^"_admSource_"^"_qualifStatus_"^"_careType
}

/// Creator: hujunbin
/// CreatDate: 2014-06-12
/// Description: 返回押金数和可用押金数
/// Input: adm:PA_Adm.RowId, prtRowId:DHC_INVPRTZY.RowId
/// Return:	全部押金^可用押金
/// Debug: w ##class(web.DHCIPBillCashier).GetDepositSum(7852, 838)
ClassMethod GetDepositSum(adm As %String, prtRowId As %String) As %String
{
	quit:(adm="") 0_"^"_0
	
	set (depAmt, avaiDepAmt)=0
	if (+prtRowId'=0) {
		//已结算
		set depAmt=$p($g(^DHCINVPRTZY(prtRowId)),"^",22)
		set depAmt=$fn(depAmt,"",2)
		set avaiDepAmt=depAmt
		quit depAmt_"^"_avaiDepAmt
	}

	//未结算
	set depRowId=0
	while($o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))) {
		set depRowId=$o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))
		set depData=$g(^DHCSFPRINTDETAIL(depRowId))
		set prtStatus=$p(depData,"^",8)
		continue:(prtStatus'=1)
		set depTypeDR=$p(depData,"^",13)
		continue:(+depTypeDR=0)
		set depTypeCode=$p($g(^ARC("ARCDT",depTypeDR)),"^",1)
		continue:(depTypeCode'="01")   //住院押金
		set payedFlag=$p(depData,"^",38)
		continue:(payedFlag="Y")       //过滤已参与结算押金
		set amt=$p(depData,"^",6)
		set depAmt=$i(depAmt, amt)            //总押金金额
		set rtnValue=##class(BILL.IP.COM.Method).ChkDepCanToPay(depRowId)   //+2023-04-04 ZhYW 判断押金是否能参与结算
		set billFlag=$p(rtnValue,"^",1)
		continue:(billFlag=0)
		set avaiDepAmt=$i(avaiDepAmt, amt)    //可参与结算的押金金额
	}
	
	set depAmt=$fn(depAmt,"",2)
	set avaiDepAmt=$fn(avaiDepAmt,"",2)
	
	quit depAmt_"^"_avaiDepAmt
}

/// Creator: hujunbin
/// CreatDate: 2014-07-15
/// Description: 返回是否有必填项
/// Input: paymId:CT_PayMode.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillCashier).IsRequiredInfo()
ClassMethod IsRequiredInfo(groupId As %String, hospId As %String, paymId As %String) As %String
{
	set rtn=0
	quit:((groupId="")||(paymId="")) rtn
	
	set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(groupId, hospId)
	quit:(myGSRowID="") rtn
	
	set myPMSub=$o(^DHCOPGSi("GS",0,"CTPMDR",paymId,myGSRowID,"PM",0))
	quit:(myPMSub="") rtn
	
	set myRPFlag=$p($g(^DHCOPGS("GS",myGSRowID,"PM",myPMSub)),"^",6)
	if (myRPFlag="Y") set rtn=1
	
	quit rtn
}

/// Description: 查询患者就诊列表
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCashier","SearchAdm",111)
Query SearchAdm(papmi As %String, sessionStr As %String) As websys.Query(ROWSPEC = "TAdm:%String:就诊ID,TAdmDate:%String:就诊日期,TAdmTime:%String:就诊时间,TDept:%String:就诊科室,TWard:%String:就诊病区,TDischDate:%String:出院日期,TDischTime:%String:出院时间")
{
}

ClassMethod SearchAdmExecute(ByRef qHandle As %Binary, papmi As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
    if (+papmi=0)  quit $$$OK
    
    set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
    set adm=""
    while($o(^PAPERdr(papmi,"ADM","I",adm),-1)) {
	    set adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1)
	    set admStatus=$p(^PAADM(adm),"^",20)
   		continue:(" C P "[(" "_admStatus_" "))   //+2018-07-03 ZhYW 增加预住院就诊退出
   		set admDeptDR=$p(^PAADM(adm),"^",4)
   		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
   		continue:(admHospDR'=hospId)
   		set admDept=$s((+admDeptDR'=0):$p(^CTLOC(admDeptDR),"^",2),1:"")
   		set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
   		set admWardDR=$p(^PAADM(adm),"^",70)
   		set admWard=$s((+admWardDR'=0):$p(^PAWARD(admWardDR),"^",2),1:"")
   		set admWard=##class(User.PACWard).GetTranByDesc("WARDDesc", admWard, langId)
   		set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(adm)
   		set admDate=$p(admInOutDateInfo,"^",5)
		set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
		set admTime=$p(admInOutDateInfo,"^",6)
		set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
		set dischDate=$p(admInOutDateInfo,"^",7)
		set dischDate=##class(websys.Conversions).DateLogicalToHtml(dischDate)
		set dischTime=$p(admInOutDateInfo,"^",8)
		set dischTime=##class(websys.Conversions).TimeLogicalToHtml(dischTime)
   		do OutputAdmList
	}
	
	quit $$$OK
	
OutputAdmList
	set Data=$lb(adm,admDate,admTime,admDept,admWard,dischDate,dischTime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Description: 获取住院费用大类金额
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillCashier","GetCateList","5315",3)
Query GetCateList(bill As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "CateDesc:%String:分类,CateAmt:%Float:金额")
{
}

ClassMethod GetCateListExecute(ByRef qHandle As %Binary, bill As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
 	if (langId="")&&($d(%session)) {
	 	set langId=%session.Get("LOGON.LANGID")
	}
	
    kill itmCateAry
    
    if (+bill'=0) {
		set pbo=0
		while($o(^DHCPB(bill,"O",pbo))) {
			set pbo=$o(^DHCPB(bill,"O",pbo))
			set pbd=0
			while($o(^DHCPB(bill,"O",pbo,"D",pbd))) {
				set pbd=$o(^DHCPB(bill,"O",pbo,"D",pbd))
				set pbdData=$g(^DHCPB(bill,"O",pbo,"D",pbd))
				continue:(pbdData="")
				set tarItmDR=$p(pbdData,"^",3)
				set amt=$p(pbdData,"^",7)        //总额
    			set itmSubCate=$p(^DHCTARI(tarItmDR),"^",14)    //住院费用子分类 
				set itmCate=$p(^DHCTarC("IC",itmSubCate),"^",3)
				set itmCateAry(itmCate)=$i(itmCateAry(itmCate), amt)
			}
		}
    }
	
	set cate=0
	while($o(^DHCTarC("TIC",cate))) {
		set cate=$o(^DHCTarC("TIC",cate))
		set cateData=$g(^DHCTarC("TIC",cate))
		set showDataFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC", cate, hospId)
	 	continue:(showDataFlag="N")
	 	set cateDesc=$p(cateData,"^",2)
	 	set cateDesc=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", cateDesc, langId)
	 	set cateAmt=$g(itmCateAry(cate))
		set cateAmt=$fn(cateAmt,"",2)
		do OutputCateList
	}
    
	quit $$$OK
OutputCateList
	set Data=$lb(cateDesc,cateAmt)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: hujunbin
/// CreatDate: 2015-3-12
/// Modify: ZhYW
/// Description: 获取基本信息
/// Input: PatientNo:登记号, MedicareNo: 病案号, Adm:就诊ID
/// Return: 
/// Debug: w ##class(web.DHCIPBillCashier).GetAdmInfo("1","", "", "^^2")
ClassMethod GetAdmInfo(PatientNo As %String, MedicareNo As %String, EpisodeID As %String, SessionStr As %String) As %String
{
	set userId=$p(SessionStr,"^",1)
	set groupId=$p(SessionStr,"^",2)
	set ctLocId=$p(SessionStr,"^",3)
	set hospId=$p(SessionStr,"^",4)
		
	set Adm=""
	if (EpisodeID'="") {
		set Adm=EpisodeID
		set PatientId=$p($g(^PAADM(EpisodeID)),"^",1)
	}elseif (PatientNo'="") {
		set PatientNo=##class(web.UDHCJFBaseCommon).regnocon(PatientNo)
		set PatientId=$o(^PAPERi("PAPMI_PatNo",PatientNo,""))
		set Adm=$$GetAdmByPatientId(PatientId)
	}elseif (MedicareNo'="") {
		set PatientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(MedicareNo, "I", hospId, "")
		set Adm=$$GetAdmByPatientId(PatientId)
	}
	quit:((PatientId="")||(Adm="")) ""
    
	set Visitstatus=$p(^PAADM(Adm),"^",20)
    set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PatientId, "")
    set EncryptLevel=$p(PatEncryptLevel,"^",1)
    set PatLevel=$p(PatEncryptLevel,"^",2)
    set PatName=$p(^PAPER(PatientId,"ALL"),"^",1)
    set PatNo=$p(^PAPER(PatientId,"PAT",1),"^",1)
    set MrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Adm, "I", "")
    set Decease=##class(web.UDHCJFDischQuery).GetDeceaseStatus(PatientId, Adm)  //死亡状态
    set Deposit=##class(web.UDHCJFBaseCommon).deposit(Adm)
    set TotalAmountStr=##class(web.UDHCJFORDCHK).getpatshare(Adm)
    set TotalAmt=$p(TotalAmountStr,"^",1)
    set YBZFPay=$p(TotalAmountStr,"^",2)
    set ZFPay=$p(TotalAmountStr,"^",3)
    set DiscAmt=$p(TotalAmountStr,"^",4)
    set PayOrAmt=$p(TotalAmountStr,"^",5)
    set PatShareAmt=$p(TotalAmountStr,"^",6)
    set Balance=Deposit-PatShareAmt
    if (+YBZFPay'=0) {
	    set PatShareAmt=TotalAmt-YBZFPay
	    set Balance=Deposit-PatShareAmt
	}
    set Str=PatNo_"^"_PatName_"^"_Adm_"^"_Deposit_"^"_TotalAmt_"^"_Balance_"^"_MrNo_"^"_Decease_"^"_Visitstatus_"^"_ZFPay_"^"_YBZFPay_"^"_DiscAmt_"^"_PayOrAmt_"^"_PatShareAmt_"^"_PatientId_"^"_EncryptLevel_"^"_PatLevel
	
	quit Str
	
GetAdmByPatientId(papmi)
	set episodeId=""
	quit:(papmi="") episodeId
	
	set adm=""
	while($o(^PAPERdr(papmi,"ADM","I",adm),-1)&&(episodeId="")) {
		set adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		continue:(admHospDR'=hospId)
		set visitStatus=$p(^PAADM(adm),"^",20)
		continue:((" C P")[(" "_visitStatus_" "))
		set episodeId=adm
	}
	
    quit episodeId
}

/// Creator: tangtao
/// CreatDate: 2015-03-24
/// Description: 判断该就诊下是否有婴儿就诊且有未结算押金
/// Input: Adm:PA_Adm.RowId
/// Return:	0:否，1:是
/// Debug: w ##class(web.DHCIPBillCashier).JudgeBabyDeposit(5, 2)
ClassMethod JudgeBabyDeposit(Adm As %String, HospId As %String) As %String
{
	set rtn=0
	set cfgId=##class(web.DHCBillCommon).GetTarParaId(HospId)
	set newBornToMother=$s((+cfgId'=0):$p(^DHCTarC("CF",cfgId),"^",5),1:"")
	quit:(newBornToMother'="Y") rtn		//说明母婴账单分开不用判断婴儿是否存在押金
	
	set mother=$p(^PAADM(Adm),"^",75)
	if (mother'="") {
		//Adm是婴儿就诊
		set rtn=$$CheckAdmDeposit(Adm)
		quit:(+rtn) rtn
		
		set babyAdmStr=..GetBabyAdm(mother)
		for i=1:1:$l(babyAdmStr,"^") {
			set babyAdm=$p(babyAdmStr,"^",i)
			continue:((+babyAdm=0)||(babyAdm=Adm))
			set rtn=$$CheckAdmDeposit(babyAdm)
			quit:(+rtn)
		}
		quit rtn
	}
	
	//Adm是母亲就诊
	set babyAdmStr=..GetBabyAdm(Adm)
	for i=1:1:$l(babyAdmStr,"^") {
		set babyAdm=$p(babyAdmStr,"^",i)
		continue:(+babyAdm=0)
		set rtn=$$CheckAdmDeposit(babyAdm)
		quit:(+rtn)
	}
	
    quit rtn

CheckAdmDeposit(adm)
	set rtn=0
	set prtId=0
	while($o(^DHCSFPRINTDETAIL(0,"adm",adm,prtId))) {
		set prtId=$o(^DHCSFPRINTDETAIL(0,"adm",adm,prtId))
		set depData=$g(^DHCSFPRINTDETAIL(prtId))
		set prtstatus=$p(depData,"^",8)
		continue:(+prtstatus'=1)
		set paidFlag=$p(depData,"^",38)
		continue:(paidFlag="Y")
		set rtn=1
		quit
	}
	quit rtn
}

/// Description: 判断是否医保已上传
ClassMethod JudgePBInsuUpFlag(BillNo As %String, ExpStr As %String) As %String
{
	set rtn=##class(web.DHCINSUPort).GetInsuUpFlag(BillNo, ExpStr)
	quit +rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-01-25
/// Description: 判断医保结算是否已结算
/// Input: bill:DHC_PatientBill.RowId
/// Return: 0:医保未结算，1:自费患者或医保已结算
/// Debug: w ##class(web.DHCIPBillCashier).IsInsuDivided(282055)
ClassMethod IsInsuDivided(bill As %String) As %String
{
	set rtn=1
	quit:((+bill=0)||('$d(^DHCPB(bill)))) rtn
	set admReaDR=$p(^DHCPB(bill),"^",4)
	set nationalCode=$p(^PAC("ADMREA",admReaDR),"^",5)
	quit:(+nationalCode=0) rtn
	set tmp=##class(web.DHCINSUPort).CheckINSUDivFlag("", bill, "", "", "N")
	set flag=$p(tmp,"!",1)
	quit (flag="Y")
}

/// Description: 获取四舍五入分币误差
ClassMethod GetFBWCAmt(Amt As %String, HospId As %String) As %String
{
	set Amt=$fn(Amt,"",2)
	set RoundAmt=##class(web.DHCBillConsIF).OPCRound(Amt, HospId, "")
	set RoundErr=Amt-RoundAmt
	set RoundErr=$fn(RoundErr,"",2)
	quit RoundErr
}

/// Creator: zhangli
/// CreatDate: 2017-08-03
/// Description: 判断患者是否有转科
/// Input: adm:PA_Adm.RowId
/// Return: Y:是, N:否
/// Debug: w ##class(web.DHCIPBillCashier).GetTransLocFlag(9)
ClassMethod GetTransLocFlag(adm As %String) As %String
{
	set locStr=""
	set tmpLoc=""
	set chl=0
	while($o(^PAADM(adm,"TRANS",chl))) {
		set chl=$o(^PAADM(adm,"TRANS",chl))
		set data=$g(^PAADM(adm,"TRANS",chl))
		continue:(data="")
		set locDR=$p(^PAADM(adm,"TRANS",chl),"^",6)
 		continue:(locDR="")
 		if (locDR'=tmpLoc) {
	 		set locStr=$s((locStr=""):locDR,1:(locStr_"^"_locDR))
	 	}
		set tmpLoc=locDR
	}
  	
  	quit $s(($l(locStr,"^")>1):"Y",1:"N")
}

/// Creator: ZhYW
/// CreatDate: 2022-08-16
/// Description: 是否是使用押金找平后再结算模式
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->住院收费->是否使用押金找平后再结算
/// Debug: w ##class(web.DHCIPBillCashier).IsBalanceByDepMode(2)
ClassMethod IsBalanceByDepMode(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPChrg.SFSYYJZPHZJS", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: TianZJ
/// CreatDate: 2022-11-28
/// Description: 是否是就诊子类信息维护
/// Input: adm:PA_Adm.RowId, hospId:CT_Hospital.RowId
/// Return: 0:未维护就诊子类，非0：维护就诊子类
/// Others: 通用配置->住院收费系统->住院收费->就诊子类提醒内容维护
/// Debug: w ##class(web.DHCIPBillCashier).IsEpSubType(4, 2)
ClassMethod IsEpSubType(adm As %String, hospId As %String) As %String
{
	quit:(+adm=0) 0
	set subEpiType=$p(^PAADM(adm,1),"^",6)
	quit:(+subEpiType=0) 0
	set cfgJson=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPChrg.JZZLTXNRWH", "", subEpiType, hospId)
	set cgfData=##class(%DynamicObject).%FromJSON(cfgJson).data
	quit:(cgfData'="") -1_"^"_"就诊子类是："_$p(cgfData,"^",3)
	quit 0
}

/// Creator: TianZJ
/// CreatDate: 2022-11-29
/// Description: 获取住院医保审核标识
/// Input: adm:PA_Adm.RowId, bill:DHC_PatientBill.RowId, hospId:CT_Hospital.RowId
/// Return: 1:通过(允许住院结算)，0:未通过(不允许结算)
/// Others: 通用配置->住院收费系统->住院收费->住院结算审核模式
/// Debug: w ##class(web.DHCIPBillCashier).GetInsuCheckFlag("", "", "2")
ClassMethod GetInsuCheckFlag(adm As %String, bill As %String, hospId As %String) As %String
{
	quit:(+bill=0) 0
	
	set insTypeId=$p($g(^DHCPB(bill)),"^",4)
	quit:(+insTypeId=0) 0
	set nationalCode=$p($g(^PAC("ADMREA",insTypeId)),"^",5)
	quit:(+nationalCode=0) 1   //自费账单不需要医保审核
	
	//根据通用配置取审核标识
	//0:不启用审核、1：医保审核、2：医保智能审核
	set cfgJson=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPChrg.ZYJSYBSHMS", "", "", hospId)
	set cfgValue=##class(%DynamicObject).%FromJSON(cfgJson).value
	quit:(+cfgValue=0) 1
	
	if (cfgValue=1) {
		//调用医保审核方法
		set rtnValue=##class(web.DHCINSUPort).CheckAuditFlag(adm, bill, "")
		set auditFlag=$p(rtnValue,"^",1)
		quit (auditFlag="Y")
	}
	
	if (cfgValue=2) {
		//调用医保智能审核方法
		set rtnValue=##class(insuqc.service.ic.ServicePort).CheckMaybeDivFlag(adm, bill, "")
		set auditFlag=$p(rtnValue,"^",1)
		quit (auditFlag=1)
	}
	
	quit 0
}

/// Creator: TianZJ
/// CreatDate: 2022-11-28
/// Description: 获取费别对应押金不足不允许结算配置
/// Input: insTypeId:PAC_AdmReason.RowId, hospId:CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->住院收费->费别对应押金不足不允许结算
/// Debug: w ##class(web.DHCIPBillCashier).IsChrgInsTypeLowDepAmt(4, 2)
ClassMethod IsChrgInsTypeLowDepAmt(insTypeId As %String, hospId As %String) As %String
{
	set cfgJson=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPChrg.FBDYYJBZBYXJS", "", insTypeId, hospId)
	set cgfData=##class(%DynamicObject).%FromJSON(cfgJson).success
	quit (cgfData=1)
}

}
