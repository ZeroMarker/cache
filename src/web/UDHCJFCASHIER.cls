Import SQLUser

Class web.UDHCJFCASHIER Extends BILL.COM.Abstract
{

ClassMethod Judge(adm As %String)
{
	set num=0
 	quit:(+adm=0) 0
 	
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
	 	continue:(pbData="")
	 	set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(pb)
	 	continue:(prtRowId'="")
	 	set num=$i(num)
	}
 	quit num
}

/// 删除checkbox入参 新增 CurrentFlag: billed=未结算; paid=结算历史; tobill=新入院 , disch=最终结算 tangzf 2019-06-04
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFCASHIER","QryBillList","0000000373","000209","门转住","","2022-08-16","","","","","2")
Query QryBillList(regno As %String, medicareNo As %String, patientName As %String, frmdat As %String, todat As %String, loc As %String, insTypeId As %String, InvoiceNO As %String, CurrentFlag As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TpatientId:%String,Tregno:%String:登记号,Tzyno:%String:病案号,Tname:%String:患者姓名,Tadmdate:%String:入院日期,Tadmtime:%String:入院时间,Tadmno:%String:就诊号,Tinvno:%String:发票号,Ttotalamount:%Float:总费用,Tdiscountamount:%Float:折扣费用,Tpayorshare:%Float:记账费用,Tpatientshare:%Float:自付费用,Tamountpaid:%Float,TInsuPayAmt:%Float:医保金额,Tamounttopay:%Float:应收/应退金额,Tdischargestatus:%String:患者状态,TpayedFlag:%String:账单状态,TinsType:%String:费别,Tbillrowid:%String:账单ID,Tadm:%String:就诊ID,Trefund:%String:红冲标志,Tdischargedate:%String:结算日期,Tdischargetime:%String:结算时间,Tpatdisdate:%String:出院日期,Tpatdistime:%String:出院时间,Tdeposit:%Float:押金,Tloc:%String:科室,Tward:%String:病区,Tbed:%String:床号,Tadmuser:%String:办理入院人员,Tdisuser:%String:办理出院人员,Tpaidflag:%String:结算状态,Tadmdays:%String:住院天数,TPatBillDateFrom:%String:账单开始日期,TPatBillDateTo:%String:账单结束日期,TDecease:%String:出院状态,EncryptLevel:%String:密级,PatLevel:%String:级别")
{
}

ClassMethod QryBillListExecute(ByRef qHandle As %Binary, regno As %String, medicareNo As %String, patientName As %String, frmdat As %String, todat As %String, loc As %String, insTypeId As %String, InvoiceNO As %String, CurrentFlag As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryBillList")=$lb(regno, medicareNo, patientName, frmdat, todat, loc, insTypeId, InvoiceNO, CurrentFlag, hospId, langId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set frmdat=##class(websys.Conversions).DateHtmlToLogical(frmdat)
	set todat=##class(websys.Conversions).DateHtmlToLogical(todat)
	if (frmdat="") set frmdat=+$h-30
	if (todat="") set todat=+$h

	kill BillArray
	kill BabyAdmAry	      //主要用在通过婴儿找母亲时，多个婴儿的情况，使能通过一个婴儿找到另外的婴儿
	kill DoubleAdmAry
	
	set (flag1, flag2, flag3, flag4)=""
	if (CurrentFlag'="") {
		set flag1=$case(CurrentFlag,"billed":"Y",:"N") 	    //未结算
		set flag2=$case(CurrentFlag,"paid":"Y",:"N")	    //结算历史
		set flag3=$case(CurrentFlag,"tobill":"Y",:"N")	    //新入院
		set flag4=$case(CurrentFlag,"disch":"Y",:"N")	    //最终结算
	}
	
	if ((regno'="")||(medicareNo'="")||(patientName'="")||(InvoiceNO'="")) {
		if ((regno'="")||(medicareNo'="")||(patientName'="")) {
			kill patIdAry
			if (regno'="") {
				//按登记号查询
				set regno=##class(web.UDHCJFBaseCommon).regnocon(regno)
				set papmi=$o(^PAPERi("PAPMI_PatNo",regno,""))
				quit:(papmi="") $$$OK
				set patIdAry(papmi)=""
			}elseif (medicareNo'="") {
				//按病案号查询
				set papmi=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
				quit:(papmi="") $$$OK
				set patIdAry(papmi)=""
			}elseif (patientName'="") {
				//按姓名模糊查询
	   			do ##class(BILL.COM.PAPatMas).GetPatientByName(patientName, .patIdAry)
			}
			
			set papmi=0
			for  set papmi=$o(patIdAry(papmi)) quit:(papmi="")  do
			.set Adm=0
			.for  set Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) quit:(Adm="")  do
			..if ($$valAdm(Adm)=0) do
			...do Billa(Adm)
			...set BabyAdmAry(Adm)=Adm
			...set BabyAdmRowID=..GetBabyAdm(Adm)
			...if (BabyAdmRowID'="") do
			....for lm=1:1:$l(BabyAdmRowID,"^") do
			.....set BabyAdm=$p(BabyAdmRowID,"^",lm)
			.....quit:(BabyAdm="")
			.....quit:$d(BabyAdmAry(BabyAdm))
			.....do Billa(BabyAdm)
		   	.....if (BabyAdm'="") set BabyAdmAry(BabyAdm)=""
		   	...set MotherAdmRowID=..GetMotherAdm(Adm)
		   	...if (MotherAdmRowID'="") do
		   	....quit:$d(BabyAdmAry(MotherAdmRowID))
		   	....do Billa(MotherAdmRowID)
		   	....set BabyAdmAry(MotherAdmRowID)=MotherAdmRowID
		   	....set BabyAdmRowID=..GetBabyAdm(MotherAdmRowID)
		   	....if (BabyAdmRowID'="") do
		   	.....for lm=1:1:$l(BabyAdmRowID,"^") do
		   	......set BabyAdm=$p(BabyAdmRowID,"^",lm)
			......quit:(BabyAdm="")
		   	......quit:$d(BabyAdmAry(BabyAdm))
		   	......do Billa(BabyAdm)
		   	......set BabyAdmAry(BabyAdm)=""
		   	
		   	quit $$$OK
		}
		
		if (InvoiceNO'="") {
			set invrowid=$o(^DHCINVPRTZY(0,"INV",InvoiceNO,""))
			quit:(invrowid="") $$$OK

		 	set Adm=$p(^DHCINVPRTZY(invrowid),"^",4)
		 	if ($$valAdm(Adm)=0) do
		 	.do Billa(Adm)
		 	.set BabyAdmAry(Adm)=Adm
			.set BabyAdmRowID=..GetBabyAdm(Adm)
			.if (BabyAdmRowID'="") do
			..for lm=1:1:$l(BabyAdmRowID,"^") do
			...set BabyAdm=$p(BabyAdmRowID,"^",lm)
			...quit:(BabyAdm="")
			...quit:$d(BabyAdmAry(BabyAdm))
			...do Billa(BabyAdm)
			...set BabyAdmAry(BabyAdm)=""
			
			quit $$$OK
		}
	}
	quit:(CurrentFlag="") $$$OK    //+2022-08-16 ZhYW 结算状态为"全部"时，不能无条件查询
	
   	i (((flag2'="Y")&&(flag4'="Y"))||(flag1="Y")) d
   	.f AdmDate=frmdat:1:todat  d
   	..s AdmTime=""
   	..f  s AdmTime=$o(^PAADMi("TypeDate","I",AdmDate,AdmTime)) q:(AdmTime="")  d
   	...s Adm=0
   	...f  s Adm=$o(^PAADMi("TypeDate","I",AdmDate,AdmTime,Adm)) q:(Adm="")  d
   	....q:$d(BabyAdmAry(Adm))     //避免婴儿记录重复 add zhli 2017-09-19
   	....i ($$valAdm(Adm)=0)  d
   	.....d Billa(Adm)
   	.....s BabyAdmAry(Adm)=Adm
   	.....s BabyAdmRowID=..GetBabyAdm(Adm)
   	.....i (BabyAdmRowID'="") d
   	......f lm=1:1:$l(BabyAdmRowID,"^")  d
   	.......s BabyAdm=$p(BabyAdmRowID,"^",lm)
   	.......q:(BabyAdm="")
   	.......q:$d(BabyAdmAry(BabyAdm))
   	.......d Billa(BabyAdm)
   	.......s BabyAdmAry(BabyAdm)=""
   	e  i (flag2="Y") d
   	.f AdmDate=frmdat:1:todat  d
   	..s prtrowid=0
   	..f  s prtrowid=$o(^DHCINVPRTZY(0,"DATE",AdmDate,prtrowid)) q:(prtrowid="")  d
   	...s Adm=$p(^DHCINVPRTZY(prtrowid),"^",4)
   	...q:($d(DoubleAdmAry(Adm)))
   	...q:$d(BabyAdmAry(Adm))      //避免婴儿记录重复 add zhli 2017-09-19
   	...i ($$valAdm(Adm)=0) d
   	....s DoubleAdmAry(Adm)=""
   	....d Billa(Adm)
   	....s BabyAdmAry(Adm)=Adm
   	....s BabyAdmRowID=..GetBabyAdm(Adm)
   	....i (BabyAdmRowID'="") d
   	.....f lm=1:1:$l(BabyAdmRowID,"^") d
	......s BabyAdm=$p(BabyAdmRowID,"^",lm)
 	......q:(BabyAdm="")
   	......q:$d(BabyAdmAry(BabyAdm))
   	......d Billa(BabyAdm)
   	......s BabyAdmAry(BabyAdm)=""
   	..//增加封账记录
   	..s AcountTime=""
   	..f  s AcountTime=$o(^DHCIPBill("PatientBill",0,"accountrec",AdmDate,AcountTime)) q:(AcountTime="")  d
   	...s AcountAdm=""
   	...f  s AcountAdm=$o(^DHCIPBill("PatientBill",0,"accountrec",AdmDate,AcountTime,AcountAdm)) q:(AcountAdm="")  d
   	....q:($d(DoubleAdmAry(AcountAdm)))
   	....i $$valAdm(AcountAdm)=0 d
   	.....s DoubleAdmAry(AcountAdm)=""
   	.....q:$d(BabyAdmAry(AcountAdm))
   	.....d Billa(AcountAdm)
   	.....s BabyAdmAry(AcountAdm)=AcountAdm
   	.....s BabyAdmRowID=..GetBabyAdm(AcountAdm)
   	.....i (BabyAdmRowID'="") d
   	......f lm=1:1:$l(BabyAdmRowID,"^") d
   	.......s BabyAdm=$p(BabyAdmRowID,"^",lm)
 	.......q:(BabyAdm="")
   	.......q:$d(BabyAdmAry(BabyAdm))
	.......d Billa(BabyAdm)
   	.......s BabyAdmAry(BabyAdm)=""
   	e  i (flag4="Y") d
   	.f DisDate=frmdat:1:todat  d
   	..s Adm=0
   	..f  s Adm=$o(^PAADMi("DischDate",DisDate,Adm)) q:(Adm="")  d
   	...q:$d(BabyAdmAry(Adm))    //避免婴儿记录重复 add zhli 2017-09-19
   	...i ($$valAdm(Adm)=0) d
   	....d Billa(Adm)
   	....s BabyAdmAry(Adm)=Adm
   	....s BabyAdmRowID=..GetBabyAdm(Adm)
   	....i (BabyAdmRowID'="") d
   	.....f lm=1:1:$l(BabyAdmRowID,"^") d
   	......s BabyAdm=$p(BabyAdmRowID,"^",lm)
 	......q:(BabyAdm="")
   	......q:$d(BabyAdmAry(BabyAdm))
   	......d Billa(BabyAdm)
   	......s BabyAdmAry(BabyAdm)=""
   
	quit $$$OK
   
Billa(Adm)
	s Bill=0
	f  s Bill=$o(^DHCPB(0,"ADM",+Adm,Bill)) q:(Bill="")  d
	.s valBill=$$valBill(Bill)  ;1-valid,0-not valid
	.i (valBill) d
 	..q:$d(BillArray(Bill))
 	..s BillArray(Bill)=""
 	..d selBill(Bill,Adm)
 	i (((flag3="Y")||(CurrentFlag=""))&&('$d(^DHCPB(0,"ADM",+Adm))))  d selBill("", Adm)
 	q
                   
valAdm(adm)	;check if Admission is valid for search criteria 0-valid,1-not valid
	set admData=$g(^PAADM(+adm))
	set loc1=$p(admData,"^",4)
	set admType=$p(admData,"^",2)
	quit:(admType'="I") 1
	if (loc), (loc-loc1) quit 1
	set AdmDep=$p(admData,"^",4)
	set AdmDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDep)
	quit:((hospId'=AdmDepHosDr)&&(AdmDepHosDr'="")&&(hospId'="")) 1
	
	quit 0
	
valBill(bill)	;check if Bill is valid for search criteria 1-valid,0-not valid
	set pbData=$g(^DHCPB(+bill))
	set adm=+$p(pbData,"^",1)
	set refundflag=$p(pbData,"^",17)
	set visitStatus=$p($g(^PAADM(adm)),"^",20)
	set fprowid=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(+bill)
	set paid=$s((+fprowid'=0):"P",1:"B")
	set prtInvData=$s((+fprowid'=0):$g(^DHCINVPRTZY(fprowid)),1:"")
	set amount=$p(prtInvData,"^",6)
	set prtFlag=$p(prtInvData,"^",8)
	set prtInvNo=$p(prtInvData,"^",1)

	if ((InvoiceNO'="")&&(InvoiceNO'=prtInvNo)) quit 0
    if ((fprowid="")&&(refundflag'="")) quit 0
	if ((prtFlag="A")&&(+amount<0)) quit 0
	
	if (CurrentFlag="") quit 1   //+2022-08-16 ZhYW 查询全部
	if flag1="N",flag2="N",flag4="N" quit 0
	if flag1="Y",paid="B" quit 1
	if flag2="Y",paid="P" quit 1
	//if flag4="Y",paid="B" quit 1
	if flag4="Y",visitStatus="D" quit 1
	
	quit 0
selBill(Bill, Adm)
	set visitstatus=$p($g(^PAADM(Adm)),"^",20)
	quit:((" P C ")[(" "_visitstatus_" "))   //+2018-07-03 ZhYW 增加预住院就诊退出

	set patientid=$p($g(^PAADM(Adm)),"^",1)
	set regNo=$p($g(^PAPER(patientid,"PAT",1)),"^",1)
	set patName=$p($g(^PAPER(patientid,"ALL")),"^",1)
	set decease=##class(web.UDHCJFDischQuery).GetDeceaseStatus(patientid, Adm, langId)

	//add by lml 2015-01-15 增加病人密级和级别
    set PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(patientid, "")
    set EncryptLevel=$p(PatEncryptLevel,"^",1)
    set PatLevel=$p(PatEncryptLevel,"^",2)
    
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Adm, "I", "")
	set admno=$p(^PAADM(Adm),"^",81)
	set deptDR=$p($g(^PAADM(Adm)),"^",4)
	set dept=$s((deptDR'=""):$p(^CTLOC(deptDR),"^",2),1:"")
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
	
	set admuserDR=$p($g(^PAADM(Adm)),"^",43)
	set admuser=$s((+admuserDR'=0):$p(^SSU("SSUSR",admuserDR),"^",2),1:"")   //办理入院的收费员
	set admuser=##class(User.SSUser).GetTranByDesc("SSUSRName", admuser, langId)
	set wardDR=$p($g(^PAADM(Adm)),"^",70)
	set ward=$s((wardDR'=""):$p(^PAWARD(wardDR),"^",2),1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set bedCode=##class(DHCBillCommon).GetPatBedCode(Adm)
	
	set PBData=$s((+Bill'=0):$g(^DHCPB(Bill)),1:"")
	set insTypeDR=$p(PBData,"^",4)	   //Lid 取账单上的费别
	if (insTypeDR="") {
		set insTypeDR=$p($g(^PAADM(Adm,1)),"^",7)
	}
	quit:((insTypeId'="")&&(insTypeId'=insTypeDR))
	set insType=$s((+insTypeDR'=0):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
	set totpat=$p(PBData,"^",8)        //总费用
	set totpat=$fn(totpat,"",2)
	set distot=$p(PBData,"^",9)        //折扣费用
	set distot=$fn(distot,"",2)
	set payshtot=$p(PBData,"^",11)     //记账费用
	set payshtot=$fn(payshtot,"",2)
	set payshtot=$fn(payshtot,"",2)
	set patshtot=$p(PBData,"^",12)     //自付费用
	set patshtot=$fn(patshtot,"",2)
	set amtpytot=$p(PBData,"^",13)     //实际付款 PB_AmountPaid
	set amtpytot=$fn(amtpytot,"",2)
	
	set amttptot=$p(PBData,"^",14)     //应付款  PB_AmountToPay
	set payedFlag=$p(PBData,"^",16)    //账单状态 PB_PayedFlag
	
	set billrefund=$p(PBData,"^",17)   //PB_RefundFlag
	set DateFrom=$p(PBData,"^",6)      //PB_DateFrom
	set DateFrom=##class(websys.Conversions).DateLogicalToHtml(DateFrom)
	set DateTo=$p(PBData,"^",7)        //PB_DateTo
	set DateTo=##class(websys.Conversions).DateLogicalToHtml(DateTo)
	set paidflag=""
	set invno=""
	set prtrowid=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(+Bill)
	if (prtrowid'="") {
		set prtInvData=$g(^DHCINVPRTZY(prtrowid))
		set prtFlag=$p(prtInvData,"^",8)
		set paidflag=$case(prtFlag,"I":"中途结算","N":"出院结算","A":"发票作废","S":"发票红冲",:"")
		set invno=$p(prtInvData,"^",1)
		set deposit=$p(prtInvData,"^",22)   //yyx 2009-11-10
		set deposit=$fn(deposit,"",2)
	}else {
		set paidflag="未结算"
		set isClosedAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(Bill)
		if (isClosedAcount="Y") set paidflag="已封账"
		set deposit=##class(web.UDHCJFBaseCommon).deposit(Adm)     //modify 2018-08-12 ZhYW 测试组提出显示全部的未结算押金
	}
	quit:((InvoiceNO'="")&&(InvoiceNO'=invno))
	set paidflag=##class(websys.Translation).Get("", paidflag, langId)
	
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(Adm)
	set admDays=$p(admInOutDateInfo,"^",3)
	set disch=$p(admInOutDateInfo,"^",4)
	set admdate=$p(admInOutDateInfo,"^",5)
	set admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
	set admtime=$p(admInOutDateInfo,"^",6)
	set admtime=##class(websys.Conversions).TimeLogicalToHtml(admtime)
	set disdate=$p(admInOutDateInfo,"^",7)
	set disdate=##class(websys.Conversions).DateLogicalToHtml(disdate)
	set distime=$p(admInOutDateInfo,"^",8)
	set distime=##class(websys.Conversions).TimeLogicalToHtml(distime)
	
	//2017-12-01 取医保信息 zhli
	set insuSelfAmt=patshtot
	set insuPayAmt=0
	set nationalCode=$p(^PAC("ADMREA",insTypeDR),"^",5)
	if (nationalCode>0) {
		set insuInfo=##class(web.DHCINSUPort).GetDivideByPBDr("", Bill)
		if (insuInfo'="") {
			set divInfo=$p(insuInfo,"!^",2)
			set insuTotalAmt=$p(divInfo,"^",7)         //医保总金额
			set insuSelfAmt=$p(divInfo,"^",15)         //医保自付(医保现金)
			set insuSelfAmt=$fn(insuSelfAmt,"",2)
			set insuPayAmt=insuTotalAmt-insuSelfAmt      //医保支付金额
		}
	}
	set insuPayAmt=$fn(insuPayAmt,"",2)
	set amttptot=insuSelfAmt-deposit    //应收/应退金额
	set amttptot=$fn(amttptot,"",2)

	set disuser=""
	set dischargedate=""
	set dischargetime=""
	if (prtrowid'="") {
		set prtDate=$p(^DHCINVPRTZY(prtrowid),"^",2)
		set prtTime=$p(^DHCINVPRTZY(prtrowid),"^",3)
		set dischargedate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
		set dischargetime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
		//取就诊表最终结算人员 ShangXuehao
		set disuserDR=$p($g(^PAADM(Adm)),"^",19)
		set disuser=$s((+disuserDR'=0):$p($g(^CTPCP(disuserDR,1)),"^",2),1:"")
		set disuser=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", disuser, langId)
	}
	
	do OutputBillList
	
	quit
OutputBillList
	set Data=$lb(patientid,regNo,mrNo,patName,admdate,admtime,admno,invno,totpat,distot,payshtot,patshtot,amtpytot,insuPayAmt,amttptot,disch,payedFlag,insType,Bill,Adm,billrefund,dischargedate,dischargetime,disdate,distime,deposit,dept,ward,bedCode,admuser,disuser,paidflag,admDays,DateFrom,DateTo,decease,EncryptLevel,PatLevel)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Description: 根据母亲就诊取婴儿的就诊
ClassMethod GetBabyAdm(MotherAdm As %String)
{
	set BabyAdmRowIDstr=""
	set BabyAdmRowID=0
	while($o(^PAADMi("Mother",MotherAdm,BabyAdmRowID))) {
		set BabyAdmRowID=$o(^PAADMi("Mother",MotherAdm,BabyAdmRowID))
		set BabyAdmRowIDstr=$s((BabyAdmRowIDstr=""):BabyAdmRowID,1:(BabyAdmRowIDstr_"^"_BabyAdmRowID))
	}
	quit BabyAdmRowIDstr
}

/// Description: 根据婴儿的就诊取母亲的就诊
ClassMethod GetMotherAdm(BabyAdm As %String)
{
	quit:(+BabyAdm=0) ""
	set MotherAdm=$p(^PAADM(BabyAdm),"^",75)
	quit MotherAdm
}

/// Debug: w ##class(web.UDHCJFCASHIER).GetPatInfo()
ClassMethod GetPatInfo(patientNo As %String, medicareNo As %String, hospId As %String) As %String
{
    set patientId=""
    if (patientNo'="") {
	    set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
	    set patientId=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
    }elseif (medicareNo'="") {
		set patientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
    }
	quit:(patientId="") {}.%ToJSON()
	
	quit ##class(BILL.COM.PAPatMas).GetPatientInfo(patientId, hospId)
}

}
