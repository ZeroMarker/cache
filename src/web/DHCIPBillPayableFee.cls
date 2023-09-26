Import SQLUser

Class web.DHCIPBillPayableFee Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: Lid
/// CreatDate: 2014-01-07
/// Description: 获取就诊记录的应收金额.
/// Input: Adm:就诊rowid,BillUser:操作员，默认传空
/// Return: 总金额^折扣金额^记账金额^自付金额
/// Debug: w ##class(web.DHCIPBillPayableFee).BILL(1)
ClassMethod BILL(Adm, BillUser = "1", expStr = "") As %String
{
	n (Adm, BillUser, expStr)

	q:(Adm="") "AdmNull^"
	s AdmType=$p(^PAADM(Adm),"^",2)
    q:(AdmType'="I") 0
    
    s BabyInfo=##class(web.UDHCJFORDCHK).GetMotherAdmByBabyAdm(Adm)
	s BabyFlag=$p(BabyInfo,"^",1)
	s MotherAdm=$p(BabyInfo,"^",2)
	i (BabyFlag="true") s Adm=MotherAdm
	q:(BabyFlag="true") 0

	i (BillUser="") s BillUser=1
	
	s Error=..BILLC(Adm, BillUser, expStr)
	
	q Error
}

ClassMethod BILLC(Adm, BillUser, expStr)
{
	n (Adm, BillUser, expStr)
	;
	k ^TMP2("IB",BillUser,$j)
	;
	;Get Patient Admission Details
	s AdmDep=$P($g(^PAADM(Adm)),"^",4)
	s PatType=$P($g(^PAADM(Adm,1)),"^",6)	;PAADM_Epissubtype
	s InsType=$P($g(^PAADM(Adm,1)),"^",7)	;PAADM_AdmReason_DR
	;Get Patient Admission OEORD
	s Ord=$O(^OEORD(0,"Adm",Adm,""))
	
	s OrdFrom=+$H, OrdEnd=0
	;Calculate Order
	s Count=..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser, expStr)
	
	//+2019-07-23 ZhYW 急诊转住院医嘱
	s OPAdm=""
	f  s OPAdm=$o(^DHCOPIPADMCON(0,"IPADM",Adm,"OPADM",OPAdm),-1)  q:(OPAdm="")  d
	.s Ord=""
	.s OCIId=""
	.f  s OCIId=$o(^DHCOPIPADMCON(0,"IPADM",Adm,"OPADM",OPAdm,OCIId),-1)  q:((OCIId="")||(Ord'=""))  d
	..s OCIInfo=$g(^DHCOPIPADMCON(OCIId))
	..s Status=$p(OCIInfo,"^",7)
	..q:(Status'="N")
	..s Ord=$o(^OEORD(0,"Adm",OPAdm,""))
	.q:(Ord="")
	.s Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser, expStr)
	
	;Calculate NewBorn Order to Mother
	s HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDep)
	s Conf=##class(web.DHCBillCommon).GetTarParaId(HospDR)
	i ($d(^PAADMi("Mother",Adm))'=0)&&($p(^DHCTarC("CF",Conf),"^",5)="Y") d
	.s babyAdm=""
	.f  s babyAdm=$o(^PAADMi("Mother",Adm,babyAdm)) q:(babyAdm="")  d
	..//+2019-07-23 ZhYW 婴儿急诊转住院医嘱
	..s OPAdm=""
	..f  s OPAdm=$o(^DHCOPIPADMCON(0,"IPADM",babyAdm,"OPADM",OPAdm),-1)  q:(OPAdm="")  d
	...s Ord=""
	...s OCIId=""
	...f  s OCIId=$o(^DHCOPIPADMCON(0,"IPADM",babyAdm,"OPADM",OPAdm,OCIId),-1)  q:((OCIId="")||(Ord'=""))  d
	....s OCIInfo=$g(^DHCOPIPADMCON(OCIId))
	....s Status=$p(OCIInfo,"^",7)
	....q:(Status'="N")
	....s Ord=$o(^OEORD(0,"Adm",OPAdm,""))
	...q:(Ord="")
	...s Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser, expStr)
	..//婴儿医嘱
	..s Ord=$o(^OEORD(0,"Adm",babyAdm,""))
	..q:(Ord="")
	..s Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser, expStr)
	;
	
	s ReturnValue="0^0^0^0"   ;总金额^折扣金额^记账金额^自付金额
    i (Count>0) d
	.s ReturnValue=..PBORD(Adm, OrdFrom, OrdEnd, BillUser)
	
	k ^TMP2("IB",BillUser,$j)
	
	q ReturnValue
}

ClassMethod CheckBillPoint(oeitm, ItemCat, OrdStatus, Type, OEExecRowID, Adm)
{
	n (oeitm, ItemCat, OrdStatus, Type, OEExecRowID, Adm)
	;
	s Itm=+OEExecRowID, Cld=$p(OEExecRowID,"||",2), ExcCld=$p(OEExecRowID,"||",3)
	;
	s Status=0
	s BillDate="", BillTime=""
	;
	s CP="OD"   ;默认都是下医嘱计费
	
	s ExcFreeChargeFlag=$p($g(^OEORD(Itm,"I",Cld,"X",ExcCld,"BILL")),"^",18)   ;免费标志

	i (CP="OD") d
	.s BillDate=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",1)
	.s BillTime=$p(^OEORD(Itm,"I",Cld,"X",ExcCld),"^",2)
	.s Status=1

	i (ExcFreeChargeFlag="Y") s Status=1
	
	q Status_"^"_BillDate_"^"_BillTime
}

ClassMethod Error()
{
	s count=$o(^DHCERROR($ZN,""),-1)+1
	s ^DHCERROR($ZN,count)=$ZERROR_"  "_$H
	q
}

ClassMethod GetItem(pattype, instype, oeitm, arcim, oeprice, BillDate, BillTime, OEExecRowID, Adm, BillUser)
{
	n (pattype, instype, oeitm, oeprice, BillDate, BillTime, OEExecRowID, Adm, BillUser)
	
	s Ord=+OEExecRowID, Itm=$p(OEExecRowID,"||",2), ExecSub=$p(OEExecRowID,"||",3)
	s RCDRowID=$p($g(^PAADM(Adm,"DHC")),"^",25)
	s HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	s Price=0, DiscPrice=0, InsPrice=0, PatPrice=0
	
	s regLoc=""
	s itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_OEExecRowID_"^"_Adm_"^"_regLoc_"^"_""
	
	//账单中是取OEORE_BillPriceDate，这里取OEORE_ExStDate
	s priceDate=$p(^OEORD(Ord,"I",Itm,"X",ExecSub),"^",1)
	
	;2016-05-25 Lid 取预约检查医嘱单价
	set OEOREBillFlag=$p(^OEORD(Ord,"I",Itm,"X",ExecSub),"^",6)  //OEORE_Billed
	set priceStr="0^0^0^0"
	set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRepFlag="Y") do
	.set itmDr=0
	.for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:(itmDr="")  do
	..set artiDr=0
	..for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:(artiDr="")  do
	...set tmp=$g(^DHCAPREPTA(artiDr))
	...set disc=$p(tmp,"^",4)	    ;ARTI_Disc
	...set itm=$p(tmp,"^",5)	    ;ARTI_Tar_Dr
	...set qty=$p(tmp,"^",8)	    ;ARTI_Qty
	...set billStatus=$p(tmp,"^",9) ;ARTI_Billed
	...set ordExec=$p(tmp,"^",10)	;ARTI_OrdExec
	...quit:(ordExec'="")&&(ordExec'=OEExecRowID)
	...quit:$d(^TMPpointType(artiDr))
	...if (ordExec="") set ^TMPpointType(artiDr)=""
	...quit:(" TB I "'[(" "_billStatus_" "))
	...quit:(OEOREBillFlag'=billStatus)
	...set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
	...set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
	...set Price=$p(err0,"^",1)*qty+Price
	...set DiscPrice=$p(err0,"^",2)*qty+DiscPrice
	...set InsPrice=$p(err0,"^",3)*qty+InsPrice
	...set PatPrice=$p(err0,"^",4)*qty+PatPrice
	...if '$d(^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm)) do
	....set ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm)=qty_"^"_err0_"^"_BillDate_"^"_BillTime_"^"_disc_"^"_artiDr
	...else  do
	....set tmpitm=^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm)
	....set $p(tmpitm,"^",1)=$p(tmpitm,"^",1)+qty
	....set ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm)=tmpitm
	...set priceStr=Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
	;
	quit:(isAppRepFlag="Y") priceStr
	;
	;2017-09-13 Lid 药品医嘱结构改造
	set isOP2IP=..OrdIsOPToIPByIPAdm(Adm, oeitm)
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
	if (ordCateType="R") do
	.set statCodeDR=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3),"BILL")),"^",1)
	.set statCode=$s((+statCodeDR'=0):$p($g(^OEC("OSTAT",+statCodeDR)),"^",1), 1:"")
	.set dspQty=0
	.set dspDr="0"
	.for  set dspDr=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dspDr)) quit:(dspDr="")  do
	..set dspInfo=$g(^DHCOEDISQTY(dspDr))
	..set myDspQty=+$p(dspInfo,"^",11)
	..set dspQty=dspQty+myDspQty
	..set dspbSub="0"
	..for  set dspbSub=$o(^DHCOEDISQTY(dspDr,"I",dspbSub)) quit:(dspbSub="")  do
	...set tmp=$g(^DHCOEDISQTY(dspDr,"I",dspbSub))
	...quit:(tmp="")
	...set dspbDr=dspDr_"||"_dspbSub
	...set dspbQty=$p(tmp,"^",2)	   ;DSPB_Qty
	...set inciDr=$p(tmp,"^",5)        ;DSPB_INCI_DR
	...set dspbStutus=$p(tmp,"^",6)    ;DSPB_Status
	...set myQty=0, myRefQty=0
	...if (dspbStutus'="R") do
	....set myQty=dspbQty
	...if (((" D U ")[(" "_statCode_" "))||(isOP2IP=1)) do
	....if ((" TC R ")[(" "_dspbStutus_" ")) do
	.....set myRefQty=0-dspbQty
	...set qty=myQty+myRefQty
	...set price=0, discPrice=0, insPrice=0, patPrice=0
	...set cltDr="0"
	...for  set cltDr=$o(^DHCINCTARi("INCI",inciDr,cltDr)) quit:(cltDr="")  do
	....set stDate=$p(^DHCINCTAR(cltDr),"^",4)
	....set endDate=$p(^DHCINCTAR(cltDr),"^",5)
	....quit:((priceDate<stDate)||((endDate'="")&&(priceDate>endDate)))
	....set itm=$p(^DHCINCTAR(cltDr),"^",2)
	....set qty0=$p(^DHCINCTAR(cltDr),"^",3)
	....set $p(itmPriceExpStr,"^",8)=dspbDr
	....set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
	....set err0=$p(err,"^",1)_"^"_$p(err,"^",2)_"^"_$p(err,"^",3)_"^"_$p(err,"^",4)
	....set price=$p(err,"^",1)*qty0+price
	....set discPrice=$p(err,"^",2)*qty0+discPrice
	....set insPrice=$p(err,"^",3)*qty0+insPrice
	....set patPrice=$p(err,"^",4)*qty0+patPrice
	....if '$d(^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm,"DSPB",dspDr,dspbSub)) do
	.....set ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm,"DSPB",dspDr,dspbSub)=qty_"^"_err0_"^"_BillDate_"^"_BillTime
	....else  do
	.....set tmpitm=$g(^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm,"DSPB",dspDr,dspbSub))
	.....set $p(tmpitm,"^",1)=$p(tmpitm,"^",1)+qty
	.....set ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",itm,"DSPB",dspDr,dspbSub)=tmpitm
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
	..set EndDate=$p(^DHCOLT(OLT),"^",5)
	..quit:(EndDate<priceDate)&&(EndDate'="")
	..set qty0=$p(^DHCOLT(OLT),"^",3)
	..set Itm=$p(^DHCOLT(OLT),"^",2)
	..set err=##class(web.UDHCJFPRICE).GetItmPrice(Itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
	..set err0=$p(err,"^",1)_"^"_$p(err,"^",2)_"^"_$p(err,"^",3)_"^"_$p(err,"^",4)
	..set Price=$p(err,"^",1)*qty0+Price
	..set DiscPrice=$p(err,"^",2)*qty0+DiscPrice
	..set InsPrice=$p(err,"^",3)*qty0+InsPrice
	..set PatPrice=$p(err,"^",4)*qty0+PatPrice
	..if '$d(^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",Itm)) do
	...set ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",Itm)=qty0_"^"_err0_"^"_BillDate_"^"_BillTime
	..else  do
	...set tmpitm=^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",Itm)
	...set $p(tmpitm,"^",1)=$p(tmpitm,"^",1)+qty0
	...set ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",Itm)=tmpitm
	;
	quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
}

/// 过滤，需要计费的医嘱执行记录
ClassMethod ORDERS(Ord, PatType, InsType, OrdFrom, OrdEnd, Adm, BillUser, expStr)
{
	n (Ord, PatType, InsType, OrdFrom, OrdEnd, Adm, BillUser, expStr)
	q:(Ord="") 0
	s Count=0
	s Itm=0
	f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:(Itm="")  d
	.s OrdItmRowID=Ord_"||"_Itm
	.q:(expStr'="")&&(OrdItmRowID'=expStr)
	.s OEOrdItmInfo=""
	.i $d(^OEORD(+OrdItmRowID,"I",$p(OrdItmRowID,"||",2),1))=0  d
	..s ^DHCIPBILLOEORDERR(Ord,Itm)="NoOEORDItem"
	.q:($d(^OEORD(+OrdItmRowID,"I",$p(OrdItmRowID,"||",2),1))=0)
	.s OEOrdItmInfo=..GetOEOrdItemInfo(OrdItmRowID)
	.q:(OEOrdItmInfo="")
	.s OEPirorCode=$p(OEOrdItmInfo,"^",1)
	.q:(OEPirorCode["OM")
	.s BUomCode=$p(OEOrdItmInfo,"^",3)
	.s OEBillFlag=$p(OEOrdItmInfo,"^",15)
	.;q:(OEBillFlag="P")
	.;取执行记录表的数据
	.s ExecSub=0
	.f  s ExecSub=$o(^OEORD(Ord,"I",Itm,"X",ExecSub)) q:(ExecSub="")  d
	..s OEExecRowID=Ord_"||"_Itm_"||"_ExecSub
	..s OEOREBillFlag=$p(^OEORD(Ord,"I",Itm,"X",ExecSub),"^",6)   ;OEORE_Billed
	..q:(" TB I "'[(" "_OEOREBillFlag_" "))
	..s HourBillFlag=$p($g(^OEORD(Ord,"I",Itm,"X",ExecSub,"BILL")),"^",19)
	..s ErrCode=..GetBillData(OrdItmRowID, PatType, InsType, OEExecRowID, OEOrdItmInfo, Adm, BillUser)
	..q:(ErrCode=1)
	..s OrdStDate=$p(^OEORD(Ord,"I",Itm,"X",ExecSub),"^",1)
	..i (OrdStDate<OrdFrom) s OrdFrom=OrdStDate
	..i (OrdStDate>OrdEnd) s OrdEnd=OrdStDate
	..s Count=Count+1

	q Count
}

/// Function：判断计费点，取计费数量，并将要计费的执行记录记录到global中
ClassMethod GetBillData(OrdItmRowID, PatType, InsType, OEExecRowID, OEOrdItmInfo, Adm, BillUser)
{
    n (OrdItmRowID, PatType, InsType, OEExecRowID, OEOrdItmInfo, Adm, BillUser)
   
    s OEPirorCode=$p(OEOrdItmInfo,"^",1)
	s StatCode=$p(OEOrdItmInfo,"^",2)
	s BUomCode=$p(OEOrdItmInfo,"^",3)
	s ArcGrp=$p(OEOrdItmInfo,"^",4)
    s OrdCateType=$p(OEOrdItmInfo,"^",5)
	s ArcimRowID=$p(OEOrdItmInfo,"^",6)
	s OEStDate=$p(OEOrdItmInfo,"^",7)
	s OEStTime=$p(OEOrdItmInfo,"^",8)
	s OEXDate=$p(OEOrdItmInfo,"^",9)
	s OEXTime=$p(OEOrdItmInfo,"^",10)
	s OEInstr=$p(OEOrdItmInfo,"^",12)
	s OELinkTo=$p(OEOrdItmInfo,"^",13)
	s OEPirce=$p(OEOrdItmInfo,"^",14)
     
	;取执行记录表的医嘱状态OEORE_OrderStatus_DR
	s OrdStatusID=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3),"BILL")),"^",1)
	s StatCode=$s((+OrdStatusID'=0):$p($g(^OEC("OSTAT",OrdStatusID)),"^",1),1:"")
	//2020-07-08 ZhYW 若检查申请单医嘱已撤销，执行记录状态按作废处理
	i (##class(web.UDHCJFBILLIP).IsAppRepOrdCancel(OEExecRowID)) d
	.s StatCode="U"
	
	s err=..CheckBillPoint(OrdItmRowID, ArcGrp, StatCode, OrdCateType, OEExecRowID, Adm)
	s BillDate=$p(err,"^",2)
	s BillTime=$p(err,"^",3)
	
	q:$p(err,"^",1)'=1 1
 	
	;Calculate Billing Qty
	s qty=..GetBillQty(OrdItmRowID, StatCode, BUomCode, ArcGrp, OrdCateType, ArcimRowID, OEPirorCode, OEExecRowID, Adm)

	s RecLoc=$p($g(PLIST(75)),$c(1))
	s PatType=..GetPatTypeByRecLoc(PatType, RecLoc)
	
	;Get order price and set item
	s price=..GetItem(PatType, InsType, OrdItmRowID, ArcimRowID, OEPirce, BillDate, BillTime, OEExecRowID, Adm, BillUser)

	s ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID)=""
	s ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"PRICE")=price
	s ^TMP2("IB",BillUser,$j,"ORDER",OEExecRowID,"QTY")=qty
	q 0
}

ClassMethod PBORD(Adm, OrdFrom, OrdEnd, BillUser)
{
	new (Adm, OrdFrom, OrdEnd, BillUser)
	;
	
	set Tot=0, TotDisc=0, TotIns=0, TotPat=0
	
	set OEORE=""
	for  set OEORE=$o(^TMP2("IB",BillUser,$j,"ORDER",OEORE)) q:(OEORE="")  d
	.set TotalAmount=0, DiscAmount=0, InsAmount=0, PatAmount=0
	.set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORE, 2)
	.if (ordCateType="R") do
	..set Itm=""
	..for  set Itm=$o(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:(Itm="")  do
	...set dspDr=""
	...for  set dspDr=$o(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr)) quit:(dspDr="")  do
	....set dspbSub=""
	....for  set dspbSub=$o(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)) quit:(dspbSub="")  do
	.....set dspbDr=dspDr_"||"_dspbSub
	.....set rtnValue=..PBODINS("", OEORE, Itm, BillUser, dspbDr)
	.....set TotalAmt=$p(rtnValue,"^",1)
	.....set DiscAmt=$p(rtnValue,"^",2)
	.....set InsAmt=$p(rtnValue,"^",3)
	.....set PatAmt=$p(rtnValue,"^",4)
	.....set Tot=Tot+TotalAmt
	.....set TotDisc=TotDisc+DiscAmt
	.....set TotIns=TotIns+InsAmt
	.....set TotPat=TotPat+PatAmt
	.else  do
	..set Itm=""
	..for  set Itm=$o(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) q:(Itm="")  d
	...set rtnValue=..PBODINS("", OEORE, Itm, BillUser)
	...set TotalAmt=$p(rtnValue,"^",1)
	...set DiscAmt=$p(rtnValue,"^",2)
	...set InsAmt=$p(rtnValue,"^",3)
	...set PatAmt=$p(rtnValue,"^",4)
	...set Tot=Tot+TotalAmt
	...set TotDisc=TotDisc+DiscAmt
	...set TotIns=TotIns+InsAmt
	...set TotPat=TotPat+PatAmt

	quit Tot_"^"_TotDisc_"^"_TotIns_"^"_TotPat
}

ClassMethod PBODINS(PBO, OEORE, Itm, BillUser, dspbDr = "")
{
	new (PBO, OEORE, Itm, BillUser, dspbDr)
	if (dspbDr'="") {
		set dspDr=$p(dspbDr,"||",1)
		set dspbSub=$p(dspbDr,"||",2)
		set Qty0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)),"^",1)
		set Price0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)),"^",2)
		set DiscPrice0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)),"^",3)
		set InsPrice0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)),"^",4)
		set PatPrice0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)),"^",5)
		set BillDate=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)),"^",6)
		set BillTime=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub)),"^",7)
		;
		set OrdQty=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"QTY")),"^",1)
	}else {
		set Qty0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)),"^",1)
		set Price0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)),"^",2)
		set DiscPrice0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)),"^",3)
		set InsPrice0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)),"^",4)
		set PatPrice0=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)),"^",5)
		set BillDate=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)),"^",6)
		set BillTime=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)),"^",7)
		;
		set OrdQty=$p($g(^TMP2("IB",BillUser,$j,"ORDER",OEORE,"QTY")),"^",1)
	}
	
	kill PLIST
	set PLIST(3)=Itm
	set PLIST(4)=+Price0
	;
	;Add By Su MingLiang 2007/08/04
	set PLIST(18)=+DiscPrice0
	set PLIST(19)=+InsPrice0
	set PLIST(20)=+PatPrice0
	;
	if (dspbDr="") {
		set PLIST(5)=+Qty0*OrdQty
	}else {
		if (PBO="") {
			set PBO=$p($g(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3),"BILL")),"^",2)
		}
		set initBillQty=$s((PBO'=""):..GetTarItmBillQty(PBO, Itm, dspbDr),1:0)
		set Qty0=Qty0-initBillQty
		quit:(+Qty0=0) 0_"^"_0_"^"_0_"^"_0_"^"_0
		set PLIST(5)=+Qty0
	}
	set PLIST(7)=+..round(Price0*PLIST(5))
	set PLIST(8)=+..round(DiscPrice0*PLIST(5))
	set PLIST(9)=+..round(InsPrice0*PLIST(5))
	
	set PLIST(10)=PLIST(7)-PLIST(8)-PLIST(9)  ;+$$round(PatPrice0*PLIST(5))
	
	quit +PLIST(7)_"^"_+PLIST(8)_"^"_+PLIST(9)_"^"_+PLIST(10)
}

ClassMethod GetQtyHour(priorcode As %String, oeitm As %String, statcode As %String, OEExecRowID As %String)
{
	New (priorcode, oeitm, statcode, OEExecRowID)
	
	Set stDate=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",1)    //OEORE_ExStDate
	Set stTime=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",2)    //OEORE_ExStTime

	Set endDate=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",35)   //OEORE_ExEnDate
	Set endTime=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",36)   //OEORE_ExEnTime

	If (+endDate=0) Set endDate=+$h
	If (+endTime=0) Set endTime=$p($h,",",2)
	If ((endDate<stDate) || ((endDate=stDate)&&(endTime<stTime))) {
		Set qty=0
	}Else {
		Set period=endDate-stDate
		Set dcnt=period*24                //转化为小时
		Set tcnt=$fn((endTime-stTime)/60/60,"",2)     //转化为小时
		Set qty=dcnt+tcnt
	}
	
	//"S": 长期医嘱
	If (priorcode'="S") {
		If (statcode="D") {
			Set qty=0
		}Else {
			Set qty=+$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",5)   //OEORE_QtyAdmin
		}
	}

	Quit qty
}

ClassMethod round(Num)
{
	n (Num)
	s NegFlag=0
	q:$g(Num)=""!(Num=0) 0
	i Num<0 s Num=-Num,NegFlag=1
	i Num<0.01 s Num=0.01       
	e  d
	.s Num=+Num+0.0000001
	.s np=$p(Num,".",1)_"."_$e($p(Num,".",2),1,2)
	.s point="0.00"_$e($p(Num,".",2),3,$l($p(Num,".",2)))
	.s Num=np 
	.s:point'<0.005 Num=Num+0.01
	i NegFlag=1 s Num=-Num
	q Num
}

ClassMethod GetBillQty(oeitm As %String, statcode As %String, buomcode As %String, ItemCat As %String, ItemCatType As %String, arcim As %String, priorcode As %String, OEExecRowID As %String, Adm As %String) As %String
{
	New (oeitm, statcode, buomcode, ItemCat, ItemCatType, arcim, priorcode, OEExecRowID, Adm)
	If (buomcode'="HOUR") {
		Set returnqty=..GetRefundQty(oeitm, statcode, ItemCat, ItemCatType, arcim, priorcode, OEExecRowID, Adm)
		Set qty=..GetQty(oeitm, statcode, ItemCat, ItemCatType, arcim, priorcode, OEExecRowID, Adm)
	} Else {        
		Set qty=..GetQtyHour(priorcode, oeitm, statcode, OEExecRowID)
		Set returnqty=0
	}
	Set qty=qty-returnqty               ;substract refunded qty
	Quit qty
}

ClassMethod GetRefundQty(oeitm As %String, Status As %String, ItemCat As %String, ItemCatType As %String, arcim As %String, priorcode As %String, OEExecRowID As %String, Adm As %String) As %Numeric
{
	New (oeitm, Status, ItemCat, ItemCatType, arcim, priorcode, OEExecRowID, Adm)
	
	Set RefundQty=0
	
	Set isOP2IP=..OrdIsOPToIPByIPAdm(Adm, oeitm)
	If (isOP2IP=1) {
		Quit ..GetRefundQtyO(OEExecRowID)    //返回门急诊转入医嘱的退费数量
	}
	Quit:((" D U ")'[(" "_Status_" ")) RefundQty

	;get bill point
	Set HospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	Set Conf=##class(web.DHCBillCommon).GetTarParaId(HospDR)
	Set DefaultCP=$p($g(^DHCTarC("CF",Conf)),"^",9)
	If (DefaultCP="") Set DefaultCP="OD"
	Set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_BillCondition", HospDR)
	Set Condition=""
	Set BCRowId=0
	While($o(^DHCTarC("BC",0,ItemCat,BCRowId))&&(Condition="")) {
		Set BCRowId=$o(^DHCTarC("BC",0,ItemCat,BCRowId))
		Set BCHospDR=$p($g(^DHCTarC("BC",BCRowId)),"^",3)
		Continue:(BCHospDR'=GroupHospID)
		Set Condition=BCRowId
	}
	Set CP=$s((+Condition'=0):$p($g(^DHCTarC("BC",Condition)),"^",2),1:DefaultCP)
	
	Set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	If (inci'="") {
		If (CP="CR") {
			Set LinkFlag=..GetUserLocLinkRecLoc(oeitm)
			If (LinkFlag="Y") Set CP="OD"
			If (priorcode="OUT") {
				Set PhOutFlag=..GetPhOutFlag(Adm)
				If (PhOutFlag'="Y") Set CP="OD"
			}
		}
		
		If (CP="CR") {
			Set dsp=0
			For  Set dsp=$O(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) Quit:(dsp="")  Do
			.Set disp=^DHCOEDISQTY(dsp)
			.Set dspstatus=$P(disp,"^",7)
			.Quit:(dspstatus'="R")
			.Set dspqty=+$P(disp,"^",11)
			.Set RefundQty=RefundQty+dspqty
		} Else 	{
			Set dsp=0 
			For  Set dsp=$O(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) Quit:(dsp="")  Do
			.Set disp=^DHCOEDISQTY(dsp)
			.Set dspstatus=$P(disp,"^",7)
			.Quit:(dspstatus'="R")
			.Set dspqty=+$P(disp,"^",11)
			.Set RefundQty=RefundQty+dspqty	
		}
	} Else {
		Set RefundQty=+$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",5)
		Set ExecQty=0
		If (CP="NE") {
			If (+$d(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X"))=0) {
				Set ExecQty=0
			} else {
				Set s=^OEORD(+OEExecRowID,"I",+$p(OEExecRowID,"||",2),"X",+$p(OEExecRowID,"||",3))
				Set ExecStatus=$p(s,"^",16)
				Set BillFlag=$p($g(^OEC("STAT",+ExecStatus)),"^",3)
				If (BillFlag="Y") Set ExecQty=ExecQty++$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",5)
			}
		}
		Set RefundQty=RefundQty-ExecQty
	}
	
	Quit RefundQty
}

ClassMethod GetQty(oeitm As %String, Status As %String, ItemCat As %String, ItemCatType As %String, arcim As %String, priorcode As %String, OEExecRowID As %String, Adm As %String) As %Numeric
{
	New (oeitm, Status, ItemCat, ItemCatType, arcim, priorcode, OEExecRowID, Adm)
	
	Set Qty=0
	
	;get bill point
	Set HospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	Set Conf=##class(web.DHCBillCommon).GetTarParaId(HospDR)
	Set DefaultCP=$p($g(^DHCTarC("CF",Conf)),"^",9)
	If (DefaultCP="") Set DefaultCP="OD"
	
	Set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_BillCondition", HospDR)
	Set Condition=""
	Set BCRowId=0
	While($o(^DHCTarC("BC",0,ItemCat,BCRowId))&&(Condition="")) {
		Set BCRowId=$o(^DHCTarC("BC",0,ItemCat,BCRowId))
		Set BCHospDR=$p($g(^DHCTarC("BC",BCRowId)),"^",3)
		Continue:(BCHospDR'=GroupHospID)
		Set Condition=BCRowId
	}
	Set CP=$s((+Condition'=0):$p($g(^DHCTarC("BC",Condition)),"^",2),1:DefaultCP)
	
	Set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	If (inci'="") {
		If (CP="CR") {
			Set LinkFlag=..GetUserLocLinkRecLoc(oeitm)
			If (LinkFlag="Y") Set CP="OD"
			If (priorcode="OUT") {
				Set PhOutFlag=..GetPhOutFlag(Adm)
				If (PhOutFlag'="Y") Set CP="OD"
			}
		}
	    
		If (CP="CR") {
			Set dsp=0 
			For  Set dsp=$O(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) Quit:(dsp="")  Do
			.Set disp=^DHCOEDISQTY(dsp)
			.Set dspstatus=$P(disp,"^",7)
			.Quit:(dspstatus="R")
			.Set dspqty=+$P(disp,"^",11)
			.Set Qty=Qty+dspqty
		} Else 	{
			Set dsp=0
			For  Set dsp=$O(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp)) Quit:(dsp="")  Do
			.Set disp=^DHCOEDISQTY(dsp)
			.Set dspstatus=$P(disp,"^",7)
			.Quit:(dspstatus="R")
			.Set dspqty=+$P(disp,"^",11)
			.Set Qty=Qty+dspqty
		}
	} Else {
		Set Qty=+$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",5)
	}
		
	Quit Qty
}

ClassMethod GetUserLocLinkRecLoc(oeitm As %String) As %String
{
	New (oeitm)
	Set LinkFlag="N"
	Set UserLoc=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),7),"^",2)
	Set RecLoc=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",6)
	Quit:((RecLoc="")||(UserLoc="")) LinkFlag
	
	If $d(^CTLOC(RecLoc,"LINK",0,"Loc",UserLoc)) {
		Set LinkFlag="Y"
	}
	
	Quit LinkFlag
}

ClassMethod GetPhOutFlag(Adm As %String) As %String
{
	new (Adm)
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	set PhOutFlag=##class(web.DHCBillCommon).GetIPParamConfig(HospDR, "OutPhBillCondition")
	quit PhOutFlag
}

ClassMethod GetPatTypeByRecLoc(pattype As %String, recloc As %String) As %String
{
	New (pattype, recloc)
	Quit:(recloc="") pattype
	Set recsubtype=$O(^DHCTARRS(0,"RS",recloc,""))
	Quit:(recsubtype="") pattype
	Set subtype=$p($g(^DHCTARRS(recsubtype)),"^",2)
	Quit:(subtype="") pattype
	Quit subtype
}

/// Creator: yyx
/// CreateDate: yyx
/// Function: 根据医嘱明细rowid取医嘱明细(oe_orditem)
/// Output: OEPirorCode_"^"_StatCode_"^"_BUomCode_"^"_ArcGrp_"^"_OrdCateType_"^"_ArcimRowID_"^"_OEXDate_"^"_OEXTime_"^"_OEStDate_"^"_OEStTime
ClassMethod GetOEOrdItemInfo(OrdItmRowID)
{
	n (OrdItmRowID)
    s OEOrd=+OrdItmRowID, ItmCld=$p(OrdItmRowID,"||",2)
    s ArcimRowID=$p(^OEORD(OEOrd,"I",ItmCld,1),"^",2)
    i $d(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1))=0  d
	.s ^DHCIPBILLOEORDERR(OEOrd,ItmCld)="NoArcimItem^"_ArcimRowID
    q:($d(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1))=0) ""   ;医嘱对应的医嘱项不存在
    s OEBillFlag=$p($g(^OEORD(OEOrd,"I",ItmCld,3)),"^",5)	   ;OEORI_Billed
    s OEXDate=$p($g(^OEORD(OEOrd,"I",ItmCld,3)),"^",34)        ;OEORI_XDate
    s OEXTime=$p($g(^OEORD(OEOrd,"I",ItmCld,2)),"^",15)        ;OEORI_XTime
    s OEStDate=$p($g(^OEORD(OEOrd,"I",ItmCld,1)),"^",9)        ;OEORI_SttDat
    s OEStTime=$p($g(^OEORD(OEOrd,"I",ItmCld,1)),"^",10)       ;OEORI_SttTim
    s OEOrdDate=$p($g(^OEORD(OEOrd,"I",ItmCld,3)),"^",7)       ;OEORI_Date
    s OEPriorDr=$p($g(^OEORD(OEOrd,"I",ItmCld,1)),"^",8)       ;OEORI_priority_dr
    s OEPirorCode=$p($g(^OECPR(+OEPriorDr)),"^",1)
    s OEUom=$p($g(^OEORD(OEOrd,"I",ItmCld,2)),"^",3)           ;oeori_unit_dr ->CT_Unit 剂量单位
	s OEInstr=$p($g(^OEORD(OEOrd,"I",ItmCld,2)),"^",7)         ;OEORI_Instr_DR->PHC_Instruction 用法
	//s BillUom=$p($g(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),8)),"^",14)       //2020-12-07 ZhYW 取单位改为调用医生站接口
	s BillUom=##class(BILL.Interface.Inside.Invoke).GetOrdPackUOMDR(OrdItmRowID)
	s BUomCode=$s((+BillUom'=0):$p($g(^CT("UOM",BillUom)),"^"),1:"")
	s BUomCode=$zcvt(BUomCode,"U")
	s OEStatDr=$p($g(^OEORD(OEOrd,"I",ItmCld,1)),"^",13)      ;OEORI_itemstat_dr
	s StatCode=$p($g(^OEC("OSTAT",+OEStatDr)),"^")
	s ArcGrp=$p($g(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1)),"^",10)          ;子类
	s CatGrp=$p($g(^ARC("IC",ArcGrp)),"^",8)                           ;大类             
	s OrdCateType=$p($g(^ARC("IC",ArcGrp)),"^",7)                      ;医嘱类型
	;
	s OELinkto=$p($g(^OEORD(OEOrd,"I",ItmCld,2)),"^",2)       ;OEORI_linkto
	s OEEnt=$p($g(^OEORD(OEOrd,"I",ItmCld,1)),"^",1)          ;OEORI_Ordent_dr
	s OEPirce=$p($g(^OEORD(OEOrd,"I",ItmCld,3)),"^",25)       ;OEORI_oeprice
    
   q OEPirorCode_"^"_StatCode_"^"_BUomCode_"^"_ArcGrp_"^"_OrdCateType_"^"_ArcimRowID_"^"_OEStDate_"^"_OEStTime_"^"_OEXDate_"^"_OEXTime_"^"_OEEnt_"^"_OEInstr_"^"_OELinkto_"^"_OEPirce_"^"_OEBillFlag
}

/// Creator: ZhYW
/// CreatDate: 2017-11-20
/// Description: 取收费项计费数量
/// Input: pbo:DHC_PatBillOrder.PBO_RowId, tarItm:DHC_TarItem.RowId, dspbDr:DHC_OEDispBatch.RowId
/// Output: 
/// Table: DHC_PatBillDetails
/// Debug: w ##class(web.DHCIPBillPayableFee).GetTarItmBillQty("330704||15", 2252, "")
ClassMethod GetTarItmBillQty(pbo As %String, tarItm As %String, dspbDr As %String) As %String
{
	new (pbo, tarItm, dspbDr)

	set billQty=0
	set pbdSub=0
	for  set pbdSub=$o(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbdSub)) quit:(pbdSub="")  do
	.set tmp=$g(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbdSub))
	.set myTarItm=$p(tmp,"^",3)
	.quit:(tarItm'=myTarItm)
	.set myDspbDr=$p(tmp,"^",27)
	.quit:(dspbDr'=myDspbDr)
	.set myBillQty=$p(tmp,"^",5)
	.set billQty=billQty+myBillQty

	quit billQty
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 获取门诊退药数量
/// Input: oeore: OE_OrdExec.RowId
/// Output: 
/// Return: 
/// Debug: w ##class(web.UDHCJFBILLIP).GetRefundQtyO("3927||4||1")
ClassMethod GetRefundQtyO(oeore As %String) As %String
{
	new (oeore)
	
	set refundQty=0
	
	set dsp=0
	for  set dsp=$o(^DHCOEDISQTY(0,"OEORE",oeore,dsp)) quit:(dsp="")  do
	.set dspInfo=$g(^DHCOEDISQTY(dsp))
	.quit:(dspInfo="")
	.set dspStatus=$p(dspInfo,"^",7)
	.quit:(dspStatus'="R")
	.set dspQty=+$p(dspInfo,"^",11)
	.set refundQty=refundQty+dspQty
		
	set expStr=""
	set applyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY($p(oeore,"||",1,2), expStr)
	set factRefQty=$p(applyRefQtyInfo,"^",3)    //已退数量
	if (+factRefQty'=0) {
		set refundQty=factRefQty
	}
	
	quit refundQty
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否转入该住院就诊
/// Input: adm: PA_Adm.RowId(住院), oeitm: OE_OrdItem.RowId
/// Output: 
/// Return: 1:是, 0:否
/// Debug: w ##class(web.UDHCJFBILLIP).OrdIsOPToIPByIPAdm(1250, "1174||3")
ClassMethod OrdIsOPToIPByIPAdm(adm As %String, oeitm As %String) As %String
{
	new (adm, oeitm)
	set rtn=0
	quit:((adm=0)||(oeitm="")) rtn
	
	set rtn=$$IsOP2IPOrd(adm, oeitm)
	if (rtn=1) {
		quit rtn
	}
	
	//判断是否是婴儿的急诊费用转入
	set babyAdm=0
	while ($o(^PAADMi("Mother",adm,babyAdm))&&(rtn=0)) {
		set babyAdm=$o(^PAADMi("Mother",adm,babyAdm))
		set rtn=$$IsOP2IPOrd(babyAdm, oeitm)
	}

	quit rtn
	
IsOP2IPOrd(adm, oeitm)
	new (adm, oeitm)
	set flag=0
	set ociId=$o(^DHCOPIPADMCON(0,"IPADM",adm,"OEORI",oeitm,""),-1)
	if (+ociId'=0) {
		set tmp=$g(^DHCOPIPADMCON(ociId))
		set status=$p(tmp,"^",7)
		if (status="N") {
			set flag=1
		}
	}
	quit flag
}

}
