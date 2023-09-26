Import SQLUser

Class web.UDHCJFBILL Extends BILL.COM.Abstract [ Not ProcedureBlock ]
{

/// Input: flag="0" 按照病人Adm账单, flag="1" 按医嘱串账单
/// Debug: w ##class(web.UDHCJFBILL).BILL("1588","5","","")
ClassMethod BILL(adm As %String, userId As %String, ordstr As %String = "", flag As %String = "") As %String [ ProcedureBlock = 1 ]
{
	set $zt="ERROR"
	
	quit:(adm="") -1_"^"_"参数错误"
	
    set admType=$p(^PAADM(adm),"^",2)
    quit:(admType="I") 0
    
	set rtn=##class(web.DHCOPBillChargExcepiton).CheckTPFlagByEpisodeID(adm, "")
	quit:((" O E "[(" "_admType_" "))&&(+rtn)) 0
    
    //+2022-10-09 ZhYW 改为使用系统锁
    set lockErr=##class(DHCDoc.Util.System).LOCK("PA_Adm", adm, userId, $zu(67,15,$j))
	quit:(+lockErr'=-1) -110_"^"_##class(websys.Translation).Get("", "就诊")_"："_adm_##class(websys.Translation).Get("", "被锁定")
	
	set rtnValue=..BILLC(adm, userId, ordstr, flag)
	
	do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", adm)
	
	quit rtnValue
	
ERROR
	quit ..AppException()
}

ClassMethod BILLC(adm As %String, userId As %String, ordstr As %String, flag As %String) As %String [ ProcedureBlock = 1 ]
{
	quit:(adm="") -1_"^"_"参数错误"
	
	kill ^||TMP("IB",$j)
	
	//Get Patient Admission Details
	set PatType=$p($g(^PAADM(adm,1)),"^",6)
	set InsType=$p($g(^PAADM(adm,1)),"^",7)
	
	//Get Patient Admission OEORD
	set Ord=$o(^OEORD(0,"Adm",adm,""))
	quit:(Ord="") 0
	
	set LockErr=##class(DHCDoc.Util.System).LOCK("OE_Order", Ord, userId, $zu(67,15,$j))
	quit:(+LockErr'=-1) -110_"^"_"医嘱："_Ord_"被锁定"
	
	//Calculate Order
	set OrdFrom=+$h, OrdEnd=0
	set Count=..ORDERS(Ord, ordstr, flag, PatType, InsType, .OrdFrom, .OrdEnd, adm)
	
	//Insert DHC_PatientBill
	set RtnValue=0
	if (Count>0) {
		set RtnValue=..PBORD(adm, OrdFrom, OrdEnd, userId)
	}
	
	//set EndTime=+$p($ZUTIL(188),",",2)
	//set ^||TMP("DHCBILLTime2",$H,adm)=EndTime-StartTime
	
	kill ^||TMP("IB",$j)
	
	do ##class(DHCDoc.Util.System).LOCKCLR("OE_Order", Ord)
	
	quit RtnValue
}

/// Return Status
/// Status=1 Should be billed
/// Status'=1 Cannot be billed
ClassMethod CheckBillPoint(oeitm As %String, OrdStatus As %String) As %String
{
	new (oeitm, OrdStatus)
	set Itm=+oeitm, Cld=$p(oeitm,"||",2)
	
	set Status=0
	set BillDate="", BillTime=""
	
	//+2021-10-28 ZhYW 验证医嘱，医嘱数据不合法的不能账单
	set rtnValue=##class(BILL.OP.COM.Method).IsValidOrd(oeitm)
	set rtn=('$p(rtnValue,"^",1))
	if (+rtn) {
		quit Status_"^"_BillDate_"^"_BillTime
	}
	
	set OESttDate=$p(^OEORD(Itm,"I",Cld,1),"^",9)    //OEORI_SttDat
	set OESttTime=$p(^OEORD(Itm,"I",Cld,1),"^",10)   //OEORI_SttTim
	if (" V E "[(" "_OrdStatus_" ")) {
		set BillDate=OESttDate
		set BillTime=OESttTime
		set Status=1
	}
	if (" D U "[(" "_OrdStatus_" ")) {
		set BillDate=$p(^OEORD(Itm,"I",Cld,3),"^",34)   //OEORI_XDate
		set BillTime=$p(^OEORD(Itm,"I",Cld,2),"^",15)   //OEORI_XTime
		set Status=1
	}
	//更新医嘱表取价格日期
	set rtn=..UpdateOrdPriceDate(oeitm, OESttDate, OESttTime)
	if (+rtn) set Status=0
	
	quit Status_"^"_BillDate_"^"_BillTime
}

ClassMethod Error()
{
	set count=$o(^DHCERROR($ZN,""),-1)+1
	set ^DHCERROR($ZN,count)=$ZERROR_"  "_$H
	quit
}

ClassMethod GetItem(pattype As %String, instype As %String, oeitm As %String, arcim As %String, oeprice As %String, BillDate As %String, BillTime As %String, adm As %String) As %String
{
	new (pattype, instype, oeitm, arcim, oeprice, BillDate, BillTime, adm)
	
	set Price=0, DiscPrice=0, InsPrice=0, PatPrice=0
	//取Adm保存的挂号优惠类别
	set RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)
    set HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
   	set regLoc="", oeore=""
	set itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_oeore_"^"_adm_"^"_regLoc_"^"_""
	
    set priceDate=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9)),"^",15)    //OEORI_BillPriceDate

	//2016-05-25 Lid 取预约检查医嘱单价
	set OEOREBillFlag=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)
	set priceStr="0^0^0^0"
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRep="Y") do
	.set itmDr=0
	.for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:(itmDr="")  do
	..set artiDr=0
	..for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:(artiDr="")  do
	...set artiData=$g(^DHCAPREPTA(artiDr))
	...set disc=$p(artiData,"^",4)	       //ARTI_Disc
	...set itm=$p(artiData,"^",5)	       //ARTI_Tar_Dr
	...set qty=$p(artiData,"^",8)	       //ARTI_Qty
	...set ordExec=$p(artiData,"^",10)	   //ARTI_OrdExec
	...set exec=$p(ordExec,"||",3)
	...set billStatus=$p(artiData,"^",9)   //ARTI_Billed
	...quit:(" TB I "'[(" "_billStatus_" "))
	...quit:(OEOREBillFlag'=billStatus)
	...set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
	...set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
	...set Price=$p(err0,"^",1)*qty+Price
	...set DiscPrice=$p(err0,"^",2)*qty+DiscPrice
	...set InsPrice=$p(err0,"^",3)*qty+InsPrice
	...set PatPrice=$p(err0,"^",4)*qty+PatPrice
	...if '$d(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",itm,"Exec",exec)) do
	....set ^||TMP("IB",$j,"ORDER",oeitm,"ITEM",itm,"Exec",exec)=qty_"^"_err0_"^"_BillDate_"^"_BillTime_"^"_disc_"^"_artiDr
	...else  do
	....set tmpitm=^||TMP("IB",$j,"ORDER",oeitm,"ITEM",itm,"Exec",exec)
	....set $p(tmpitm,"^",1)=$p(tmpitm,"^",1)+qty
	....set ^||TMP("IB",$j,"ORDER",oeitm,"ITEM",itm,"Exec",exec)=tmpitm
	.set priceStr=Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
	quit:(isAppRep="Y") priceStr
	
	//2017-09-13 Lid 药品医嘱结构改造
	set priceStr="0^0^0^0"
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
	if (ordCateType="R") do
	.set statCodeDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",13)
	.set statCode=$s((statCodeDR'=""):$p($g(^OEC("OSTAT",statCodeDR)),"^",1), 1:"")
	.set dspQty=0
	.set dspDr=0
	.for  set dspDr=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dspDr)) quit:(dspDr="")  do
	..set dspData=$g(^DHCOEDISQTY(dspDr))
	..quit:(dspData="")
	..set myDspQty=+$p(dspData,"^",11)
	..set dspQty=dspQty+myDspQty
	..set dspbSub=0
	..for  set dspbSub=$o(^DHCOEDISQTY(dspDr,"I",dspbSub)) quit:(dspbSub="")  do
	...set dspbData=$g(^DHCOEDISQTY(dspDr,"I",dspbSub))
	...quit:(dspbData="")
	...set dspbDr=dspDr_"||"_dspbSub
	...set dspbQty=$p(dspbData,"^",2)	   //DSPB_Qty
	...set inciDr=$p(dspbData,"^",5)       //DSPB_INCI_DR
	...set dspbStatus=$p(dspbData,"^",6)   //DSPB_Status
	...set myQty=0, myRefQty=0
	...if (dspbStatus'="R") do
	....set myQty=dspbQty
	...if ((" D U ")[(" "_statCode_" ")) do
	....//停止或作废医嘱取负数量
	....if ((" TC R ") [ (" "_dspbStatus_" ")) do
	.....set myRefQty=-dspbQty
	...else  if ((" V E ")[(" "_statCode_" ")) do   //门诊退药不一定停医嘱，因此医嘱核实状态也要考虑取退费数量
	....if ((" R ") [ (" "_dspbStatus_" ")) do
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
	....if '$d(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",itm,"DSPB",dspDr,dspbSub)) do
	.....set ^||TMP("IB",$j,"ORDER",oeitm,"ITEM",itm,"DSPB",dspDr,dspbSub)=qty_"^"_err0_"^"_BillDate_"^"_BillTime
	....else  do
	.....set tmpitm=$g(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",itm,"DSPB",dspDr,dspbSub))
	.....set $p(tmpitm,"^",1)=$p(tmpitm,"^",1)+qty
	.....set ^||TMP("IB",$j,"ORDER",oeitm,"ITEM",itm,"DSPB",dspDr,dspbSub)=tmpitm
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
	
	//+2022-11-04 ZhYW 全部退费后重新在收费界面收费的，价格从原账单取
	set initPBO=..GetInitChgPBORowID(oeitm)      //获取原来收费时的医嘱账单RowID
	if (initPBO'="") {
		set pb=+initPBO
		set pbo=$p(initPBO,"||",2)
		set pboData=$g(^DHCPB(pb,"O",pbo))
		set Price=$p(pboData,"^",7)
		set DiscPrice=$p(pboData,"^",17)
		set InsPrice=$p(pboData,"^",18)
		set PatPrice=$p(pboData,"^",19)
		set pbd=0
		while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
			set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
			set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
			continue:(pbdData="")
			set Itm=$p(pbdData,"^",3)
			set ItmPrice=+$p(pbdData,"^",4)
			set ItmDiscPrice=+$p(pbdData,"^",18)
			set ItmInsPrice=+$p(pbdData,"^",19)
			set ItmPatPrice=+$p(pbdData,"^",20)
			set Olt=$p(pbdData,"^",29)            //PBD_OrderLinkTar_DR
			continue:(Olt="")
			set qty0=$p($g(^DHCOLT(Olt)),"^",3)   //DHC_OrderLinkTar.OLT_Qty
			set ^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",Olt)=qty0_"^"_ItmPrice_"^"_ItmDiscPrice_"^"_ItmInsPrice_"^"_ItmPatPrice_"^"_BillDate_"^"_BillTime
		}
		
		quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
	}
	
	set ExecuDate=""
	for  set ExecuDate=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate)) quit:(ExecuDate="")  do
	.quit:(ExecuDate>priceDate)
	.set Olt=""
	.for  set Olt=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate,Olt)) quit:(Olt="")  do
	..set OltData=$g(^DHCOLT(Olt))
	..set EndDate=$p(OltData,"^",5)
	..quit:((EndDate'="")&&(EndDate<priceDate))
	..set qty0=$p(OltData,"^",3)
	..set Itm=$p(OltData,"^",2)
	..set err=##class(web.UDHCJFPRICE).GetItmPrice(Itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
	..set err0=$p(err,"^",1)_"^"_$p(err,"^",2)_"^"_$p(err,"^",3)_"^"_$p(err,"^",4)
	..set Price=$p(err,"^",1)*qty0+Price
	..set DiscPrice=$p(err,"^",2)*qty0+DiscPrice
	..set InsPrice=$p(err,"^",3)*qty0+InsPrice
	..set PatPrice=$p(err,"^",4)*qty0+PatPrice
	..set ^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",Olt)=qty0_"^"_err0_"^"_BillDate_"^"_BillTime   //+2022-11-01 ZhYW 增加医嘱项关联收费项关联表Id节点
	
	quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
}

ClassMethod LOCK(ADM, BILL, USER, COMPU)
{
	if (ADM="") set ADM=$p(^DHCPB(BILL),"^")
	set order=$o(^OEORD(0,"Adm",ADM,""))
	set err=$$LOCK^SSLOCK("OE_Order",order,USER)
	if $d(^DBLock("DHC_PatientBill",BILL)) do  quit 100
	.set ssid=$p(^DBLock("DHC_PatientBill",BILL),"^")
	.set name=$p(^SSU("SSUSR",ssid),"^",2)
	.set PLIST(1)="抱歉,目前"_name_",机器:"_COMPU_"正在作结算,请等会好吗?"
	.set PLIST=1
	set err=$$LOCK^SSLOCK("DHC_PatientBill",BILL,USER,COMPU)
	quit err
}

ClassMethod ORDERS(Ord, ordstr, flag, pattype, instype, OrdFrom, OrdEnd, adm)
{
	new (Ord, ordstr, flag, pattype, instype, OrdFrom, OrdEnd, adm)
	
	set Count=0
	
	if (flag=1) {
		//实时账单
		set len=$l(ordstr,"^")
		for i=1:1:len {
			set oeitm=$p(ordstr,"^",i)
			continue:(oeitm="")
			continue:($d(^||TMP("IB",$j,"ORDER",oeitm)))
			continue:('$d(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)))
			continue:(..OrdIsOPToIPByOEORI(oeitm)=1)      //+2019-07-23 ZhYW  将转出的医嘱退出
			set ErrCode=..GetBillData(oeitm, pattype, instype, adm)
			continue:(ErrCode)
			set OrdBillDate=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9)),"^",15)   //OEORI_BillPriceDate
			if (OrdBillDate<OrdFrom) set OrdFrom=OrdBillDate
			if (OrdBillDate>OrdEnd) set OrdEnd=OrdBillDate
			set Count=$i(Count)
		}
	}else {
		//按病人账单
		set Itm=0
		while($o(^OEORD(Ord,"I",Itm))) {
			set Itm=$o(^OEORD(Ord,"I",Itm))
			set oeitm=Ord_"||"_Itm
			continue:('$d(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)))
			continue:(..OrdIsOPToIPByOEORI(oeitm)=1)     //+2019-07-23 ZhYW  将转出的医嘱退出
			set ErrCode=..GetBillData(oeitm, pattype, instype, adm)
			continue:(ErrCode)
			set OrdBillDate=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9)),"^",15)   //OEORI_BillPriceDate
			if (OrdBillDate<OrdFrom) set OrdFrom=OrdBillDate
			if (OrdBillDate>OrdEnd) set OrdEnd=OrdBillDate
			set Count=$i(Count)
		}
	}
	
	quit Count
}

/// Debug: w ##class(web.UDHCJFBILL).GetBillData("4||1", "", "", "")
ClassMethod GetBillData(oeitm As %String, pattype As %String, instype As %String, adm As %String)
{
    new (oeitm, pattype, instype, adm)
    
    set ErrCode=1
    
	set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	quit:(+arcim=0) ErrCode
	set billed=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3)),"^",5)
	quit:(billed="P") ErrCode
	
	set priorDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",8)
	set priorCode=$p($g(^OECPR(+priorDR)),"^",1)
	quit:(priorCode["OM") ErrCode
	
	set arcgrp=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)          //子类
	set ordCateType=$p($g(^ARC("IC",arcgrp)),"^",7)                      //医嘱类型
	quit:((billed="B")&&(ordCateType'="R")) ErrCode    //药品可以多次记账

	set statDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",13)
	set statCode=$p($g(^OEC("OSTAT",+statDR)),"^",1)
	quit:(statCode="I") ErrCode	      //未审核的不账单(OEC_OrderStatus)
	
	set err=..CheckBillPoint(oeitm, statCode)
	quit:($p(err,"^",1)'=1) ErrCode
	set BillDate=$p(err,"^",2)
	set BillTime=$p(err,"^",3)
 	
	//Calculate Billing Qty
	set qty=..GetBillQty(oeitm, statCode, arcgrp, arcim)

	//set recloc=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3)),"^",6)    //接收科室
	//set pattype=..GetPatTypeByRecLoc(pattype, recloc)
	
	//Get order price and set item
	set oeprice=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3)),"^",25)   //OEORI_Price
	set price=..GetItem(pattype, instype, oeitm, arcim, oeprice, BillDate, BillTime, adm)

	set ^||TMP("IB",$j,"ORDER",oeitm)=""
	set ^||TMP("IB",$j,"ORDER",oeitm,"PRICE")=price
	set ^||TMP("IB",$j,"ORDER",oeitm,"QTY")=qty
	
	quit 0
}

ClassMethod PBCHG(AmtStr, Tot, TotDisc, TotIns, TotPat)
{
	new (AmtStr, Tot, TotDisc, TotIns, TotPat)
	set TotalAmt=$p(AmtStr,"^",1)
	set DiscAmt=$p(AmtStr,"^",2)
	set InsAmt=$p(AmtStr,"^",3)
	set PatAmt=$p(AmtStr,"^",4)
	
	set Tot=Tot+TotalAmt
	set TotDisc=TotDisc+DiscAmt
	set TotIns=TotIns+InsAmt
	set TotPat=TotPat+PatAmt
		
	quit 0
}

ClassMethod PBOADD(PBO, ORD, USER)
{
    new (PBO, ORD, USER)
    	
	set OldPBOData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2)))
	set OldQty=+$p(OldPBOData,"^",5)
	set RefundQty=+$p(OldPBOData,"^",6)
	set JFQty=OldQty+RefundQty
	set NewQty=+$p($g(^||TMP("IB",$j,"ORDER",ORD,"QTY")),"^",1)
	set Qty=NewQty-JFQty
	set $p(^||TMP("IB",$j,"ORDER",ORD,"QTY"),"^",1)=Qty
	
	//2016-07-23 Lid 预约检查类医嘱，不按原来的单价计费。
	set arcim=$p(^OEORD(+ORD,"I",$p(ORD,"||",2),1),"^",2)
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(ORD)
	quit:(isAppRep="Y") 0
	
	if (Qty=0) quit 0
	
	if (Qty<0) set Status="R"
	else  set Status="B"
	
	set OldTotalAmount=$p(OldPBOData,"^",8)
	set OldDiscAmount=$p(OldPBOData,"^",9)
	set OldPayorShare=$p(OldPBOData,"^",10)
	set OldPatientShare=$p(OldPBOData,"^",11)
	
	set err=..PBOUPD(PBO, ORD, Status, USER)
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0

	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ORD)
	
	if (ordCateType="R") {
		set Itm=""
		for  set Itm=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set dspDr=""
		.for  set dspDr=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"DSPB",dspDr)) quit:((dspDr="")||(+err))  do
		..set dspbSub=""
		..for  set dspbSub=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"DSPB",dspDr,dspbSub)) quit:((dspbSub="")||(+err))  do
		...set dspbDr=dspDr_"||"_dspbSub
		...set rtn=..PBODINS(PBO, ORD, Itm, Status, USER, "", dspbDr)
		...set err=$p(rtn,"^",1)
		
		if (+err=0) {
			set rtn=..PBOUpdateByPBD(PBO)
			set err=$p(rtn,"^",1)
		}
	}else {
		set Itm=""
		for  set Itm=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set Olt=""
		.for  set Olt=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
		..set rtn=..PBODINS(PBO, ORD, Itm, Status, USER, "", "", Olt)
		..set err=$p(rtn,"^",1)
	}
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//set BillStatus=$p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)
	//if (BillStatus'="R") set $p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)="B"

	set PBOData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2)))
	set PBOBillQty=$p(PBOData,"^",5)
	set PBORefQty=$p(PBOData,"^",6)
	set PBOQty=PBOBillQty+PBORefQty
	if (PBOQty=0) set $p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)="R"
	else  set $p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)="B"
	
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

ClassMethod PBODEL(PBO, USER)
{
	new (PBO, USER)
	
	do ..SetDetPatBillDetails(PBO)
	set err=##class(web.UDHCJFPBO).SELECT(PBO)
	quit:(+err) err_"^"_0_"^"_0_"^"_0_"^"_0
	set TotalAmount=-PLIST(8)
	set DiscAmount=-PLIST(9)
	set PayorShare=-PLIST(10)
	set PatientShare=-PLIST(11)
	set err=##class(web.UDHCJFPBO).PBODEL(PBO)
	quit:(+err) err_"^"_0_"^"_0_"^"_0_"^"_0
	
	quit err_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatientShare
}

/// Modify: 2022-11-01 ZhYW 增加医嘱项关联收费项关联表Id
ClassMethod PBODINS(PBO, ORD, Itm, Status, User, Exec = "", dspbDr = "", Olt = "")
{
	new (PBO, ORD, Itm, Status, User, Exec, dspbDr, Olt)
	if (Exec'="") {
		//新版检查申请单账单明细表按执行记录插入
		set ItmData=$g(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"Exec",Exec))
	}elseif (dspbDr'="") {
		//药品按DHC_OEDispBatch
		set dspDr=$p(dspbDr,"||",1)
		set dspbSub=$p(dspbDr,"||",2)
		set ItmData=$g(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"DSPB",dspDr,dspbSub))
	}elseif (Olt'="") {
		set ItmData=$g(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"OLT",Olt))
	}else {
		set ItmData=$g(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm))
	}
	
	set Qty0=$p(ItmData,"^",1)
	set Price0=$p(ItmData,"^",2)
	set DiscPrice0=$p(ItmData,"^",3)
	set InsPrice0=$p(ItmData,"^",4)
	set PatPrice0=$p(ItmData,"^",5)
	set BillDate=$p(ItmData,"^",6)
	set BillTime=$p(ItmData,"^",7)
	set disc=$p(ItmData,"^",8)	        //新版申请单折扣系数
	set artiDr=$p(ItmData,"^",9)	    //新版申请单中间表指针
	
	set OrdQty=$p($g(^||TMP("IB",$j,"ORDER",ORD,"QTY")),"^",1)
	
	kill PLIST
	set PLIST(0)=PBO
	set PLIST(3)=Itm
	set PLIST(4)=+Price0
	if (dspbDr="") {
		set PLIST(5)=Qty0*OrdQty
	}else {
		set initBillQty=..GetTarItmBillQty(PBO, Itm, dspbDr)
		quit:((+initBillQty'=0)&&(+Qty0=+initBillQty)) 0_"^"_0_"^"_0_"^"_0_"^"_0
		set PLIST(5)=Qty0-initBillQty
	}	
	set PLIST(7)=+..round(Price0*PLIST(5))
	set PLIST(8)=+..round(DiscPrice0*PLIST(5))
	set PLIST(9)=+..round(InsPrice0*PLIST(5))
	set PLIST(10)=PLIST(7)-PLIST(8)-PLIST(9)
	
	if (BillDate="") set BillDate=+$h
	if (BillTime="") set BillTime=$p($h,",",2)
	set PLIST(11)=BillDate                ;计费日期
	set PLIST(12)=BillTime                ;计费时间
	set PLIST(13)=Status              
	set PLIST(14)=+$h
	set PLIST(15)=$p($h,",",2)
	set PLIST(16)=User
	;Add By Su MingLiang 2007/08/04
	set PLIST(18)=+DiscPrice0
	set PLIST(19)=+InsPrice0
	set PLIST(20)=+PatPrice0
	;
	set PLIST(25)=disc
	set PLIST(26)=artiDr
	set PLIST(27)=dspbDr
	set PLIST(29)=Olt       //+2022-11-01 ZhYW 增加医嘱项关联收费项关联表Id节点
	set err=##class(web.UDHCJFPBOD).INSERT()
	
	quit err_"^"_+PLIST(7)_"^"_+PLIST(8)_"^"_+PLIST(9)_"^"_+PLIST(10)
}

ClassMethod PBOINS(BILL, ORD, USER)
{
	new (BILL, ORD, USER)
	
	set PriceStr=$g(^||TMP("IB",$j,"ORDER",ORD,"PRICE"))
	set UnitPrice=$p(PriceStr,"^",1)
	set DiscPrice=$p(PriceStr,"^",2)
	set InsPrice=$p(PriceStr,"^",3)
	set PatPrice=$p(PriceStr,"^",4)
	
	set Qty=$p(^||TMP("IB",$j,"ORDER",ORD,"QTY"),"^",1)
	
	set ArcimRowID=$p(^OEORD(+ORD,"I",$p(ORD,"||",2),1),"^",2)
	set BillPriceDate=$p($g(^OEORD(+ORD,"I",$p(ORD,"||",2),9)),"^",15)    //OEORI_BillPriceDate
	set BillPriceTime=$p($g(^OEORD(+ORD,"I",$p(ORD,"||",2),9)),"^",16)    //OEORI_BillPriceTime
	
	kill PLIST
	set PLIST(0)=BILL
	set PLIST(3)=ArcimRowID
	set PLIST(4)=ORD
	set PLIST(5)=UnitPrice
	set PLIST(6)=Qty
	set PLIST(7)=0
	set PLIST(8)=+..round(UnitPrice*Qty)
	set PLIST(9)=+..round(DiscPrice*Qty)
	set PLIST(10)=+..round(InsPrice*Qty)
	set PLIST(11)=PLIST(8)-PLIST(9)-PLIST(10)
	;
	set PLIST(17)=+DiscPrice
	set PLIST(18)=+InsPrice
	set PLIST(19)=+PatPrice
	;
	set PLIST(12)=BillPriceDate
	set PLIST(13)=BillPriceTime
	set err=##class(web.UDHCJFPBO).INSERT()
	quit:(+err) err_"^"_0_"^"_0_"^"_0_"^"_0
	set PBO=PLIST(1)
	
	set Status="B"
	
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ORD)
	if (ordCateType="R") {
		set Itm=""
		for  set Itm=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set dspDr=""
		.for  set dspDr=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"DSPB",dspDr)) quit:((dspDr="")||(+err))  do
		..set dspbSub=""
		..for  set dspbSub=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"DSPB",dspDr,dspbSub)) quit:((dspbSub="")||(+err))  do
		...set dspbDr=dspDr_"||"_dspbSub
		...set rtn=..PBODINS(PBO, ORD, Itm, Status, USER, "", dspbDr)
		...set err=$p(rtn,"^",1)
		
		if (+err=0) {
			set rtn=..PBOUpdateByPBD(PBO)
			set err=$p(rtn,"^",1)
		}
	}else {
		set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(ORD)
		if (isAppRep="Y") {
			set Itm=""
			for  set Itm=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm)) quit:((Itm="")||(+err))  do
			.set Exec=""
			.for  set Exec=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"Exec",Exec)) quit:((Exec="")||(+err))  do
			..set rtn=..PBODINS(PBO, ORD, Itm, Status, USER, Exec)
			..set err=$p(rtn,"^",1)
		}else {
			set Itm=""
			for  set Itm=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm)) quit:((Itm="")||(+err))  do
			.set Olt=""
			.for  set Olt=$o(^||TMP("IB",$j,"ORDER",ORD,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
			..set rtn=..PBODINS(PBO, ORD, Itm, Status, USER, "", "", Olt)
			..set err=$p(rtn,"^",1)
		}
	}
	quit:(+err) err_"^"_0_"^"_0_"^"_0_"^"_0
	
	set $p(^OEORD(+ORD,"I",$p(ORD,"||",2),1),"^",16)=PBO
	
	//set BillStatus=$p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)
	//if (BillStatus'="R") set $p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)="B"
	
	set PBOData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2)))
	set PBOBillQty=$p(PBOData,"^",5)
	set PBORefQty=$p(PBOData,"^",6)
	set PBOQty=PBOBillQty+PBORefQty
	if (PBOQty=0) set $p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)="R"
	else  set $p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)="B"
	
	//2016-07-19 Lid 更新预约检查申请单明细表的账单状态
	set err=..UpdateAppRepTarItmBillStatus(ORD, "TB", "B", PBO)
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	set TotalAmount=$p(PBOData,"^",8)
	set DiscAmount=$p(PBOData,"^",9)
	set PayorShare=$p(PBOData,"^",10)
	set PatientShare=$p(PBOData,"^",11)

	quit err_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatientShare
}

ClassMethod PBORD(adm, OrdFrom, OrdEnd, userId)
{
	set $zt="ERROR^DHCSSERR"
	new (adm, OrdFrom, OrdEnd, userId)
	
	quit:(adm="") ""
	
	set rtn=0
	ts
	
	set PBRowID=""
	
	set PB=0
	while($o(^DHCPB(0,"ADM",adm,PB))) {
		set PB=$o(^DHCPB(0,"ADM",adm,PB))
		set PBData=$g(^DHCPB(PB))
		set PayedFlag=$p(PBData,"^",16)
		continue:(PayedFlag="P")
		set PBRowID=PB
		quit
	}
	if (PBRowID="") {
	    set rtnValue=##class(web.UDHCJFPB).PBINS(adm, userId)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		set PBRowID=$p(rtnValue,"^",2)
	}
	
	set Tot=0, TotDisc=0, TotIns=0, TotPat=0
	set ORD=""
	for  set ORD=$o(^||TMP("IB",$j,"ORDER",ORD)) quit:((ORD="")||(+rtn))  do
	.set BillFlag=$p($g(^OEORD(+ORD,"I",$p(ORD,"||",2),3)),"^",5)   //OEORI_Billed
	.set PBO=""
	.set OrdSub=""
	.for  set OrdSub=$o(^DHCPBi(0,"OEORI",ORD,PBRowID,OrdSub)) quit:((OrdSub="")||(PBO'=""))  do
	..quit:($p(^DHCPB(PBRowID,"O",OrdSub),"^",14)="Y")
	..set PBO=PBRowID_"||"_OrdSub
	.;
	.if ((BillFlag="TB")&&(PBO'="")) do
	..set rtnValue=..PBODEL(PBO, userId)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	..set PBO=""
	.;
	.if (BillFlag="TB") do
	..set rtnValue=..PBOINS(PBRowID, ORD, userId)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.if ((BillFlag="I")&&(PBO="")) do
	..set rtnValue=..PBOINS(PBRowID, ORD, userId)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.if ((BillFlag="I")&&(PBO'="")) do
	..do ..SetItmPrice(ORD, PBO)
	..set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(ORD)
	..if (isAppRep'="Y") do
	...set rtnValue=..PBOADD(PBO, ORD, userId)
	..else  do
	...set rtnValue=..RefunAppRep(ORD, PBO, userId)  //如果是预约申请单医嘱，新版检查申请单退费	模式：全部退费再收
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.if ((BillFlag="B")&&(PBO="")) do
	..set rtnValue=..PBOINS(PBRowID, ORD, userId)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.if ((BillFlag="B")&&(PBO'="")) do
	..set rtnValue=..PBOADD(PBO, ORD, userId)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.if ((BillFlag="R")&&(PBO'="")) do
	..set rtnValue=..PBOADD(PBO, ORD, userId)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.if ((BillFlag="TR")&&(PBO="")) do
	..set rtnValue=..PBOREFUND(PBRowID, ORD, userId)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	..set rtnValue=..PBOINS(PBRowID, ORD, userId)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.set rtn=..UpdateOrdDetailBalance(ORD)
	.quit:(+rtn)
	
	if (+rtn)  tro  quit rtn
	
	if (+PBRowID'=0) {
		set rtn=..PBUPD(PBRowID, userId, Tot, TotDisc, TotIns, TotPat, OrdFrom, OrdEnd)
		if (+rtn) tro  quit rtn
	}
	
	if ($tl>0) tc
	
	quit rtn_"^"_PBRowID
}

ClassMethod PBOREFUND(BILL, ORD, USER)
{
	new (BILL, ORD, USER)
	
	set RefBill=$p(^OEORD(+ORD,"I",$p(ORD,"||",2),2),"^",9)
	set DisDate=$p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",34)
	if (DisDate="") set DisDate=+$h
	set DisTime=$p(^OEORD(+ORD,"I",$p(ORD,"||",2),2),"^",13)
	if (DisTime="") set DisTime=$p($h,",",2)
	
	set err=##class(web.UDHCJFPBO).SELECT(RefBill)
	quit:(+err) err_"^"_0_"^"_0_"^"_"0"_"^"_0
	kill PLIST(1), PLIST(2)
	set PLIST(0)=BILL
	set PLIST(6)=-PLIST(6)
	set PLIST(7)=-PLIST(7)
	set PLIST(8)=-PLIST(8)
	set PLIST(9)=-PLIST(9)
	set PLIST(10)=-PLIST(10)
	set PLIST(11)=-PLIST(11)
	set PLIST(12)=DisDate                      //计费日期
	set PLIST(13)=DisTime                      //计费时间
	set PLIST(14)="Y"
	set PLIST(15)=RefBill
	set err=##class(web.UDHCJFPBO).INSERT()
	quit:(+err) err_"^"_0_"^"_0_"^"_"0"_"^"_0
	set NewPBO=PLIST(1)
	set Tot=PLIST(8)_"^"_PLIST(9)_"^"_PLIST(10)_"^"_PLIST(11)
	;
	set $p(^OEORD(+ORD,"I",$p(ORD,"||",2),3),"^",5)="R"
	;
	set Itm=0
	for  set Itm=$o(^DHCPB(+RefBill,"O",$p(RefBill,"||",2),"D",Itm)) quit:((Itm="")||(+err))  do
	.set err=##class(web.UDHCJFPBOD).SELECT(RefBill_"||"_Itm)
	.quit:(+err)
	.kill PLIST(1), PLIST(2)
	.set PLIST(0)=NewPBO
	.set PLIST(5)=-PLIST(5)
	.set PLIST(7)=-PLIST(7)
	.set PLIST(8)=-PLIST(8)
	.set PLIST(9)=-PLIST(9)
	.set PLIST(10)=-PLIST(10)
	.set PLIST(11)=DisDate
	.set PLIST(12)=DisTime
	.set PLIST(16)=USER
	.set err=##class(web.UDHCJFPBOD).INSERT()
	.quit:(+err)
	
	quit err_"^"_Tot
}

ClassMethod PBOUPD(PBO, ORD, Status, USER)
{
	new (PBO, ORD, Status, USER)
	
	set PriceStr=$g(^||TMP("IB",$j,"ORDER",ORD,"PRICE"))
	set UnitPrice=+$p(PriceStr,"^",1)
	set DiscPrice=+$p(PriceStr,"^",2)
	set InsPrice=+$p(PriceStr,"^",3)
	set PatPrice=+$p(PriceStr,"^",4)
	
	set Qty=$p(^||TMP("IB",$j,"ORDER",ORD,"QTY"),"^",1)
	
	set TotalAmount=+..round(UnitPrice*Qty)
	set DiscAmount=+..round(DiscPrice*Qty)
	set PayorShare=+..round(InsPrice*Qty)
	set PatientShare=TotalAmount-DiscAmount-PayorShare
	
	set rtn=##class(web.UDHCJFPBO).SELECT(PBO)
	quit:(rtn) rtn_"^0^0^0^0"
	if (Status="R") set PLIST(7)=PLIST(7)+Qty
	else  set PLIST(6)=PLIST(6)+Qty
	set PLIST(8)=TotalAmount+PLIST(8)
	set PLIST(9)=DiscAmount+PLIST(9)
	set PLIST(10)=PayorShare+PLIST(10)
	set PLIST(11)=PatientShare+PLIST(11)
	
	set rtn=##class(web.UDHCJFPBO).UPDATE(PBO)
	if (rtn) quit rtn_"^0^0^0^0"
	
	quit rtn_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorShare_"^"_PatientShare
}

ClassMethod PBUPD(BILL, UserId, TotalAmt, DiscAmt, PayorAmt, PatShareAmt, OrdFrom, OrdEnd)
{
	new (BILL, UserId, TotalAmt, DiscAmt, PayorAmt, PatShareAmt, OrdFrom, OrdEnd)
	
	set PBData=$g(^DHCPB(BILL))
	set Adm=$p(PBData,"^",1)	
	set PBDateFrom=$p(PBData,"^",6)    //PB_DateFrom
	set PBDateTo=$p(PBData,"^",7)      //PB_DateTo
	set PBTotalAmt=$p(PBData,"^",8)
	set PBDiscAmt=$p(PBData,"^",9)
	set PBPayorAmt=$p(PBData,"^",11)
	set PBPatShareAmt=$p(PBData,"^",12)
		
	set AdmDate=$p($g(^PAADM(Adm)),"^",6)           //PAADM_AdmDate
	set DischgDate=$p($g(^PAADM(Adm)),"^",17)       //PAADM_DischgDate
 	set EpisSubTypeDR=$p($g(^PAADM(Adm,1)),"^",6)   //PAADM_Epissubtype_DR
 	set InsTypeDR=$p($g(^PAADM(Adm,1)),"^",7)       //PAADM_AdmReason_DR
	set DateFrom=$s(((+PBDateFrom=0)||(OrdFrom<PBDateFrom)):OrdFrom,1:PBDateFrom)
	set DateTo=$s((OrdEnd>PBDateTo):OrdEnd,1:PBDateTo)
	set TotalAmount=PBTotalAmt+TotalAmt
	set DiscAmount=PBDiscAmt+DiscAmt
	set PayorAmount=PBPayorAmt+PayorAmt
	set PatShareAmount=PBPatShareAmt+PatShareAmt
	
	&SQL(
 		UPDATE DHC_PatientBill
 		SET PB_AdmDate = :AdmDate, PB_DisChargeDate = :DischgDate, PB_PatInsType_DR = :InsTypeDR, PB_PatAdmType_DR = :EpisSubTypeDR, PB_DateFrom = :DateFrom,
 			PB_DateTo = :DateTo, PB_TotalAmount = :TotalAmount, PB_DiscAmount = :DiscAmount, PB_PayorShare = :PayorAmount, PB_PatientShare = :PatShareAmount, 			
 			PB_UpdateDate = CONVERT(DATE, NOW()), PB_UpdateTime = CONVERT(TIME, NOW()), PB_UpdateUser = :UserId
 		WHERE %ID = :BILL
 	)
 	set rtn=SQLCODE
 	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

ClassMethod UNLOCK(ADM, BILL, USER, COMPU)
{
	if (ADM="") set ADM=$p(^DHCPB(BILL),"^")
	set order=$o(^OEORD(0,"Adm",ADM,""))
	set err=$$LOCKCLR^SSLOCK("OE_Order",order)
	set err=$$LOCKCLR^SSLOCK("DHC_PatientBill",BILL)
	quit err
}

/// Creator: ZhYW
/// CreatDate: 2022-03-15
/// Debug: w ##class(web.UDHCJFBILL).round(-0.009)
ClassMethod round(Num)
{
	new (Num)
	quit:(+Num=0) 0
	quit:($zabs(Num)<0.01) (Num/$zabs(Num))*0.01    //小于一分钱按一分钱算
	quit $fn(Num,"",2)
}

/// Debug: w ##class(web.UDHCJFBILL).roundBak(0.015)
ClassMethod roundBak(Num)
{
	new (Num)
	set NegFlag=0
	quit:$g(Num)=""!(Num=0) 0
	if (Num<0) set Num=-Num,NegFlag=1
	if (Num<0.01) set Num=0.01
	else  do
	.set Num=+Num+0.0000001
	.set np=$p(Num,".",1)_"."_$e($p(Num,".",2),1,2)
	.set point="0.00"_$e($p(Num,".",2),3,$l($p(Num,".",2)))
	.set Num=np 
	.set:(point'<0.005) Num=Num+0.01
	if (NegFlag=1) set Num=-Num
	quit Num
}

/// Input: adm: 就诊Id
/// 	   userId: 操作员Id
/// 	   ordstr: 住院传执行记录Id, 门诊传医嘱Id
/// 	   flag: 0按就诊账单，1按医嘱或执行记录账单
/// Return:	0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFBILL).BILLN(264721, 1, "","")
ClassMethod BILLN(adm As %String, userId As %String, ordstr As %String = "", flag As %String = 0) As %String [ ProcedureBlock = 1 ]
{
	set BabyInfo=##class(web.UDHCJFORDCHK).GetMotherAdmByBabyAdm(adm)
	set BabyFlag=$p(BabyInfo,"^",1)
	set MotherAdm=$p(BabyInfo,"^",2)
	if (BabyFlag="true") set adm=MotherAdm
	
	set PAADMType=$p(^PAADM(adm),"^",2)
	set StayInfo=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(adm)
	set StayFlag=$p(StayInfo,"^",1)
	quit:((PAADMType="O")||((PAADMType="E"))&&(StayFlag="N")) 0	  //Lid 2015-05-29 解决问题：门诊病人在医生站停止医嘱时不账单。

	set Num=##class(web.UDHCJFBaseCommon).JudgeBillNum(adm)
	quit:(Num>1) 0
	
	if (PAADMType="I") {
		set rtnValue=##class(web.UDHCJFBILLIP).BILL(adm, userId, ordstr, flag)
	}else {
		set rtnValue=##class(web.UDHCJFBILL).BILL(adm, userId, ordstr, flag)
	}
	set err=$p(rtnValue,"^",1)
	quit err
}

ClassMethod GetBillQty(oeitm As %String, statCode As %String, itemCat As %String, arcim As %String) As %String [ ProcedureBlock = 1 ]
{
	set qty=..GetQty(oeitm, statCode, itemCat, arcim)
	set returnQty=..GetRefundQty(oeitm, statCode, itemCat, arcim)
	set billQty=qty-returnQty
	quit billQty
}

ClassMethod GetQty(oeitm As %String, Status As %String, ItemCat As %String, arcim As %String) As %Numeric
{
	new (oeitm, Status, ItemCat, arcim)
	
	set Qty=0
	set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	if (inci'="") {
	    set isOPIVAS=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",16)
     	if (isOPIVAS="Y") {
	     	//取门诊配液医嘱的有效数量
	     	set Qty=##class(BILL.Interface.Inside.Invoke).GetEffectiveQtyForOPIVAS(oeitm)
	     	quit Qty
	    }
	    set dsp=0
	    while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))) {
		    set dsp=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))
		    set disp=$g(^DHCOEDISQTY(dsp))
			set dspStatus=$p(disp,"^",7)
			continue:(dspStatus="R")
			set dspQty=+$p(disp,"^",11)
			set Qty=Qty+dspQty
		}
	} else {
		set Qty=+$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",12)
	}
	
	quit Qty
}

/// Debug: w ##class(web.UDHCJFBILL).GetRefundQty("2942||3","D","3","R","310||1")
ClassMethod GetRefundQty(oeitm As %String, Status As %String, ItemCat As %String, arcim As %String) As %Numeric
{
	new (oeitm, Status, ItemCat, arcim)
	
	set RefundQty=0
	
	set StayFlag=..CheckStayFlag("", oeitm)	         //Y:留观, <>Y:非留观
	set PHRefundFlag=..CheckPartRefund(oeitm)	     //R:有退药记录, 非R:无退药记录
	
	//2021-07-20 Lid  1：部分退费，0：未退费或全部退费
	set IsPartRefund=##class(BILL.OP.COM.Method).IsPartRefund(oeitm)
	if ((StayFlag'="Y")&&(IsPartRefund=1)) {
		set Status="D"     //部分退费时医嘱没有停止但是要取退费数量，先不考虑留观
	}
	
	quit:((" D U ")'[(" "_Status_" "))&&((StayFlag="Y")&&(PHRefundFlag'="R")||(StayFlag'="Y")) RefundQty
	
	set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	if (inci'="") {
	    set isOPIVAS=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",16)
     	if (isOPIVAS="Y") {
	     	quit RefundQty   //门诊配液不根据收-退，直接取有效数量
	    }
	    if (StayFlag="Y") {
			set dsp=0
			while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))) {
				set dsp=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))
				set disp=$g(^DHCOEDISQTY(dsp))
				set dspStatus=$p(disp,"^",7)
				continue:(dspStatus="C")
				set dspQty=+$p(disp,"^",11)
				set RefundQty=RefundQty+dspQty
			}
		} else {
			set RefundQty=##class(BILL.Interface.Inside.Invoke).GetRetOrdQty(oeitm, "")
		}
	} else {
		set RefundQty=+$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",12)
		//2021-04-02 ZhYW 取治疗医嘱未执行数量
		set ExecQty=..GetOrdExecQty(oeitm)
		set RefundQty=RefundQty-ExecQty   //默认为未执行的数量
	}
    
	set ApplyRefundQty=..GetApplyRefundQty(oeitm, "")
	if (+ApplyRefundQty'=0) {
		set RefundQty=ApplyRefundQty	//申请退费数量不为0时，按申请退费数量退费
	}

	quit RefundQty
}

/// Modify: 2022-11-01 ZhYW 修改重新给^||TMP赋值逻辑
ClassMethod SetItmPrice(oeitm As %String, pboRowId As %String)
{
	new (oeitm, pboRowId)
	quit:((oeitm="")||(pboRowId="")) 0
	
	//2016-07-23 Lid 预约检查类医嘱，不按原来的单价计费。
	set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	quit:(isAppRep="Y") 0

	//+2018-10-31 ZhYW 药品医嘱，取原计费价格
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
	quit:(ordCateType="R") ..SetDrugItmPrice(oeitm, pboRowId)
	
	set pb=$p(pboRowId,"||",1)
	set pbo=$p(pboRowId,"||",2)

	set Price=0, DiscPrice=0, InsPrice=0, PatPrice=0
	
	//先将DHC_PatBillDetails中不存在的节点kill
	set Itm=0
	while($o(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm))) {
		set Itm=$o(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm))
		set pbd=0
		while($o(^DHCPB(0,"TARI",Itm,pb,pbo,pbd))) {
			set pbd=$o(^DHCPB(0,"TARI",Itm,pb,pbo,pbd))
			set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
			continue:(pbdData="")
			set olt=$p(pbdData,"^",29)            //PBD_OrderLinkTar_DR
			continue:(olt="")
			continue:($d(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",olt)))
			kill ^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",olt)
		}
	}
	
	//重新赋值
	kill ItmAry
	set pbd=0
	while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
		set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
		set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
		continue:(pbdData="")
		set pbdRowId=pb_"||"_pbo_"||"_pbd
		set Itm=$p(pbdData,"^",3)
		continue:($d(ItmAry(Itm)))   //过滤重复赋值记录
		set ItmAry(Itm)=""
		set ItmPrice=+$p(pbdData,"^",4)
		set ItmDiscPrice=+$p(pbdData,"^",18)
		set ItmInsPrice=+$p(pbdData,"^",19)
		set ItmPatPrice=+$p(pbdData,"^",20)
		set olt=$p(pbdData,"^",29)            //PBD_OrderLinkTar_DR
		continue:(olt="")
		set qty0=$p($g(^DHCOLT(olt)),"^",3)   //DHC_OrderLinkTar.OLT_Qty
		set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",olt),"^",1)=qty0
		set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",olt),"^",2)=ItmPrice
		set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",olt),"^",3)=ItmDiscPrice
		set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",olt),"^",4)=ItmInsPrice
		set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",olt),"^",5)=ItmPatPrice
		set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"OLT",olt),"^",10)=pbdRowId    //+2023-04-17 ZhYW 原计费账单RowId
		;
		set Price=ItmPrice*qty0+Price
		set DiscPrice=ItmDiscPrice*qty0+DiscPrice
		set InsPrice=ItmInsPrice*qty0+InsPrice
		set PatPrice=ItmPatPrice*qty0+PatPrice
	}
	
    set ^||TMP("IB",$j,"ORDER",oeitm,"PRICE")=Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
    
	quit 0
}

/// Debug: w ##class(web.UDHCJFBILL).GetPatTypeByRecLoc()
ClassMethod GetPatTypeByRecLoc(pattype As %String, recloc As %String) As %String
{
	new (pattype, recloc)
	quit:(recloc="") pattype
	set recsubtype=$o(^DHCTARRS(0,"RS",recloc,""))
	quit:(recsubtype="") pattype
	set subtype=$p($g(^DHCTARRS(recsubtype)),"^",2)
	quit:(subtype="") pattype
	quit subtype
}

/// Creator: 杨艳秀
/// CreateDate: 2009-03-16
/// Description: 记录删除的收费项目明细，^DHCOPBillDelDetail(+$h,PBDRowID)=Adm
/// Table: DHC_PatBillOrder, DHC_PatBillDetails
/// Debug: w ##class(web.UDHCJFBILL).SetDetPatBillDetails()
ClassMethod SetDetPatBillDetails(PBORowID As %String) As %String
{
	new (PBORowID)
	set PBRowID=+PBORowID
	set PAADMRowID=$p(^DHCPB(PBRowID),"^",1)
 	set PBOSub=$p(PBORowID,"||",2)
    set PBDSub=0
    while($o(^DHCPB(PBRowID,"O",PBOSub,"D",PBDSub))) {
	    set PBDSub=$o(^DHCPB(PBRowID,"O",PBOSub,"D",PBDSub))
	  	set PBDRowID=PBORowID_"||"_PBDSub
		set ^DHCOPBillDelDetail(+$h,PBDRowID)=PAADMRowID
	}
	quit 0
}

/// Creator: 杨艳秀
/// CreateDate: 2010-01-12
/// Description: 判断DHC_PatBillOrder，DHC_PatBillDetails的医嘱的单条金额是否相等，
///            不等，则将DHC_PatBillDetails中的此医嘱的最后一条收费项目找平
/// Table: DHC_PatBillOrder, DHC_PatBillDetails
ClassMethod UpdateOrdDetailBalance(oeitm As %String) As %String
{
	new (oeitm)
	
	set rtn=0
	quit:(oeitm="") rtn
	
	set PBORowID=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",16)
	quit:(PBORowID="") rtn
	set PB=+PBORowID
	set PBO=$p(PBORowID,"||",2)
	set PBOData=$g(^DHCPB(PB,"O",PBO))
	set PboTotAmt=+$p(PBOData,"^",8)
	set PboDisAmt=+$p(PBOData,"^",9)
	set PboPayAmt=+$p(PBOData,"^",10)
	set PboPatAmt=+$p(PBOData,"^",11)
	
	set PBDRowID=""
	set PbdQty=""
	set PbdTotSum=0, PbdDisSum=0, PbdPaySum=0, PbdPatSum=0
	set PBD=0
	while($o(^DHCPB(PB,"O",PBO,"D",PBD))) {
		set PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD))
		set PBDData=$g(^DHCPB(PB,"O",PBO,"D",PBD))
		continue:(PBDData="")
		set myTotAmt=$p(PBDData,"^",7)
		set myDisAmt=$p(PBDData,"^",8)
		set myPayAmt=$p(PBDData,"^",9)
		set myPatAmt=$p(PBDData,"^",10)
		set myQty=$p(PBDData,"^",5)
		continue:(+myQty=0)      //不能往数量为0的账单上找平
		set PBDRowID=PB_"||"_PBO_"||"_PBD
		set PbdTotAmt=myTotAmt
		set PbdDisAmt=myDisAmt
		set PbdPayAmt=myPayAmt
		set PbdPatAmt=myPatAmt
		set PbdQty=myQty
		set PbdTotSum=$i(PbdTotSum, PbdTotAmt), PbdDisSum=$i(PbdDisSum, PbdDisAmt)
		set PbdPaySum=$i(PbdPaySum, PbdPayAmt), PbdPatSum=$i(PbdPatSum, PbdPatAmt)
	}
	
	//修改最后一条的金额
	if ((PboTotAmt'=PbdTotSum)||(PboDisAmt'=PbdDisSum)||(PboPayAmt'=PbdPaySum)||(PboPatAmt'=PbdPatSum))&&(PBDRowID'="") {
		set BalTotAmt=PbdTotSum-PboTotAmt, BalDisAmt=PbdDisSum-PboDisAmt
		set BalPayAmt=PbdPaySum-PboPayAmt, BalPatAmt=PbdPatSum-PboPatAmt
		set PbdTotAmt=PbdTotAmt-BalTotAmt, PbdDisAmt=PbdDisAmt-BalDisAmt
		set PbdPayAmt=PbdPayAmt-BalPayAmt, PbdPatAmt=PbdPatAmt-BalPatAmt
		set PbdUnitPrice=PbdTotAmt/PbdQty, PbdDisPrice=PbdDisAmt/PbdQty
		set PbdPayPrice=PbdPayAmt/PbdQty, PbdPatPrice=PbdPatAmt/PbdQty
		&SQL(
			UPDATE DHC_PatBillDetails
			SET PBD_UnitPrice = :PbdUnitPrice, PBD_DiscPrice = :PbdDisPrice, PBD_InsPrice = :PbdPayPrice, PBD_PatPrice =:PbdPatPrice,
	   			PBD_TotalAmount = :PbdTotAmt, PBD_DiscAmount = :PbdDisAmt, PBD_PayorShare = :PbdPayAmt, PBD_PatientShare = :PbdPatAmt
	  		WHERE %ID = :PBDRowID
	  	)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
	}
	
    quit rtn
}

/// Creator: Lid
/// CreatDate: 2012-08-18
/// Description: 根据就诊ID或医嘱ID，判断是否为留观病人或特病病人（就诊ID优先级高）
/// Input: adm:PA_Adm.RowId, oeitm:OE_OrdItem.RowId
/// Return: Y:留观病人或特病，N:非留观病人和特病
/// Debug: w ##class(web.UDHCJFBILL).CheckStayFlag("","956||4")
ClassMethod CheckStayFlag(adm As %String, oeitm As %String) As %String
{
	set $zt="AppERROR"
	new (adm, oeitm)
	quit:((+adm=0)&&(+oeitm=0)) "N"

	if (+adm=0) {
		set adm=$p($g(^OEORD(+oeitm)),"^",1)
		quit:(+adm=0) "N"
	}
	
	//+2023-03-30 ZhYW 配置急诊留观为"现金"模式时，算作急诊流水患者
	set stayStatus=##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(adm)
	quit:(stayStatus>0) "Y"  //>0时为急诊留观
	
	set readToBill=$s((oeitm'=""):$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),12)),"^",26),1:"")  //OE_OrdItem.OEORI_ReadyToBill先诊疗后付费
	quit:(readToBill="Y") "Y"
	
	quit "N"
AppERROR
	quit "N"
}

/// Creator: Lid
/// CreatDate: 2012-08-22
/// Description: 获取医嘱的部分退费数量
/// Input: OEORIDR:OE_OrdItem.RowId, ExpStr:扩展串(可以传空)
/// Debug: w ##class(web.UDHCJFBILL).GetApplyRefundQty("339932||20","")
ClassMethod GetApplyRefundQty(OEORIDR As %String, ExpStr As %String = "") As %String
{
	new (OEORIDR, ExpStr)
	set rtn=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORIDR, ExpStr)
	set AppRefQty=$p(rtn,"^",2)     //申请数量
	set FactRefQty=$p(rtn,"^",3)    //已退数量
	quit AppRefQty+FactRefQty
}

/// Description: 判断医嘱是否退药
/// Return: R:说明有退药记录, 非R:没有退药记录
/// Debug: w ##class(web.UDHCJFBILL).CheckPartRefund("331257||122")
ClassMethod CheckPartRefund(oeitm As %String) As %String
{
	new (oeitm)
	set dspStatus=""
	set dsp=0
	while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))) {
		set dsp=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))
		set dspData=$g(^DHCOEDISQTY(dsp))
		set dspStatus=$p(dspData,"^",7)
		quit:(dspStatus="R")
	}
	quit dspStatus
}

/// 新版检查申请单退费
/// 		模式：全部退费再收
ClassMethod RefunAppRep(OEORI As %String, PBO As %String, USER As %String) As %String
{
	new (OEORI, PBO, USER)
	quit:(+PBO=0) 0
	set (Error, TotalAmount, DiscAmount, InsAmount, PatAmount)=0
	set (RefTotalAmount, RefDiscAmount, RefInsAmount, RefPatAmount)=0
	set currDate=+$h, currTime=$p($h,",",2)
	//增加判断，当DHC_PatBillOrder 表中PBO_TotalAmount的值和本次退费的和小于0时不能退费
	set OldPBOTotalAmt=$p(^DHCPB(+PBO,"O",$p(PBO,"||",2)),"^",8)
	quit:(OldPBOTotalAmt=0) 0
	
	//预约检查类医嘱，不按原来的单价计费
	set arcim=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
	quit:(isAppRep'="Y") 0
	
	set OldItmSub=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",""),-1)
	set Itm=0
	for  set Itm=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",Itm)) quit:((Itm="")||(Itm>OldItmSub))  do
	.set BillStatus=$p(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",Itm),"^",14)
	.set PBDRowID=PBO_"||"_Itm
	.set err=##class(web.UDHCJFPBOD).SELECT(PBDRowID)
	.set PLIST(13)="R"
	.set err=##class(web.UDHCJFPBOD).UPDATE(PBDRowID)
	.kill PLIST(1), PLIST(2)
	.set PLIST(0)=PBO
	.set PLIST(5)=-PLIST(5)
	.set RefTotalAmount=RefTotalAmount+PLIST(7)
	.set RefDiscAmount=RefDiscAmount+PLIST(8)
	.set RefInsAmount=RefInsAmount+PLIST(9)
	.set RefPatAmount=RefPatAmount+PLIST(10)
	.set PLIST(7)=-PLIST(7)
	.set PLIST(8)=-PLIST(8)
	.set PLIST(9)=-PLIST(9)
	.set PLIST(10)=-PLIST(10)
	.set PLIST(11)=currDate
	.set PLIST(12)=currTime
	.set PLIST(13)="R"
	.set PLIST(14)=currDate
	.set PLIST(15)=currTime
	.set PLIST(16)=USER
	.set PLIST(23)=PBDRowID      //+2023-04-17 ZhYW 原计费明细Id
	.set err=##class(web.UDHCJFPBOD).INSERT()
	.set Error=Error+err
	
	//更新账单表总金额
	set err=##class(web.UDHCJFPB).SELECT(+PBO)
	set Error=Error+err
	if (Error=0) {
		set PLIST(9)=PLIST(9)-RefTotalAmount
		set PLIST(10)=PLIST(10)-RefDiscAmount
		set PLIST(12)=PLIST(12)-RefInsAmount
		set PLIST(13)=PLIST(13)-RefPatAmount
		set err=##class(web.UDHCJFPB).UPDATE(+PBO)
		set Error=Error+err
	}
	;
	if (Error=0) {
		set err=..UpdateAppRepTarItmBillStatus(OEORI, "I", "R", PBO)
		set Error=Error+err
	}
	
	set OrdQty=+$p($g(^||TMP("IB",$j,"ORDER",OEORI,"QTY")),"^",1)
	
	if (Error=0) {
		set Adm=$p(^OEORD(+OEORI),"^",1)
		set HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
		set RCDRowID=$p($g(^PAADM(Adm,"DHC")),"^",25)
		set regLoc=""
		set oeprice=""
		set pattype=$p($g(^PAADM(Adm,1)),"^",6)	   ;PAADM_Epissubtype_Dr->PAC_EpisodeSubType
		set instype=$p($g(^PAADM(Adm,1)),"^",7)	   ;PAADM_AdmReason_DR->PAC_AdmReason
		set priceDate=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),9)),"^",15)    //OEORI_BillPriceDate
		set itmPriceExpStr=RCDRowID_"^"_OEORI_"^"_""_"^"_Adm_"^"_regLoc_"^"_""
		;
		set (price, discPrice, insPrice, patPrice)=0
		set itmDr=0
		for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",OEORI,itmDr)) quit:(itmDr="")||(Error'=0)  do
		.set artiDr=0
		.for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",OEORI,itmDr,artiDr)) quit:(artiDr="")||(Error'=0)  do
		..set artiData=$g(^DHCAPREPTA(artiDr))
		..set disc=$p(artiData,"^",4)	        ;ARTI_Disc
		..set itm=$p(artiData,"^",5)	        ;ARTI_Tar_Dr
		..set qty=$p(artiData,"^",8)	        ;ARTI_Qty
		..set billStatus=$p(artiData,"^",9)     ;ARTI_Billed
		..//quit:(" TB I "'[(" "_billStatus_" "))
		..quit:(billStatus'="TB")
		..set err=##class(web.UDHCJFPRICE).GetItmPrice(itm, priceDate, instype, pattype, oeprice, HospID, itmPriceExpStr)
		..set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
		..set price=$p(err0,"^",1)*qty+price
		..set discPrice=$p(err0,"^",2)*qty+discPrice
		..set insPrice=$p(err0,"^",3)*qty+insPrice
		..set patPrice=$p(err0,"^",4)*qty+patPrice
		..;
		..kill PLIST
		..set PLIST(0)=PBO
		..set PLIST(3)=itm
		..set PLIST(4)=+$p(err0,"^",1)
		..set PLIST(18)=+$p(err0,"^",2)
		..set PLIST(19)=+$p(err0,"^",3)
		..set PLIST(20)=+$p(err0,"^",4)
		..set PLIST(5)=qty*OrdQty
		..set PLIST(7)=+..round(PLIST(4)*PLIST(5))
		..set PLIST(8)=+..round(PLIST(18)*PLIST(5))
		..set PLIST(9)=+..round(PLIST(19)*PLIST(5))
		..set PLIST(10)=PLIST(7)-PLIST(8)-PLIST(9)
		..set PLIST(11)=currDate                
		..set PLIST(12)=currTime                
		..set PLIST(13)="B"
		..set PLIST(14)=currDate
		..set PLIST(15)=currTime
		..set PLIST(16)=USER
		..set PLIST(25)=disc
		..set PLIST(26)=artiDr
		..set TotalAmount=TotalAmount+PLIST(7)
		..set DiscAmount=DiscAmount+PLIST(8)
		..set InsAmount=InsAmount+PLIST(9)
		..set PatAmount=PatAmount+PLIST(10)
		..set err=##class(web.UDHCJFPBOD).INSERT()
		..set Error=Error+err
		;
		;如果是部分退费，需要更新关联表的状态
		set err=..UpdateAppRepTarItmBillStatus(OEORI, "TB", "B", PBO)
		set Error=Error+err
	}
	;
	;更新DHC_PatBillOrder
	if (Error=0) {
		kill PLIST
		set err=##class(web.UDHCJFPBO).SELECT(PBO) 
		set Error=Error+err
		set PLIST(6)=OrdQty
		if (TotalAmount=0) {
			;总金额说明是0，说明是部分退费
			set PLIST(16)="R"
		}else {
			set PLIST(5)=price
			set PLIST(17)=discPrice
			set PLIST(18)=insPrice
			set PLIST(19)=patPrice
		}
		set PLIST(7)=0
		set PLIST(8)=TotalAmount
		set PLIST(9)=DiscAmount
		set PLIST(10)=InsAmount
		set PLIST(11)=PatAmount
		set err=##class(web.UDHCJFPBO).UPDATE(PBO) 
		set Error=Error+err
	}
	
	;更新医嘱表账单状态
	;	规则：
	;		1. I + 部分退费--->B
	;		2. I + 全部退费--->R
	;		3. TB --> B
	set BillStatus=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3),"^",5)
	if ((BillStatus="I")&&(TotalAmount=0))  set $p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3),"^",5)="R"	
	else  set $p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3),"^",5)="B"	
	
	quit Error_"^"_TotalAmount_"^"_DiscAmount_"^"_InsAmount_"^"_PatAmount
}

/// Description: 更新预约检查申请单的账单状态
ClassMethod UpdateAppRepTarItmBillStatus(oeitm As %String, oldStatus As %String, newStatus As %String, pbo As %String) As %String
{
	new (oeitm, oldStatus, newStatus, pbo)
	set rtn=0
	set itmDr=0
	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr))) {
		set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr))
		set artiDr=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr))) {
			set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr))
			set artiData=$g(^DHCAPREPTA(artiDr))
			set billStatus=$p(artiData,"^",9)     //账单状态
			continue:(oldStatus'=billStatus)
			&SQL(
				UPDATE DHC_AppRepTarItm
				SET ARTI_Billed = :newStatus, ARTI_PBO_Dr = :pbo
				WHERE %ID = :artiDr
			)
			set rtn=SQLCODE
			quit:(+rtn)
		}
		quit:(+rtn)
	}
	quit rtn
}

/// Creator: Lid
/// CreatDate: 2017-09-15
/// Description: 根据账单明细表(DHC_PatBillDetails)更新账单医嘱表(DHC_PatBillOrder)
/// Input: pbo:账单医嘱表rowid
ClassMethod PBOUpdateByPBD(pbo As %String) As %String
{
	new (pbo)
	set (pbdTotalSum, pbdDiscSum, pbdPayorSum)=0
	set (totalAmount, discAmount, payorShare, patientShare)=0
	set refFlag=0
	set pbd=0
	while($o(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))) {
		set pbd=$o(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))
		set pbdData=$g(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))
		continue:(pbdData="")
		set pbdQty=$p(pbdData,"^",5)
		if (pbdQty<0) {
			set refFlag=1
		}
		set pbdPrice=$p(pbdData,"^",4)
		set pbdTotalAmt=$p(pbdData,"^",7)
		set pbdDiscAmt=$p(pbdData,"^",8)
		set pbdPayorShare=$p(pbdData,"^",9)
		set pbdPatShare=$p(pbdData,"^",10)
		set pbdDiscPrice=$p(pbdData,"^",18)
		set pbdInsPrice=$p(pbdData,"^",19)
		set pbdPatPrice=$p(pbdData,"^",20)
		
		set pbdTotalSum=$i(pbdTotalSum, (pbdPrice*pbdQty))
		set pbdDiscSum=$i(pbdDiscSum, (pbdDiscPrice*pbdQty))
		set pbdPayorSum=$i(pbdPayorSum, (pbdInsPrice*pbdQty))
		
		set totalAmount=$i(totalAmount, pbdTotalAmt)
		set discAmount=$i(discAmount, pbdDiscAmt)
		set payorShare=$i(payorShare, pbdPayorShare)
		set patientShare=$i(patientShare, pbdPatShare)
	}
	
	set pboData=$g(^DHCPB(+pbo,"O",$p(pbo,"||",2)))
	set arcim=$p(pboData,"^",3)
	set oeitm=$p(pboData,"^",4)
	set billQty=$p(pboData,"^",5)
	set refundQty=$p(pboData,"^",6)
	set qty=billQty+refundQty
	if (qty=0) set qty=1
	
	set adm=$p(^OEORD(+oeitm),"^",1)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set decimal=##class(BILL.Interface.Inside.Invoke).GetFmtSPBill(arcim, hospDR)
	
	kill PLIST
	set PLIST(8)=totalAmount
	set PLIST(9)=discAmount
	set PLIST(10)=payorShare
	set PLIST(11)=patientShare
	//2017-11-23 ZhYW 只有收费时才更新价格
	//if (refFlag=0) {
	if ((refFlag=0)&&(+totalAmount'=0)) {    //+2023-05-19 ZhYW 只有收费且金额不为0时更新价格
		set PLIST(5)=$fn((pbdTotalSum/qty),"",decimal)        //PBO_UnitPrice
		set PLIST(17)=$fn((pbdDiscSum/qty),"",decimal)        //PBO_DiscPrice
		set PLIST(18)=$fn((pbdPayorSum/qty),"",decimal)       //PBO_InsPrice
		set PLIST(19)=(PLIST(5)-PLIST(17)-PLIST(18))          //PBO_PatPrice
	}
	set err=##class(web.UDHCJFPBO).UPDATE(pbo)

	quit err_"^"_totalAmount_"^"_discAmount_"^"_payorShare_"^"_patientShare
}

/// Creator: ZhYW
/// CreatDate: 2017-11-20
/// Description: 取收费项计费数量
/// Input: pbo:DHC_PatBillOrder.PBO_RowId, tarItm:DHC_TarItem.RowId, dspbDr:DHC_OEDispBatch.RowId
/// Return: 
/// Table: DHC_PatBillDetails
/// Debug: w ##class(web.UDHCJFBILL).GetTarItmBillQty("330704||15", 2252, "")
ClassMethod GetTarItmBillQty(pbo As %String, tarItm As %String, dspbDr As %String) As %String
{
	new (pbo, tarItm, dspbDr)
	
	set billQty=0
	set pbd=0
	while($o(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))) {
		set pbd=$o(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))
		set pbdData=$g(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))
		set myTarItm=$p(pbdData,"^",3)
		continue:(tarItm'=myTarItm)
		set myDspbDr=$p(pbdData,"^",27)
		continue:(dspbDr'=myDspbDr)
		set myBillQty=$p(pbdData,"^",5)
		set billQty=$i(billQty, myBillQty)
	}

	quit billQty
}

/// Creator: ZhYW
/// CreatDate: 2018-10-31
/// Description: 取药品医嘱原计费价格
/// Input: 
/// Table: DHC_PatBillDetails
/// Debug: w ##class(web.UDHCJFBILL).SetDrugItmPrice("330704||15", "2252||2")
ClassMethod SetDrugItmPrice(oeitm As %String, pboRowId As %String) As %String
{
	new (oeitm, pboRowId)
	quit:((oeitm="")||(pboRowId="")) 0
	
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
	quit:(ordCateType'="R") 0
	
	set pb=$p(pboRowId,"||",1)
	set pbo=$p(pboRowId,"||",2)

	set (Price, DiscPrice, InsPrice, PatPrice)=0
	set Itm=0
	while($o(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm))) {
		set Itm=$o(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm))
		set dspDr=0
		while($o(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr))) {
			set dspDr=$o(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr))
			set dspbSub=0
			while($o(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr,dspbSub))) {
				set dspbSub=$o(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr,dspbSub))
				set ItmData=$g(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr,dspbSub))
				set qty0=$p(ItmData,"^",1)
				set ItmPrice=+$p(ItmData,"^",2)
				set ItmDiscPrice=+$p(ItmData,"^",3)
				set ItmInsPrice=+$p(ItmData,"^",4)
				set ItmPatPrice=+$p(ItmData,"^",5)
				set dspbDr=dspDr_"||"_dspbSub
				set initDspbDr=##class(PHA.FACE.OUT.Com).GetDispDspbByRetDspb(dspbDr)   //调用药房接口通过退药打包子表id获取发药打包子表id
				if (initDspbDr="") set initDspbDr=dspbDr   //未发药，未退药时接口返回空
				set pbdRowId=""
				set pbd=0
				while($o(^DHCPB(0,"TARI",Itm,pb,pbo,pbd))) {
					set pbd=$o(^DHCPB(0,"TARI",Itm,pb,pbo,pbd))
					set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
					continue:(pbdData="")
					set pbdRowId=pb_"||"_pbo_"||"_pbd
					set myDspbDr=$p(pbdData,"^",27)
					continue:(myDspbDr'=initDspbDr)
					set ItmPrice=+$p(pbdData,"^",4)
					set ItmDiscPrice=+$p(pbdData,"^",18)
					set ItmInsPrice=+$p(pbdData,"^",19)
					set ItmPatPrice=+$p(pbdData,"^",20)
					quit
				}
				set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",2)=ItmPrice
				set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",3)=ItmDiscPrice
				set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",4)=ItmInsPrice
				set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",5)=ItmPatPrice
				set $p(^||TMP("IB",$j,"ORDER",oeitm,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",10)=pbdRowId    //+2023-04-17 ZhYW 原计费账单RowId
				;
				set Price=ItmPrice*qty0+Price
				set DiscPrice=ItmDiscPrice*qty0+DiscPrice
				set InsPrice=ItmInsPrice*qty0+InsPrice
				set PatPrice=ItmPatPrice*qty0+PatPrice
			}
		}
	}
	set ^||TMP("IB",$j,"ORDER",oeitm,"PRICE")=Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice

	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否是急诊转入住院的医嘱
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.UDHCJFBILL).OrdIsOPToIPByOEORI("46||5")
ClassMethod OrdIsOPToIPByOEORI(oeitm As %String) As %String
{
	new (oeitm)
	set rtn=0
	quit:($l(oeitm,"||")'=2) rtn
	
	set adm=$p($g(^OEORD(+oeitm)),"^",1)
	quit:(+adm=0) rtn
	
	set ociId=$o(^DHCOPIPADMCON(0,"OPADM",adm,"OEORI",oeitm,""),-1)
	if (+ociId'=0) {
		set tmp=$g(^DHCOPIPADMCON(ociId))
		set status=$p(tmp,"^",7)
		if (status="N") {
			set rtn=1
		}
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-02-18
/// Description: 更新医嘱表取价格日期
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFBILL).UpdateOrdPriceDate("1104||1", +$h, $p($h,",",2))
ClassMethod UpdateOrdPriceDate(oeitm As %String, priceDate As %String, priceTime As %String) As %String
{
	new (oeitm, priceDate, priceTime)
	set rtn=0
	set oldPriceDate=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),9),"^",15)
	quit:(+oldPriceDate'=0) rtn    //不为空时不更新
	ts
	&SQL(
		UPDATE OE_OrdItem
		SET OEORI_BillPriceDate = :priceDate, OEORI_BillPriceTime = :priceTime
		WHERE %ID = :oeitm
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2021-04-21
/// Description: 获取医嘱已执行数量
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 已执行数量
/// Debug: w ##class(web.UDHCJFBILL).GetOrdExecQty("1822||2")
ClassMethod GetOrdExecQty(oeitm As %String) As %String
{
	new (oeitm)
	quit ##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdExecQty(oeitm)   //2023-04-25 ZhYW 改为调用医生站接口获取已执行数量
}

/// Creator: ZhYW
/// CreatDate: 2022-11-04
/// Description: 获取原来收费时的医嘱账单RowID
/// Input: oeitm: OE_OrdItem.RowId
/// Return: DHC_PatBillOrder.RowID
/// Debug: w ##class(web.UDHCJFBILL).GetInitChgPBORowID("1104||1")
ClassMethod GetInitChgPBORowID(oeitm As %String) As %String
{
	new (oeitm)
	set pboRowId=""
	
	set reChgOrdId=$o(^BILL.OP.ReChgOrderI("IdxOEORI",oeitm,0))
	quit:(+reChgOrdId=0) pboRowId
	
	set initInvDR=$lg(^BILL.OP.ReChgOrderD(reChgOrdId),5)
	quit:(+initInvDR=0) pboRowId
	
	set billConInv=0
	while($o(^DHCBCI(0,"INV",initInvDR,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",initInvDR,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		set pb=$p(conData,"^",2)
		continue:(+pb=0)
		set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,0))
		continue:(+pbo=0)
		set pboRowId=pb_"||"_pbo
		quit
	}
	
	quit pboRowId
}

}
