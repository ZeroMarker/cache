Import SQLUser

Class web.UDHCOEORDOP7 Extends BILL.COM.Abstract
{

/// w ##class(web.UDHCOEORDOP7).AutoAddNewOrder("1^",$C(2)_"1"_$C(2)_"^1||47^"_$C(2)_"1"_$C(2),"1","0","^2^207^5^^DHCHealth^","")
ClassMethod AutoAddNewOrder(Paadminfo As %String, UnBillOrdStr As %String, Instype As %String, SFlag As %String, SessionStr As %String, ExpStr As %String) As %String
{
	;自动录入医嘱 功能，数据配置
	;^DHCOPCHARGECP("AutoNOrd","ARCI")					;医嘱RowID
	;^DHCOPCHARGECP("AutoNOrd","RECLOC")				;执行科室
	;^DHCOPCHARGECP("AutoNOrd","LISTUBEAMOUNT")		   ;lis管子数量
	;门诊收费自动增加医嘱
	;
	s rtn=0
	
	;=0  表示有医嘱加入
	;=126 门诊收费没有自动加入医嘱
	
	s myServiceName="OPCBeforeCharge"
	;(PAADMStr, AdmInsType, unBillStr, groupDR, UserLDR)
	;s myOEORIStr=##class(web.udhcOPBillIF).ReadUFAdmOrder(Paadminfo,Instype,UnBillOrdStr,gloc,Userid)
	
	b	;;
	;s myOERInfo=##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService(myServiceName,myOEORIStr)
	;收费前服务；
	s myGroupDR=$p(SessionStr,"^",4)
	s myUserDR=$p(SessionStr,"^",2)
	s myConDef=##class(web.DHCEntity.CIDefine.ConditionDefine).%New()
	s myConDef.AdmListInfo=Paadminfo
	s myConDef.Instype=Instype
	s myConDef.UserDR=myUserDR
	s myConDef.GroupDR=myGroupDR
	s myConDef.UnBillOrdStr=UnBillOrdStr
	s myConDef.ServiceName="OPCBeforeCharge"
	s myConDef.SFlag=SFlag
	s mySerInfo=##class(web.DHCBL.CI.Service).Service(myConDef)
		
	s myOrdRowIDStr=""
	s myFairStr="0^0^0^0"
	;rtn_$c(1)_myLISXmlInfo_$c(1)_myBCXmlInfo_$c(1)_myPACSXmlInfo
	i +$p(mySerInfo,$c(1))=0 d
	.s myLisInfo=$p(mySerInfo,$c(1),2)
	.q:(myLisInfo="")
	.s myResultCode=##class(web.DHCOPCommonFunLib).GetXmlElementValue(myLisInfo,"ResultCode")
	.q:(+myResultCode)
	.s myAmount=##class(web.DHCOPCommonFunLib).GetXmlElementValue(myLisInfo,"Amount")
	.;s myAmount=0
	.q:(+myAmount<=0)
	.s:(+myAmount<=0) myAmount=2
	.s myAdm=+Paadminfo
	.q:(myAdm="")
	.s myPAPMI=$p($g(^PAADM(myAdm)),"^",1)
	.s myPatTypeDR=$p($g(^PAPER(myPAPMI,"PER",1)),"^",10)
	.;^DHCOPCHARGECP("AutoNOrd","ARCI")					;医嘱RowID
	.;^DHCOPCHARGECP("AutoNOrd","RECLOC")				;执行科室
	.;^DHCOPCHARGECP("AutoNOrd","LISTUBEAMOUNT")		;lis管子数量
	.s myArcItmRowID=$g(^DHCOPCHARGECP("AutoNOrd","ARCI"))
	.s myRecLocRID=$g(^DHCOPCHARGECP("AutoNOrd","RECLOC"))
	.s:(myArcItmRowID="") myArcItmRowID="2154||1"			;"1687||1"  本地   9961||1
	.s:(myRecLocRID="") myRecLocRID="157"
	.s myOrdPrice=##class(web.DHCOPItemMast).GetOrderPrice(myPatTypeDR,Instype,myArcItmRowID,+$h,"","","",0)
	.s myOrdPrice=+myOrdPrice
	.s myInsRowID=Instype
	.s myOrdItemStr=myArcItmRowID_"^"_myAmount_"^"_myRecLocRID_"^"_myOrdPrice_"^^"_myInsRowID
	.s myUser=myUserDR
	.s myLoc=$p($g(^PAADM(myAdm)),"^",4)
	.s myDocUserID=""		;$p($g(^PAADM(myAdm)),"^",9)
	.s myOSRID=""
	.;s ^TMPCICIResponseBuilder=$lb(myAdm, myOrdItemStr, myUser, myLoc, myDocUserID, myOSRID)
	.s myOrdInfo=##class(web.DHCOPCashier).CashierInsertOrdItem(myAdm, myOrdItemStr, myUser, myLoc, myDocUserID, myOSRID)	
	.q:(" 0 100 "[(" "_myOrdInfo_" "))
	.s myOEORI=$p(myOrdInfo,"^",2)
	.s myOrdRowIDStr=myOEORI
	.s OEORICost=##class(web.DHCOPCashier1).GetOrderItemDetail(myPatTypeDR, Instype, myOEORI)
	.s OEORISum=$p(OEORICost,"^",1)
	.s OEORIDiscSum=$p(OEORICost,"^",2)
	.s OEORIInsSum=$fn($p(OEORICost,"^",3),"",2)
	.s OEORIPatSum=$fn($p(OEORICost,"^",4),"",2)
	.s myFairStr=$fn(OEORISum,"",2)_"^"_$fn(OEORIDiscSum,"",2)_"^"_OEORIInsSum_"^"_OEORIPatSum
	.s ServiceType="OPC"
	.s ServiceRangeType="OPCB"				;收费前服务
	.s myHISOrdInfo=##class(web.UDHCOEORDOPCommon).AutoAddNewOrder(Paadminfo, UnBillOrdStr, Instype, SFlag, SessionStr, ServiceType, ServiceRangeType, ExpStr)
	.s myOPCBInfo=$p(myHISOrdInfo,$c(1),3)
	.s myOrdRowIDStr=myOrdRowIDStr_"^"_$p(myHISOrdInfo,$c(1),2)
	.s $p(myFairStr,"^",1)=+$p(myFairStr,"^",1)+$p(myOPCBInfo,"^",1)
	.s $p(myFairStr,"^",2)=+$p(myFairStr,"^",2)+$p(myOPCBInfo,"^",2)
	.s $p(myFairStr,"^",3)=+$p(myFairStr,"^",3)+$p(myOPCBInfo,"^",3)
	.s $p(myFairStr,"^",4)=+$p(myFairStr,"^",4)+$p(myOPCBInfo,"^",4)
	.s rtn=0
	e  d
	.s rtn=126
	
	s ServiceType="OPC"
	s ServiceRangeType="HIS"			;医嘱自己的规则
	s myHISOrdInfo=##class(web.UDHCOEORDOPCommon).AutoAddNewOrder(Paadminfo, UnBillOrdStr, Instype, SFlag, SessionStr, ServiceType, ServiceRangeType, ExpStr)
	s myOPCBInfo=$p(myHISOrdInfo,$c(1),3)
	s myOrdRowIDStr=myOrdRowIDStr_"^"_$p(myHISOrdInfo,$c(1),2)
	s $p(myFairStr,"^",1)=+$p(myFairStr,"^",1)+$p(myOPCBInfo,"^",1)
	s $p(myFairStr,"^",2)=+$p(myFairStr,"^",2)+$p(myOPCBInfo,"^",2)
	s $p(myFairStr,"^",3)=+$p(myFairStr,"^",3)+$p(myOPCBInfo,"^",3)
	s $p(myFairStr,"^",4)=+$p(myFairStr,"^",4)+$p(myOPCBInfo,"^",4)
	
	i +$p(myHISOrdInfo,$c(1),1)=0 d
	.s rtn=0
	
	;标志$c(1)医嘱RowID$c(1)价格
	q rtn_$c(1)_myOrdRowIDStr_$c(1)_myFairStr
}

/// Creator: ZhYW
/// CreatDate: 2018-10-16
/// Description: 判断是否发药
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 0:未发，1:已发
/// Debug: w ##class(web.UDHCOEORDOP7).CheckPhDispRet("15||4")
ClassMethod CheckPhDispRet(oeitm As %String) As %String
{
	set rtn=0
	
	set dsp=0
	while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))&&(rtn=0)) {
		set dsp=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))
		set disp=$g(^DHCOEDISQTY(dsp))
		continue:(disp="")
		set dspStatus=$p(disp,"^",7)
		set rtn=(dspStatus="C")
	}
	
	quit rtn
}

/// w ##class(web.UDHCOEORDOP7).ReadOEORDRefundQty("348","1877||2")
ClassMethod ReadOEORDRefundQty(INVRowID As %String = "", OEORIRowID As %String = "") As %String
{
	;这个是 第 0 版的 退药数量检查
	;^DHCPHRETi("NEWPRT",{PHRET_NEWPRT_DR},{PHRET_PHL_DR},{PHRET_ROWID})
	;没有办理过退药
	q:($d(^DHCPHRETi("NEWPRT",INVRowID))=0) 0
	s refundQty=0
	
	;办理过退药?
	s PhLocrid=0
	f  s PhLocrid=$o(^DHCPHRETi("NEWPRT",INVRowID,PhLocrid)) q:(PhLocrid="")  d
	.s RetRID=0
	.f  s RetRID=$o(^DHCPHRETi("NEWPRT",INVRowID,PhLocrid,RetRID)) q:(RetRID="")  d
	..;^DHCPHRTI({DHC_PHRETURN.PHRET_ROWID},"RTI",{PHRTI_CHILDSUB})
	..s RetSubRID=0
	..f  s RetSubRID=$o(^DHCPHRTI(RetRID,"RTI",RetSubRID)) q:(RetSubRID="")  d
	...s myOERid=$p(^DHCPHRTI(RetRID,"RTI",RetSubRID),"^",2)
	...i OEORIRowID=myOERid d
	....s refundQty=refundQty+$p($g(^DHCPHRTI(RetRID,"RTI",RetSubRID)),"^",3)
	
	;增加护士数量
	s oeordId=$p(OEORIRowID,"||",1),oeoriSub=$p(OEORIRowID,"||",2)
	s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
	s itemstat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	s ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(OEORIRowID, 1)
	
	s statcode=""
	i (itemstat'="") d
	.s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
    i ((ordCateType="R")&(phlId'="")&(statcode'="D")) d
    .;对于药物，非停止医嘱，符合护士站虚发药的
    .s ActiveFlag=+$p($g(^DHCPHLOC(phlId)),"^",7)
    .i (ActiveFlag=1) d
    ..s refundQty=+$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",23) ;医嘱退药数量
	
	quit refundQty
}

/// w ##class(web.UDHCOEORDOP7).ReadOEORDExecQty(460619, "440922||10", "")
ClassMethod ReadOEORDExecQty(PRTRowID As %String, OEORI As %String, ExpStr As %String) As %String
{
	s myExcQty=0
	
	q:(OEORI="") myExcQty
	
	s ArcimRowid=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)		;EORI_ItmMast_DR
	s myCBP=..CheckBillPoint(ArcimRowid)
	
	;护士不执行 返回执行数量=0
	q:(myCBP'="NE") myExcQty
	
	;OEC_Order_AdminStatus
	; STAT_Bill  属于账单Yes的
	; ^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub}, "X",{OEORE_Childsub})
	
	s myORESub=0
	f  s myORESub=$o(^OEORD(+OEORI,"I",$p(OEORI,"||",2), "X",myORESub))  q:(myORESub="")  d
	.s myExStDate=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2), "X",myORESub), "^", 1)	;OEORE_ExStDate
	.s myExStTime=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2), "X",myORESub), "^", 2)	;EORE_ExStTime
	.s myOrdAdmStatusDR=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2), "X",myORESub), "^", 16)		;OEORE_Order_AdminStatus
	.q:(myOrdAdmStatusDR="")
	.s mySBill=$p(^OEC("STAT",myOrdAdmStatusDR),"^",3)
	.q:(mySBill="N")
	.s myExcQty=myExcQty+1
	
	q myExcQty
}

/// w ##class(web.UDHCOEORDOP7).CheckBillPoint()
ClassMethod CheckBillPoint(ArcimID As %String) As %String
{
	s myItemCatDR=$p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)	;ARCIM_ItemCat_DR
	
	s CP=""
	s Conf=""
	s Conf=$o(^DHCTarC("CF",Conf))
	s DefaultCP=$p(^DHCTarC("CF",Conf),"^",9)
	i (DefaultCP="") s DefaultCP="OD"
	
	s Condition=$o(^DHCTarC("BC",0,myItemCatDR,""))
	i (Condition'="") s CP=$p(^DHCTarC("BC",Condition),"^",2)
	e  s CP=DefaultCP
	
	q CP
}

/// 通过发票号码检测 在退费时医嘱是否发生变化
/// 检测要退费的医嘱是否发生变化
/// 0:返回表示医嘱没有变化, 114:返回检测到退费医嘱发生变化，需要重新刷新界面才能退费
/// w ##class(web.UDHCOEORDOP7).CheckOEORDChangeStatus(PRTRowID, StopOrdStr, ExpStr)
ClassMethod CheckOEORDChangeStatus(PRTRowID As %String, StopOrdStr As %String, ExpStr As %String) As %String
{
	set rtn=0
	
	set mylen=$l(StopOrdStr,"^")
	for i=1:1:mylen {
		set oeitm=$p(StopOrdStr,"^",i)
		continue:(oeitm="")
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(oeitm)=1)   //判断医嘱是不是转入住院，转入住院的医嘱需要退费
		set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
		set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
		set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm, 1)
		if (ordCateType="R") {
			set isOPIVAS=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC")),"^",16)   //静配标识
			if (isOPIVAS="Y") {
				set effectiveQty=##class(BILL.Interface.Inside.Invoke).GetEffectiveQtyForOPIVAS(oeitm)
				set billQty=##class(BILL.OP.COM.Method).GetOrdPrtBillQty(PRTRowID, oeitm)
				if (billQty=effectiveQty) {
					set rtn=114_"^"_"医嘱："_arcimDesc_"无可退数量，不能退费"    //没有可退数量时不能退费(未发的药品医嘱申请退费时会停执行记录)
					quit
				}
			}else {
				set isExecut=##class(web.UDHCOEORDOPIF).CheckPhDispRet(oeitm)
				set retQty=##class(BILL.Interface.Inside.Invoke).GetRetOrdQty(oeitm, PRTRowID)
				if ((+isExecut=1)&&(+retQty=0)) {
					set rtn=114_"^"_"医嘱："_arcimDesc_"未退药，不能退费"    //已发药但未退药时不能退费
					quit
				}
			}
		}else {
			set ordStatDR=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",13)
			set ordStatCode=$s((+ordStatDR'=0):$p($g(^OEC("OSTAT",ordStatDR)),"^",1),1:"")
			//Lid 2017-04-12 新版申请单部分执行时，医嘱状态空
			set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
			if (isAppRep="Y") {
				set isPartExec=##class(web.DHCOPBillRefund).IsPartExecut(oeitm)   //0:部分执行或未执行，1：全部执行
				if (isPartExec=0)  set ordStatCode=""
			}
			if (ordStatCode="E") {
				set rtn=114_"^"_"医嘱："_arcimDesc_"被执行，不能退费"
				quit
			}
		}
	}
	quit:(+rtn) rtn
	
	//在界面上没有选择退药的医嘱
	set billConInv=0
	while($o(^DHCBCI(0,"INV",PRTRowID,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",PRTRowID,billConInv))
		set conData=$g(^DHCBCI(billConInv))
		set pb=$p(conData,"^",2)
		set pbo=0
		while($o(^DHCPB(pb,"O",pbo))) {
			set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
			continue:(pboData="")
			set oeitm=$p(pboData,"^",4)
			continue:(("^"_StopOrdStr_"^")[("^"_oeitm_"^"))
			set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
			set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
			set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm, 1)
			if (ordCateType="R") {
				set isExecut=##class(web.UDHCOEORDOPIF).CheckPhDispRet(oeitm)
				set retQty=##class(BILL.Interface.Inside.Invoke).GetRetOrdQty(oeitm, PRTRowID)
				if ((+isExecut=1)&&(+retQty'=0)) {
					set rtn=114_"^"_"医嘱："_arcimDesc_"已退药，须勾选退费"  //已发药且已退药但未勾选退费时不能退费
					quit
				}
			}
		}
		quit:(+rtn)
	}
	quit:(+rtn) rtn
	
	//+2019-07-23 ZhYW 已转入住院的医嘱是否有未退的
	set ociId=0
	while($o(^DHCOPIPADMCON(0,"InvPrt",PRTRowID,ociId))) {
		set ociId=$o(^DHCOPIPADMCON(0,"InvPrt",PRTRowID,ociId))
		set ociData=$g(^DHCOPIPADMCON(ociId))
		set status=$p(ociData,"^",7)
		continue:(status'="N")
		set oeitm=$p(ociData,"^",6)
		continue:(("^"_StopOrdStr_"^")[("^"_oeitm_"^"))
		set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
		set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
		set rtn=115_"^"_"医嘱："_arcimDesc_"费用已转入住院，须勾选退费"
		quit
	}
	quit:(+rtn) rtn
	
	quit rtn
}

/// w ##class(web.UDHCOEORDOP7).CancleStopOrdItemStatus("")
ClassMethod CancleStopOrdItemStatus(PRTRowID As %String) As %String
{
	s rtn=0
	
	s myNewINVRowID=""
	s myNewINVRowID=$o(^DHCINVPRT(0,"OldINV",PRTRowID,0))
	
	;$o(^DHCBCI(0,"INV",myRefundRowID, myRefBCIRowID))  q:(myRefBCIRowID="")||(+rtn'=0)  d
	s myPBRowID=0
	s myBCIRowID=0
	f  s myBCIRowID=$o(^DHCBCI(0,"INV",PRTRowID, myBCIRowID))  q:(myBCIRowID="")||(+rtn'=0)  d
	.;^DHCBCI({DHCBCI_Rowid})
	.s myPBRowID=$p(^DHCBCI(myBCIRowID),"^", 2)
	.;^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
	.s myPBOSub=0
	.f  s myPBOSub=$o(^DHCPB(myPBRowID,"O",myPBOSub))  q:(myPBOSub="")||(+rtn'=0)  d
	..q:($d(^DHCPB(myPBRowID,"O",myPBOSub))=10)
	..s myOEORDDR=$p(^DHCPB(myPBRowID,"O",myPBOSub),"^", 4)
	..s myfindflag=..CheckOrdItemStatus(myNewINVRowID, myOEORDDR)
	..q:(+myfindflag)
	..;下面停止医嘱
	..
	.
	
	q rtn
}

/// 验证 此医嘱是否在发票中存在
ClassMethod CheckOrdItemStatus(PRTRowID As %String, OEORDItemRowID As %String) As %String
{
	
	s rtn=0
	
	q:(PRTRowID="") rtn
	
	s myBCIRowID=0
	f  s myBCIRowID=$o(^DHCBCI(0,"INV",PRTRowID,myBCIRowID))  q:(myBCIRowID="")||(+rtn'=0)  d
	.s myPBRowID=$p(^DHCBCI(myBCIRowID),"^", 2)
	.s myPBOSub=0
	.f  s myPBOSub=$o(^DHCPB(myPBRowID,"O",myPBOSub))  q:(myPBOSub="")||(+rtn'=0)  d
	..q:($d(^DHCPB(myPBRowID,"O",myPBOSub))=10)
	..s myOEORDDR=$p(^DHCPB(myPBRowID,"O",myPBOSub),"^",4)
	..i (OEORDItemRowID=myOEORDDR) d
	...s rtn=1
	
	q rtn
}

/// d ##class(web.UDHCOEORDOP7).XMLTEST()
ClassMethod XMLTEST()
{
	s myXml="<?xml version='1.0' encoding='gb2312'?>"
	s myXml=myXml_"<Response><ResultCode>0</ResultCode><ErrorMsg></ErrorMsg><Amount>1</Amount></Response>"
	
	s myResultCode=##class(web.DHCOPCommonFunLib).GetXmlElementValue(myXml,"ResultCode")
	;q:(+myResultCode)
	s myAmount=##class(web.DHCOPCommonFunLib).GetXmlElementValue(myXml,"Amount")

	;s myAmount=0
	q:(+myAmount<=0)
	s:(+myAmount<=0) myAmount=2
	s myAdm=+1
	q:(myAdm="")
	s myPAPMI=$p($g(^PAADM(myAdm)),"^",1)
	s myPatTypeDR=$p($g(^PAPER(myPAPMI,"PER",1)),"^",10)
	s myArcItmRowID="9961||1"
	s myRecLocRID="157"
	s myUserDR=1
	s Instype=1
	s myOrdPrice=##class(web.DHCOPItemMast).GetOrderPrice(myPatTypeDR,Instype,myArcItmRowID,+$h,"","","",0)
	s myOrdPrice=+myOrdPrice
	s myInsRowID=Instype
	.s myOrdItemStr=myArcItmRowID_"^"_myAmount_"^"_myRecLocRID_"^"_myOrdPrice_"^^"_myInsRowID
	.s myUser=myUserDR
	.s myLoc=$p($g(^PAADM(myAdm)),"^",4)
	.s myDocUserID=""		;$p($g(^PAADM(myAdm)),"^",9)
	.s myOSRID=""
	.;s ^TMPCICIResponseBuilder=$lb(myAdm, myOrdItemStr, myUser, myLoc, myDocUserID, myOSRID)
	.s myOrdInfo=##class(web.DHCOPCashier).CashierInsertOrdItem(myAdm, myOrdItemStr, myUser, myLoc, myDocUserID, myOSRID)	
	.q:(+myOrdInfo'=0)
	.s myOEORI=$p(myOrdInfo,"^",2)
	.s myOrdRowIDStr=myOEORI
	.s OEORICost=##class(web.DHCOPCashier1).GetOrderItemDetail(myPatTypeDR,Instype,myOEORI)
	.s OEORISum=$p(OEORICost,"^",1)
	.s OEORIDiscSum=$p(OEORICost,"^",2)
	.s OEORIInsSum=$fn($p(OEORICost,"^",3),"",2)
	.s OEORIPatSum=$fn($p(OEORICost,"^",4),"",2)
	.s myFairStr=$fn(OEORISum,"",2)_"^"_$fn(OEORIDiscSum,"",2)_"^"_OEORIInsSum_"^"_OEORIPatSum
	.s rtn=0
	e  d
	.s rtn=126
	
	;标志$c(1)医嘱RowID$c(1)价格
	q rtn_$c(1)_myOrdRowIDStr_$c(1)_myFairStr
}

}
