Import SQLUser

Class web.UDHCJFREBILL2 Extends BILL.COM.Abstract [ Not ProcedureBlock ]
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
	set Count=..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser)
	
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
	.set Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser)
	
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
	...set Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser)
	..//婴儿医嘱
	..set Ord=$o(^OEORD(0,"Adm",babyAdm,""))
	..quit:(Ord="")
	..set Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser)
	
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

ClassMethod GetItem(pattype, instype, oeitm, arcim, oeprice, BillDate, BillTime, OEExecRowID, Adm, BillUser)
{
	new (pattype, instype, oeitm, arcim, oeprice, BillDate, BillTime, OEExecRowID, Adm, BillUser)

	set Price=0, DiscPrice=0, InsPrice=0, PatPrice=0
	set Ord=+OEExecRowID, Itm=$p(OEExecRowID,"||",2), Exec=$p(OEExecRowID,"||",3)
	set RCDRowID=$p($g(^PAADM(Adm,"DHC")),"^",25)
	set HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	
	set regLoc=""
	set itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_OEExecRowID_"^"_Adm_"^"_regLoc_"^"_""
	
    set priceDate=$p($g(^OEORD(Ord,"I",Itm,"X",Exec)),"^",47)    //OEORE_BillPriceDate

	//2016-05-25 Lid 取预约检查医嘱单价
	kill artiAry    //用于记录"后处理"医嘱是否已经计费
	set OEOREBillFlag=$p(^OEORD(Ord,"I",Itm,"X",Exec),"^",6)  //OEORE_Billed
	set priceStr="0^0^0^0"
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRep="Y") do
	.set itmDr=0
	.for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:(itmDr="")  do
	..set artiDr=0
	..for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:(artiDr="")  do
	...set artiData=$g(^DHCAPREPTA(artiDr))
	...set disc=$p(artiData,"^",4)	      //ARTI_Disc
	...set itm=$p(artiData,"^",5)	      //ARTI_Tar_Dr
	...set qty=$p(artiData,"^",8)	      //ARTI_Qty
	...set billStatus=$p(artiData,"^",9)   //ARTI_Billed
	...set ordExec=$p(artiData,"^",10)	  //ARTI_OrdExec
	...quit:((ordExec'="")&&(ordExec'=OEExecRowID))
	...quit:$d(artiAry(artiDr))
	...if (ordExec="") set artiAry(artiDr)=""
	...quit:(" TB B I "'[(" "_billStatus_" "))
	...set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
	...set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
	...set Price=$p(err0,"^",1)*qty+Price
	...set DiscPrice=$p(err0,"^",2)*qty+DiscPrice
	...set InsPrice=$p(err0,"^",3)*qty+InsPrice
	...set PatPrice=$p(err0,"^",4)*qty+PatPrice 
	...if '$d(^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm)) do
	....set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm)=qty_"^"_err0_"^"_BillDate_"^"_BillTime_"^"_disc_"^"_artiDr
	...else  do
	....set tmpitm=^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm)
	....set $p(tmpitm,"^",1)=$p(tmpitm,"^",1)+qty
	....set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm)=tmpitm
	...set priceStr=Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
	quit:(isAppRep="Y") priceStr
	
	//2017-09-13 Lid 药品医嘱结构改造
	set isOP2IP=##class(web.UDHCJFBILLIP).OrdIsOPToIPByIPAdm(Adm, oeitm)
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
	if (ordCateType="R") do
	.set statCodeDR=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3),"BILL")),"^",1)
	.set statCode=$s((+statCodeDR'=0):$p($g(^OEC("OSTAT",+statCodeDR)),"^",1), 1:"")
	.set dspQty=0
	.set dspDr=0
	.for  set dspDr=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dspDr)) quit:(dspDr="")  do
	..set dspData=$g(^DHCOEDISQTY(dspDr))
	..set myDspQty=+$p(dspData,"^",11)
	..set dspQty=dspQty+myDspQty
	..set dspbSub=0
	..for  set dspbSub=$o(^DHCOEDISQTY(dspDr,"I",dspbSub)) quit:(dspbSub="")  do
	...set dspbData=$g(^DHCOEDISQTY(dspDr,"I",dspbSub))
	...quit:(dspbData="")
	...set dspbDr=dspDr_"||"_dspbSub
	...set dspbQty=$p(dspbData,"^",2)	       //DSPB_Qty
	...set inciDr=$p(dspbData,"^",5)            //DSPB_INCI_DR
	...set dspbStutus=$p(dspbData,"^",6)        //DSPB_Status
	...set myQty=0, myRefQty=0
	...if (dspbStutus'="R") do
	....set myQty=dspbQty
	...if (((" D U ")[(" "_statCode_" "))||(isOP2IP=1)) do
	....if ((" TC R ")[(" "_dspbStutus_" ")) do
	.....set myRefQty=-dspbQty
	...set qty=myQty+myRefQty
	...set price=0, discPrice=0, insPrice=0, patPrice=0
	...set cltDr=0
	...for  set cltDr=$o(^DHCINCTARi("INCI",inciDr,cltDr)) quit:(cltDr="")  do
	....set cltData=$g(^DHCINCTAR(cltDr))
	....set stDate=$p(cltData,"^",4)
	....set endDate=$p(cltData,"^",5)
	....quit:((priceDate<stDate)||((endDate'="")&&(priceDate>endDate)))
	....set itm=$p(cltData,"^",2)
	....set qty0=$p(cltData,"^",3)
	....set $p(itmPriceExpStr,"^",8)=dspbDr
	....set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
	....set err0=$p(err,"^",1)_"^"_$p(err,"^",2)_"^"_$p(err,"^",3)_"^"_$p(err,"^",4)
	....set price=$p(err,"^",1)*qty0+price
	....set discPrice=$p(err,"^",2)*qty0+discPrice
	....set insPrice=$p(err,"^",3)*qty0+insPrice
	....set patPrice=$p(err,"^",4)*qty0+patPrice
	....if '$d(^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm,"DSPB",dspDr,dspbSub)) do
	.....set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm,"DSPB",dspDr,dspbSub)=qty_"^"_err0_"^"_BillDate_"^"_BillTime
	....else  do
	.....set tmpitm=$g(^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm,"DSPB",dspDr,dspbSub))
	.....set $p(tmpitm,"^",1)=$p(tmpitm,"^",1)+qty
	.....set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm,"DSPB",dspDr,dspbSub)=tmpitm
	...set Price=price*dspbQty+Price
	...set DiscPrice=discPrice*dspbQty+DiscPrice
	...set InsPrice=insPrice*dspbQty+InsPrice
	...set PatPrice=patPrice*dspbQty+PatPrice
	.if (+dspQty'=0) do
	..set Price=Price/dspQty
	..set DiscPrice=DiscPrice/dspQty
	..set InsPrice=InsPrice/dspQty
	..set PatPrice=PatPrice/dspQty
	.set priceStr=Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice	
	quit:(ordCateType="R") priceStr
	
	set ExecuDate=""
	for  set ExecuDate=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate)) quit:(ExecuDate="")  do
	.quit:(ExecuDate>priceDate)
	.set OLT=""
	.for  set OLT=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate,OLT)) quit:(OLT="")  do
	..set OLTData=$g(^DHCOLT(OLT))
	..set EndDate=$p(OLTData,"^",5)
	..quit:((EndDate'="")&&(EndDate<priceDate))
	..set qty0=$p(OLTData,"^",3)
	..set Itm=$p(OLTData,"^",2)
	..set err=##class(web.UDHCJFPRICE).GetItmPrice(Itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
	..set err0=$p(err,"^",1)_"^"_$p(err,"^",2)_"^"_$p(err,"^",3)_"^"_$p(err,"^",4)
	..set Price=$p(err,"^",1)*qty0+Price
	..set DiscPrice=$p(err,"^",2)*qty0+DiscPrice
	..set InsPrice=$p(err,"^",3)*qty0+InsPrice
	..set PatPrice=$p(err,"^",4)*qty0+PatPrice
	..set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",Itm,"OLT",OLT)=qty0_"^"_err0_"^"_BillDate_"^"_BillTime   //+2022-11-01 ZhYW 增加医嘱项关联收费项关联表Id节点

	quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
}

/// 需要计费的医嘱执行记录
ClassMethod ORDERS(Ord, PatType, InsType, OrdFrom, OrdEnd, Adm, BillUser) [ ProcedureBlock = 1 ]
{
	quit:(Ord="") 0
	set Count=0
	set Itm=0
	while($o(^OEORD(Ord,"I",Itm))) {
		set Itm=$o(^OEORD(Ord,"I",Itm))
		set OrdItmRowID=Ord_"||"_Itm
		continue:('$d(^OEORD(Ord,"I",Itm,1)))
		continue:(##class(web.UDHCJFBILLIP).CheckOPOrdToIPOrd(Adm, OrdItmRowID)=1)
		set OEOrdItmInfo=##class(web.UDHCJFBILLIP).GetOEOrdItemInfo(OrdItmRowID)
		continue:(OEOrdItmInfo="")
		set OEPirorCode=$p(OEOrdItmInfo,"^",1)
		continue:(OEPirorCode["OM")
		set IsHourOrd=$p(OEOrdItmInfo,"^",3)   //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
		//取执行记录表的数据
		set Exec=0
		while($o(^OEORD(Ord,"I",Itm,"X",Exec))) {
			set Exec=$o(^OEORD(Ord,"I",Itm,"X",Exec))
			set OEExecRowID=Ord_"||"_Itm_"||"_Exec
			set OEOREBillFlag=$p(^OEORD(Ord,"I",Itm,"X",Exec),"^",6)  //OEORE_Billed
			continue:(OEOREBillFlag="P")                        //2012-06-20 已经结算的医嘱执行记录不能计费
			set UpdErr=..GetPHQty(OEExecRowID)
			set SuccessFlag=..UpdateBilled(OEExecRowID)	   //2015-06-16 Lid 更新账单状态
			set OEOREBillFlag=$p(^OEORD(Ord,"I",Itm,"X",Exec),"^",6)  //由于上面更新了OEORE_Billed，故需重新取一下
			if ((OEOREBillFlag="R")&&(IsHourOrd'=1)) {
				set $p(^OEORD(+Ord,"I",Itm,"X",Exec,"BILL"),"^",2)=""   //OEORE_PBO_DR
				continue
			}
			set HourBillFlag=$p($g(^OEORD(Ord,"I",Itm,"X",Exec,"BILL")),"^",19)   //OE_OrdExecExt.OEORE_BlillFlag, HOUR医嘱能否计费标识
			continue:((IsHourOrd=1)&&(HourBillFlag'="Y"))  //按小时计费
			set ErrCode=..GetBillData(OrdItmRowID, PatType, InsType, OEExecRowID, OEOrdItmInfo, Adm, BillUser)
			continue:($p(ErrCode,"^",1)=1)
			set OrdBillDate=$p(ErrCode,"^",2)
			if (OrdBillDate<OrdFrom) set OrdFrom=OrdBillDate
			if (OrdBillDate>OrdEnd) set OrdEnd=OrdBillDate
			set Count=$i(Count)
		}
	}
	
	quit Count
}

/// Description: 判断计费点，取计费数量，并将要计费的执行记录记录到global中
ClassMethod GetBillData(OrdItmRowID, PatType, InsType, OEExecRowID, OEOrdItmInfo, Adm, BillUser) [ ProcedureBlock = 1 ]
{
	set IsHourOrd=$p(OEOrdItmInfo,"^",3)
	set ArcGrp=$p(OEOrdItmInfo,"^",4)
	set ArcimRowID=$p(OEOrdItmInfo,"^",6)
	set OEPirce=$p(OEOrdItmInfo,"^",7)

	set OrdStatusID=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3),"BILL")),"^",1)   //OE_OrdExecExt.OEORE_OrderStatus_DR
	set StatCode=$s((+OrdStatusID'=0):$p($g(^OEC("OSTAT",OrdStatusID)),"^",1),1:"")

	set err=..CheckBillPoint(OrdItmRowID, ArcGrp, StatCode, OEExecRowID, Adm)
	quit:($p(err,"^",1)'=1) 1
	set BillDate=$p(err,"^",2)
	set BillTime=$p(err,"^",3)
	
	//modify 2014-11-21 病人已出院账单billdate日期若大于最终结算日期则按最终结算日期取值
	//按小时计费医嘱若停止日期不是当天则按当天计费
	set CurDate=+$h
	set CurTime=$p($h,",",2)
	set HourBillFlag=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3),"BILL")),"^",19)
 	
 	if (+Adm'=0) {
		set AdmStatusCode=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(Adm)
		set AdmInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(Adm)
	 	set DischDate=$p(AdmInOutDateInfo,"^",4)
	 	set DischTime=$p(AdmInOutDateInfo,"^",5)
	 	if (" F B T "[(" "_AdmStatusCode_" "))&&(DischDate'="")&&(DischDate<BillDate) {
		 	set BillDate=DischDate
		 	set BillTime=DischTime
	 	}
 	}
 	
	//Calculate Billing Qty
	set qty=##class(web.UDHCJFBILLIP).GetBillQty(OrdItmRowID, StatCode, IsHourOrd, ArcimRowID, OEExecRowID, Adm)
	
	//Get order price and set item
	set price=..GetItem(PatType, InsType, OrdItmRowID, ArcimRowID, OEPirce, BillDate, BillTime, OEExecRowID, Adm, BillUser)
	
	set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID)=""
	set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"PRICE")=price
	set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"QTY")=qty
	
	quit 0_"^"_BillDate
}

/// 非医嘱执行后计费:判断执行记录是否要计费，账单状态为TB,要计费，账单状态为I,要退费
ClassMethod CheckBillPoint(oeitm, ItemCat, OrdStatus, OEExecRowID, Adm) [ ProcedureBlock = 1 ]
{
	set Itm=+OEExecRowID, Cld=$p(OEExecRowID,"||",2), ExcCld=$p(OEExecRowID,"||",3)
		
	set Status=0
	set BillDate="", BillTime=""
	
	//+2021-10-28 ZhYW 验证医嘱，医嘱数据不合法的不能账单
	set rtnValue=##class(BILL.IP.COM.Method).IsValidOrd(OEExecRowID)
	set rtn=('$p(rtnValue,"^",1))
	quit:(+rtn) Status_"^"_BillDate_"^"_BillTime

	set ItmStat=$p(^OEORD(Itm,"I",Cld,1),"^",13)	        //OEORI_ItemStat_DR->OEC_OrderStatus
	set ItmStatCode=$p($g(^OEC("OSTAT",+ItmStat)),"^",1)
	set CateType=$p($g(^ARC("IC",ItemCat)),"^",7)                      //医嘱类型
	
	//ZhYW 2021-07-05 物资走发放模式
	set isMatDisp=##class(BILL.IP.COM.Method).IsMatDisp(oeitm)
	set CP=##class(BILL.IP.COM.Method).GetBillPoint(oeitm)

	//计费点为护士执行后计费的，按护士执行状态
	set ExcStatusID=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",16)    
	set ExcStatus=$s((+ExcStatusID'=0):$p($g(^OEC("STAT",ExcStatusID)),"^",1),1:"")
	
	set ExcBillFlag=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",6)                    //执行记录的账单状态TB要计费，I要退费
	set ExcFreeChargeFlag=$p($g(^OEORD(Itm,"I",Cld,"X",ExcCld,"BILL")),"^",18)  //免费标识
	
	set rtn=0
	;Check Point is Order Entry or Discontinuned,It should include Order executed
	if (CP="OD") do
	.set ExStDate=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",1)
	.set ExStTime=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",2)
	.set InsertDate=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",45)
	.set InsertTime=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",46)
	.set rtn=##class(web.UDHCJFBILLIP).UpdateOEPriceDate(OEExecRowID, ExStDate, ExStTime)
	.quit:(+rtn)
	.set BillDateTime=##class(web.UDHCJFBILLIP).GetODBillDateTime(OEExecRowID, CP, CateType)
	.set BillDate=$p(BillDateTime,"^",1)
	.set BillTime=$p(BillDateTime,"^",2)
	.;
	.if " V E "[(" "_OrdStatus_" ") do
	..set Status=1
	..if ((InsertDate<ExStDate)||((InsertDate=ExStDate)&&(InsertTime<ExStTime))) do  ;插入日期小于要求执行时间时
	...if ((##class(web.UDHCJFBILLIP).%GetParameter("ODBillMode")=1) && (ExStDate>+$h)) do    ;按日期判断，同一天若开始不到具体时间点可以计费
	....set Status=0      //不到要求执行时间不计费
	.if " D U "[(" "_OrdStatus_" ") do
	..set Status=1

	;Check Point is Pharmacy Collected or Return
	if (CP="CR")&&(CateType="R") do
	.set dspStatus=""
	.set dspDate=""      //发药日期
	.set dspTime=""      //发药时间
	.set dsp=0
	.for  set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) quit:((dsp="")||(dspStatus="C"))  do
	..set dspData=$g(^DHCOEDISQTY(dsp))
	..set dspStatus=$p(dspData,"^",7)
	..quit:(dspStatus'="C")
	..set dspDate=$p(dspData,"^",8)
	..set dspTime=$p(dspData,"^",9)
	.if " V E "[(" "_OrdStatus_" ") do
	..if (dspStatus="C") do
	...set Status=1
	...set BillDate=dspDate
	...set BillTime=dspTime
	.if " D U "[(" "_OrdStatus_" ") do
	..set Status=1
	..set BillDate=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",12)
	..set BillTime=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",14)
	..set dsp=0
	..for  set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) quit:(dsp="")  do
	...set dspData=$g(^DHCOEDISQTY(dsp))
	...set dspStatus=$p(dspData,"^",7)
	...quit:(" C R "'[(" "_dspStatus_" "))
	...set BillDate=$p(dspData,"^",8)
	...set BillTime=$p(dspData,"^",9)
	.//+2023-04-26 ZhYW 移动到此次是为解决已发药但未计费执行记录就停止的情况
	.set rtn=##class(web.UDHCJFBILLIP).UpdateOEPriceDate(OEExecRowID, BillDate, BillTime)
	.if (+rtn) set Status=0
	
	//2021-07-15 ZhYW 走发放模式的物资材料
	if (CP="CR")&&(isMatDisp=1) do
	.set dspStatus=""
	.set dspDate=""      //发放日期
	.set dspTime=""      //发放时间
	.set dsp=0
	.for  set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) quit:((dsp="")||(dspStatus="C"))  do
	..set dspData=$g(^DHCOEDISQTY(dsp))
	..set dspStatus=$p(dspData,"^",7)
	..quit:(dspStatus'="C")
	..set dspDate=$p(dspData,"^",8)
	..set dspTime=$p(dspData,"^",9)
	.if " V E "[(" "_OrdStatus_" ") do
	..if (dspStatus="C") do
	...set Status=1
	...set BillDate=dspDate
	...set BillTime=dspTime
	.if " D U "[(" "_OrdStatus_" ") do
	..set Status=1
	..set BillDate=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",12)
	..set BillTime=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",14)
	..set dsp=0
	..for  set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) quit:(dsp="")  do
	...set dspData=$g(^DHCOEDISQTY(dsp))
	...set dspStatus=$p(dspData,"^",7)
	...quit:(" C R "'[(" "_dspStatus_" "))
	...set BillDate=$p(dspData,"^",8)
	...set BillTime=$p(dspData,"^",9)
	.//+2023-04-26 ZhYW 移动到此次是为解决已发放但未计费执行记录就停止的情况
	.set rtn=##class(web.UDHCJFBILLIP).UpdateOEPriceDate(OEExecRowID, BillDate, BillTime)
	.if (+rtn) set Status=0

	;Check Point is Order has benn Executed by Examine Department
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (CP="OE") do
	.set STStatusCode=""
	.set ExeDate=""
	.set ExeTime=""
	.if (isAppRep="Y") do
	..//+2023-02-02 ZhYW 多部位检查申请单计费时间改为从执行记录扩展表状态变化表中取
	..//OE_OrdExecOrdStatus
	..set OSCH=0
	..for  set OSCH=$o(^OEORD(Itm,"I",Cld,"X",ExcCld,"OSCH",OSCH)) quit:((OSCH="")||(STStatusCode="E"))  do
	...set OSCHData=$g(^OEORD(Itm,"I",Cld,"X",ExcCld,"OSCH",OSCH))
	...quit:(OSCHData="")
	...set STStatusDR=$p(OSCHData,"^",3)
	...set STStatusCode=$p($g(^OEC("OSTAT",STStatusDR)),"^",1)   //OEC_OrderStatus.OSTAT_Code
	...quit:(STStatusCode'="E")
	...set ExeDate=$p(OSCHData,"^",1)
	...set ExeTime=$p(OSCHData,"^",2)
	.else  do
	..//OE_OrdStatus
	..set STCld=0
	..for  set STCld=$o(^OEORD(Itm,"I",Cld,"ST",STCld)) quit:((STCld="")||(STStatusCode="E"))  do
	...set STDr=$p(^OEORD(Itm,"I",Cld,"ST",STCld),"^",3)
	...set STStatusCode=$p(^OEC("OSTAT",STDr),"^",1)
	...quit:(STStatusCode'="E")
	...set ExeDate=$p(^OEORD(Itm,"I",Cld,"ST",STCld),"^",1)
	...set ExeTime=$p(^OEORD(Itm,"I",Cld,"ST",STCld),"^",2)
	.if (STStatusCode="E") do
	..set rtn=##class(web.UDHCJFBILLIP).UpdateOEPriceDate(OEExecRowID, ExeDate, ExeTime)
	.quit:(+rtn)
	.if ((isAppRep'="Y")&&((" E "[(" "_OrdStatus_" "))||(ItmStatCode="E")))||((isAppRep="Y")&&(" E "[(" "_OrdStatus_" "))) d	 //个别产品组总是忘记修改执行记录扩展表的状态导致漏费，所以此处加了"(ItmStatCode="E")"
	..if (STStatusCode="E")  do
	...set Status=1
	...set BillDate=ExeDate
	...set BillTime=ExeTime
	.//当执行记录的执行状态不是执行时，判断医嘱的执行状态，如果医嘱为执行状态则计费
	.if " D U "[(" "_OrdStatus_" ") do
    ..set BillDate=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",12)
	..set BillTime=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",14)
	..if (BillDate="") do
    ...set BillDate=$p($g(^OEORD(Itm,"I",Cld,"X",ExcCld,"BILL")),"^",24)   //OEORE_OrderStatusCancelDate
    ...set BillTime=$p($g(^OEORD(Itm,"I",Cld,"X",ExcCld,"BILL")),"^",25)   //OEORE_OrderStatusCancelTime
	..if (BillDate'="") do
    ...set Status=1
    
	;Check Point is Order has been executed by Nurse
	if (CP="NE") do
    .//OE_OrdExecStatus
	.set AdminStatusCode=""
	.set STCHDate=""
	.set STCHTime=""
	.set STCH=0
	.for  set STCH=$o(^OEORD(Itm,"I",Cld,"X",ExcCld,"STCH",STCH)) quit:((STCH="")||(AdminStatusCode="F"))  do
	..set STCHData=$g(^OEORD(Itm,"I",Cld,"X",ExcCld,"STCH",STCH))
	..quit:(STCHData="")
	..set AdminStatusDR=$p(STCHData,"^",1)
	..set AdminStatusCode=$p($g(^OEC("STAT",AdminStatusDR)),"^",1)
	..quit:(AdminStatusCode'="F")
 	..set STCHDate=$p(STCHData,"^",3)
	..set STCHTime=$p(STCHData,"^",4)
    .if (AdminStatusCode="F") do
    ..set rtn=##class(web.UDHCJFBILLIP).UpdateOEPriceDate(OEExecRowID, STCHDate, STCHTime)
    .quit:(+rtn)
    .if " F "[(" "_ExcStatus_" ") do
    ..if (AdminStatusCode="F") do
    ...set Status=1
    ...set BillDate=STCHDate
    ...set BillTime=STCHTime
    .if " D C "[(" "_ExcStatus_" ") do
    ..set BillDate=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",12)
    ..set BillTime=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",14)
    ..if " C "[(" "_ExcStatus_" ") set BillDate=STCHDate, BillTime=STCHTime   //+2022-11-10 ZhYW 撤销执行不退费，计费时间取执行时间
    ..if (BillDate="") set BillDate=+$h, BillTime=$p($h,",",2)
    ..set Status=1
    
    if (ExcFreeChargeFlag="Y") set Status=1
	
	quit Status_"^"_BillDate_"^"_BillTime
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

	//modify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	if (NewQty<0) {
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
		...set rtn=##class(web.UDHCJFBILLIP).PBODINS(PBO, OEORE, Itm, Status, BillUser, dspbDr)
		...set err=$p(rtn,"^",1)

		if (+err=0) {
			set rtn=##class(web.UDHCJFBILLIP).PBOUpdateByPBD(PBO)
			set err=$p(rtn,"^",1)
		}
	}else {
		set Itm=""
		for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set Olt=""
		.for  set Olt=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
		..set rtn=##class(web.UDHCJFBILLIP).PBODINS(PBO, OEORE, Itm, Status, BillUser, "", Olt)
		..set err=$p(rtn,"^",1)
	}
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//+2022-11-02 ZhYW
	set err=##class(web.UDHCJFBILLIP).AdjustPatBillOrder(PBO)
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
	
	do ..SetDetPatBillDetails(PBO)
	set err=##class(web.UDHCJFPBO).SELECT(PBO)
	quit:(+err) err_"^0^0^0^0"
	set TotalAmount=-PLIST(8)
	set DiscAmount=-PLIST(9)
	set PayorShare=-PLIST(10)
	set PatientShare=-PLIST(11)
	set err=##class(web.UDHCJFPBO).PBODEL(PBO)
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

	//mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
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
		set PLIST(20)=OEORE       ;PBO_OrdExec_Dr
		set err=##class(web.UDHCJFPBO).INSERT()
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
		...set rtn=##class(web.UDHCJFBILLIP).PBODINS(PBO, OEORE, Itm, Status, BillUser, dspbDr)
		...set err=$p(rtn,"^",1)

		if (+err=0) {
			set rtn=##class(web.UDHCJFBILLIP).PBOUpdateByPBD(PBO)
			set err=$p(rtn,"^",1)
		}
	}else {
		set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
		if (isAppRep="Y") {
			set Itm=""
			for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
			.set rtn=##class(web.UDHCJFBILLIP).PBODINS(PBO, OEORE, Itm, Status, BillUser)
			.set err=$p(rtn,"^",1)
		}else {
			set Itm=""
			for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
			.set Olt=""
			.for  set Olt=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
			..set rtn=##class(web.UDHCJFBILLIP).PBODINS(PBO, OEORE, Itm, Status, BillUser, "", Olt)
			..set err=$p(rtn,"^",1)
		}
	}
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//+2022-11-02 ZhYW
	set err=##class(web.UDHCJFBILLIP).AdjustPatBillOrder(PBO)
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
	set err=##class(web.UDHCJFBILLIP).UpdateAppRepTarItmBillStatus($p(OEORE,"||",1,2), "TB", "B", OEORE)
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
	...set rtnValue=##class(web.UDHCJFBILLIP).RefunAppRep(OEORE, PBO, BillUser)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ##class(web.UDHCJFBILLIP).PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.set rtn=##class(web.UDHCJFBILLIP).UpdateOrdDetailBalance(OEORE)
	.quit:(+rtn)
	
	if (+rtn)  tro  quit rtn
	
	if (+PBRowID'=0) {
		set rtn=##class(web.UDHCJFBILLIP).PBUPD(PBRowID, BillUser, Tot, TotDisc, TotIns, TotPat, OrdFrom, OrdEnd)
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
	i (+OldPBOTotalAmt=0) s $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
	q:(+OldPBOTotalAmt=0) 0
	//
	i (+PBO'=0) s OldItmSub=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",""),-1)
	
	s Itm=0 
	f  s Itm=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",Itm)) q:((Itm="")||(Itm>OldItmSub))  d
	.s PBDRowID=PBO_"||"_Itm
	.s err=##class(web.UDHCJFPBOD).SELECT(PBDRowID)
	.k PLIST(1), PLIST(2)
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
	.s err=##class(web.UDHCJFPBOD).INSERT() 
	.s Error=Error+err
	
	k PLIST
	s err=##class(web.UDHCJFPBO).SELECT(PBO) 
	s Error=Error+err
	s PLIST(7)=-PLIST(6)
	s PLIST(8)=0
	s PLIST(9)=0
	s PLIST(10)=0
	s PLIST(11)=0
	s PLIST(16)="R"
	s err=##class(web.UDHCJFPBO).UPDATE(PBO) 
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
	.s err=##class(web.UDHCJFPBOD).INSERT() 
	
	k PLIST
	s PLIST(7)=-PLIST(6)
	s PLIST(8)=0
	s PLIST(9)=0
	s PLIST(10)=0
	s PLIST(11)=0
	s Error=##class(web.UDHCJFPBO).UPDATE(PBO) 
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

	set err=##class(web.UDHCJFPBO).SELECT(PBO)
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
	//modfiy 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	set NegativeNum=PLIST(6)+PLIST(7)
	if (NegativeNum<0) {
		set Adm=$p($g(^DHCPB(+PBO)),"^",1)
		set AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
		set IsIntArcim=##class(web.UDHCJFIntBill).JudgeArcIsorNot(ArcimRowID, AdmHospDR)
		quit:(IsIntArcim=0) 0_"^"_0_"^"_0_"^"_0_"^"_0
	}
	set err=##class(web.UDHCJFPBO).UPDATE(PBO)
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

/// Creator: 杨艳秀
/// CreateDate: 2009-03-16
/// Description: 记录删除的收费项目明细，DHCIPBillDelDetail(+$h,PBDRowID)=Adm
/// Table: DHC_PatBillOrder,DHC_PatBillDetails
ClassMethod SetDetPatBillDetails(PBORowID)
{
	new (PBORowID)
	set PBRowID=+PBORowID
	set PAADMRowID=$p(^DHCPB(PBRowID),"^",1)
 	set PBOSub=$p(PBORowID,"||",2)
    set PBDSub=0
  	for  set PBDSub=$o(^DHCPB(PBRowID,"O",PBOSub,"D",PBDSub)) quit:(PBDSub="")  do
	.set PBDRowID=PBORowID_"||"_PBDSub
	.kill ^DHCIPBillDelDetail(+$h,PBDRowID,"Done")
	.set ^DHCIPBillDelDetail(+$h,PBDRowID)=PAADMRowID
	.;kill ^DHCIPBillDelDetailNew(+$h,PBDRowID,"Done")
	.;set ^DHCIPBillDelDetailNew(+$h,PBDRowID)=$p(^DHCPB(PBRowID,"O",PBOSub),"^",4)_"#"_^DHCPB(PBRowID,"O",PBOSub,"D",PBDSub)
}

/// 根据执行记录取药品是否有需要计费的数量,有部分退药的医嘱,要保证能计费
ClassMethod GetPHQty(OEExecRowID)
{
	new (OEExecRowID)
	set err=0
	set DspQtySum=0, RefQtySum=0
	set dsp=0
	for  set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) quit:(dsp="")  do
	.set dspData=$g(^DHCOEDISQTY(dsp))
	.set dspStatus=$p(dspData,"^",7)
	.set dspQty=+$p(dspData,"^",11)
	.if (dspStatus="C") set DspQtySum=DspQtySum+dspQty
	.if (dspStatus="R") set RefQtySum=RefQtySum+dspQty

	if ((+DspQtySum'=0)&&(+RefQtySum'=0)) do
	.&SQL(UPDATE OE_OrdExec SET OEORE_Billed = 'TB' WHERE OEORE_RowId = :OEExecRowID AND OEORE_Billed<>'P')
	.set err=SQLCODE

	quit err
}

/// Debug: w ##class(web.UDHCJFREBILL2).UpdateBilled("153||157||1")
ClassMethod UpdateBilled(OEExecRowID As %String) As %String
{
	new (OEExecRowID)
	set rtn=0
	set Itm=+OEExecRowID, Cld=$p(OEExecRowID,"||",2), ExcCld=$p(OEExecRowID,"||",3)
	
	set oeitm=$p(OEExecRowID,"||",1,2)
	set CP=##class(BILL.IP.COM.Method).GetBillPoint(oeitm)
	
	set oeoreBilled=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",6)
	
	//对于执行后计费的医嘱，如果账单状态是B,则重新账单时把账单状态改为TB，否则漏费
	if ((oeoreBilled="B")&&(" OE NE "[(" "_CP_" "))) {
		&SQL(
			UPDATE OE_OrdExec
			SET OEORE_Billed = 'TB'
			WHERE %ID = :OEExecRowID
		)
	    set rtn=SQLCODE
	    quit:(+rtn) rtn_"^"_$g(%msg)
		set $p(^OEORD(+Itm,"I",Cld,"X",ExcCld,"BILL"),"^",2)=""   //OEORE_PBO_DR
	    //2017-04-14 Lid 如果是新版申请单，需要把中间表的账单状态也改为TB
	    set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	    if (isAppRep="Y") {
	   		set rtn=##class(web.UDHCJFBILLIP).UpdateAppRepTarItmBillStatus(oeitm, "B", "TB", OEExecRowID)
	    }
	}
	
    quit rtn
}

}
