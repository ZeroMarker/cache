Class web.DHCIPBillPayControl Extends %RegisteredObject
{

/// function:判断是否为出院结算还是中途结算，如果病人未做最终结算则判断账单的医嘱否则判断就诊的
/// w ##class(web.DHCIPBillPayControl).GetNotBillOrd("1333","1931")
ClassMethod GetNotBillOrd(Adm, BillNo)
{
	set ^TMP("GetNotBillOrd")=$lb(Adm, BillNo)
	set RetInfo="^^^^^"
	set VisitStatus=$p(^PAADM(Adm),"^",20)
	if (VisitStatus'="D") {   ;未出院时则判断账单的数据就可以了
		set RetInfo=..GetNotBillPBOrd(Adm, BillNo)
	}else {
		set RetInfo=..GetNotBillAdmOrd(Adm, BillNo)   ;出院了，判断这次就诊的未结算的
	}
	
	quit RetInfo
}

/// Creator: yyx
/// CreateDate: 2011-04-21
/// Description: 判断病人是否有未记账的费用,并且判断药品费用是否收取正确
/// Return: NotBillNum<>0时，表示有未记账或状态发生变化未计费的;
///          DispNum<>0表示药品为发药后计费的判断是否计费数量与发药数量是否一致
///          BabyNum :^1,表示婴儿有未计费医嘱不能结算,^2<>0表示婴儿有计费数量与发药数量不一致的药品
///          DisPTCSum:有需要发放的药品，DisPTCInfo需要发放的药品的信息
/// Debug: w ##class(web.DHCIPBillPayControl).GetNotBillAdmOrd(3, 4098)
ClassMethod GetNotBillAdmOrd(Adm, BillNo)
{
	s AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	s OrdStr="", NotBillNum=0, DispNum=0, NotBillOrdStr="", DisPTCInfo=""
	s DispNotEqualInfo=""
	s DisPTCSum=0
	s OEORD=$o(^OEORD(0,"Adm",+Adm,0))
	q:(OEORD="") 0_"^"_0_"^"_0_"^"_0
	
	s OrdSub=0
	f  s OrdSub=$o(^OEORD(OEORD,"I",OrdSub)) q:(OrdSub="")  d
	.s ExecSub=0
	.f  s ExecSub=$o(^OEORD(OEORD,"I",OrdSub,"X",ExecSub)) q:(ExecSub="")  d
	..s OEORERowID=OEORD_"||"_OrdSub_"||"_ExecSub
	..s ArcimRowID=$p($g(^OEORD(OEORD,"I",OrdSub,1)),"^",2)
	..//判断药品的计费和发药数量是否一致
	..s ItemCat=$p($g(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1)),"^",10)          ;医嘱子类
	..s OrdCateType=$p($g(^ARC("IC",ItemCat)),"^",7)                      ;医嘱类型
	..s OEOrdRowID=OEORD_"||"_OrdSub
	..s PriorID=$p(^OEORD(OEORD,"I",OrdSub,1),"^",8)
	..s PriorCode=$s((PriorID'=""):$p(^OECPR(PriorID),"^",1),1:"")
	..q:(PriorCode["OM")
	..s CP=##class(BILL.IP.COM.Method).GetBillPoint(OEOrdRowID)
	..i ((CP="CR")&&(OrdCateType="R")) d
	...s DispTCInfo=..GetTCDsp(OEOrdRowID, OEORERowID)    //取未发放的药品的数量
	...s DisPTCQty=$p(DispTCInfo,"^",1)
	...s DisPTCSum=DisPTCSum+DisPTCQty
	...i (+DisPTCQty'=0) d
	....i (DisPTCInfo="") s DisPTCInfo="未发药或部分发药医嘱rowid:"_OEOrdRowID
	....e  s DisPTCInfo=DisPTCInfo_","_OEOrdRowID
	..i ((CP="CR")&&(OrdCateType="R")) d
	...s DisFlag=..GetOrdDisp(OEOrdRowID, OEORERowID)
	...i (DisFlag="N") d
	....s DispNum=DispNum+1
	....i (DispNotEqualInfo="") s DispNotEqualInfo="发药数量与计费数量不一致医嘱rowid:"_"%"_OEOrdRowID
	....e  s DispNotEqualInfo=DispNotEqualInfo_","_OEOrdRowID
	..//判断是否有未计费或状态发生变化的
	..s Billed=$p(^OEORD(OEORD,"I",OrdSub,"X",ExecSub),"^",6)
	..q:(Billed'="TB")
	..s NotBillNum=NotBillNum+1
	..s OrdStr=OrdStr_"^"_OEORD_"||"_OrdSub
	..i (NotBillOrdStr="") s NotBillOrdStr="未计费医嘱rowid:"_OEORD_"||"_OrdSub
	..e  s NotBillOrdStr=NotBillOrdStr_","_OEORD_"||"_OrdSub 
	
	i (+NotBillNum'=0) s NotBillNum=NotBillNum_","_NotBillOrdStr
	i (+DispNum'=0) s DispNum=DispNum_","_DispNotEqualInfo
	i (+DisPTCSum'=0) s DisPTCSum=DisPTCSum_","_DisPTCInfo
	
	q NotBillNum_"^"_DispNum_"^"_DisPTCSum
}

/// Creator:yyx
/// CreateDate:2011-04-21
/// Function:判断要结算的账单是否有未记账的费用,并且判断药品费用是否收取正确
/// Output  :NotBillNum<>0时，表示有未记账或状态发生变化未计费的;
///          DispNum<>0表示药品为发药后计费的判断是否计费数量与发药数量是否一致
///          BabyNum :^1,表示婴儿有未计费医嘱不能结算,^2<>0表示婴儿有计费数量与发药数量不一致的药品
///          DisPTCSum:有需要发放的药品，DisPTCInfo需要发放的药品的信息
/// w ##class(web.DHCIPBillPayControl).GetNotBillPBOrd(2684, 5512)
ClassMethod GetNotBillPBOrd(Adm, BillNo)
{
	s AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	s NotBillOrdStr="",NotBillNum=0,DispNum=0,BabayNum="0^0",DisPTCInfo="",DispNotEqualInfo=""
	s NegativeNumStr="",PBNegativeNum=0
	s DisPTCSum=0
	
	s OEORD=$o(^OEORD(0,"Adm",+Adm,0))
	
	s PBOSub=0
	f  s PBOSub=$o(^DHCPB(BillNo,"O",PBOSub)) q:(PBOSub="")  d
	.s PBOData=$g(^DHCPB(BillNo,"O",PBOSub))
	.q:(PBOData="")
	.s OEOrdRowID=$p(PBOData,"^",4)
	.s AArcimRowid=$p(PBOData,"^",3)
	.s OEOrdExecRowID=$p(PBOData,"^",20)    //医嘱执行记录
	.s PBOAmt=$p(PBOData,"^",8)
	.i (+PBOAmt<0) d
	..q:(##class(web.UDHCJFIntBill).JudgeArcIsorNot(AArcimRowid, AdmHospDR)=1)   //过滤自定义价格医嘱
	..s PBNegativeNum=PBNegativeNum+1
	..i (NegativeNumStr="") s NegativeNumStr="负数医嘱rowid:"_OEOrdRowID
	..e  s NegativeNumStr=NegativeNumStr_"%"_OEOrdRowID
	.s OEORD=+OEOrdRowID, OrdSub=$p(OEOrdRowID,"||",2)
	.s ExecSub=$p(OEOrdExecRowID,"||",3)
	.s ArcimRowID=$p($g(^OEORD(OEORD,"I",OrdSub,1)),"^",2)
	.;判断药品的计费和发药数量是否一致
	.s ItemCat=$p($g(^ARCIM(+ArcimRowID,$p(ArcimRowID,"||",2),1)),"^",10)          ;医嘱子类
	.s OrdCateType=$p($g(^ARC("IC",ItemCat)),"^",7)                      ;医嘱类型
	.s PriorID=$p(^OEORD(OEORD,"I",OrdSub,1),"^",8)
	.s PriorCode=$s((PriorID'=""):$p(^OECPR(PriorID),"^",1),1:"")
	.q:(PriorCode["OM")
	.s CP=##class(BILL.IP.COM.Method).GetBillPoint(OEOrdRowID)
	.i ((CP="CR")&&(OrdCateType="R")) d
	..s DispTCInfo=..GetTCDsp(OEOrdRowID, OEOrdExecRowID)    ;取未发放的药品的数量
	..s DisPTCQty=$p(DispTCInfo,"^",1)
	..s DisPTCSum=DisPTCSum+DisPTCQty
	..i (+DisPTCQty'=0) d
	...i (DisPTCInfo="") s DisPTCInfo="未发药或部分发药医嘱rowid:"_OEOrdRowID
	...e  s DisPTCInfo=DisPTCInfo_"%"_OEOrdRowID
	.i ((CP="CR")&&(OrdCateType="R")) d
	..s DisFlag=..GetOrdDisp(OEOrdRowID, OEOrdExecRowID)
	..i (DisFlag="N") d
	...s DispNum=DispNum+1
	...i (DispNotEqualInfo="") s DispNotEqualInfo="发药数量与计费数量不一致医嘱rowid:"_"%"_OEOrdRowID
	...e  s DispNotEqualInfo=DispNotEqualInfo_"%"_OEOrdRowID
	.//判断是否有未计费或状态发生变化的
	.s Billed=$p(^OEORD(OEORD,"I",OrdSub,"X",ExecSub),"^",6)
	.q:(" TB I "'[(" "_Billed_" "))
	.s NotBillNum=NotBillNum+1
	.i (NotBillOrdStr="") s NotBillOrdStr="需要计费医嘱rowid:"_OEORD_"||"_OrdSub
	.e  s NotBillOrdStr=NotBillOrdStr_"%"_OEORD_"||"_OrdSub

	//未计费，计费错误，未发放
    i (+NotBillNum'=0) s NotBillNum=NotBillNum_","_NotBillOrdStr
	i (+DispNum'=0) s DispNum=DispNum_","_DispNotEqualInfo
	i (+DisPTCSum'=0) s DisPTCSum=DisPTCSum_","_DisPTCInfo
	i (+PBNegativeNum'=0)  s NegativeNumStr=PBNegativeNum_","_NegativeNumStr
	
	q NotBillNum_"^"_DispNum_"^"_DisPTCSum_"^"_NegativeNumStr
}

/// Creator: yyx
/// CreateDate: 2011-04-21
/// Function: 判断医嘱药房发药的和计费的数量是否一致，如果不一致则记录到临时global，并且不允许结算
ClassMethod GetOrdDisp(OEOrdRowID, OEOrdExecRowID)
{
	s DisQty=0,PBOQty=0,EqualFlag="Y",PBOQtyAll=0
	s dsp=0 
	f  s dsp=$O(^DHCOEDISQTY(0,"OEORE",OEOrdExecRowID,dsp)) q:(dsp="")  d
	.s disp=^DHCOEDISQTY(dsp)
	.s dspstatus=$P(disp,"^",7)
	.q:((dspstatus'="R")&&(dspstatus'="C"))
	.s dspqty=+$P(disp,"^",11)
	.i dspstatus="R" s dspqty=0-dspqty
	.s DisQty=DisQty+dspqty
	
	s PBRowID=0
	f  s PBRowID=$o(^DHCPB(0,"OEEXC",OEOrdExecRowID,PBRowID)) q:(PBRowID="")  d
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCPB(0,"OEEXC",OEOrdExecRowID,PBRowID,ChildSub)) q:(ChildSub="")  d
	..s BillQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",5)
	..s RefundQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",6)
	..s PBOQty=BillQty+RefundQty
	..s PBOQtyAll=PBOQtyAll+PBOQty
	
	i (DisQty'=PBOQtyAll) d
	.s EqualFlag="N"
	
	q EqualFlag
}

/// Creator:yyx
/// CreateDate:2011-04-21
/// Function  :判断婴儿的费用是否有未计费的，传入母亲的就诊rowid
ClassMethod GetBabyNotBillOrd(MotherAdm, BillNo)
{
	s RetNum="0^0^0^0"
	s BabyAdmRowID=0
	f  s BabyAdmRowID=$o(^PAADMi("Mother",MotherAdm,BabyAdmRowID)) q:(BabyAdmRowID="")  d
	.s RetNum=..GetNotBillAdmOrd(BabyAdmRowID, BillNo)
	
	q RetNum
}

/// Descript：	取某医嘱剩余未发数量(计费组使用,中途结算时未发完的不结算)(已经停止的、自备药过滤掉返回值是0)
/// Creater：	zhouyg
/// CreateDate:	2012-01-12
/// Input:		医嘱RowID
/// Retrun:		剩余未发数量(基本单位数量^基本单位描述),没有则返回空值""
ClassMethod GetTCDsp(oeori, OEOrdExecRowID As %String) As %String
{
	
	s retQty=""
	q:(oeori="") retQty
	s OrdID=$p(oeori,"||",1)
	s OrdSub=$p(oeori,"||",2)
	q:(OrdID="")!(OrdSub="") retQty
	//判断医嘱状态(医嘱核实、未核实、停止状态)
	s oestID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",13)
	q:oestID="" retQty
	s oestflag=$p($g(^OEC("OSTAT",oestID)),"^",1)
	q:(" V E "'[(" "_oestflag_" ")) retQty
 	//判断医嘱优先级(是否自备药)
 	s PriorID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",8)
 	q:(PriorID="") retQty
 	s priorCode=$p($g(^OECPR(PriorID)),"^",1) ;医嘱优先级代码 
 	q:(priorCode["OM") retQty
 	s ArcimID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2)
 	s ArcimSub=$p(ArcimID,"||",1)
 	q:(ArcimSub="") retQty
 	s InciID=$o(^INCI(0,"ARCIM_DR",ArcimSub,""))
 	q:InciID="" retQty
 	s bUomID=$p(^INCI(InciID,1),"^",10)
 	q:bUomID="" retQty
 	s bUomDesc=$p($g(^CT("UOM",bUomID)),"^",2)
 	s dspID=""
 	f  s dspID=$o(^DHCOEDISQTY(0,"OEORE",OEOrdExecRowID,dspID))  q:(dspID="")  d
 	.q:$p(^DHCOEDISQTY(dspID),"^",7)'="TC"  //状态不是"TC"的不考虑
 	.s qty=$p(^DHCOEDISQTY(dspID),"^",11)
 	.s retQty=retQty+qty
	q:(retQty="") retQty
	i $g(DisPTCInfo)="" s DisPTCInfo=OEOrdExecRowID_"("_retQty_bUomDesc_")"
	e  s DisPTCInfo=DisPTCInfo_"&"_OEOrdExecRowID_"("_retQty_bUomDesc_")"
	
	q retQty   ;_"^"_bUomDesc
}

/// Descript：	取某医嘱剩余未发数量(计费组使用,中途结算时未发完的不结算)(已经停止的、自备药过滤掉返回值是0)
/// Creater：	zhouyg
/// CreateDate:	2012-01-12
/// Input:		医嘱RowID
/// Retrun:		剩余未发数量(基本单位数量^基本单位描述),没有则返回空值""
ClassMethod GetOEORITCDsp(oeori As %String) As %String
{
	
	s retQty=""
	q:oeori="" retQty
	s OrdID=$p(oeori,"||",1)
	s OrdSub=$p(oeori,"||",2)
	q:(OrdID="")!(OrdSub="") retQty
	//判断医嘱状态(医嘱核实、未核实、停止状态)
	s oestID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",13)
	q:oestID="" retQty
	s oestflag=$p($g(^OEC("OSTAT",oestID)),"^",1)
 	q:(oestflag'="V")&(oestflag'="E") retQty
 	//判断医嘱优先级(是否自备药)
 	s PriorID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",8)
 	q:PriorID="" retQty
 	s priorCode=$p($g(^OECPR(PriorID)),"^",1) ;医嘱优先级代码 
 	q:priorCode="" retQty
 	q:$zcvt(priorCode,"U")["OM" retQty
 	s ArcimID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2)
 	s ArcimSub=$p(ArcimID,"||",1)
 	q:ArcimSub="" retQty
 	s InciID=$o(^INCI(0,"ARCIM_DR",ArcimSub,""))
 	q:InciID="" retQty
 	s bUomID=$p(^INCI(InciID,1),"^",10)
 	q:bUomID="" retQty
 	s bUomDesc=$p($g(^CT("UOM",bUomID)),"^",2)
 	s dspID=""
 	f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",oeori,dspID))  q:dspID=""  d
 	.q:$p(^DHCOEDISQTY(dspID),"^",7)'="TC"  //状态不是"TC"的不考虑
 	.s qty=$p(^DHCOEDISQTY(dspID),"^",11)
 	.s retQty=retQty+qty
	q:retQty="" retQty
	i $g(DisPTCInfo)="" s DisPTCInfo=oeori_"("_retQty_bUomDesc_")"
	e  s DisPTCInfo=DisPTCInfo_"&"_oeori_"("_retQty_bUomDesc_")"
	q retQty   ;_"^"_bUomDesc
}

}
