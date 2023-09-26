Import SQLUser

/// Creator: Lid
/// CreatDate: 2014-12-20
/// Description: 重新账单NOLOCK版
Class web.UDHCJFREBILL2NoLock Extends BILL.COM.Abstract [ Not ProcedureBlock ]
{

ClassMethod BILL(Adm As %String, BillUser As %String) As %String [ ProcedureBlock = 1 ]
{
	set $zt="ERROR"
	quit:(Adm="") -1_"^"_"参数错误"
	set AdmType=$p(^PAADM(Adm),"^",2)
    quit:(AdmType'="I") 0
    	
	set BabyInfo=##class(web.UDHCJFORDCHK).GetMotherAdmByBabyAdm(Adm)
	set BabyFlag=$p(BabyInfo,"^",1)
	set MotherAdm=$p(BabyInfo,"^",2)
	if (BabyFlag="true") set Adm=MotherAdm
	
	if (BillUser="") set BillUser=1
	
	//+2022-10-09 ZhYW 改为使用系统锁
    set LockErr=##class(DHCDoc.Util.System).LOCK("PA_Adm", Adm, BillUser, $zu(67,15,$j))
	quit:(+LockErr'=-1) -110_"^"_##class(websys.Translation).Get("", "就诊")_"："_Adm_##class(websys.Translation).Get("", "被锁定")

	set RtnValue=..BILLC(Adm, BillUser)
	
	do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", Adm)
	
	quit RtnValue
	
ERROR
	quit ..AppException()
}

ClassMethod BILLC(Adm As %String, BillUser As %String) As %String [ ProcedureBlock = 1 ]
{
	kill ^||TMP("IB",BillUser,$j)
	
	//Get Patient Admission Details
	set AdmDep=$p($g(^PAADM(Adm)),"^",4)
	set PatType=$p($g(^PAADM(Adm,1)),"^",6)
	set InsType=$p($g(^PAADM(Adm,1)),"^",7)
	
	//Get Patient Admission OEORD
	set Ord=$o(^OEORD(0,"Adm",Adm,""))
	
	if (+Ord'=0) {
		set LockErr=##class(DHCDoc.Util.System).LOCK("OE_Order", Ord, BillUser, $zu(67,15,$j))
		quit:(+LockErr'=-1) -110_"^"_"医嘱："_Ord_"被锁定"
	}
	
	set OrdFrom=+$h, OrdEnd=0
	//Calculate Order
	set Count=##class(web.UDHCJFREBILL2).ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser)
	
	//+2019-07-23 ZhYW 急诊转住院医嘱账单
	set OPAdm=""
	for  set OPAdm=$o(^DHCOPIPADMCON(0,"IPADM",Adm,"OPADM",OPAdm),-1)  quit:(OPAdm="")  do
	.set Ord=""
	.set OCIId=""
	.for  set OCIId=$o(^DHCOPIPADMCON(0,"IPADM",Adm,"OPADM",OPAdm,OCIId),-1)  quit:((OCIId="")||(Ord'=""))  do
	..set OCIData=$g(^DHCOPIPADMCON(OCIId))
	..set Status=$p(OCIData,"^",7)
	..quit:(Status'="N")
	..set Ord=$o(^OEORD(0,"Adm",OPAdm,""))
	.quit:(Ord="")
	.set Count=Count+##class(web.UDHCJFREBILL2).ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser)

	//Calculate NewBorn Order to Mother
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDep)
	set Conf=##class(web.DHCBillCommon).GetTarParaId(HospDR)
	if ($d(^PAADMi("Mother",Adm)))&&($p(^DHCTarC("CF",Conf),"^",5)="Y") do
	.set babyAdm=""
	.for  set babyAdm=$o(^PAADMi("Mother",Adm,babyAdm)) quit:(babyAdm="")  do
	..//+2019-07-23 ZhYW 婴儿急诊转住院医嘱
	..set OPAdm=""
	..for  set OPAdm=$o(^DHCOPIPADMCON(0,"IPADM",babyAdm,"OPADM",OPAdm),-1)  quit:(OPAdm="")  do
	...set Ord=""
	...set OCIId=""
	...for  set OCIId=$o(^DHCOPIPADMCON(0,"IPADM",babyAdm,"OPADM",OPAdm,OCIId),-1)  quit:((OCIId="")||(Ord'=""))  do
	....set OCIData=$g(^DHCOPIPADMCON(OCIId))
	....set Status=$p(OCIData,"^",7)
	....quit:(Status'="N")
	....set Ord=$o(^OEORD(0,"Adm",OPAdm,""))
	...quit:(Ord="")
	...set Count=Count+##class(web.UDHCJFREBILL2).ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser)
	..//婴儿医嘱
	..set Ord=$o(^OEORD(0,"Adm",babyAdm,""))
	..quit:(Ord="")
	..set Count=Count+##class(web.UDHCJFREBILL2).ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser)
	
	//Insert DHC_PatientBill
	if (Count>0) do
	.set RtnValue=..PBORD(Adm, OrdFrom, OrdEnd, BillUser)
	else  do
	.set PBRowID=""
	.set PB=0
	.for  set PB=$o(^DHCPB(0,"ADM",Adm,PB)) quit:((PB="")||(PBRowID'=""))  do
	..quit:($p(^DHCPB(PB),"^",16)="P")
	..set PBRowID=PB
	.set RtnValue=0_"^"_PBRowID

	kill ^||TMP("IB",BillUser,$j)
	
	if (+Ord'=0) {
		do ##class(DHCDoc.Util.System).LOCKCLR("OE_Order", Ord)
	}
	
	quit RtnValue
}

ClassMethod PBOADD(PBO, OEORE, BillUser)
{
	new (PBO, OEORE, BillUser)
    if (PBO="") quit 0_"^"_0_"^"_0_"^"_0_"^"_0
    
	//2016-07-23 Lid 预约检查类医嘱，不按原来的单价计费。
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
	quit:(isAppRep="Y") 0_"^"_0_"^"_0_"^"_0_"^"_0
	
	set OldPBOData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2)))
	set OldQty=+$p(OldPBOData,"^",5)
	set RefundQty=+$p(OldPBOData,"^",6)
	set JFQty=OldQty+RefundQty
	set NewQty=+$p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"QTY"),"^",1)
	set Qty=NewQty-JFQty
	set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"QTY"),"^",1)=Qty
	
	set ArcimRowID=$p(^OEORD($p(OEORE,"||",1),"I",$p(OEORE,"||",2),1),"^",2)
	set IsHourOrd=##class(BILL.IP.COM.Method).IsBilledByHourOrd($p(OEORE,"||",1,2))   //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
	
	if ((Qty=0)&&(IsHourOrd'=1)) {
		quit 0_"^"_0_"^"_0_"^"_0_"^"_0
	}
	if (Qty<0) set Status="R"
	else  set Status="B"
	
	//modfiy 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	set NegativeNum=JFQty+Qty
	if (NegativeNum<0) {
		set Adm=$p($g(^DHCPB(+PBO)),"^",1)
		set AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
		set IsIntArcim=##class(web.UDHCJFIntBill).JudgeArcIsorNot(ArcimRowID, AdmHospDR)
		quit:(IsIntArcim=0) 0
	}
	
	set OldTotalAmount=$p(OldPBOData,"^",8)
	set OldDiscAmount=$p(OldPBOData,"^",9)
	set OldPayorShare=$p(OldPBOData,"^",10)
	set OldPatientShare=$p(OldPBOData,"^",11)

	set err=..PBOUPD(PBO, OEORE, Status, BillUser) 
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0

	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORE, 2)
	if (ordCateType="R") {
		set Itm=""
		for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set dspDr=""
		.for  set dspDr=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr)) quit:((dspDr="")||(+err))  do
		..set dspbSub=""
		..for  set dspbSub=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)) quit:((dspbSub="")||(+err))  do
		...set dspbDr=dspDr_"||"_dspbSub
		...set rtn=##class(web.UDHCJFBILLIPNoLock).PBODINS(PBO, OEORE, Itm, Status, BillUser, dspbDr)
		...set err=$p(rtn,"^",1)
		
		if (+err=0) {
			set rtn=##class(web.UDHCJFBILLIPNoLock).PBOUpdateByPBD(PBO)
			set err=$p(rtn,"^",1)
		}
	}else {
		set Itm=""
		for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set Olt=""
		.for  set Olt=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
		..set rtn=##class(web.UDHCJFBILLIPNoLock).PBODINS(PBO, OEORE, Itm, Status, BillUser, "", Olt)
		..set err=$p(rtn,"^",1)
	}
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//+2022-11-02 ZhYW
	set err=##class(web.UDHCJFBILLIPNoLock).AdjustPatBillOrder(PBO)
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//modify 2012-6-5 退费时当DHC_PatBillOrder 表PBO_TotalAmount为负数时不能更新
	set BillStatus=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)
	if (BillStatus'="R") {
		if (IsHourOrd'=1) {
			set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)=Status
		}
		if (BillStatus="TB") {
			set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="B"
		}
		if (BillStatus="I") {
			set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
		}
	}
	
	set PBOData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2)))
	set TotalAmount=$p(PBOData,"^",8)
	set DiscAmount=$p(PBOData,"^",9)
	set PayorShare=$p(PBOData,"^",10)
	set PatientShare=$p(PBOData,"^",11)
	//计算变化值
	set TotalAmount=TotalAmount-OldTotalAmount
	set DiscAmount=DiscAmount-OldDiscAmount
	set PayorShare=PayorShare-OldPayorShare
	set PatientShare=PatientShare-OldPatientShare

	quit err_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatientShare
}

ClassMethod PBODEL(PBO, BillUser)
{
	new (PBO, BillUser)
	
	do ##class(web.UDHCJFREBILL2).SetDetPatBillDetails(PBO)
	set err=##class(web.UDHCJFPBONoLock).SELECT(PBO)
	quit:(+err) err_"^0^0^0^0"
	set TotalAmount=-PLIST(8)
	set DiscAmount=-PLIST(9)
	set PayorShare=-PLIST(10)
	set PatientShare=-PLIST(11)
	set err=##class(web.UDHCJFPBONoLock).PBODEL(PBO)
	quit:(+err) err_"^0^0^0^0"
	
	quit err_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatientShare
}

/// 判断执行记录在DHC_PatBillOrder是否有记录，如果有记录则直接插入收费项目的记录即可，并修改DHC_PatBillOrder的金额
/// 如果没有则 记录则直接插入并插入DHC_PatBillDetails表，同时更新DHC_PatBillOrder的金额
/// DHC_PatBillOrder里不再保存单价，只保存数量和金额
ClassMethod PBOINS(BILL, OEORE, BillUser, PBO)
{
	new (BILL, OEORE, BillUser, PBO)
	quit:(OEORE="") 0_"^"_0_"^"_0_"^"_0_"^"_0
	
	set PriceStr=$g(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"PRICE"))
	set UnitPrice=$p(PriceStr,"^",1)
	set DiscPrice=$p(PriceStr,"^",2)
	set InsPrice=$p(PriceStr,"^",3)
	set PatPrice=$p(PriceStr,"^",4)
	
	set Qty=$p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"QTY"),"^",1)
	
	set ArcimRowID=$p(^OEORD($p(OEORE,"||",1),"I",$p(OEORE,"||",2),1),"^",2)
	set BillPriceDate=$p($g(^OEORD($p(OEORE,"||",1),"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3))),"^",47)   //OEORE_BillPriceDate
	set BillPriceTime=$p($g(^OEORD($p(OEORE,"||",1),"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3))),"^",48)   //OEORE_BillPriceTime
	
	//modify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	if (Qty<0) {
		set Adm=$p($g(^DHCPB(+BILL)),"^",1)
		set AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
		set IsIntArcim=##class(web.UDHCJFIntBill).JudgeArcIsorNot(ArcimRowID, AdmHospDR)
		quit:(IsIntArcim=0) 0_"^"_0_"^"_0_"^"_0_"^"_0
	}
	
	if (PBO="") {
		kill PLIST
		set PLIST(0)=BILL
		set PLIST(3)=ArcimRowID
		set PLIST(4)=$p(OEORE,"||",1,2)  ;PBO_OEORI_DR
		set PLIST(5)=UnitPrice
		//modify 2014-12-20 将账单order表计费方式改为老账单计费模式，账单表不平时再调平
		set PLIST(6)=Qty
		set PLIST(8)=+..round(UnitPrice*Qty)
		set PLIST(9)=+..round(DiscPrice*Qty)
		set PLIST(10)=+..round(InsPrice*Qty)
		set PLIST(11)=PLIST(8)-PLIST(9)-PLIST(10)
		//
		set PLIST(12)=BillPriceDate
		set PLIST(13)=BillPriceTime
		set PLIST(17)=+DiscPrice
		set PLIST(18)=+InsPrice
		set PLIST(19)=+PatPrice
		set PLIST(20)=OEORE       ;保存执行记录的数据
		set err=##class(web.UDHCJFPBONoLock).INSERT()
		set PBO=$g(%ROWID)
	}
    
    set Status="B"
    
 	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORE, 2)
	if (ordCateType="R") {
		set Itm=""
		for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set dspDr=""
		.for  set dspDr=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr)) quit:((dspDr="")||(+err))  do
		..set dspbSub=""
		..for  set dspbSub=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)) quit:((dspbSub="")||(+err))  do
		...set dspbDr=dspDr_"||"_dspbSub
		...set rtn=##class(web.UDHCJFBILLIPNoLock).PBODINS(PBO, OEORE, Itm, Status, BillUser, dspbDr)
		...set err=$p(rtn,"^",1)

		if (+err=0) {
			set rtn=##class(web.UDHCJFBILLIPNoLock).PBOUpdateByPBD(PBO)
			set err=$p(rtn,"^",1)
		}
	}else {
		set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
		if (isAppRep="Y") {
			set Itm=""
			for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
			.set rtn=##class(web.UDHCJFBILLIPNoLock).PBODINS(PBO, OEORE, Itm, Status, BillUser)
			.set err=$p(rtn,"^",1)
		}else {
			set Itm=""
			for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
			.set Olt=""
			.for  set Olt=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
			..set rtn=##class(web.UDHCJFBILLIPNoLock).PBODINS(PBO, OEORE, Itm, Status, BillUser, "", Olt)
			..set err=$p(rtn,"^",1)
		}
	}
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//+2022-11-02 ZhYW
	set err=##class(web.UDHCJFBILLIPNoLock).AdjustPatBillOrder(PBO)
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3),"BILL"),"^",2)=PBO  
	
	set IsHourOrd=##class(BILL.IP.COM.Method).IsBilledByHourOrd($p(OEORE,"||",1,2))   //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
	
	set BillStatus=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)
	if (BillStatus'="R") {
		if (IsHourOrd'=1) {
			if (BillStatus="I") {
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="I"
			}else {
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="B"
			}
			if (+Qty=0) {
				//Lid 2017-04-13 数量为0，认为是作废后，重新生成账单,执行记录的账单状态改为R
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
			}
		}else {
			if (BillStatus="I") {
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
			}else {
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="B"
			}
		}
	}
	
	//2016-07-19 Lid 更新预约检查申请单明细表的账单状态
	set err=##class(web.UDHCJFBILLIPNoLock).UpdateAppRepTarItmBillStatus($p(OEORE,"||",1,2), "TB", "B", OEORE)
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	set PBOData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2)))
	set TotalAmount=$p(PBOData,"^",8)
	set DiscAmount=$p(PBOData,"^",9)
	set PayorShare=$p(PBOData,"^",10)
	set PatientShare=$p(PBOData,"^",11)

	quit err_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatientShare
}

ClassMethod PBORD(Adm, OrdFrom, OrdEnd, BillUser)
{
	set $zt="ERROR^DHCSSERR"
	new (Adm, OrdFrom, OrdEnd, BillUser)

	set rtn=0
	
	ts

	set Error=0
	set PBRowID=""
	
	set PB=0
	while($o(^DHCPB(0,"ADM",Adm,PB))) {
		set PB=$o(^DHCPB(0,"ADM",Adm,PB))
		set PBData=$g(^DHCPB(PB))
		set PayedFlag=$p(PBData,"^",16)
		continue:(PayedFlag="P")
		set PBRowID=PB
		quit
	}
	if (PBRowID="") {
	    set rtnValue=##class(web.UDHCJFPB).PBINS(Adm, BillUser)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		set PBRowID=$p(rtnValue,"^",2)
	}
		
	set Tot=0, TotDisc=0, TotIns=0, TotPat=0
	set OEORE=""
	for  set OEORE=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE)) quit:((OEORE="")||(+rtn))  do
	.set BillFlag=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)    //执行记录的计费状态
	.set PBO=""
	.set OrdSub=""
	.for  set OrdSub=$o(^DHCPB(0,"OEEXC",OEORE,PBRowID,OrdSub)) quit:((OrdSub="")||(PBO'=""))  do
	..quit:($p(^DHCPB(PBRowID,"O",OrdSub),"^",14)="Y")
	..set PBO=PBRowID_"||"_OrdSub
	.;
    .set IsHourOrd=##class(BILL.IP.COM.Method).IsBilledByHourOrd($p(OEORE,"||",1,2))   //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
	.//按小时计费的允许部分退费，否则不允许部分退费
	.if (IsHourOrd=1) do
	..set BillFlag="TB"
	.;
	.if ((BillFlag="TB")&&(PBO'="")) do
	..set rtnValue=..PBODEL(PBO, BillUser)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ##class(web.UDHCJFBILLIP).PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	..set PBO=""
	.;
	.if (BillFlag="TB") do
	..set rtnValue=..PBOINS(PBRowID, OEORE, BillUser, PBO)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ##class(web.UDHCJFBILLIP).PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
    .if ((BillFlag="B")&&(PBO'="")) do
	..set rtnValue=..PBODEL(PBO, BillUser)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ##class(web.UDHCJFBILLIP).PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	..set PBO=""
	.;
	.if (BillFlag="B") do
	..set rtnValue=..PBOINS(PBRowID, OEORE, BillUser, PBO)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ##class(web.UDHCJFBILLIP).PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
    .if ((BillFlag="I")&&(PBO="")) do
	..set rtnValue=..PBOINS(PBRowID, OEORE, BillUser, PBO)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ##class(web.UDHCJFBILLIP).PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.if ((BillFlag="I")&&(PBO'="")) do
	..do ##class(web.UDHCJFBILLIP).SetItmPrice(OEORE, PBO, BillUser)
	..set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
	..if (isAppRep'="Y") do
	...set rtnValue=..PBOADD(PBO, OEORE, BillUser)
	..else  do
	...set rtnValue=##class(web.UDHCJFBILLIPNoLock).RefunAppRep(OEORE, PBO, BillUser)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ##class(web.UDHCJFBILLIP).PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.set rtn=##class(web.UDHCJFBILLIPNoLock).UpdateOrdDetailBalance(OEORE)
	.quit:(+rtn)
	
	if (+rtn) tro  quit rtn
	
	if (+PBRowID'=0) {
		set rtn=##class(web.UDHCJFBILLIPNoLock).PBUPD(PBRowID, BillUser, Tot, TotDisc, TotIns, TotPat, OrdFrom, OrdEnd)
		if (+rtn) tro  quit rtn
	
		set rtn=##class(web.UDHCJFPAY).UpdatePatFee(PBRowID)
		if (+rtn) tro  quit rtn
	}
	
	if ($tl>0) tc
	    
	quit rtn_"^"_PBRowID
}

/// 执行记录退费
ClassMethod PBOREFUND(PBO, OEORE, BillUser)
{
	n (PBO, OEORE, BillUser)
	
	;s ArcimRowID=$p(^DHCPB(+PBO,"I",$p(PBO,"||",2)),"^",3)
	;s ArcGrp=$p($g(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1)),"^",10)          ;子类
	;s CatGrp=$p($g(^ARC("IC",ArcGrp)),"^",8)                           ;大类             
	;s OrdCateType=$p($g(^ARC("IC",ArcGrp)),"^",7)                      ;医嘱类型
	s rtn=..PBOItmRefund(PBO, OEORE, BillUser)
	/*
	i (OrdCateType'="R") d
	.s rtn=..PBOItmRefund(PBO)
	e  d
	.s rtn=..PBOMedRefund(PBO)
	*/
	q rtn
}

/// 退费直接在DHC_PatBillDetails中冲负记录
ClassMethod PBOItmRefund(PBO, OEORE, USER)
{
	n (PBO, OEORE, USER)
	s (Error, TotalAmount, DiscAmount, InsAmount, PatAmount)=0
	q:(+PBO=0) 0
	//modify 2012-06-05 增加判断，当DHC_PatBillOrder 表中PBO_TotalAmount的值和本次退费的和小于0时不能退费
	s OldPBOTotalAmt=$p(^DHCPB(+PBO,"O",$p(PBO,"||",2)),"^",8)
	i OldPBOTotalAmt=0 s $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
	q:(OldPBOTotalAmt=0) 0
	//
	i (+PBO'=0) s OldItmSub=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",""),-1)
	
	s Itm=0 
	f  s Itm=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",Itm)) q:((Itm="")||(Itm>OldItmSub))  d
	.s PBDRowID=PBO_"||"_Itm
	.s err=##class(web.UDHCJFPBODNoLock).SELECT(PBDRowID)
	.k PLIST(1),PLIST(2)
	.s PLIST(0)=PBO
	.s PLIST(5)=-PLIST(5)
	.s PLIST(7)=-PLIST(7)
	.s PLIST(8)=-PLIST(8)
	.s PLIST(9)=-PLIST(9)
	.s PLIST(10)=-PLIST(10)
	.s PLIST(11)=+$h
	.s PLIST(12)=$p($h,",",2)
	.s PLIST(14)=+$h
	.s PLIST(15)=$p($h,",",2)
	.s PLIST(16)=USER
	.s TotalAmount=TotalAmount+$g(PLIST(7))
	.s DiscAmount=DiscAmount+$g(PLIST(8))
	.s InsAmount=InsAmount+$g(PLIST(9))
	.s PatAmount=PatAmount+$g(PLIST(10))
	.s err=##class(web.UDHCJFPBODNoLock).INSERT() 
	.s Error=Error+err
	
	k PLIST
	s err=##class(web.UDHCJFPBONoLock).SELECT(PBO) 
	s Error=Error+err
	s PLIST(7)=-PLIST(6)
	s PLIST(8)=0
	s PLIST(9)=0
	s PLIST(10)=0
	s PLIST(11)=0
	s PLIST(16)="R"
	s err=##class(web.UDHCJFPBONoLock).UPDATE(PBO) 
	s Error=Error+err
	i (Error=0) s $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
	
	q Error_"^"_TotalAmount_"^"_DiscAmount_"^"_InsAmount_"^"_PatAmount
}

/// 药品退费，取退药表的记录，按退药明细插入DHC_PatBillDetails表,PBDDspDr=dhc_oedispensing的rowid
/// 问题：如果是部分退药，如果有附加收费的时候
ClassMethod PBOMedRefund(PBO, OEORE)
{
	n (PBO, OEORE)
	s Itm=0 
	f  s Itm=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",Itm)) q:(Itm="")  d
	.s PBDUnitPrice=$p(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",Itm),"^",4)  ;取原来的单价	
	.s err=##class(web.UDHCJFPBODNoLock).INSERT() 
	
	k PLIST
	s PLIST(7)=-PLIST(6)
	s PLIST(8)=0
	s PLIST(9)=0
	s PLIST(10)=0
	s PLIST(11)=0
	s Error=##class(web.UDHCJFPBONoLock).UPDATE(PBO) 
	i (Error=0) s $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"

	q Error
}

ClassMethod PBOUPD(PBO, OEORE, Status, BillUser)
{
	new (PBO, OEORE, Status, BillUser)
	
	set PriceStr=$g(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"PRICE"))
	set UnitPrice=+$p(PriceStr,"^",1)
	set DiscPrice=+$p(PriceStr,"^",2)
	set InsPrice=+$p(PriceStr,"^",3)
	set PatPrice=+$p(PriceStr,"^",4)
	
	set Qty=$p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"QTY"),"^",1)
	
	set TotalAmount=+..round(UnitPrice*Qty)
	set DiscAmount=+..round(DiscPrice*Qty)
	set PayorShare=+..round(InsPrice*Qty)
	set PatientShare=TotalAmount-DiscAmount-PayorShare
	
	set ArcimRowID=$p(^OEORD($p(OEORE,"||",1),"I",$p(OEORE,"||",2),1),"^",2)

	set err=##class(web.UDHCJFPBONoLock).SELECT(PBO)
	quit:(err) err
	if (Status="R") set PLIST(7)=PLIST(7)+Qty
	else  set PLIST(6)=PLIST(6)+Qty
	set PLIST(8)=TotalAmount+PLIST(8)
	set PLIST(9)=DiscAmount+PLIST(9)
	set PLIST(10)=PayorShare+PLIST(10)
	set PLIST(11)=PatientShare+PLIST(11)
	set PLIST(16)=Status
	if (PLIST(8)<0) {
		set ^TMPPBOUPDERR0(PBO)=OEORE_"^"_PLIST(8)_"^"_PLIST(9)_"^"_PLIST(10)_"^"_PLIST(11)
	}
	//modify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	set NegativeNum=PLIST(6)+PLIST(7)
	if (NegativeNum<0) {
		set Adm=$p($g(^DHCPB(+PBO)),"^",1)
		set AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
		set IsIntArcim=##class(web.UDHCJFIntBill).JudgeArcIsorNot(ArcimRowID, AdmHospDR)
		quit:(IsIntArcim=0) 0_"^"_0_"^"_0_"^"_0_"^"_0
	}
	set err=##class(web.UDHCJFPBONoLock).UPDATE(PBO)
	if (err) {
		set ^TMPPBOUPDERR(PBO)=err
		quit err_"^"_0_"^"_0_"^"_0_"^"_0
	}
	
	quit err_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatientShare
}

ClassMethod round(Num)
{
	new (Num)
	quit ##class(web.UDHCJFBILL).round(Num)
}

}
