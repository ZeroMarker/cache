Import SQLUser

/// 名称: web.UDHCJFBILLIP.cls
/// 描述: 住院病人账单程序
/// 编写者: yyx
/// 编写日期: 2012-02-24
/// 产品组：计费组
Class web.UDHCJFBILLIP Extends BILL.COM.Abstract [ Not ProcedureBlock ]
{

/// 插入时间小于要求执行时间时? 1:不到要求执行时间不计费; 2:不到要求执行时间计费,计费时间取执行记录插入时间; 
/// 3:不到要求执行时间计费,计费时间取要求执行时间
Parameter ODBillMode [ Final ] = 2;

/// Debug: w ##class(web.UDHCJFBILLIP).BILL(40, 19084)
ClassMethod BILL(Adm As %String, BillUser As %String, OrdExecStr As %String = "", Flag As %String = 0) As %String [ ProcedureBlock = 1 ]
{
	set $zt="ERROR"
	
	quit:(Adm="") -1_"^"_"参数错误"
	set AdmType=$p(^PAADM(Adm),"^",2)
    quit:(AdmType'="I") 0
	
	set BabyInfo=##class(web.UDHCJFORDCHK).GetMotherAdmByBabyAdm(Adm)
	set BabyFlag=$p(BabyInfo,"^",1)
	set MotherAdm=$p(BabyInfo,"^",2)
	if (BabyFlag="true") set Adm=MotherAdm
	quit:(BabyFlag="true") 0
	
	if (BillUser="") set BillUser=1
	
	//+2022-10-09 ZhYW 改为使用系统锁
	set LockErr=##class(DHCDoc.Util.System).LOCK("PA_Adm", Adm, BillUser, $zu(67,15,$j))
	quit:(+LockErr'=-1) -110_"^"_##class(websys.Translation).Get("", "就诊")_"："_Adm_##class(websys.Translation).Get("", "被锁定")
    
	set RtnValue=..BILLC(Adm, BillUser, OrdExecStr, Flag)
	
	do ##class(DHCDoc.Util.System).LOCKCLR("PA_Adm", Adm)
	
	quit RtnValue
	
ERROR
	quit ..AppException()
}

ClassMethod BILLC(Adm As %String, BillUser As %String, OrdExecStr As %String = "", Flag As %String = 0) As %String [ ProcedureBlock = 1 ]
{
	kill ^||TMP("IB",BillUser,$j)
	
	//Get Patient Admission Details
	set AdmDep=$p($g(^PAADM(Adm)),"^",4)
	set PatType=$p($g(^PAADM(Adm,1)),"^",6)	;PAADM_Epissubtype_Dr->PAC_EpisodeSubType
	set InsType=$p($g(^PAADM(Adm,1)),"^",7)	;PAADM_AdmReason_DR->PAC_AdmReason
	
	//Get Patient Admission OEORD
	set Ord=$o(^OEORD(0,"Adm",Adm,""))
	
	if (+Ord'=0) {
		set LockErr=##class(DHCDoc.Util.System).LOCK("OE_Order", Ord, BillUser, $zu(67,15,$j))
		quit:(+LockErr'=-1) -110_"^"_"医嘱："_Ord_"被锁定"
	}
	
	set OrdFrom=+$h, OrdEnd=0
	//Calculate Order
	set Count=..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser, OrdExecStr, Flag)
	
	//+2019-07-23 ZhYW 急诊转住院医嘱
	if (Flag=0) do
	.set OPAdm=""
	.for  set OPAdm=$o(^DHCOPIPADMCON(0,"IPADM",Adm,"OPADM",OPAdm),-1)  quit:(OPAdm="")  do
	..set Ord=""
	..set OCIId=""
	..for  set OCIId=$o(^DHCOPIPADMCON(0,"IPADM",Adm,"OPADM",OPAdm,OCIId),-1)  quit:((OCIId="")||(Ord'=""))  do
	...set OCIData=$g(^DHCOPIPADMCON(OCIId))
	...set Status=$p(OCIData,"^",7)
	...quit:(Status'="N")
	...set Ord=$o(^OEORD(0,"Adm",OPAdm,""))
	..quit:(Ord="")
	..set Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser, "", 0)
	
	//Calculate NewBorn Order to Mother
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDep)
	set Conf=##class(web.DHCBillCommon).GetTarParaId(HospDR)
	if ($d(^PAADMi("Mother",Adm)))&&($p(^DHCTarC("CF",Conf),"^",5)="Y")&&(Flag=0) do
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
	...set Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser, "", 0)
	..//婴儿医嘱
	..set Ord=$o(^OEORD(0,"Adm",babyAdm,""))
	..quit:(Ord="")
	..set Count=Count+..ORDERS(Ord, PatType, InsType, .OrdFrom, .OrdEnd, Adm, BillUser, "", 0)
	
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

/// 需要计费的医嘱执行记录
ClassMethod ORDERS(Ord, PatType, InsType, OrdFrom, OrdEnd, Adm, BillUser, OrdExecStr, Flag) [ ProcedureBlock = 1 ]
{
	quit:((Ord="")&&(Flag=0)) 0
	set Count=0
	if (Flag=0) {
		//按就诊计费
		set Itm=0
		while($o(^OEORD(Ord,"I",Itm))) {
			set Itm=$o(^OEORD(Ord,"I",Itm))
			set OrdItmRowID=Ord_"||"_Itm
			continue:('$d(^OEORD(Ord,"I",Itm,1)))
			continue:(..CheckOPOrdToIPOrd(Adm, OrdItmRowID)=1)
			set OEOrdItmInfo=..GetOEOrdItemInfo(OrdItmRowID)
			continue:(OEOrdItmInfo="")
			set OEPirorCode=$p(OEOrdItmInfo,"^",1)
			continue:(OEPirorCode["OM")
			set IsHourOrd=$p(OEOrdItmInfo,"^",3)   //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
			//取执行记录表的数据
			set Exec=0
			while($o(^OEORD(Ord,"I",Itm,"X",Exec))) {
				set Exec=$o(^OEORD(Ord,"I",Itm,"X",Exec))
				set OEExecRowID=Ord_"||"_Itm_"||"_Exec
				set OEOREBillFlag=$p(^OEORD(Ord,"I",Itm,"X",Exec),"^",6)    //OEORE_Billed
				continue:(" P B R "[(" "_OEOREBillFlag_" "))    //已结算、已计费、已退费的执行记录不再账单
				set HourBillFlag=$p($g(^OEORD(Ord,"I",Itm,"X",Exec,"BILL")),"^",19)   //OE_OrdExecExt.OEORE_BlillFlag, HOUR医嘱能否计费标识
				continue:((IsHourOrd=1)&&(HourBillFlag'="Y"))   //按小时计费
				set ErrCode=..GetBillData(OrdItmRowID, PatType, InsType, OEExecRowID, OEOrdItmInfo, Adm, BillUser)
				continue:($p(ErrCode,"^",1)=1)
				set OrdBillDate=$p(ErrCode,"^",2)
				if (OrdBillDate<OrdFrom) set OrdFrom=OrdBillDate
				if (OrdBillDate>OrdEnd) set OrdEnd=OrdBillDate
				set Count=$i(Count)
			}
		}
	}else {
		//按执行记录
		set len=$l(OrdExecStr,"^")
		for i=1:1:len {
			set OEExecRowID=$p(OrdExecStr,"^",i)
			continue:(OEExecRowID="")
			continue:$d(^||TMP("IB",$j,"ORDER",OEExecRowID))
			set Order=$p(OEExecRowID,"||",1)
			set Itm=$p(OEExecRowID,"||",2)
			set Exec=$p(OEExecRowID,"||",3)
			set OrdItmRowID=$p(OEExecRowID,"||",1,2)
			continue:('$d(^OEORD(Order,"I",Itm,1)))
			continue:('$d(^OEORD(Order,"I",Itm,"X",Exec)))
			continue:(..CheckOPOrdToIPOrd(Adm, OrdItmRowID)=1)
			set OEOrdItmInfo=..GetOEOrdItemInfo(OrdItmRowID)
			continue:(OEOrdItmInfo="")
			set OEPirorCode=$p(OEOrdItmInfo,"^",1)
			continue:(OEPirorCode["OM")
			set IsHourOrd=$p(OEOrdItmInfo,"^",3)      //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
			set OEOREBillFlag=$p(^OEORD(Order,"I",Itm,"X",Exec),"^",6)    //OEORE_Billed
			continue:(" P B R "[(" "_OEOREBillFlag_" "))   //已结算、已计费、已退费的执行记录不再账单
			set HourBillFlag=$p($g(^OEORD(Order,"I",Itm,"X",Exec,"BILL")),"^",19)   //OE_OrdExecExt.OEORE_BlillFlag, HOUR医嘱能否计费标识
			continue:((IsHourOrd=1)&&(HourBillFlag'="Y"))    //按小时计费
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
	
    set OEExcBilled=$p(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3)),"^",6)  
    
	set OrdStatusID=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3),"BILL")),"^",1)  //OE_OrdExecExt.OEORE_OrderStatus_DR
	set StatCode=$s((+OrdStatusID'=0):$p($g(^OEC("OSTAT",OrdStatusID)),"^",1),1:"")

	set err=..CheckBillPoint(OrdItmRowID, ArcGrp, StatCode, OEExecRowID, Adm)
	quit:($p(err,"^",1)'=1) 1
	set BillDate=$p(err,"^",2)
	set BillTime=$p(err,"^",3)
	
	//modify 2014-11-21 病人已出院账单billDate日期若大于最终结算日期则按最终结算日期取值
	//按小时计费医嘱若停止日期不是当天则按当天计费
	set CurDate=+$h
	set CurTime=$p($h,",",2)
	set HourBillFlag=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3),"BILL")),"^",19)
 	if ((IsHourOrd=1)&&(HourBillFlag="Y")) {
	 	if ((BillDate'=CurDate)&&(OEExcBilled="I")) {
		 	set BillDate=CurDate
		 	set BillTime=CurTime
	 	}
 	}
 	
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
	set qty=..GetBillQty(OrdItmRowID, StatCode, IsHourOrd, ArcimRowID, OEExecRowID, Adm)
	
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
	.quit:(+rtn)
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
	...set STStatusCode=$p($g(^OEC("OSTAT",STDr)),"^",1)
	...quit:(STStatusCode'="E")
	...set ExeDate=$p(^OEORD(Itm,"I",Cld,"ST",STCld),"^",1)
	...set ExeTime=$p(^OEORD(Itm,"I",Cld,"ST",STCld),"^",2)
	.if (STStatusCode="E") do
	..set rtn=##class(web.UDHCJFBILLIP).UpdateOEPriceDate(OEExecRowID, ExeDate, ExeTime)
	.quit:(+rtn)
	.if ((isAppRep'="Y")&&((" E "[(" "_OrdStatus_" "))||(ItmStatCode="E")))||((isAppRep="Y")&&(" E "[(" "_OrdStatus_" "))) do	 //个别产品组总是忘记修改执行记录扩展表的状态导致漏费，所以此处加了"(ItmStatCode="E")"
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
	..set AdminStatusCode=$p($g(^OEC("STAT",AdminStatusDR)),"^",1)   //OEC_Order_AdminStatus.STAT_Code
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
    ..if (BillDate'="") do
    ...set Status=1
    
    if (ExcFreeChargeFlag="Y") set Status=1
	
	quit Status_"^"_BillDate_"^"_BillTime
}

/// Creator: ZhYW
/// CreatDate: 2020-02-06
/// Description: 取下医嘱计费时的计费时间
/// Input: OEORE:执行记录RowId, CP:计费点, OrderType:医嘱类型
/// Return: BillDate_"^"_BillTime
/// Debug: w ##class(web.UDHCJFBILLIP).GetODBillDateTime()
ClassMethod GetODBillDateTime(OEORE As %String, CP As %String, OrderType As %String) As %String
{
	new (OEORE, CP, OrderType)

	set OrdStatusDR=$p($g(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3),"BILL")),"^",1) ;计费点为医嘱执行计费，则按这个医嘱执行状态OEORE_OrderStatus_DR
	set OrdStatus=$s((+OrdStatusDR'=0):$p($g(^OEC("OSTAT",OrdStatusDR)),"^",1),1:"")
	
	set BillDate="", BillTime=""
	if (" V E "[(" "_OrdStatus_" ")) {
		set ExStDateTime=$$GetStDateTime(OEORE)
		set BillDate=$p(ExStDateTime,"^",1)
		set BillTime=$p(ExStDateTime,"^",2)
	}elseif (" D U  "[(" "_OrdStatus_" ")) {
		set XDateTime=$$GetXDateTime(OEORE)
		set BillDate=$p(XDateTime,"^",1)
		set BillTime=$p(XDateTime,"^",2)
		if (OrderType="R") {
			set Disp=0
			while ($o(^DHCOEDISQTY(0,"OEORE",OEORE,Disp))) {
				set Disp=$o(^DHCOEDISQTY(0,"OEORE",OEORE,Disp))
				set DispData=$g(^DHCOEDISQTY(Disp))
				continue:(DispData="")
				set DspStatus=$p(DispData,"^",7)
				if (DspStatus="R") {
					set BillDate=$p(DispData,"^",8)
					set BillTime=$p(DispData,"^",9)
				}
			}
		}
	}
	
	quit BillDate_"^"_BillTime
	
GetStDateTime(OEORE)
	new (OEORE)
	set BindSource=$p($g(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"DHC")),"^",41)
	set ExStDate=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",1)
	set ExStTime=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",2)
	set InsertDate=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",45)
	set InsertTime=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",46)

	set StDate=ExStDate
	set StTime=ExStTime
	
	//针对系统任务自动插入的前一天的床位费、诊察费，取OEORE_ExStDate, OEORE_ExStTime
	if (BindSource="DBFee") {
		quit StDate_"^"_StTime
	}
	
	//插入时间大于要求执行时间时，计费时间取执行记录插入时间
	if ((InsertDate>ExStDate)||((InsertDate=ExStDate)&&(InsertTime>ExStTime))) {
		set StDate=InsertDate
		set StTime=InsertTime
		quit StDate_"^"_StTime
	}
	
	//执行记录插入时间小于要求执行时间时
	if ((InsertDate<ExStDate)||((InsertDate=ExStDate)&&(InsertTime<ExStTime))) {
		if (..#ODBillMode=2) {         //计费时间取执行记录插入时间
			set StDate=InsertDate
			set StTime=InsertTime
			quit StDate_"^"_StTime
		}
		
		if (..#ODBillMode=3) {    //计费时间取要求执行时间
			set StDate=ExStDate
			set StTime=ExStTime
			quit StDate_"^"_StTime
		}
	}
	
	quit StDate_"^"_StTime

GetXDateTime(OEORE)
	new (OEORE)
	set ExStDateTime=$$GetStDateTime(OEORE)
	set StDate=$p(ExStDateTime,"^",1)
	set StTime=$p(ExStDateTime,"^",2)
	set ExXDate=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",12)
	set ExXTime=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",14)

	set XDate=+$h
	set XTime=$p($h,",",2)
	if ((ExXDate<StDate)||((ExXDate=StDate)&&(ExXTime<StTime))) {
		set XDate=StDate
		set XTime=StTime
	}else {
		set XDate=ExXDate
		set XTime=ExXTime
	}

	quit XDate_"^"_XTime
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
	...set disc=$p(artiData,"^",4)	       //ARTI_Disc
	...set itm=$p(artiData,"^",5)	       //ARTI_Tar_Dr
	...set qty=$p(artiData,"^",8)	       //ARTI_Qty
	...set billStatus=$p(artiData,"^",9)   //ARTI_Billed
	...set ordExec=$p(artiData,"^",10)	   //ARTI_OrdExec
	...quit:((ordExec'="")&&(ordExec'=OEExecRowID))
	...quit:$d(artiAry(artiDr))
	...if (ordExec="") set artiAry(artiDr)=""
	...quit:(" TB I "'[(" "_billStatus_" "))
	...quit:(OEOREBillFlag'=billStatus)
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
	set isOP2IP=..OrdIsOPToIPByIPAdm(Adm, oeitm)
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
	...set dspbQty=$p(dspbData,"^",2)	    //DSPB_Qty
	...set inciDr=$p(dspbData,"^",5)        //DSPB_INCI_DR
	...set dspbStutus=$p(dspbData,"^",6)    //DSPB_Status
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
	..set ^||TMP("IB",BillUser,$j,"ORDER",OEExecRowID,"ITEM",Itm,"OLT",Olt)=qty0_"^"_err0_"^"_BillDate_"^"_BillTime  //+2022-11-01 ZhYW 增加医嘱项关联收费项关联表Id节点
	
	quit Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
}

ClassMethod PBOADD(PBO, OEORE, BillUser)
{
	new (PBO, OEORE, BillUser)
    if (PBO="") quit 0_"^"_0_"^"_0_"^"_0_"^"_0
	
	//2016-07-23 Lid 预约检查类医嘱，不按原来的单价计费
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
	quit:(isAppRep="Y") 0_"^"_0_"^"_0_"^"_0_"^"_0
	
	set OldPBOData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2)))
	set OldQty=+$p(OldPBOData,"^",5)
	set RefundQty=+$p(OldPBOData,"^",6)
	set JFQty=OldQty+RefundQty
	set NewQty=+$p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"QTY"),"^",1)
	set Qty=NewQty-JFQty
	set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"QTY"),"^",1)=Qty
	
	//if (RefundQty'=0) quit 0      //如果已经有退费?则不能进行二次退费
	
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
		quit:(IsIntArcim=0) 0_"^"_0_"^"_0_"^"_0_"^"_0
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
		...set rtn=..PBODINS(PBO, OEORE, Itm, Status, BillUser, dspbDr)
		...set err=$p(rtn,"^",1)

		if (+err=0) {
			set rtn=..PBOUpdateByPBD(PBO)
			set err=$p(rtn,"^",1)
		}
	}elseif(IsHourOrd=1) {
		//2022-01-19 ZhYW 小时医嘱按全退重收
		set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"QTY"),"^",1)=NewQty   //收的数量
		
		set Itm=""
		for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set Olt=""
		.for  set Olt=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
		..set rtn=..RefundHourPBD(PBO, OEORE, Itm, BillUser, Olt)
		..set err=$p(rtn,"^",1)
	}else {
		set Itm=""
		for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
		.set Olt=""
		.for  set Olt=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
		..set rtn=..PBODINS(PBO, OEORE, Itm, Status, BillUser, "", Olt)
		..set err=$p(rtn,"^",1)
	}
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//+2022-11-02 ZhYW
	set err=..AdjustPatBillOrder(PBO)
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//modify 2012-6-5 退费时当DHC_PatBillOrder 表PBO_TotalAmount为负数时不能更新
	set BillStatus=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)
	if (BillStatus'="R") {
		if (IsHourOrd'=1) {
			set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)=Status
		}else {
			set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)=$s((NewQty>0):"B",1:"R")   //+2023-04-17 ZhYW			
			/*
			if (BillStatus="I") {
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
			}else {
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="B"
			}
			*/
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

/// 插入表DHC_PatBillDetails
ClassMethod PBODINS(PBO, OEORE, Itm, Status, BillUser, dspbDr = "", Olt = "")
{
	new (PBO, OEORE, Itm, Status, BillUser, dspbDr, Olt)
	if (dspbDr'="") {
		set dspDr=$p(dspbDr,"||",1)
		set dspbSub=$p(dspbDr,"||",2)
		set ItmData=$g(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"DSPB",dspDr,dspbSub))
	}elseif(Olt'="") {
		set ItmData=$g(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt))
	}else {
		set ItmData=$g(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm))
	}
	
	set Qty0=$p(ItmData,"^",1)
	set Price0=$p(ItmData,"^",2)
	set DiscPrice0=$p(ItmData,"^",3)
	set InsPrice0=$p(ItmData,"^",4)
	set PatPrice0=$p(ItmData,"^",5)
	set BillDate=$p(ItmData,"^",6)
	set BillTime=$p(ItmData,"^",7)
	set disc=$p(ItmData,"^",8)	    //新版申请单折扣系数
	set artiDr=$p(ItmData,"^",9)	//新版申请单中间表指针
	set OriginalDR=$p(ItmData,"^",10)	//2023-04-17 ZhYW 退费记录原计费明细Id
	
	set OrdQty=$p($g(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"QTY")),"^",1)
	
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
	set PLIST(16)=BillUser
	;Add By Su MingLiang 2007/08/04
	set PLIST(18)=+DiscPrice0
	set PLIST(19)=+InsPrice0
	set PLIST(20)=+PatPrice0
	set PLIST(23)=OriginalDR   //+2023-04-17 ZhYW 原计费明细Id
	;
	set PLIST(25)=disc
	set PLIST(26)=artiDr
	set PLIST(27)=dspbDr
	set PLIST(29)=Olt       //+2022-11-01 ZhYW 增加医嘱项关联收费项关联表Id节点
	set err=##class(web.UDHCJFPBOD).INSERT()
	
	quit err_"^"_+PLIST(7)_"^"_+PLIST(8)_"^"_+PLIST(9)_"^"_+PLIST(10)
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
		set PLIST(4)=$p(OEORE,"||",1,2)   //PBO_OEORI_DR
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
		set PLIST(20)=OEORE           //PBO_OrdExec_Dr
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
		...set rtn=..PBODINS(PBO, OEORE, Itm, Status, BillUser, dspbDr)
		...set err=$p(rtn,"^",1)
		
		if (+err=0) {
			set rtn=..PBOUpdateByPBD(PBO)
			set err=$p(rtn,"^",1)
		}
	}else {
		set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
		if (isAppRep="Y") {
			set Itm=""
			for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
			.set rtn=..PBODINS(PBO, OEORE, Itm, Status, BillUser)
			.set err=$p(rtn,"^",1)
		}else {
			set Itm=""
			for  set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm)) quit:((Itm="")||(+err))  do
			.set Olt=""
			.for  set Olt=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt)) quit:((Olt="")||(+err))  do
			..set rtn=..PBODINS(PBO, OEORE, Itm, Status, BillUser, "", Olt)
			..set err=$p(rtn,"^",1)
		}
	}
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	//+2022-11-02 ZhYW
	set err=..AdjustPatBillOrder(PBO)
	quit:(+err) +err_"^"_0_"^"_0_"^"_0_"^"_0
	
	set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3),"BILL"),"^",2)=PBO
	
	set IsHourOrd=##class(BILL.IP.COM.Method).IsBilledByHourOrd($p(OEORE,"||",1,2))   //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
	
	set BillStatus=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)
	if (BillStatus'="R") {
		if (IsHourOrd'=1) {
			set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="B"
		}else {
			if (BillStatus="I") {
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
			}else {
				set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="B"
			}
		}
	}
	
	//2016-07-19 Lid 更新预约检查申请单明细表的账单状态
	set err=..UpdateAppRepTarItmBillStatus($p(OEORE,"||",1,2), "TB", "B", OEORE)
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
	.if ((BillFlag="TB")&&(PBO'="")) do
	..set rtnValue=..PBODEL(PBO, BillUser)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	..set PBO=""
	.;
	.if (BillFlag="TB") do
	..set rtnValue=..PBOINS(PBRowID, OEORE, BillUser, PBO)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
    .if ((BillFlag="I")&&(PBO="")) do
	..set rtnValue=..PBOINS(PBRowID, OEORE, BillUser, PBO)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.if ((BillFlag="I")&&(PBO'="")) do
	..do ..SetItmPrice(OEORE, PBO, BillUser)
	..set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
	..if (isAppRep'="Y") do
	...set rtnValue=..PBOADD(PBO, OEORE, BillUser)
	..else  do
	...set rtnValue=..RefunAppRep(OEORE, PBO, BillUser)
	..set rtn=$p(rtnValue,"^",1)
	..quit:(+rtn)
	..do ..PBCHG($p(rtnValue,"^",2,*), .Tot, .TotDisc, .TotIns, .TotPat)
	.;
	.set rtn=..UpdateOrdDetailBalance(OEORE)
	.quit:(+rtn)
	
	if (+rtn)  tro  quit rtn
	
	if (+PBRowID'=0) {
		set rtn=..PBUPD(PBRowID, BillUser, Tot, TotDisc, TotIns, TotPat, OrdFrom, OrdEnd)
		if (+rtn) tro  quit rtn
		
		set rtn=##class(web.UDHCJFPAY).UpdatePatFee(PBRowID)
		if (+rtn)  tro  quit rtn
	}
	
	if ($tl>0) tc
    
	quit rtn_"^"_PBRowID
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
	//modify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
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

/// Debug: w ##class(web.UDHCJFBILLIP).GetQtyHour("153||395", "D", "153||395||1")
ClassMethod GetQtyHour(oeitm As %String, statcode As %String, OEExecRowID As %String)
{
	new (oeitm, statcode, OEExecRowID)
	
	set stDate=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",1)    //OEORE_ExStDate
	set stTime=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",2)    //OEORE_ExStTime

	set endDate=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",35)   //OEORE_ExEnDate
	set endTime=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",36)   //OEORE_ExEnTime

	if (+endDate=0) set endDate=+$h
	if (+endTime=0) set endTime=$p($h,",",2)
	if ((endDate<stDate) || ((endDate=stDate)&&(endTime<stTime))) {
		set qty=0
	}else {
		set period=endDate-stDate
		set dcnt=period*24                //转化为小时
		set tcnt=$fn((endTime-stTime)/60/60,"",2)     //转化为小时
		set qty=dcnt+tcnt
	}

	quit qty
}

ClassMethod round(Num)
{
	new (Num)
	quit ##class(web.UDHCJFBILL).round(Num)
}

/// Debug: w ##class(web.UDHCJFBILLIP).roundBak(0.015)
ClassMethod roundBak(Num)
{
	n (Num)
	s NegFlag=0
	q:$g(Num)=""!(Num=0) 0
	i Num<0 s Num=-Num,NegFlag=1
	i Num<0.01 s Num=0.01
	e  d
	.s Num=+Num+0.00000001
	.s np=$p(Num,".",1)_"."_$e($p(Num,".",2),1,2)
	.s point="0.00"_$e($p(Num,".",2),3,$l($p(Num,".",2)))
	.s Num=np 
	.s:point'<0.005 Num=Num+0.01
	i NegFlag=1 s Num=-Num
	q Num
}

ClassMethod GetBillQty(oeitm As %String, statcode As %String, isHourOrd As %String, arcim As %String, OEExecRowID As %String, Adm As %String) As %String
{
	new (oeitm, statcode, isHourOrd, arcim, OEExecRowID, Adm)
	if (isHourOrd'=1) {
		set qty=..GetQty(oeitm, statcode, arcim, OEExecRowID, Adm)
		set returnQty=..GetRefundQty(oeitm, statcode, arcim, OEExecRowID, Adm)
	} else {
		set qty=..GetQtyHour(oeitm, statcode, OEExecRowID)
		set returnQty=0
	}
	set billQty=qty-returnQty
	
	quit billQty
}

ClassMethod GetQty(oeitm As %String, Status As %String, arcim As %String, OEExecRowID As %String, Adm As %String) As %Numeric
{
	new (oeitm, Status, arcim, OEExecRowID, Adm)
	
	set Qty=0
	
	set CP=##class(BILL.IP.COM.Method).GetBillPoint(oeitm)

	set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	if (inci'="") {
		if (CP="CR") {
			set dsp=0
			while($o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp))) {
				set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp))
				set dspData=$g(^DHCOEDISQTY(dsp))
				set dspStatus=$p(dspData,"^",7)
				continue:(dspStatus'="C")
				set dspQty=+$p(dspData,"^",11)
				set Qty=Qty+dspQty
			}
		} else {
			set dsp=0
			while($o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp))) {
				set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp))
				set dspData=$g(^DHCOEDISQTY(dsp))
				set dspStatus=$p(dspData,"^",7)
				continue:(dspStatus="R")
				set dspQty=+$p(dspData,"^",11)
				set Qty=Qty+dspQty
			}
		}
	} else {
		set Qty=+$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",5)
	}
	
	quit Qty
}

ClassMethod GetRefundQty(oeitm As %String, Status As %String, arcim As %String, OEExecRowID As %String, Adm As %String) As %Numeric
{
	new (oeitm, Status, arcim, OEExecRowID, Adm)
	
	set RefundQty=0
	
	set isOP2IP=..OrdIsOPToIPByIPAdm(Adm, oeitm)
	if (isOP2IP=1) {
		quit ..GetRefundQtyO(OEExecRowID)    //返回门急诊转入医嘱的退费数量
	}
	quit:((" D U ")'[(" "_Status_" ")) RefundQty
	
	set CP=##class(BILL.IP.COM.Method).GetBillPoint(oeitm)
	
	set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	if (inci'="") {
		if (CP="CR") {
			set dsp=0
			while($o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp))) {
				set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp))
				set dspData=$g(^DHCOEDISQTY(dsp))
				set dspStatus=$p(dspData,"^",7)
				continue:(dspStatus'="R")
				set dspQty=+$p(dspData,"^",11)
				set RefundQty=RefundQty+dspQty
			}
		} else {
			set dsp=0
			while($o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp))) {
				set dsp=$o(^DHCOEDISQTY(0,"OEORE",OEExecRowID,dsp))
				set dspData=$g(^DHCOEDISQTY(dsp))
				set dspStatus=$p(dspData,"^",7)
				continue:(dspStatus="C")
				set dspQty=+$p(dspData,"^",11)
				set RefundQty=RefundQty+dspQty
			}
		}
	} else {
		set RefundQty=+$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",5)
		set ExecQty=0
		if (CP="NE") {
			set ExcStatusID=$p($g(^OEORD(+OEExecRowID,"I",+$p(OEExecRowID,"||",2),"X",+$p(OEExecRowID,"||",3))),"^",16)
			set ExcStatus=$s((+ExcStatusID'=0):$p($g(^OEC("STAT",ExcStatusID)),"^",1),1:"")
			if (ExcStatus="F") {
				set ExecQty=$p($g(^OEORD(+OEExecRowID,"I",$p(OEExecRowID,"||",2),"X",$p(OEExecRowID,"||",3))),"^",5)
			}
		}
		set RefundQty=RefundQty-ExecQty
	}
	
	quit RefundQty
}

/// Modify: 2022-11-01 ZhYW 修改重新给^||TMP赋值逻辑
ClassMethod SetItmPrice(OEORE As %String, PBORowId As %String, BillUser As %String) As %Status
{
	new (OEORE, PBORowId, BillUser)
	quit:((OEORE="")||(PBORowId="")) 0
	
	//2016-07-23 Lid 预约检查类医嘱，不按原来的单价计费。
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
	quit:(isAppRep="Y") 0
	
	//+2018-10-31 ZhYW 药品医嘱，取原计费价格
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORE, 2)
	quit:(ordCateType="R") ..SetDrugItmPrice(OEORE, PBORowId, BillUser)
	
	set pb=+PBORowId
	set pbo=$p(PBORowId,"||",2)
	
	set Price=0, DiscPrice=0, InsPrice=0, PatPrice=0
	
	//先将DHC_PatBillDetails中不存在的节点kill
	set Itm=0
	while($o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm))) {
		set Itm=$o(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm))
		set pbd=0
		while($o(^DHCPB(0,"TARI",Itm,pb,pbo,pbd))) {
			set pbd=$o(^DHCPB(0,"TARI",Itm,pb,pbo,pbd))
			set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
			continue:(pbdData="")
			set olt=$p(pbdData,"^",29)            //PBD_OrderLinkTar_DR
			continue:(olt="")
			continue:($d(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",olt)))
			kill ^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",olt)
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
		continue:($d(ItmAry(Itm)))  //过滤重复赋值记录
		set ItmAry(Itm)=""
		set ItmPrice=+$p(pbdData,"^",4)
		set ItmDiscPrice=+$p(pbdData,"^",18)
		set ItmInsPrice=+$p(pbdData,"^",19)
		set ItmPatPrice=+$p(pbdData,"^",20)
		set olt=$p(pbdData,"^",29)            //PBD_OrderLinkTar_DR
		continue:(olt="")
		set qty0=$p($g(^DHCOLT(olt)),"^",3)   //DHC_OrderLinkTar.OLT_Qty
		set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",olt),"^",1)=qty0
		set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",olt),"^",2)=ItmPrice
		set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",olt),"^",3)=ItmDiscPrice
		set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",olt),"^",4)=ItmInsPrice
		set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",olt),"^",5)=ItmPatPrice
		set $p(^||TMP("IB",BillUser,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",olt),"^",10)=pbdRowId    //+2023-04-17 ZhYW 原计费账单RowId
		;
		set Price=ItmPrice*qty0+Price
		set DiscPrice=ItmDiscPrice*qty0+DiscPrice
		set InsPrice=ItmInsPrice*qty0+InsPrice
		set PatPrice=ItmPatPrice*qty0+PatPrice
	}
	
    set ^||TMP("IB",BillUser,$j,"ORDER",OEORE,"PRICE")=Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
	
	quit 0
}

ClassMethod GetUserLocLinkRecLoc(oeitm As %String) As %String
{
	new (oeitm)
	set LinkFlag="N"
	set UserLoc=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),7)),"^",2)
	set RecLoc=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3)),"^",6)
	quit:((RecLoc="")||(UserLoc="")) LinkFlag
	
	if $d(^CTLOC(RecLoc,"LINK",0,"Loc",UserLoc)) {
		set LinkFlag="Y"
	}
	
	quit LinkFlag
}

ClassMethod GetPhOutFlag(Adm As %String) As %String
{
	new (Adm)
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	set PhOutFlag=##class(web.DHCBillCommon).GetIPParamConfig(HospDR, "OutPhBillCondition")
	quit PhOutFlag
}

/// Creator: 杨艳秀
/// CreateDate: 2009-03-16
/// Description: 记录删除的收费项目明细，DHCIPBillDelDetail(+$h,PBDRowID)=Adm
/// Table: DHC_PatBillOrder,DHC_PatBillDetails
/// Debug: w ##class(web.UDHCJFBILLIP).SetDetPatBillDetails()
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
	.kill ^DHCIPBillDelDetailNew(+$h,PBDRowID,"Done")
	.set ^DHCIPBillDelDetailNew(+$h,PBDRowID)=$p(^DHCPB(PBRowID,"O",PBOSub),"^",4)_"#"_^DHCPB(PBRowID,"O",PBOSub,"D",PBDSub)
}

/// Creator: yyx
/// CreateDate: yyx
/// Description: 根据医嘱明细rowid取医嘱明细(OE_OrdItem)
/// Return: OEPirorCode_"^"_StatCode_"^"_IsHourOrd_"^"_ArcGrp_"^"_OrdCateType_"^"_ArcimRowID_"^"_OEPirce
ClassMethod GetOEOrdItemInfo(OrdItmRowID As %String) As %String
{
	new (OrdItmRowID)
    set OEOrd=+OrdItmRowID, ItmCld=$p(OrdItmRowID,"||",2)
    set ArcimRowID=$p(^OEORD(OEOrd,"I",ItmCld,1),"^",2)
    if ('$d(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1))) {
		set ^DHCIPBILLOEORDERR(OEOrd,ItmCld)="NoArcimItem^"_ArcimRowID
		quit ""
	}
    set OEPriorDr=$p($g(^OEORD(OEOrd,"I",ItmCld,1)),"^",8)    //OEORI_Priority_DR
    set OEPirorCode=$p($g(^OECPR(+OEPriorDr)),"^",1)
	set IsHourOrd=##class(BILL.IP.COM.Method).IsBilledByHourOrd(OrdItmRowID)   //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
	set StatDR=$p($g(^OEORD(OEOrd,"I",ItmCld,1)),"^",13)     //OEORI_ItemStat_DR
	set StatCode=$p($g(^OEC("OSTAT",+StatDR)),"^",1)
	set ArcGrp=$p($g(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1)),"^",10)       //子类
	set OrdCateType=$p($g(^ARC("IC",ArcGrp)),"^",7)                     //医嘱类型
	set OEPirce=$p($g(^OEORD(OEOrd,"I",ItmCld,3)),"^",25)     //OEORI_Price
	quit OEPirorCode_"^"_StatCode_"^"_IsHourOrd_"^"_ArcGrp_"^"_OrdCateType_"^"_ArcimRowID_"^"_OEPirce
}

/// Creator: yyx
/// CreateDate: 2012-09-28
/// Description: 判断执行记录是否有附加收费项目，有则不允许部分退药
/// Input: 执行记录rowid，Output：”Y"有附加项目，不允许部分退药，“N"没有附加项目，运行部分退药
/// Debug: w ##class(web.UDHCJFBILLIP).GetExtraItmFlag(执行记录rowid)
ClassMethod GetExtraItmFlag(OrdExcRowID)
{
	n (OrdExcRowID)
	s ExcExtraItmFlag="N"
	s ExtralSum=0
	s PBRowID=$o(^DHCPB(0,"OEEXC",OrdExcRowID,""))
	q:(PBRowID="") "N"
	s OrdSub=$o(^DHCPB(0,"OEEXC",OrdExcRowID,PBRowID,""))
	s DetSub=0
	f  s DetSub=$o(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub))  q:(DetSub="")  d
	.s ExtraFlag=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",22)
	.q:(ExtraFlag'="Y")
	.s TotalAmount=$p(^DHCPB(PBRowID,"O",OrdSub,"D",DetSub),"^",7)
	.s ExtralSum=ExtralSum+TotalAmount
	i (+ExtralSum'=0) d
	.s ExcExtraItmFlag="Y"
	e  d
	.s ExcExtraItmFlag="N"
	
	q ExcExtraItmFlag
}

/// Creator: ZHL
/// CreateDate: 2011-04-06
/// Description：急诊转入院时账单程序调用判断
/// Debug: w ##class(web.UDHCJFBILLIP).CheckOPOrdToIPOrd(1250, "1174||3")
ClassMethod CheckOPOrdToIPOrd(adm As %String, oeitm As %String) As %String
{
    new (adm, oeitm)
    set rtn=0
    set orderAdm=+$p(^OEORD(+oeitm),"^",1)
    set motherAdm=$p(^PAADM(+orderAdm),"^",75)
	//医嘱adm与账单adm不一致并且不是婴儿费用，且该医嘱不是急诊转入住院的医嘱时，不能账单
    if ((adm'=orderAdm)&&(adm'=motherAdm)&&('..OrdIsOPToIPByIPAdm(adm, oeitm))) {
	    set rtn=1
	}

	quit rtn
}

/// Creator: Lid
/// CreatDate: 2014-06-19
/// Description: 是否锁表标志
/// Input: Adm:就诊号
/// 		Bill:账单号
/// Others: 优先级：Adm与Bill都不为空时，Bill的优先级高
///         条数：医嘱执行记录表(OE_OrdExec)或账单医嘱表(DHC_PatBillDetails)的数量大于3000条时，
///         重新账单或取消结算时不锁DHC_PatBillOrder、DHC_PatBillDetails
/// Debug: w ##class(web.UDHCJFBILLIP).IsNoLockTable(605,"","")
ClassMethod IsNoLockTable(Adm As %String, Bill As %String, LimitCount As %String = 3000) As %String
{
	new (Adm, Bill, LimitCount)
	set NoLockFlag=""
	set num=0
	if (Bill'="") {
		&SQL(SELECT count(*) INTO :num FROM DHC_PatBillDetails WHERE PBD_PBO_ParRef->PBO_PB_ParRef = :Bill)
	}else{
		&SQL(SELECT count(*) INTO :num FROM OE_OrdExec WHERE OEORE_OEORI_ParRef->OEORI_OEORD_ParRef->OEORD_Adm_DR = :Adm)	
	}
	if (+num>+LimitCount) set NoLockFlag="NoLock"
	
	quit NoLockFlag
}

/// Creator: 陈曦
/// CreateDate: 2014-12-20
/// Description: 判断DHC_PatBillOrder，DHC_PatBillDetails的医嘱的单条金额是否相等，
///            不等，则将DHC_PatBillDetails中的此医嘱的最后一条收费项目找平
/// Table: DHC_PatBillOrder, DHC_PatBillDetails
/// Debug: w ##class(web.UDHCJFBILLIP).UpdateOrdDetailBalance()
ClassMethod UpdateOrdDetailBalance(OEORE As %String) As %String
{
	new (OEORE)
	
	set rtn=0
	quit:(OEORE="") rtn

	set PBORowID=$p($g(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3),"BILL")),"^",2)
	quit:(PBORowID="") rtn
	
	set PB=+PBORowID
	set PBO=$p(PBORowID,"||",2)
	set PBOData=$g(^DHCPB(PB,"O",PBO))
	quit:(PBOData="") rtn     //modify 2015-02-16  chenxi 重新生成账单时错误医嘱数量小于0时，执行表指向的记录被删除，重新生成账单失败
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
			SET PBD_UnitPrice = :PbdUnitPrice, PBD_DiscPrice = :PbdDisPrice, PBD_InsPrice = :PbdPayPrice, PBD_PatPrice = :PbdPatPrice,
	       		PBD_TotalAmount = :PbdTotAmt, PBD_DiscAmount = :PbdDisAmt, PBD_PayorShare = :PbdPayAmt, PBD_PatientShare = :PbdPatAmt
			WHERE %ID = :PBDRowID
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
	}
	
    quit rtn
}

/// 更新预约检查申请单的账单状态
ClassMethod UpdateAppRepTarItmBillStatus(oeitm, oldStatus, newStatus, oeore)
{
	new (oeitm, oldStatus, newStatus, oeore)

	set itmDr=0
	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr))) {
		set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr))
		set artiDr=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr))) {
			set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr))
			set artiData=$g(^DHCAPREPTA(artiDr))
			set billStatus=$p(artiData,"^",9)  ;账单状态
			set billpoint=$p(artiData,"^",1)
			set ordExec=$p(artiData,"^",10)	;ARTI_OrdExec
			continue:((ordExec'="")&&(ordExec'=oeore))
			continue:(oldStatus'=billStatus)
			set $p(^DHCAPREPTA(artiDr),"^",9)=newStatus
		}
	}
	
	quit 0
}

/// 新版检查申请单退费
/// 		模式：全部退费再收
ClassMethod RefunAppRep(OEORE, PBO, USER)
{
	new (OEORE, PBO, USER)
	set $zt="ERROR^DHCSSERR"
	quit:(+PBO=0) 0
	set (Error, TotalAmount, DiscAmount, InsAmount, PatAmount)=0
	set (RefTotalAmount, RefDiscAmount, RefInsAmount, RefPatAmount)=0
	set currDate=+$h, currTime=$p($h,",",2)
	//增加判断，当DHC_PatBillOrder 表中PBO_TotalAmount的值和本次退费的和小于0时不能退费
	set OldPBOTotalAmt=$p(^DHCPB(+PBO,"O",$p(PBO,"||",2)),"^",8)
	//quit:(OldPBOTotalAmt=0) 0
	
	//预约检查类医嘱，不按原来的单价计费
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder($p(OEORE,"||",1,2))
	quit:(isAppRep'="Y") 0
	
	set OldItmSub=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",""),-1)
	//全部退
	set Itm=0
	for  set Itm=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",Itm)) quit:((Itm="")||(Itm>OldItmSub))  do
	.set BillStatus=$p(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",Itm),"^",14)
	.set PBDRowID=PBO_"||"_Itm
	.quit:(BillStatus'="B")
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
	
	if (Error=0) {
		set err=..UpdateAppRepTarItmBillStatus($p(OEORE,"||",1,2), "I", "R", OEORE)
		set Error=Error+err
	}

	set OrdQty=$p($g(^||TMP("IB",USER,$j,"ORDER",OEORE,"QTY")),"^",1)
		
	if (Error=0) {
		//再收
		set Adm=$p(^OEORD(+OEORE),"^",1)
		set HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
		set RCDRowID=$p($g(^PAADM(Adm,"DHC")),"^",25)
		set regLoc=""
		set oeitm=$p(OEORE,"||",1,2)
		set oeprice=""
		set pattype=$p($g(^PAADM(Adm,1)),"^",6)	   //PAADM_Epissubtype_Dr->PAC_EpisodeSubType
		set instype=$p($g(^PAADM(Adm,1)),"^",7)	   //PAADM_AdmReason_DR->PAC_AdmReason
		set priceDate=$p($g(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3))),"^",47)    //OEORE_BillPriceDate
		set itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_OEORE_"^"_Adm_"^"_regLoc_"^"_""
		
		set (price, discPrice, insPrice, patPrice)=0
		set itmDr=0
		for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:((itmDr="")||(Error'=0))  do
		.set artiDr=0
		.for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:((artiDr="")||(Error'=0))  do
		..set artiData=$g(^DHCAPREPTA(artiDr))
		..set disc=$p(artiData,"^",4)	     ;ARTI_Disc
		..set itm=$p(artiData,"^",5)	     ;ARTI_Tar_Dr
		..set qty=$p(artiData,"^",8)	     ;ARTI_Qty
		..set billStatus=$p(artiData,"^",9)  ;ARTI_Billed
		..set ordExec=$p(artiData,"^",10)    ;ARTI_OrdExec
		..quit:((ordExec'="")&&(ordExec'=OEORE))
		..set ordStatusId=$p($g(^OEORD(+ordExec,"I",$p(ordExec,"||",2),"X",$p(ordExec,"||",3),"BILL")),"^",1) //计费点为医嘱执行计费，则按这个医嘱执行状态OEORE_OrderStatus_DR
		..set ordStatus=$s((+ordStatusId'=0):$p($g(^OEC("OSTAT",ordStatusId)),"^",1),1:"")
		..quit:" D U "[(" "_ordStatus_" ")	   //过滤撤销、停止、作废
		..//quit:(billStatus'="TB")&&(billStatus'="I")
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
		
		//如果是部分退费，需要更新关联表的状态
		set err=..UpdateAppRepTarItmBillStatus($p(OEORE,"||",1,2), "TB", "B", OEORE)
		set Error=Error+err
	}
	
	//更新DHC_PatBillOrder
	if (Error=0) {
		kill PLIST
		set err=##class(web.UDHCJFPBO).SELECT(PBO) 
		set Error=Error+err
		set PLIST(6)=OrdQty
		if (TotalAmount=0) {
			//总金额如果是0，说明是部分退费
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
	
	//更新执行记录表账单状态
	//	规则：
	//		1. I + 部分退费--->B
	//		2. I + 全部退费--->R
	//		3. TB --> B
	set BillStatus=$p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)
	if (BillStatus="I")&&(TotalAmount=0)  set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="R"
	else  set $p(^OEORD(+OEORE,"I",$p(OEORE,"||",2),"X",$p(OEORE,"||",3)),"^",6)="B"
	
	quit Error_"^"_TotalAmount_"^"_DiscAmount_"^"_InsAmount_"^"_PatAmount
}

/// Creator: Lid
/// CreatDate: 2017-09-15
/// Description: 根据账单明细表(DHC_PatBillDetails)更新账单医嘱表(DHC_PatBillOrder)
/// Input: pbo:账单医嘱表rowid
/// Debug: w ##class(web.UDHCJFBILLIP).PBOUpdateByPBD("321536||11")
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
/// Debug: w ##class(web.UDHCJFBILLIP).GetTarItmBillQty("330704||15", 2252, "")
ClassMethod GetTarItmBillQty(pbo As %String, tarItm As %String, dspbDr As %String) As %String
{
	new (pbo, tarItm, dspbDr)

	set billQty=0
	set pbd=0
	while($o(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))) {
		set pbd=$o(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))
		set pbdData=$g(^DHCPB(+pbo,"O",$p(pbo,"||",2),"D",pbd))
		continue:(pbdData="")
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
/// Debug: w ##class(web.UDHCJFBILLIP).SetDrugItmPrice("330704||15", "2252||2")
ClassMethod SetDrugItmPrice(oeore As %String, pboRowId As %String, billUser As %String) As %String
{
	new (oeore, pboRowId, billUser)
	quit:((oeore="")||(pboRowId="")||(billUser="")) 0
	
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeore, 2)
	quit:(ordCateType'="R") 0
	
	set pb=$p(pboRowId,"||",1)
	set pbo=$p(pboRowId,"||",2)
	
	set (Price, DiscPrice, InsPrice, PatPrice)=0
	set Itm=0
	while($o(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm))) {
		set Itm=$o(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm))
		set dspDr=0
		while($o(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr))) {
			set dspDr=$o(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr))
			set dspbSub=0
			while($o(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr,dspbSub))) {
				set dspbSub=$o(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr,dspbSub))
				set ItmData=$g(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr,dspbSub))
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
				set $p(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",2)=ItmPrice
				set $p(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",3)=ItmDiscPrice
				set $p(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",4)=ItmInsPrice
				set $p(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",5)=ItmPatPrice
				set $p(^||TMP("IB",billUser,$j,"ORDER",oeore,"ITEM",Itm,"DSPB",dspDr,dspbSub),"^",10)=pbdRowId    //+2023-04-17 ZhYW 原计费账单RowId
				;
				set Price=ItmPrice*qty0+Price
				set DiscPrice=ItmDiscPrice*qty0+DiscPrice
				set InsPrice=ItmInsPrice*qty0+InsPrice
				set PatPrice=ItmPatPrice*qty0+PatPrice
			}
		}
	}
	set ^||TMP("IB",billUser,$j,"ORDER",oeore,"PRICE")=Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice

	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 获取门诊退费数量
/// Input: oeore: OE_OrdExec.RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFBILLIP).GetRefundQtyO("1509||9||1")
ClassMethod GetRefundQtyO(oeore As %String) As %String
{
	new (oeore)
	set refundQty=0
	set oeitm=$p(oeore,"||",1,2)
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRep="Y") {
		quit refundQty    //多部位检查申请单不取退费数量
	}
	
	set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	if (inci'="") {
		set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
		if (ordCateType="R") {
			//药品
			set dsp=0
			while($o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))) {
				set dsp=$o(^DHCOEDISQTY(0,"OEORE",oeore,dsp))
				set dspData=$g(^DHCOEDISQTY(dsp))
				continue:(dspData="")
				set dspStatus=$p(dspData,"^",7)
				continue:(dspStatus'="R")
				set dspQty=$p(dspData,"^",11)
				set refundQty=$i(refundQty, dspQty)
			}
		}else {
			//非药品，如材料
			set appRefundInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(oeitm, "")
			set factRefQty=$p(appRefundInfo,"^",3)   //实际已退数量
			if (+factRefQty'=0) {
				set refundQty=factRefQty
			}
		}
	}else {
		set excStatDR=$p($g(^OEORD(+oeore,"I",+$p(oeore,"||",2),"X",+$p(oeore,"||",3))),"^",16)
		set excStatCode=$s((+excStatDR'=0):$p($g(^OEC("STAT",excStatDR)),"^",1),1:"")
		if (excStatCode'="F") {
			set refundQty=+$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3))),"^",5)
		}
	}
	
	quit refundQty
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否转入该住院就诊
/// Input: adm: PA_Adm.RowId(住院), oeitm: OE_OrdItem.RowId
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

/// Creator: ZhYW
/// CreatDate: 2020-02-18
/// Description: 更新医嘱执行记录表取价格日期
/// Input: oeore: OE_OrdExec.RowId
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFBILLIP).UpdateOEPriceDate("1104||1||1", +$h, $p($h,",",2))
ClassMethod UpdateOEPriceDate(oeore As %String, priceDate As %String, priceTime As %String) As %String
{
	new (oeore, priceDate, priceTime)
	set rtn=0
	set oldPriceDate=$p($g(^OEORD(+oeore,"I",$p(oeore,"||",2),"X",$p(oeore,"||",3))),"^",47)    //OEORE_BilledDate
	quit:(+oldPriceDate'=0) rtn    //不为空时不更新
	ts
	&SQL(
		UPDATE OE_OrdExec
		SET OEORE_BillPriceDate = :priceDate, OEORE_BillPriceTime = :priceTime
		WHERE %ID = :oeore
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2021-01-19
/// Description: HOUR医嘱退费(全部退费再收)
/// Input: PBO:DHC_PatBillOrder.RowId, OEORE:OE_OrdExec.RowId, Itm:DHC_TarItem.RowId, Status:计费状态, UserId:SS_User.RowId, Olt:DHC_OrderLinkTar.RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFBILLIP).RefundHourPBD()
ClassMethod RefundHourPBD(PBO As %String, OEORE As %String, Itm As %String, UserId As %String, Olt As %String) As %String
{
	new (PBO, OEORE, Itm, UserId, Olt)
	set $zt="ERROR^DHCSSERR"
	quit:(+PBO=0) 0
	
	set IsHourOrd=##class(BILL.IP.COM.Method).IsBilledByHourOrd($p(OEORE,"||",1,2))   //2022-06-14 ZhYW 判断是否是按HOUR计费的医嘱
	quit:(IsHourOrd'=1) 0
	
	set ItmData=$g(^||TMP("IB",UserId,$j,"ORDER",OEORE,"ITEM",Itm,"OLT",Olt))
	set Qty0=$p(ItmData,"^",1)
	set Price0=$p(ItmData,"^",2)
	set DiscPrice0=$p(ItmData,"^",3)
	set InsPrice0=$p(ItmData,"^",4)
	set PatPrice0=$p(ItmData,"^",5)
	set BillDate=$p(ItmData,"^",6)
	set BillTime=$p(ItmData,"^",7)
	set disc=$p(ItmData,"^",8)	     //新版申请单折扣系数
	set artiDr=$p(ItmData,"^",9)	 //新版申请单中间表指针
	;
	set OrdQty=$p($g(^||TMP("IB",UserId,$j,"ORDER",OEORE,"QTY")),"^",1)
	
	set rtn=0
	set curDate=+$h, curTime=$p($h,",",2)
	
	set (TotalAmount, DiscAmount, PayorAmount, PatAmount)=0
	
	//全退
	set PBD=""
	set pbd=""
	while($o(^DHCPB(0,"TARI",Itm,+PBO,$p(PBO,"||",2),pbd),-1)) {
		set pbd=$o(^DHCPB(0,"TARI",Itm,+PBO,$p(PBO,"||",2),pbd),-1)
		set pbdData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",pbd))
		set oltDR=$p(pbdData,"^",29)      //PBD_OrderLinkTar_DR
		continue:(oltDR'=Olt)
		set PBD=pbd
		quit
	}
	if (PBD'="") {
		set PBDQty=$p($g(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",PBD)),"^",5)
		if (PBDQty>0) {
			set PBDRowID=PBO_"||"_PBD
			kill PLIST
			set PLIST(13)="R"
			set rtn=##class(web.UDHCJFPBOD).UPDATE(PBDRowID)
			if (+rtn) quit rtn_"^"_$g(%msg)
			set rtn=##class(web.UDHCJFPBOD).SELECT(PBDRowID)
			kill PLIST(1), PLIST(2)
			set PLIST(0)=PBO
			set PLIST(5)=-PLIST(5)
			set PLIST(7)=-PLIST(7)
			set PLIST(8)=-PLIST(8)
			set PLIST(9)=-PLIST(9)
			set PLIST(10)=-PLIST(10)
			set PLIST(11)=curDate
			set PLIST(12)=curTime
			set PLIST(13)="R"
			set PLIST(14)=curDate
			set PLIST(15)=curTime
			set PLIST(16)=UserId
			set PLIST(23)=PBDRowID      //+2023-04-17 ZhYW 原计费明细Id
			set rtn=##class(web.UDHCJFPBOD).INSERT()
			if (+rtn) quit rtn_"^"_$g(%msg)
			set TotalAmount=$i(TotalAmount, PLIST(7))
			set DiscAmount=$i(DiscAmount, PLIST(8))
			set PayorAmount=$i(PayorAmount, PLIST(9))
			set PatAmount=$i(PatAmount, PLIST(10))
		}
	}
	
	if (BillDate="") set BillDate=+$h
	if (BillTime="") set BillTime=$p($h,",",2)

	//再收
	if (+OrdQty'=0) {
		kill PLIST
		set PLIST(0)=PBO
		set PLIST(3)=Itm
		set PLIST(4)=+Price0
		set PLIST(5)=+Qty0*OrdQty
		set PLIST(7)=+..round(Price0*PLIST(5))
		set PLIST(8)=+..round(DiscPrice0*PLIST(5))
		set PLIST(9)=+..round(InsPrice0*PLIST(5))
		set PLIST(10)=PLIST(7)-PLIST(8)-PLIST(9)
		set PLIST(11)=BillDate              //计费日期
		set PLIST(12)=BillTime              //计费时间
		set PLIST(13)="B"
		set PLIST(14)=curDate
		set PLIST(15)=curTime
		set PLIST(16)=UserId
		set PLIST(18)=+DiscPrice0
		set PLIST(19)=+InsPrice0
		set PLIST(20)=+PatPrice0
		set PLIST(25)=disc
		set PLIST(26)=artiDr
		set PLIST(29)=Olt     //+2023-04-17 ZhYW
		set rtn=##class(web.UDHCJFPBOD).INSERT()
		if (+rtn)  quit rtn_"^"_$g(%msg)
		set TotalAmount=$i(TotalAmount, PLIST(7))
		set DiscAmount=$i(DiscAmount, PLIST(8))
		set PayorAmount=$i(PayorAmount, PLIST(9))
		set PatAmount=$i(PatAmount, PLIST(10))
	}
	
	//对数量进行验证
	set QtySum=0
	set PBD=0
	while($o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",PBD))) {
		set PBD=$o(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",PBD))
		set PBDData=$g(^DHCPB(+PBO,"O",$p(PBO,"||",2),"D",PBD))
		set PBDOltDR=$p(PBDData,"^",29)      //PBD_OrderLinkTar_DR
		continue:(PBDOltDR'=Olt)
		set PBDQty=$p(PBDData,"^",5)
		set QtySum=$i(QtySum, PBDQty)
	}
	if (QtySum<0) -1_"^"_PBO_"对应的账单明细表数量总和不合法："_QtySum
	
	quit rtn_"^"_TotalAmount_"^"_DiscAmount_"^"_PayorAmount_"^"_PatAmount
}

/// Creator: ZhYW
/// CreatDate: 2022-11-02
/// Description: 修正DHC_PatBillOrder表数据
///        原来是放在UpdateOrdDetailBalance()中，这存在更新账单主表不正确的情况
/// Input: pboRowId: DHC_PatBillOrder.RowId
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.UDHCJFBILLIP).AdjustPatBillOrder("81||41")
ClassMethod AdjustPatBillOrder(pboRowId As %String) As %String
{
	new (pboRowId)
	
	set rtn=0
	quit:(pboRowId="") -1_"^"_"参数错误"
	
	set pboData=$g(^DHCPB(+pboRowId,"O",$p(pboRowId,"||",2)))
	quit:(pboData="") rtn
	set billQty=$p(pboData,"^",5)
	set refundQty=$p(pboData,"^",6)
	set qty=billQty+refundQty
	set totalAmt=$p(pboData,"^",8)    //PBO_ToTalAmount
	if ((qty=0)&&($zabs(totalAmt)<0.05)) {
		&SQL(
			UPDATE DHC_PatBillOrder
			SET PBO_ToTalAmount = 0, PBO_DiscAmount = 0, PBO_PayorShare = 0, PBO_PatientShare = 0
			WHERE %ID = :pboRowId
		)
		set rtn=SQLCODE
		quit:(+rtn) rtn_"^"_$g(%msg)
	}
	quit rtn
}

}
