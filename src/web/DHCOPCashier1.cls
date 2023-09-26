Import SQLUser

Class web.DHCOPCashier1 Extends BILL.COM.Abstract
{

/// 版本为1  合肥
ClassMethod GetAdmInsCost(Adm As %String, InsType As %String, OrdItemStr As %String, URecLocStr As %String) As %String
{
	set ToBillSum=0
	set ToBillPatSum=0
	set ToBillDiscSum=0
	set ToBillInsSum=0
	//modify 2011-02-19 增加就诊类型取值
	set PatType=$p(^PAADM(+Adm,1),"^",6)
	//取Adm保存的挂号优惠类别
    set RCDRowID=$p($g(^PAADM(Adm,"DHC")),"^",25)
    set AdmDep=$p(^PAADM(Adm),"^",4)
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDep)
	
	set Ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(Adm)
	quit:(Ord="") $fn(ToBillSum,"",4)_"^"_$fn(ToBillDiscSum,"",4)_"^"_$fn(ToBillInsSum,"",4)_"^"_$fn(ToBillPatSum,"",4)
	
	set Itm=0
	while($o(^OEORD(Ord,"I",Itm))) {
		set Itm=$o(^OEORD(Ord,"I",Itm))
		continue:('$d(^OEORD(Ord,"I",Itm,1)))
		set OEORI=Ord_"||"_Itm
		continue:(##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(OEORI)=1)  //自备药医嘱退出
		continue:(##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(OEORI)=1)  ;将转出的医嘱退出
		set billed=$p($g(^OEORD(Ord,"I",Itm,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		set RecDepDR=$p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
		continue:((URecLocStr'="")&&(URecLocStr'[("^"_RecDepDR_"^")))
		set StatDR=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)
		set StatCode=$s((StatDR'=""):$p($g(^OEC("OSTAT",StatDR)),"^",1),1:"")
		continue:(" V E "'[(" "_StatCode_" "))
		set OrdInsType=$p($g(^OEORD(Ord,"I",Itm,11)),"^",18)
		set JfCF=##class(web.DHCBillCommon).GetTarParaId(HospId)
		if (OrdInsType="")&&(JfCF'="") set OrdInsType=$P(^DHCTarC("CF",JfCF),"^",3)
		set OrdInsType=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEORI, InsType, HospId)
		continue:(InsType'="")&&(OrdInsType'=InsType)
		continue:((OrdItemStr'="")&&(OrdItemStr[("^"_OEORI_"^")))
		set mySkinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(OEORI)
		continue:(mySkinFlag="Y")				//限制医嘱不计费
		set OEORICost=..GetOrderItemDetail(PatType, InsType, OEORI, RCDRowID)
		set OEORISum=$p(OEORICost,"^",1)
		set OEORIDiscSum=$p(OEORICost,"^",2)
		set OEORIInsSum=$p(OEORICost,"^",3)
		set OEORIPatSum=$p(OEORICost,"^",4)
		set ToBillSum=ToBillSum+OEORISum
		set ToBillInsSum=ToBillInsSum+OEORIInsSum
		set ToBillDiscSum=ToBillDiscSum+OEORIDiscSum
		set ToBillPatSum=ToBillPatSum+OEORIPatSum
	}
	
	quit $fn(ToBillSum,"",2)_"^"_$fn(ToBillDiscSum,"",2)_"^"_$fn(ToBillInsSum,"",2)_"^"_$fn(ToBillPatSum,"",2)
}

ClassMethod GetOrderItemDetail(PatType As %String, InsType As %String, OEORI As %String, RCDRowID As %String) As %String
{
	set Sum=0
	set PatSum=0
	set DiscSum=0
	set InsSum=0
	set Ord=+OEORI
	set Itm=$p(OEORI,"||",2)
	set ARCIM=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	quit:(ARCIM="") $fn(Sum,"",2)_"^"_$fn(DiscSum,"",2)_"^"_$fn(InsSum,"",2)_"^"_$fn(PatSum,"",2)
	
	set ItemCatDR=$p(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1),"^",10)
	set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	set OEPrice=$p($g(^OEORD(Ord,"I",Itm,3)),"^",25)
	set InsType=$p($g(^OEORD(Ord,"I",Itm,11)),"^",18)

	//yyx 2010-10-08 根据医院取价格
	set AdmRowID=$p(^OEORD(Ord),"^",1)
	set AdmDep=$p(^PAADM(AdmRowID),"^",4)
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDep)
	
	//2020-11-16 ZhYW 取门诊系统参数配置
	set ParCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(HospId)
	set ZeroPriceChargeFlag=$p(ParCfgInfo,"^",23)
	
	set PackQty=##class(BILL.OP.COM.Method).GetOrdEffectivePackQty(OEORI)
	set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ARCIM, OEORI)
	
	set oeore=""
	set regLoc=""
	set itmPriceExpStr=RCDRowID_"^"_OEORI_"^"_oeore_"^"_AdmRowID_"^"_regLoc_"^"_""
	set retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, InsType, ARCIM, +$h, "", "", "", OEPrice, HospId, itmPriceExpStr)
	set Price=$p(retPrice,"^",1)
	set DiscPrice=$p(retPrice,"^",2)
	set InsPrice=$p(retPrice,"^",3)
	set PatPrice=$p(retPrice,"^",4)
	set Sum=Price*ConFac*PackQty
	set InsSum=InsPrice*ConFac*PackQty
	set DiscSum=DiscPrice*ConFac*PackQty
	set Sum=##class(web.UDHCJFBILL).round(Sum)
	set InsSum=##class(web.UDHCJFBILL).round(InsSum)
	set DiscSum=##class(web.UDHCJFBILL).round(DiscSum)
	set PatSum=Sum-DiscSum-InsSum
	if (+Price=0) {
		set isZeroPriceOrd=##class(BILL.OP.COM.Method).IsZeroPriceOrd(OEORI, HospId)
		if ((+ZeroPriceChargeFlag=0)&&(isZeroPriceOrd=1)) {
			do ##class(web.DHCOPCashier1).UpdateOeoriBilled(OEORI, "P")
		}
	}
	
	quit $fn(Sum,"",2)_"^"_$fn(DiscSum,"",2)_"^"_$fn(InsSum,"",2)_"^"_$fn(PatSum,"",2)
}

/// w ##class(web.DHCOPCashier1).GetToDayAdmStr(72)
ClassMethod GetToDayAdmStr(PatDr As %String) As %String
{
	s AdmStr=""
	;24小时之内的号码
	;2006-07-01  改为72小时有效
	s myCurDT=+$h
	s myCurDT=myCurDT+($p($h,",",2)/86400)
	
	s Adm="" 
	f  s Adm=$o(^PAPERdr(PatDr,"ADM","O",Adm)) q:(Adm="")  d
	.s AdmDate=$p($g(^PAADM(Adm)),"^",6)		;PAADM_AdmDate
	.s myAdmTime=$p($g(^PAADM(Adm)),"^",7)		;PAADM_AdmTime
	.s myAdmTime=myAdmTime/86400
	.;s myMi=86400
	.s myAdmDT=AdmDate+myAdmTime
	.s myDTRange=$fn(myCurDT-myAdmDT,"",6)
	.q:((+myDTRange<0)||(+myDTRange>3))
	.;q:AdmDate'=+$H
	.;q:(+AdmDate<(+$H-90))
	.s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
	.q:(VisitStatus="C")
	.s CrUserDR=$p($g(^PAADM(Adm)),"^",43)
	.q:(CrUserDR="")
	.i (AdmStr="") s AdmStr=Adm
	.e  s AdmStr=AdmStr_"^"_Adm
	
	q AdmStr
}

/// 更新医嘱的计费状态
/// Debug: w ##class(web.DHCOPCashier1).UpdateOeoriBilled()
ClassMethod UpdateOeoriBilled(OEORI As %String, Billed As %String) As %String
{
	&SQL(
		UPDATE OE_OrdItem
		SET OEORI_Billed = :Billed
		WHERE OEORI_RowId = :OEORI
	)
	quit SQLCODE
}

}
