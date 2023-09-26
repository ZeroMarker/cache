Import SQLUser

/// 名称: web.DHCBillPilot.cls
/// 描述: 临床药理试验业务
/// 编写者: Lid
/// 编写日期: 2014-12-31
/// 产品组：计费医保组
Class web.DHCBillPilot Extends BILL.COM.Abstract
{

Parameter OutAdmReasonCode = "KYYY";

Parameter InAdmreasonCode = "ZYKYYY";

Parameter OPChargeUserCode = "KYJS";

Parameter PilotPayMode = "KY";

/// Creator: Lid
/// CreatDate: 2014-12-31
/// Description: 获取临床药理试验费别信息
/// Input: OP:门诊，IP：住院（默认）
/// Return: pac_admreason表rowid
/// Debug: w ##class(web.DHCBillPilot).GetPilotAdmReason()
ClassMethod GetPilotAdmReason(type As %String) As %String
{
	if (type="OP") {
		set admReasonCode=..#OutAdmReasonCode
	}elseif (type="IP") {
		set admReasonCode=..#InAdmreasonCode
	}else {
		set admReasonCode=..#InAdmreasonCode
	}
	set admReasonDR=$o(^PAC("ADMREA",0,"Code",$$ALPHAUP^SSUTIL4(admReasonCode),0))
	quit admReasonDR
}

/// Creator: Lid
/// CreatDate: 2014-12-31
/// Description: 判断医嘱是否是临床试验用药医嘱
/// Input: oeitm:医嘱Rowid，expStr:扩展串
/// Return: Y:是，非Y：不是
/// Debug: w ##class(web.DHCBillPilot).IsPilotOrdItem("","")
ClassMethod IsPilotOrdItem(oeitm As %String, expStr As %String = "") As %String
{
	set myOrdPlilotDR=$p($g(^OEORD(+oeitm,"I",$P(oeitm,"||",2),"DHC")),"^",10)  ;存科研项目的指针
	set pilotFlag=$s((myOrdPlilotDR'=""):"Y",1:"N")
	quit pilotFlag_"^"_myOrdPlilotDR
}

/// Creator: Lid
/// CreatDate: 2013-03-07
/// Description: 判断病人是否有科研用药就诊
/// Input: PatDr:Pa_Patmas表Rowid,ExpStr:扩展信息
/// Return: 标志(1:是科研用药就诊)^就诊号^就诊号...
/// Debug: w ##class(web.DHCBillPilot).GetPilotInsuType("","")
ClassMethod GetPilotInsuType(PatDr As %String, ExpStr As %String) As %String
{
	set IsPilotFlag="", PilotEpisodeStr=""
	set Type=$p(ExpStr,"^",1)
	set PilotEpisodeStr=##class(web.PilotProject.DHCDocPilotProCommon).getProAdmByPAPMIID(PatDr, Type)
	if (PilotEpisodeStr'="") set IsPilotFlag=1
	quit IsPilotFlag_"!"_PilotEpisodeStr
}

/// Creator: 庄娜
/// CreateDate: 2014-09-18
/// Modify: Lid
/// ModifiedDate: 2014-09-28
/// Description: 已知某段时间，输出费别为临床药理，支付方式为支票的发票明细
/// Input: 开始时间（stdate）、结束时间（enddate）、DHC_TarAcctCate
/// Output: 登记号（ipno）、姓名（name）、费别（ADMReason）、总金额（amount）、押金（deposit）、收费项目（item1）、项目金额（amt1）
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCIPINVPrtzy","DHCINVPRTDetail","63448","63448")  
Query DHCINVPRTDetail(sDate As %String, eDate As %String) As websys.Query(ROWSPEC = "ipno:%String:登记号,name:%String:姓名,ADMReason:%String:费别,amount:%String:总金额,deposit:%String:押金,item1:%String:收费项目,amt1:%String:项目金额")
{
}

ClassMethod DHCINVPRTDetailExecute(ByRef qHandle As %Binary, sDate As %String, eDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((sDate="")||(eDate="")) quit $$$OK
	set sDate=##class(websys.Conversions).DateHtmlToLogical(sDate)
	set eDate=##class(websys.Conversions).DateHtmlToLogical(eDate)
    
    k ^||TMP("INVPRTZY",$j)

    f Date=sDate:1:eDate d
    .s PRTRowid=0
	.f  s PRTRowid=$o(^DHCINVPRTZY(0,"DATE",Date,PRTRowid)) q:(PRTRowid="")  d
	..s PRTData=$g(^DHCINVPRTZY(PRTRowid))
	..s PB=$p(PRTData,"^",5)
	..s insTypeDR=$p(PRTData,"^",9)     ;费别
	..q:(insTypeDR'=..#InAdmreasonCode)
	..s PRTAdm=$p(PRTData,"^",4)
	..s papmi=$p(PRTData,"^",18)
	..s ipno=$p(^PAPER(papmi,"PAT",1),"^",1)   ;登记号（ipno）
	..s name=$p(^PAPER(papmi,"ALL"),"^",1)   ;姓名（name）
	..s amount=$p(PRTData,"^",6)       ;总金额（amount）
	..s amount=$fn(amount,"",2)
	..s deposit=$p(PRTData,"^",22)     ;押金（deposit）
	..s deposit=$fn(deposit,"",2)
	..//支付方式
	..s paymSub=0
	..f  s paymSub=$O(^DHCINVPRTZY(PRTRowid,"P",paymSub)) q:(paymSub="")  d
	...s paymSubData=$g(^DHCINVPRTZY(PRTRowid,"P",paymSub))
	...s paymDR=$p(paymSubData,"^",1)
	...s paymCode=$p(^CT("CTPM",paymDR),"^",1)
	...q:($zcvt(paymCode,"U")'="ZP")
	...;收费项目（item1）
	...s PBO=0
	...f  s PBO=$o(^DHCPB(PB,"O",PBO)) q:(PBO="")  d
    ....s PBD=0
    ....f  s PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD)) q:(PBD="")  d
    .....s PBDTARIDR=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",3)
    .....s TARIPpatCate=$p(^DHCTARI(PBDTARIDR),"^",14)
	.....s TARICTARTICDR=$p(^DHCTarC("IC",TARIPpatCate),"^",3)
	.....s item=$p(^DHCTarC("TIC",TARICTARTICDR),"^",2)
	.....;项目金额（amt1）
	.....s amt=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",7)
	.....s ^||TMP("INVPRTZY",$j,item)=$g(^||TMP("INVPRTZY",$j,item))+amt

	s item=""
	f  s item=$o(^||TMP("INVPRTZY",$j,item)) q:(item="")  d
	.s item1=item
	.s amt1=$g(^||TMP("INVPRTZY",$j,item))
	.d OutputInvDetail

	quit $$$OK
OutputInvDetail
    set Data=$lb(ipno,name,insTypeDR,amount,deposit,item1,amt1)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
    quit
}

/// Creator:庄娜
/// CreateDate:2014-09-23
/// Description:已知某段时间，最终结算但未做财务结算的明细
/// Input:开始时间（stdate）、结束时间（enddate）
/// Output:登记号（ipno）、姓名（name）、总金额（amount）、押金（deposit）、收费项目（item1）、项目金额（amt1）
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCIPINVPrtzy","FinalSettlementDetail","63448","63450")  
Query FinalSettlementDetail(sDate As %String, eDate As %String) As websys.Query(ROWSPEC = "ipno:%String:登记号,name:%String:姓名,amount:%String:总金额,deposit:%String:押金,item1:%String:收费项目,amt1:%String:项目金额")
{
}

ClassMethod FinalSettlementDetailExecute(ByRef qHandle As %Binary, sDate As %String, eDate As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((sDate="")||(eDate="")) quit $$$OK
	
	set sDate=##class(websys.Conversions).DateHtmlToLogical(sDate)
	set eDate=##class(websys.Conversions).DateHtmlToLogical(eDate)

    k ^||TMP("FINALSETTLE",$j)

    f Date=sDate:1:eDate d
    .s PAADMRowID=""
	.f  s PAADMRowID=$o(^PAADMi("DischDate",Date,PAADMRowID)) q:(PAADMRowID="")  d
	..;财务结算标志
	..s PAADMBillFlag=$p(^PAADM(PAADMRowID),"^",45)
	..q:(PAADMBillFlag="Y")
	..s PRTPAPMIDR=$p(^PAADM(PAADMRowID),"^",1)
	..;登记号（ipno）
	..s ipno=$p(^PAPER(PRTPAPMIDR,"PAT",1),"^",1)
	..;姓名（name）
	..s name=$p(^PAPER(PRTPAPMIDR,"ALL"),"^",1)
	..;总金额
	..s PB=0, sum=0
	..f  s PB=$o(^DHCPB(0,"ADM",PAADMRowID,PB)) q:(PB="")  d
	...s PBPatInsTypeDR=$p(^DHCPB(PB),"^",4)
	...s ADMReason=$p(^PAC("ADMREA",PBPatInsTypeDR),"^",1) 
	...q:ADMReason'=..#InAdmreasonCode
	...s sum=sum+$p(^DHCPB(PB),"^",8)
	...;押金（deposit）
	...s prtrowid=0, prtpayamount=0
	...f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"adm",PAADMRowID,prtrowid))  q:(prtrowid="")  d
	....s prtpayamount=prtpayamount+$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
	...s deposit=prtpayamount
	...;收费项目（item1）
	...s PBO=0
	...f  s PBO=$o(^DHCPB(PB,"O",PBO)) q:(PBO="")  d
    ....s PBD=0
    ....f  s PBD=$o(^DHCPB(PB,"O",PBO,"D",PBD)) q:(PBD="")  d
    .....s PBDTARIDR=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",3)
    .....s TARIPpatCate=$p(^DHCTARI(PBDTARIDR),"^",14)
	.....s TARICTARTICDR=$p(^DHCTarC("IC",TARIPpatCate),"^",3)
	.....s item=$p(^DHCTarC("TIC",TARICTARTICDR),"^",2)
	.....;项目金额（amt1）
	.....s amt=$p(^DHCPB(PB,"O",PBO,"D",PBD),"^",7)
	.....s ^||TMP("FINALSETTLE",$j,item)=$g(^||TMP("FINALSETTLE",$j,item))+amt
	..;总金额
	..s amount=sum
	..s item=""
	..f  s item=$o(^||TMP("FINALSETTLE",$j,item)) q:(item="")  d
	...s item1=item
	...s amt1=$g(^||TMP("FINALSETTLE",$j,item))
	...d OutputRow3
    ..k ^||TMP("FINALSETTLE",$j)
	
    k ^||TMP("FINALSETTLE",$j)
    
	quit $$$OK
OutputRow3
    set Data=$lb(ipno,name,amount,deposit,item1,amt1)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
    quit
}

/// Creator: zhl
/// CreatDate: 2018-07-23
/// Description: 门诊临床科研医生站结算接口
/// Input: episodeIdStr: PA_Adm.RowId串
/// Return: 0:结算成功，<>0：结算失败
/// Debug: w ##class(web.DHCBillPilot).OPChargeForOrder("6748")
ClassMethod OPChargeForOrder(episodeIdStr As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	
	set userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",..#OPChargeUserCode,""))
	set defInsTypeDR=$o(^PAC("ADMREA",0,"Code",..#OutAdmReasonCode,""))
	set defPaymDR=$o(^CT("CTPM",0,"Code",..#PilotPayMode,""))
	quit:(+userId=0) -1_"^"_"操作员为空"
	quit:(+defInsTypeDR=0) -1_"^"_"费别为空"
	set userDeptDR=$p(^SSU("SSUSR",userId),"^",4)
	quit:(+userDeptDR="") -1_"^"_"操作员默认科室为空"
	set userGrupDR=$p(^SSU("SSUSR",userId),"^",5)
	quit:(+userGrupDR="") -1_"^"_"操作员默认安全组为空"
	set userHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(userDeptDR)
	
	set admStr=""
	set billOrdStr=""			//待结算的医嘱
	set unBillOrdStr=""         //不结算的医嘱
	set count=$l(episodeIdStr,"^")
	for i=1:1:count {
		set adm=$p(episodeIdStr,"^",i)
		continue:(+adm=0)
		set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
		set ord=+$o(^OEORD(0,"Adm",adm,0))
		continue:(ord=0)
		set admUnBillOrd=""
		set itm=0
		while($o(^OEORD(ord,"I",itm))) {
			set itm=$o(^OEORD(ord,"I",itm))
			continue:('$d(^OEORD(ord,"I",itm,1)))
			set oeitm=ord_"||"_itm
			set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
			continue:((" I P ")[(" "_billed_" "))
			set itemStatDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
			set itemStatCode=$s((+itemStatDR'=0):$p($g(^OEC("OSTAT",itemStatDR)),"^",1),1:"")
			continue:((" V E ")'[(" "_itemStatCode_" "))
			set pilotDR=$p($g(^OEORD(+ord,"I",itm,"DHC")),"^",10)
			if (+pilotDR=0) {
				set admUnBillOrd=$s((admUnBillOrd=""):oeitm,1:(admUnBillOrd_"^"_oeitm))
			}else {
				set insTypeDR=$p(^OEORD(ord,"I",itm,11),"^",18)
				if (insTypeDR'=defInsTypeDR) {
					set rtn=-103_"^"_"费别错误"
					quit
				}
				set billOrdStr=$s((billOrdStr=""):oeitm,1:(billOrdStr_"^"_oeitm))
			}
		}
		quit:(+rtn)
		set unBillOrdStr=unBillOrdStr_$c(2)_adm_$c(2)_admUnBillOrd_$c(2)_adm_$c(2)
	}
	quit:(+rtn) rtn
	
	set payAmt=##class(web.udhcOPBillIF).GetOEORDSum(billOrdStr)   //计算待缴费医嘱金额
	if (+payAmt'=0) {
		set chgMode=..GetPilotOrdChgMode(userHospDR)     //临床药理医嘱的结算模式(1:按折扣记账系数全额记账，2:按“科研记账”支付方式结算)
		quit:(+chgMode'=2) -1_"^"_"金额不为0，不能结算"
	}
	
	ts
	
	set expStr=userGrupDR_"^"_userDeptDR_"^^N^F^0^0^0^^"
	set rtnValue=##class(web.DHCOPINVCons).OPBillCharge(admStr, userId, unBillOrdStr, defInsTypeDR, payAmt, "", userGrupDR, 0, "", "", expStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set prtRowIdStr=$p(rtnValue,"^",2,*)
	
	set payInfo=defPaymDR_"^^^^^^^"_payAmt_"^^^"
	set rtnValue=##class(web.DHCBillConsIF).CompleteCharge(0, userId, defInsTypeDR, prtRowIdStr, 0, "", expStr, payInfo)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: zhl
/// CreatDate: 2018-07-23
/// Description: 门诊临床科研医生站退费接口
/// Input: oeitmStr: OE_OrdItem.RowId串
/// Return: 0:退费成功，非0：退费失败    rtn_"@"_未退费医嘱串_"@"_已退费医嘱串
/// Debug: w ##class(web.DHCBillPilot).OPRefundForOrder("10974691||6")
ClassMethod OPRefundForOrder(oeitmStr As %String) As %String
{
	set $zt="ERROR"
	
	set unRefOrd=""
	set refOrd=""
	set rtn=0
	kill ^||TMP($j)
	set userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",..#OPChargeUserCode,""))
	set defInsTypeDR=$o(^PAC("ADMREA",0,"Code",..#OutAdmReasonCode,""))
	set defPaymDR=$o(^CT("CTPM",0,"Code",..#PilotPayMode,""))
	quit:(+userId=0) -1_"^"_"操作员为空"
	quit:(+defInsTypeDR=0) -1_"^"_"费别为空"
	
	set userGrupDR=$p(^SSU("SSUSR",userId),"^",5)
	quit:(+userGrupDR=0) -1_"^"_"操作员默认安全组为空"
	set userDeptDR=$p(^SSU("SSUSR",userId),"^",4)
	quit:(+userDeptDR=0) -1_"^"_"操作员默认科室为空"
	
	set len=$l(oeitmStr,"^")
	for i=1:1:len {
		set oeitm=$p(oeitmStr,"^",i)
		continue:(+oeitm=0)
		set ord=$p(oeitm,"||",1)
		set sub=$p(oeitm,"||",2)
		continue:('$d(^OEORD(+ord,"I",sub,1)))
		set ordInsTypeDR=$p(^OEORD(+ord,"I",sub,11),"^",18)
		if (ordInsTypeDR'=defInsTypeDR) {
			set rtn=-1_"^"_"医嘱费别不正确"
			quit
		}
		set ordBilled=$p(^OEORD(+ord,"I",sub,3),"^",5)
		if (ordBilled'="P") {
			set rtn=-1_"^"_"医嘱未结算"
			quit
		}
		set refinvdr=""
		set pb=""
		while($o(^DHCPBi(0,"OEORI",oeitm,pb),-1)) {
			set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb),-1)
			set billConInvDR=$o(^DHCBCI(0,"Bill",pb,""))
			continue:(+billConInvDR=0)
			set invdr=$p(^DHCBCI(billConInvDR),"^",1)
			set prtFlag=$p(^DHCINVPRT(+invdr),"^",8)
			if (prtFlag="N") {
				set refinvdr=invdr
				quit
			}
		}
		if (+refinvdr=0) {
			set rtn=-1_"^"_"医嘱未对应有效的结算记录"
			quit
		}
		set ^||TMP($j,refinvdr,oeitm)=""
	}
	quit:(+rtn) rtn
		
	set refinv=0
	while($o(^||TMP($j,refinv))) {
		set refinv=$o(^||TMP($j,refinv))
		set stopOrdStr=""
		set oeitm=""
		while($o(^||TMP($j,refinv,oeitm))) {
			set oeitm=$o(^||TMP($j,refinv,oeitm))
			set stopOrdStr=$s((stopOrdStr=""):oeitm,1:(stopOrdStr_"^"_oeitm))
		}
		set prtData=$g(^DHCINVPRT(refinv))
		set reportsDR=$p(prtData,"^",6)
		set userDR=$p(prtData,"^",21)
		set refundFlag=$s(((userDR=userId)&&(+reportsDR=0)):"A",1:"S")
		set repayAmt=0      //重收金额
		set rebillFlag=0
		set billConInvDR=0
		while($o(^DHCBCI(0,"INV",refinv,billConInvDR))) {
			set billConInvDR=$o(^DHCBCI(0,"INV",refinv,billConInvDR))
			set pb=$p(^DHCBCI(billConInvDR),"^",2)
			continue:(+pb=0)
			set pbo=0
			while($o(^DHCPB(+pb,"O",pbo))) {
				set pbo=$o(^DHCPB(+pb,"O",pbo))
				set pboData=$g(^DHCPB(+pb,"O",pbo))
				continue:(pboData="")
				set oeori=$p(pboData,"^",4)
				set pboPatShare=$p(pboData,"^",11)
				if ("^"_stopOrdStr_"^")'[("^"_oeori_"^") {
					set repayAmt=$i(repayAmt, pboPatShare)
					set rebillFlag=1
				}
			}
		}
		
		ts
		
		set rtnValue=##class(web.udhcOPRefEditIF).RefundReceipt(refinv, userId, refundFlag, stopOrdStr, repayAmt, userGrupDR, rebillFlag, userDeptDR, defPaymDR, defInsTypeDR, "^")
		set rtn=$p(rtnValue,"^",1)
		set newPrtRowId=$p(rtnValue,"^",2)
		if (+rtn) {
			set unRefOrd=$s((unRefOrd=""):stopOrdStr,1:(unRefOrd_"^"_stopOrdStr))
		}else {
			set refOrd=$s((refOrd=""):stopOrdStr,1:(refOrd_"^"_stopOrdStr))
			if (newPrtRowId'="") {
				set expStr=userGrupDR_"^"_userDeptDR_"^^^^^^^"_defInsTypeDR
				set payInfo=defPaymDR_"^^^^^^^"_repayAmt_"^^^"
				set rtn=##class(web.DHCBillConsIF).CompleteCharge(0, userId, defInsTypeDR, newPrtRowId, 1, refinv, expStr, payInfo)
			}
		}
		if (+rtn) {
			tro
			continue
		}
		if ($tl>0) tc
	}
	
	kill ^||TMP($j)
	
	quit rtn_"@"_unRefOrd_"@"_refOrd

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2023-01-11
/// Description: 获取审核医嘱时自动结算临床药理医嘱模式
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCBillPilot).GetPilotOrdChgMode(2)
ClassMethod GetPilotOrdChgMode(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPPilot.SHYZSZDJSMS", "", "", hospId)
	quit ##class(%DynamicObject).%FromJSON(jsonStr).value
}

}
