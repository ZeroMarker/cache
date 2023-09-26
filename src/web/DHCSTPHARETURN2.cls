Include webimport

IncludeGenerator webimport

Class web.DHCSTPHARETURN2 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:zhangdongmei
/// CreatDate:2012-03-09
/// Descriprtion:查询退药申请单信息（按申请单退药界面用,申请单查询界面用）
/// Table:DHC_PhaRetRequest
/// Input:开始日期,截止日期,申请退药科室（病区科室，或特殊科室）
/// ,药房,申请单状态,登记号,医生科室标志（暂时没用）,库存项Rowid,已退费未退药标志
/// Output:npid 进程号
/// Others:save the data into temporary global
/// w ##class(web.DHCSTPHARETURN2).GetRetReqByDateDept(64250,64280,31,98,"","","","")
ClassMethod GetRetReqByDateDept(DateFrom, DateTo, DeptId, RecLocId, RequestStatus, PatRegNo, DoctorFlag, inci As %String = "", AdvRefundFlag As %String = "", RefuseFlag = "", otherStr = "") As %String
{
 n (DateFrom, DateTo, DeptId, RecLocId,RequestStatus,PatRegNo,DoctorFlag,inci,AdvRefundFlag,RefuseFlag,otherStr)
 s pid=..NewPid()
 k ^TMP("DHCST",$this,"RETREQ",pid)
 q:DateFrom="" ""
 q:DateTo="" ""
 s pPatName = $p(otherStr, ",", 1)	// 患者姓名
 s pBedNo = $p(otherStr, ",", 2)	// 患者床号
 s stat="P"
 s n=0
 s RecLocRowId=""
 f  s RecLocRowId=$o(^RETRQ(0,"RECLOC",RecLocRowId)) q:RecLocRowId=""  d
 .q:(RecLocId'="")&&(RecLocId'=RecLocRowId)
 .f Date=DateFrom:1:DateTo  d
 ..s Retrq=""
 ..f  s Retrq=$o(^RETRQ(0,"RECLOC",RecLocRowId,Date,Retrq))  q:Retrq=""  d
 ...s ReqLoc=$p(^RETRQ(Retrq),"^",7)
 ...s WardLoc=$p(^RETRQ(Retrq),"^",21)
 ...s ReqConfig=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_ReqWard")
 ...;i ReqConfig'=1 q:(DeptId'=WardLoc)&(DeptId'="")      //退所有,按患者所在科室过滤
 ...;i reqconfig=1  q:(deptdr'=ordlocrowid)&(deptdr'="")  //只能退本病区,按患者开单科室过滤
 ...q:(DeptId'="")&(DeptId'=ReqLoc)    ;按申请科室过滤
 ...s WardDesc=##class(PHA.COM.Data.Base).LocDesc(ReqLoc)	//zhouyg 20130701 显示特殊科室或者病区，原来特殊科室的也显示为病区了
 ...i $f(WardDesc,"-") s WardDesc=$p(WardDesc,"-",2)
 ...s Status=$p(^RETRQ(Retrq),"^",14)
 ...q:(RefuseFlag = "Y")&&(..IsReqHasStatus(Retrq, "Refuse") '= "Y")
 ...q:(RefuseFlag = "N")&&(Status = "Refuse")
 ...s ReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date)
 ...s ReqNo=$p(^RETRQ(Retrq),"^",1)
 ...s ReqUserId=$p(^RETRQ(Retrq),"^",15)
 ...s ReqUser=##class(PHA.COM.Data.Base).UserName(ReqUserId)
 ...s PapmiDr=$p(^RETRQ(Retrq),"^",3)
 ...s PatNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
 ...q:(PatRegNo'="")&(PatNo'=PatRegNo)
 ...s patName = $p(^PAPER(PapmiDr, "ALL"), "^", 1)
 ...q:(pPatName '= "")&&(pPatName '= patName)
 ...s bedNo = ""
 ...s bedId=$p(^RETRQ(Retrq),"^",8)
 ...s:+bedId'=0 bedNo=$p(^PAWARD(+bedId,"BED",$p(bedId,"||",2)),"^",1)
 ...q:(pBedNo '= "")&&(pBedNo '= bedNo)		// 暂时做全匹配判断，因为做模糊匹配就不能做到精准查询
 ...q:(inci'="")&(..CheckReqItem(ReqNo,inci)=0)
 ...s statusflag=..GetRetrqStatus(ReqNo) ;过滤已退申请单
 ...s finished = ##class(web.DHCINPHA.Request).IsRequestFinished(Retrq)
 ...q:(RefuseFlag = "N")&&(finished="Y")
 ...s status=""	
 ...s patinfo=""
 ...s RefundStatus=..GetReqRefundStatus(ReqNo)
 ...
 ...i ((RefundStatus[##class(PHA.COM.Base).Get("已退费"))||((RefundStatus[##class(PHA.COM.Base).Get("部分退费"))))&&(statusflag'=0) d
 ....s status=##class(PHA.COM.Base).Get("已退费未退药")
 ...q:(AdvRefundFlag="Y")&&(status'[##class(PHA.COM.Base).Get("已退费未退药"))
 ...s n=n+1	
 ...s ^TMP("DHCST",$this,"RETREQ",pid,n)=ReqNo_"^"_ReqDate_"^"_WardDesc_"^"_$g(ReqUser)_"^"_status_"^"_patinfo_"^"_RefundStatus_"^"_bedNo_"^"_PatNo_"^"_patName
 ..
 . 
 q pid
}

/// Description:获取退药申请单病区dr
ClassMethod GetReqWardDr(retrqno As %Integer) As %String
{
	n (retrqno)
	s rqrowid=$o(^RETRQ(0,"RETRQNO",retrqno,""))
	s beddr=$p(^RETRQ(rqrowid),"^",8)
    s warddr=+beddr
    q warddr
}

/// Description:获取医嘱科室,病区发药取发药表病区，特殊科室取开单科室
ClassMethod GetOrdLocDr(retrqno As %Integer, userid = "") As %String
{
	n (retrqno,userid)
	s rqrowid=$o(^RETRQ(0,"RETRQNO",retrqno,""))
	s oeori=$p(^RETRQ(rqrowid),"^",9)
	s phaci=$p(^RETRQ(rqrowid),"^",24)
	s warddr=$p(^DHCPHAC(+phaci),"^",4)
	i warddr="" 
	s rqrowid=""
	i warddr'="" s locrowid=$p(^PAWARD(warddr),"^",5)
    e  s locrowid=##Class(web.DHCSTKUTIL).UserDept(oeori)
    s CpType=""
    s:userid'="" CpType=##Class(web.DHCSTRETREQUEST).GetSSUserType(userid)
    i CpType["DOC" s locrowid=##Class(web.DHCSTKUTIL).UserDept(oeori)
    q locrowid
}

/// Description:获取患者基本信息
ClassMethod GetPatInfo(retrqno As %Integer) As %String
{
	n (retrqno)
	s patinfo=""
	s rqrowid=""
    f  s rqrowid=$o(^RETRQ(0,"RETRQNO",retrqno,rqrowid)) q:rqrowid=""  d
    .s patno=$p(^RETRQ(rqrowid),"^",3)
    .s admdr=$p(^RETRQ(rqrowid),"^",5)
    .s beddr=$p(^RETRQ(rqrowid),"^",8)
    .s bed=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)
    .s bed=bed_"床"
    .i patinfo="" d
    ..s patinfo=patno_"("_bed_")"
    .e  d
    ..s patinfo=patinfo_"/"_patno_"("_bed_")"
	q patinfo
}

ClassMethod ListRetReqNo(i As %Integer) As %String
{
 q ^TMP($j,"RETREQ",i)
}

ClassMethod ListRetReqInfo(i As %Integer) As %String
{
	i $d(^TMP($j,"RETREQ",i))  q ^TMP($j,"RETREQ",i)	
	q ""
}

// zdm,2012-03-20,查找申请单明细（申请单查询界面用）

ClassMethod GetRetReqByNo(ReqNo As %String) As %String
{
	n (ReqNo)
	s pid=..NewPid()
	q:ReqNo="" pid
 	s ReqId=$o(^RETRQ(0,"RETRQNO",ReqNo,""))
 	q:ReqId="" pid
 	s WardLoc=$p(^RETRQ(ReqId),"^",21)
 	s WardLocDesc=##class(PHA.COM.Data.Base).LocDesc(WardLoc)
 	s PapmiDr=$p(^RETRQ(ReqId),"^",3)
 	s PatNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
 	s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
 	s AdmDr=$p(^RETRQ(ReqId),"^",5)
 	s Admno=$p(^PAADM(AdmDr),"^",81)
 	s AdmLocDR=$p(^PAADM(AdmDr),"^",4)
 	s AdmLoc=##class(PHA.COM.Data.Base).LocDesc(AdmLocDR)
 	s BedId=$p(^RETRQ(ReqId),"^",8)
 	s:BedId'="" BedNo=$p(^PAWARD(+BedId,"BED",$p(BedId,"||",2)),"^",1)
 	s curWard=$p(^PAADM(AdmDr),"^",70)
 	s curWardLocDr=$s(curWard'="":$p(^PAWARD(curWard),"^",5),1:"")
 	i curWardLocDr'=WardLoc s BedNo="" //转科的床号显示为空
 	s RecLocDR=$p(^RETRQ(ReqId),"^",2)
 	s Recloc=##class(PHA.COM.Data.Base).LocDesc(RecLocDR)
 	s DoctorDr=$p(^RETRQ(ReqId),"^",6)
 	s Doctor=##class(PHA.COM.Data.Base).CareProvDesc(DoctorDr)
 	s DeptDr=$p(^RETRQ(ReqId),"^",7)
 	s Dept=##class(PHA.COM.Data.Base).LocDesc(DeptDr)
 	;
 	s n=0
 	s chl=""
 	f  s chl=$o(^RETRQ(ReqId,"I",chl)) q:chl=""  d
 	.s Status=$p(^RETRQ(ReqId,"I",chl),"^",10)
 	.s Oeori=$p(^RETRQ(ReqId,"I",chl),"^",1)
 	.s Ord=+Oeori
 	.s Itm=$p(Oeori,"||",2)
 	.s DateDosing=$p(^RETRQ(ReqId,"I",chl),"^",2)
 	.s Qty=$p(^RETRQ(ReqId,"I",chl),"^",3)	//申请数量
 	.s Sp=$p(^RETRQ(ReqId,"I",chl),"^",4)
 	.s SpAmt=$p(^RETRQ(ReqId,"I",chl),"^",5)
 	.s ReasonDr=$p(^RETRQ(ReqId,"I",chl),"^",6)
 	.s Reason=##class(PHA.COM.Data.Base).RefundReasonDesc(ReasonDr)
 	.s ReqDate=$p(^RETRQ(ReqId,"I",chl),"^",7)
 	.s ReqTime=$p(^RETRQ(ReqId,"I",chl),"^",8)
 	.i ReqDate'="" s ReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ReqDate,"IP")
 	.i ReqTime'="" s ReqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ReqTime,"IP")
 	.s ReqUser=$p(^RETRQ(ReqId,"I",chl),"^",9)
 	.s ReqUserName=##class(PHA.COM.Data.Base).UserName(ReqUser) 
 	.s Dodis=$p(^RETRQ(ReqId,"I",chl),"^",11)
 	.s Prescno=$p(^OEORD(Ord,"I",Itm,1),"^",14) 		;处方号
 	.s ArcimId=$p(^OEORD(Ord,"I",Itm,1),"^",2)
 	.s RefundStatus=$p(^RETRQ(ReqId,"I",chl),"^",12) 
 	.s ReqItmId=ReqId_"||"_chl
 	.s dspBatId=0
	.f  s dspBatId=$o(^DHCOEDISQTY(Dodis,"I",dspBatId))  q:dspBatId=""  d
	..S dspInci=$p(^DHCOEDISQTY(Dodis,"I",dspBatId),"^",5)
	..S dspInclb=$p(^DHCOEDISQTY(Dodis,"I",dspBatId),"^",1)
	..S Inci=$s(dspInclb'="":+dspInclb,1:+dspInci)
	..Q:Inci=0
 	..s InciDesc=##class(PHA.COM.Data.Base).InciDesc(Inci)
 	..s InciCode=##class(PHA.COM.Data.Base).InciCode(Inci)
 	..s UomId=$p(^INCI(Inci,1),"^",10)
 	..s Uom=##class(PHA.COM.Data.Base).UomDesc(UomId)  
	..s Generic=$lg(##class(PHA.COM.Drug).GetGeneric(Inci),3)
 	..s Form=$lg(##class(PHA.COM.Drug).GetForm(Inci),3)
 	..s Specifaction=##class(web.DHCSTCOMMONSRV).getBarcode(Inci)
 	..s Manf=$lg(##class(PHA.COM.Drug).GetManf(Inci),3)
 	..i $f(Manf,"-") s Manf=$p(Manf,"-",2)
 	..s ReturnQty=+##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(ReqId_"||"_chl)  ;已退数量(本条申请明细的)
 	..s SurQty=Qty-ReturnQty       ;未退数量
 	..s Dspqty=$p(^DHCOEDISQTY(Dodis,"I",dspBatId),"^",2)	//发药数量
 	..i RefundStatus="1" s RefundStatus=##class(PHA.COM.Base).Get("已退费")
 	..e  d
 	...i SurQty=Qty s RefundStatus=##class(PHA.COM.Base).Get("可退费")
 	...i (ReturnQty'=0)&(SurQty>0)  s RefundStatus=##class(PHA.COM.Base).Get("可部分退费" ) 
 	...i SurQty'>0 s RefundStatus=##class(PHA.COM.Base).Get("已退费")
 	..s info1=PatNo_"^"_$g(Admno)_"^"_AdmDr_"^"_$g(Doctor)_"^"_$g(Dept)
 	..s info2=$g(BedNo)_"^"_+Dspqty_"^"_Prescno_"^"_+Qty_"^"_+Sp
 	..s info3=+SpAmt_"^"_$g(ReqUserName)_"^"_ReqDate_"^"_ReqTime_"^"_InciCode
 	..s info4=InciDesc_"^"_Oeori_"^"_Inci_"^"_DeptDr_"^"_BedId
 	..s info5=RecLocDR_"^"_$g(AdmLoc)_"^"_$g(Recloc)_"^"_ReqItmId_"^"_$g(Uom)
 	..s info6=$g(PatName)_"^"_AdmLocDR_"^"_Status_"^"_$g(ibno)_"^"_$g(Reason)
 	..s info7=ReturnQty_"^"_SurQty_"^"_Manf_"^"_RefundStatus_"^"_PapmiDr
 	..s n=n+1
 	..s ^TMP(pid,"RETREQ",n)=info1_"^"_info2_"^"_info3_"^"_info4_"^"_info5_"^"_info6_"^"_info7
 	.
 	q pid
}

/// Creator:zhangdongmei
/// CreatDate:2012-03-12
/// Descriprtion:查找申请单明细
/// Table:
/// Input:申请单号
/// Output:npid 进程号
/// Others:save the data into temporary global
/// w ##class(web.DHCSTPHARETURN2).GetRetReqByNoToRet("DHSZHYYZYRETREQ20181024001","Prove")
ClassMethod GetRetReqByNoToRet(ReqNoStr As %String, ReqStatus As %String) As %String
{
	n (ReqNoStr,ReqStatus)
	q:ReqNoStr="" ""
 	s n=0
 	s code="Prove"
 	s pid=..NewPid()
 	k ^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQ",pid)
 	k ^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid)
 	s rows=$l(ReqNoStr,"^")
 	s num=0
 	;
 	f i=1:1:rows d
 	.s ReqNo=$p(ReqNoStr,"^",i)
 	.s ReqId=$o(^RETRQ(0,"RETRQNO",ReqNo,""))
 	.q:ReqId=""
 	.s WardLoc=$p(^RETRQ(ReqId),"^",21)
 	.s WardLocDesc=##class(PHA.COM.Data.Base).LocDesc(WardLoc)
 	.s PapmiDr=$p(^RETRQ(ReqId),"^",3)
 	.s PatNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
 	.s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
 	.s AdmDr=$p(^RETRQ(ReqId),"^",5)
 	.s AdmLocDR=$p(^PAADM(AdmDr),"^",4)
 	.s AdmLoc=##class(PHA.COM.Data.Base).LocDesc(AdmLocDR)
 	.s BedId=$p(^RETRQ(ReqId),"^",8)
 	.s:BedId'="" BedNo=$p(^PAWARD(+BedId,"BED",$p(BedId,"||",2)),"^",1)
 	.s MotherAdmId=$p(^PAADM(AdmDr),"^",75)
 	.i MotherAdmId'="" s BedNo=##class(web.DHCSTCOMMONORDER).GetAdmTransBed(AdmDr,BedId)
 	.s RecLocDR=$p(^RETRQ(ReqId),"^",2)
	.s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(RecLocDR)
	.s HospID=$p(CustStr,"^",5)
	.s CustID=$p(CustStr,"^",1)
 	.s chl=""
 	.f  s chl=$o(^RETRQ(ReqId,"I",chl)) q:chl=""  d
 	..s Status=$p(^RETRQ(ReqId,"I",chl),"^",10)
 	..q:(ReqStatus'="")&(Status'=ReqStatus)
 	..s Oeori=$p(^RETRQ(ReqId,"I",chl),"^",1)
 	..s Ord=+Oeori
 	..s Itm=$p(Oeori,"||",2)
 	..s DateDosing=$p(^RETRQ(ReqId,"I",chl),"^",2)
 	..s Qty=$p(^RETRQ(ReqId,"I",chl),"^",3)
 	..s Sp=$p(^RETRQ(ReqId,"I",chl),"^",4)
 	..s SpAmt=$p(^RETRQ(ReqId,"I",chl),"^",5)
 	..s ReasonDr=$p(^RETRQ(ReqId,"I",chl),"^",6)
 	..s Reason=##class(PHA.COM.Data.Base).RefundReasonDesc(ReasonDr)
 	..s ReqDate=$p(^RETRQ(ReqId,"I",chl),"^",7)
 	..s ReqTime=$p(^RETRQ(ReqId,"I",chl),"^",8)
 	..i ReqDate'="" s ReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ReqDate)
 	..i ReqTime'="" s ReqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ReqTime)
 	..s ReqUser=$p(^RETRQ(ReqId,"I",chl),"^",9)
 	..s ReqUserName=##class(PHA.COM.Data.Base).UserName(ReqUser)
 	..s Dodis=$p(^RETRQ(ReqId,"I",chl),"^",11)
 	..s Prescno=$p(^OEORD(Ord,"I",Itm,1),"^",14) 		;处方号
 	..s queid=+$o(^PAQUE1(0,"PrescNo",Prescno,""))
 	..s CyFlag=$s($d(^PAQUE1(queid,"DHC")):"Y",1:"")
 	..s DodisBatch=$p(^RETRQ(ReqId,"I",chl),"^",14)
 	..s Inclb=$p(^RETRQ(ReqId,"I",chl),"^",16)
 	..s PhacLbRowId=$p(^RETRQ(ReqId,"I",chl),"^",15)
 	..s Inci=+Inclb
 	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
 	..s ExpDate=$p(^INCI(Inci,"IB",$p(Incib,"||",2)),"^",2)
 	..i ExpDate'="" s ExpDate=$zd(ExpDate,3)
 	..s BatchNo=$p(^INCI(Inci,"IB",$p(Incib,"||",2)),"^",1)
 	..s InciDesc=$p(^INCI(Inci,1),"^",2)
 	..s InciCode=$p(^INCI(Inci,1),"^",1)
 	..s UomId=$p(^INCI(Inci,1),"^",10)
 	..s Uom=##class(PHA.COM.Data.Base).UomDesc(UomId)
	..s Generic=$lg(##class(PHA.COM.Drug).GetGeneric(Inci),3)
 	..s Form=$lg(##class(PHA.COM.Drug).GetForm(Inci),3)
 	..s Specifaction=##class(web.DHCSTCOMMONSRV).getBarcode(Inci)
 	..s Manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(Inclb),"^",2)
 	..s ReturnQty=##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(ReqId_"||"_chl)  ;已退数量  以退药表为准 liangqiang
 	..s ReturnQty=+ReturnQty
 	..s SurQty=Qty-ReturnQty       ;未退数量
 	..s ReqItmId=ReqId_"||"_chl
 	..s OecprStr=##Class(web.DHCSTPIVA).GetOePriority(Oeori)
 	..s OecprCode=$p(OecprStr,"^",2)
 	..s RetPartFlag=..GetRetPartFlag(Dodis)	//是否允许部分退药
 	..s PhacId=+PhacLbRowId
 	..s PhacSubId=$p(PhacLbRowId,"||",2)
 	..s PhacLbId=$p(PhacLbRowId,"||",3)
 	..s DspQty=+$p(^DHCPHAC(PhacId,"I",PhacSubId,"B",PhacLbId),"^",3)	//发药数量
 	../// 格式化金额,价格
 	..s CatGrpStr=##Class(PHA.COM.Drug).GetStkCatGrp(+Inci)
 	..s StkTypeDesc=$lg(CatGrpStr,2)
 	..s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 	..s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
 	..s Sp=##Class(web.DHCSTCOMMPARA).GetNumbDec(Sp,Perv,"FmtSP",2)
 	..s PivasFlag=""
 	..s NeedPivas=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),"DHC")),"^",16)
 	..s DispCat=$p($g(^DHCOEDISQTY(+Dodis)),"^",27)
 	..i (DispCat=0)&&(NeedPivas="Y") s PivasFlag="Y"
 	..s info1=PatNo_"^"_AdmDr_"^"_$g(WardLocDesc)_"^"_$g(BedNo)_"^"_Prescno
 	..s info2=Qty_"^"_Sp_"^"_SpAmt_"^"_$g(ReqUserName)_"^"_ReqDate
 	..s info3=ReqTime_"^"_InciDesc_"^"_Oeori_"^"_WardLoc_"^"_BedId
 	..s info4=RecLocDR_"^"_$g(AdmLoc)_"^"_$g(Recloc)_"^"_ReqItmId_"^"_$g(Uom)
 	..s info5=PatName_"^"_AdmLocDR_"^"_Status_"^"_InciCode_"^"_$g(Reason)
 	..s info6=Generic_"^"_Form_"^"_Specifaction_"^"_Manf_"^"_ReturnQty
 	..s info7=SurQty_"^"_DateDosing_"^"_Dodis_"^"_OecprCode_"^"_RetPartFlag
 	..s info8=DspQty_"^"_DodisBatch_"^"_PhacLbRowId_"^"_Inclb_"^"_ExpDate
 	..s info9=BatchNo_"^"_CyFlag_"^"_PivasFlag
 	..s num=num+1
 	..s ^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQ",pid,num)=info1_"^"_info2_"^"_info3_"^"_info4_"^"_info5_"^"_info6_"^"_info7_"^"_info8_"^"_info9
 	..
 	..i $d(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp)) d
 	...s $p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",6)=$p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",6)+Qty
 	...s $p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",8)=+$p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",8)+SpAmt
 	...s $p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",30)=$p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",30)+ReturnQty
 	...s $p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",31)=$p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",31)+SurQty
 	...s $p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",19)=$p(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp),"^",19)_","_ReqItmId
 	..e  d
 	...s ^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,Inci,+Sp)=info1_"^"_info2_"^"_info3_"^"_info4_"^"_info5_"^"_info6_"^"_info7_"^"_info8
 	..
 	.
 	q pid
}

/// Descript：	是否允许部分退药(判断执行记录是否有附加收费项目，有则不允许部分退药)
/// Creater:	 	zhouyg
/// CreateDate:	2012-09-28
/// Input:		DspID-dhc_oedispensing的rowid
/// Return:		1-允许部分退药,0不允许部分退药
ClassMethod GetRetPartFlag(DspID) As %String
{
	n (DspID)
	s retFlag=0
	q:DspID="" retFlag
	s oeoreID=$p($g(^DHCOEDISQTY(DspID)),"^",3)
	q:oeoreID="" retFlag
	s ExtraFlag="Y"
	i ##Class(websys.Conversions).IsValidMethodName("web.UDHCJFBILLIP","GetExtraItmFlag")=1 d
	.s ExtraFlag=##class(web.UDHCJFBILLIP).GetExtraItmFlag(oeoreID)
	i ExtraFlag="Y" d
	.s retFlag=0
	e  d
	.s retFlag=1
	q retFlag
}

/// Descript：	是否允许退药(对部分退药(退药数量小于发药数量)的判断，判断执行记录是否有附加收费项目，有则不允许部分退药)
/// Creater:	 	zhouyg
/// CreateDate:	2012-09-28
/// Input:		DspID-dhc_oedispensing的rowid
/// Return:		1-允许退药,0不允许退药
/// w ##class(web.DHCSTPHARETURN2).GetRetParted("494","10")
ClassMethod GetRetParted(DspID, RetQty) As %String
{
	n (DspID,RetQty)
	s retFlag=0
	q:DspID="" retFlag
	s oeoreID=$p($g(^DHCOEDISQTY(DspID)),"^",3)
	q:oeoreID="" retFlag
	//s DspQty=+$p($g(^DHCOEDISQTY(DspID)),"^",5)
	//q:RetQty=DspQty 1
	//q:RetQty>DspQty retFlag
	s ExtraFlag="Y"
	i ##Class(websys.Conversions).IsValidMethodName("web.UDHCJFBILLIP","GetExtraItmFlag")=1 d
	.s ExtraFlag=##class(web.UDHCJFBILLIP).GetExtraItmFlag(oeoreID)
	i ExtraFlag="Y" d
	.s retFlag=0
	e  d
	.s retFlag=1
	q retFlag
}

ClassMethod GetPhaNameByPano(pano As %String) As %String
{
	n (pano)
	&sql(select papmi_name into :name from pa_patmas where  papmi_no=:pano) 
	q $g(name)
}

ClassMethod UpdateReqByRowid(rowid As %String) As %String
{
	s code="Ignore"
	&sql(update DHC_PhaRetRequest set retrq_status=:code where retrq_rowid=:rowid)
	q 0
}

ClassMethod GetReqDrByDsp(dsp)
{
	//Get the Ret request info in terms of the oe_dispensing
 n (dsp)
 s retreq=$o(^RETRQ(0,"OEDIS",dsp,""))
 q retreq
}

ClassMethod GetRetReqsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRetReqsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRetReqsExecute(ByRef qHandle As %Binary, returnlocrowid As %String, wardrowid As %String, StartDate As %String, EndDate As %String, RequestStatus As %String, PARegNo As %String, incirowid As %String, ReturnLoc = "", Ward = "", PAName = "", AdvRefundFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;
	;q:returnlocrowid="" $$$OK //yunhaibao20161130,不作为必选条件
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:wardrowid="" $$$OK
	s pid=..GetRetReqByDateDept(StartDate,EndDate,wardrowid,returnlocrowid,RequestStatus,PARegNo,"",incirowid, AdvRefundFlag)
	q:pid="" $$$OK
	;
	d OutputRow
	k ^TMP("DHCST",$this,"RETREQ",pid) 
	Quit $$$OK
OutputRow
	s num=0
	f  s num=$o(^TMP("DHCST",$this,"RETREQ",pid,num)) q:num=""  d
	.s retreq=^TMP("DHCST",$this,"RETREQ",pid,num)
	.s retreqno=$p(retreq,"^",1)
	.s retreqdate=$p(retreq,"^",2)
	.s ward=$p(retreq,"^",3)
	.s user=$p(retreq,"^",4)
	.s status=$p(retreq,"^",5)
	.s patinfo=$p(retreq,"^",6)
	.s RefundStatus=$p(retreq,"^",7)
	.set Data=$lb(retreqno,retreqdate,ward,user,status,patinfo,RefundStatus)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	.
	q
}

ClassMethod GetRetReqsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRetReqsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetRetReqs(returnlocrowid As %String, wardrowid As %String, StartDate As %String, EndDate As %String, RequestStatus As %String, PARegNo As %String, incirowid As %String, ReturnLoc = "", Ward = "", PAName = "", AdvRefundFlag As %String) As %Query(ROWSPEC = "TReqNo:%String,TReqDate:%String,TWard:%String,TReqOper:%String,Tstatus:%String,Tpatinfo:%String,TRefundStatus:%String")
{
}

ClassMethod RetReqDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RetReqDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// zdm,2012-03-20,申请单查询

ClassMethod RetReqDetailExecute(ByRef qHandle As %Binary, RetReqNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
    q:RetReqNo="" $$$OK
	d ResetVariables1
	s pid=""
	s h=2
    f  s Req=$p(RetReqNo,"^",h)  q:Req=""  d
	.s pid=..GetRetReqByNo(Req)
	.q:pid=""
	.
	.d OutputRow1
	.s h=h+1
	i pid'=""  d
	.k ^TMP(pid,"RETREQ")
	Quit $$$OK
	
OutputRow1
	s num=0
	f  s num=$o(^TMP(pid,"RETREQ",num)) q:num=""  d
	.s ReqItm=^TMP(pid,"RETREQ",num)
	.s regno=$p(ReqItm,"^",1)
	.s name=$p(ReqItm,"^",26)
	.s prescno=$p(ReqItm,"^",8)
	.s bedno=$p(ReqItm,"^",6)
	.s desc=$p(ReqItm,"^",16)
	.s uom=$p(ReqItm,"^",25)
	.s qty=$p(ReqItm,"^",9)
	.s reqdate=$p(ReqItm,"^",13)
	.s reqtime =$p(ReqItm,"^",14)
	.s status=$p(ReqItm,"^",28)
	.i status="Execute" d
	..s status=##class(PHA.COM.Base).Get("已退药")
	.e  d
	..s status=##class(PHA.COM.Base).Get("申请退药中")
	.s retrqrowid=$p(ReqItm,"^",24)
	.s RetReason=$p(ReqItm,"^",30)  ;退药原因
	.s Treq=Req
	.s returnqty=$p(ReqItm,"^",31)
	.s surqty=$p(ReqItm,"^",32)
	.i (+returnqty'=0)&(+surqty'=0) d
	..s status=##class(PHA.COM.Base).Get("部分退药")
	.s sp=$p(ReqItm,"^",10)
	.s manf=$p(ReqItm,"^",33)
	.s RefundStatus=$p(ReqItm,"^",34)
	.s EncryptLevelInfo=""
    .s EncryptLevel=""
    .s PatLevel="" 
    .s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    .i EncryptFlag=1 d
	..s papmidr=$p(ReqItm,"^",35)
	..s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
    ..s EncryptLevel=$p(EncryptLevelInfo,"^",1)
    ..s PatLevel=$p(EncryptLevelInfo,"^",2)
	.//i status="已退药" s RefundStatus="可退费"
	.;
	.set Data=$lb(regno,name,prescno,bedno,desc,uom,qty,reqdate,reqtime,status,retrqrowid,RetReason,Treq,+returnqty,+surqty,sp,manf,RefundStatus,EncryptLevel,PatLevel)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	q
ResetVariables1
	s (regno,name,prescno,bedno,desc,uom,qty,reqdate,reqtime,status,retrqrowid,RetReason,Treq,returnqty,surqty,sp,manf,RefundStatus,EncryptLevel,PatLevel)=""
	q
}

ClassMethod RetReqDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RetReqDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query RetReqDetail(RetReqNo As %String) As %Query(ROWSPEC = "RegNo:%String,Name:%String,PrescNo:%String,BedNo:%String,Desc:%String,Uom:%String,Qty:%String,ReqDate:%String,ReqTime:%String,Status:%String,retrqrowid:%String,RetReason:%String,Treq:%String,Treturnqty:%String,Tsurqty:%String,Tsp:%String,Tmanf:%String,TRefundStatus:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod GetRetDataByReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRetDataByReqExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRetDataByReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRetDataByReqExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetRetDataByReq(ReqNo As %String) As %Query(ROWSPEC = "TPaNo:%String,TPaName:%String,TDEPTDR:%String,TWard:%String,TBEDDR:%String,TBedNo:%String,TADMDR:%String,TAdmNo:%String,TADMLOCDR:%String,TAdmLoc:%String,TDoctor:%String,TPrescNo:%String,TINCLBDR:%String,TOEDISDR:%String,TReturnQty:%String,TDispQty:%String,TRECLOCDR:%String,TCode:%String,TDesc:%String,TUom:%String,TBatchNo:%String,TReturnPrice:%String,TRETRQDR:%String,TRetReqQty:%String,TReturnAmt:%String,TReturnDate:%String,TReturnTime:%String,TReturnOper:%String")
{
}

ClassMethod getRetReqMsg(retReqNo As %String) As %String
{
	s retrq=$o(^RETRQ(0,"RETRQNO",retReqNo,""))
	q:retrq="" ""
	s reclocdr=+$p(^RETRQ(retrq),"^",2)
	s warddr=+$p(^RETRQ(retrq),"^",7)
	i (reclocdr>0)&($d(^CTLOC(reclocdr))) s recloc=##class(PHA.COM.Data.Base).LocDesc(reclocdr)
	i (warddr>0)&($d(^CTLOC(warddr))) s ward=##class(PHA.COM.Data.Base).LocDesc(warddr)
	q $g(recloc)_"^"_$g(ward)
}

ClassMethod GetRetReqsToRetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRetReqsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRetReqsToRetExecute(ByRef qHandle As %Binary, returnlocrowid As %String, wardrowid As %String, StartDate As %String, EndDate As %String, RequestStatus As %String, PARegNo As %String, DocFlag As %String, AdvRefundFlag As %String, RefuseFlag = "", otherStr = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;
	q:returnlocrowid="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	;
	i DocFlag="on" s DocFlag=1 
    e  s DocFlag=0
	s pid=..GetRetReqByDateDept(StartDate,EndDate,wardrowid,returnlocrowid,RequestStatus,PARegNo,DocFlag,"",AdvRefundFlag,RefuseFlag,otherStr)
	q:pid="" $$$OK
	;
	d OutputRow2 
	k ^TMP("DHCST",$this,"RETREQ",pid)	
	Quit $$$OK
OutputRow2
	s num=0
	f  s num=$o(^TMP("DHCST",$this,"RETREQ",pid,num)) q:num=""  d
	.s retreq=^TMP("DHCST",$this,"RETREQ",pid,num)
	.s retreqno=$p(retreq,"^",1)
	.s retreqdate=$p(retreq,"^",2)
	.s ward=$p(retreq,"^",3)
	.s user=$p(retreq,"^",4)
	.s bedNo=$p(retreq,"^",8)
	.s patNo=$p(retreq,"^",9)
	.s patName=$p(retreq,"^",10)
	.set Data=$lb(retreqno,retreqdate,ward,user,bedNo,patNo,patName)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	q
}

ClassMethod GetRetReqsToRetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRetReqsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetRetReqsToRet(returnlocrowid As %String, wardrowid As %String, StartDate As %String, EndDate As %String, RequestStatus As %String, PARegNo As %String, DocFlag As %String, AdvRefundFlag As %String, RefuseFlag = "") As %Query(ROWSPEC = "TReqNo:%String,TReqDate:%String,TWard:%String,TReqOper:%String,TBedNo:%String,TPatNo:%String,TPatName:%String")
{
}

ClassMethod RetReqDetailToRetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RetReqDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RetReqDetailToRetExecute(ByRef qHandle As %Binary, RetReqNo As %String, RetReqStatus = "Prove") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:RetReqNo="" $$$OK
	d ResetVarToRet
	s pid=..GetRetReqByNoToRet(RetReqNo,RetReqStatus)
	q:pid="" $$$OK
	;
	d OutputRowToRet
	k ^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQ",pid)
	Quit $$$OK

OutputRowToRet
	s sub=""
	f  s sub=$o(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQ",pid,sub)) q:sub=""  d
	.s data=^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQ",pid,sub)
 	.s PatNo=$p(data,"^",1)
 	.s PatName=$p(data,"^",21)
 	.s Prescno=$p(data,"^",5) 		;处方号
 	.s BedNo=$p(data,"^",4)
 	.s InciDesc=$p(data,"^",12)
 	.s Uom=$p(data,"^",20) 
 	.s Qty=$fn($p(data,"^",6),"N")
 	.s ReqDate=$p(data,"^",10)
	.s ReqTime=$p(data,"^",11)
	.s Status=$p(data,"^",23)
	.s ReqItmId=$p(data,"^",19)
	.s Select=""
	.s WardLoc=$p(data,"^",14)
	.s BedId=$p(data,"^",15)	
 	.s AdmDr=$p(data,"^",2)
 	.s AdmLocDr=$p(data,"^",22)
 	.s Inclb=""
 	.s Oeori=$p(data,"^",13)
 	.s RecLocDr=$p(data,"^",16)
 	.s SpAmt=$p(data,"^",8)
 	.s Sp=$p(data,"^",7)
 	.s InciCode=$p(data,"^",24)
 	.s Reason=$p(data,"^",25)
 	.s Generic=$p(data,"^",26)
 	.s Specifaction=$p(data,"^",28)
 	.s Form=$p(data,"^",27)
 	.s Manf=$p(data,"^",29)
 	.s DateDosing=$p(data,"^",32)
	.s Dodis=$p(data,"^",33)
	.s ReturnQty=$fn($p(data,"^",30),"N")
 	.s SurQty=$fn($p(data,"^",31),"N")
 	.s WardLocDesc=$p(data,"^",3)
	.s ReqUserName=$p(data,"^",9)
	.s reqItm=$p(ReqItmId,"||",2)
	.s reqItmData=^RETRQ(+ReqItmId,"I",reqItm)
	.s refundStatus=$p(reqItmData,"^",12)
	.i refundStatus="1" s RefundStatus=##class(PHA.COM.Base).Get("退费完成")
 	.e  d
 	..i SurQty=Qty s RefundStatus=##class(PHA.COM.Base).Get("尚未退费")
 	..i (ReturnQty'=0)&(SurQty>0)  s RefundStatus=##class(PHA.COM.Base).Get("部分退费") 
 	..i SurQty'>0 s RefundStatus=##class(PHA.COM.Base).Get("退费完成")
 	.i SurQty<=0 s ReqStatus=##class(PHA.COM.Base).Get("退药完成")
 	.e  i SurQty=Qty s ReqStatus=##class(PHA.COM.Base).Get("尚未退药")
 	.e  s ReqStatus=##class(PHA.COM.Base).Get("部分退药")
 	.i $p(reqItmData,"^",10)="Refuse" s ReqStatus=##class(PHA.COM.Base).Get("拒绝退药")
	.//s reqRetStatus=##class(web.DHCINPHA.QueryRetReq).GetReqRetStatus(+ReqItmId) ;过滤已退申请单
	.//i reqRetStatus=0 s ReqStatus="退药完成"
	.//e  i reqRetStatus=1 s ReqStatus="部分退药"
	.//e  i reqRetStatus=2 s ReqStatus="尚未退药"
	.//e  s ReqStatus="尚未退药"
	.//s RefundStatus=##class(web.DHCINPHA.QueryRetReq).GetReqRefundStatus(+ReqItmId)
	.//i RefundStatus=0 s RefundStatus="尚未退费"
	.//e  i RefundStatus=1 s RefundStatus="退费完成"
	.//e  i RefundStatus=2 s RefundStatus="部分退费"
	.//e  s RefundStatus="尚未退费"
	.s OecprCode=$p(data,"^",34)
	.s RetPartFlag=$p(data,"^",35)
	.s dspQty=$fn($p(data,"^",36),"N")
	.s DodisBatch=$p(data,"^",37)
	.s PhacLbRowId=$p(data,"^",38)
	.s Inclb=$p(data,"^",39)
	.s ExpDate=$p(data,"^",40)
	.s BatchNo=$p(data,"^",41)
	.s CyFlag=$p(data,"^",42)
	.s PivasFlag=$p(data,"^",43)
	.s mDodis=##class(web.DHCSTCOMMONORDER).GetMainDspId(+DodisBatch)
	.s EncryptLevelInfo=""
    .s EncryptLevel=""
    .s PatLevel="" 
    .s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    .i EncryptFlag=1 d
	..s papmidr=$p(^PAADM(AdmDr),"^",1)
	..s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 	..s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	..s PatLevel=$p(EncryptLevelInfo,"^",2)
 	.s RefuseData=""
 	.i $p(reqItmData,"^",10) = "Refuse" d
 	..s RefuseData=##class(web.DHCINPHA.Request).GetRefuseData(ReqItmId)
	.set Data=$lb(PatNo,PatName,Prescno,BedNo,InciDesc,Uom,Qty,ReqDate,ReqTime,ReqStatus,ReqItmId,Select,WardLoc,BedId,AdmDr,AdmLocDr,DateDosing,Oeori,RecLocDr,SpAmt,Sp,InciCode,Reason,Generic,Specifaction,Form,Manf,ReqUserName,Dodis,ReturnQty,SurQty,pid,OecprCode,RetPartFlag,dspQty,EncryptLevel,PatLevel,DodisBatch,PhacLbRowId,Inclb,ExpDate,BatchNo,RefundStatus,CyFlag,PivasFlag,mDodis,RefuseData)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	.
	q
ResetVarToRet
	s (PatNo,PatName,Prescno,BedNo,InciDesc,Uom,Qty,ReqDate,ReqTime,ReqStatus,ReqItmId,Select,WardLoc,BedId,AdmDr,AdmLocDr,DateDosing,Oeori,RecLocDr,SpAmt,Sp,InciCode,Reason,Generic,Specifaction,Form,Manf,ReqUserName,Dodis,ReturnQty,SurQty,pid,OecprCode,RetPartFlag,dspQty,EncryptLevel,PatLevel,DodisBatch,PhacLbRowId,Inclb,ExpDate,BatchNo,RefundStatus,CyFlag,RefuseData)=""
  	q
}

ClassMethod RetReqDetailToRetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RetReqDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTPHARETURN2","RetReqDetailToRet","DHSZHYYZYRETREQ20190408003")
Query RetReqDetailToRet(RetReqNo As %String, RetReqStatus = "Prove") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TPrescNo:%String,TBedNo:%String,TDesc:%String,TUom:%String,TQty:%String,TReqDate:%String,TReqTime:%String,TReqStatus:%String,Tretrqrowid:%String,Select:%String,TDEPTDR:%String,TBEDDR:%String,TADMDR:%String,TADMLOCDR:%String,TDateDosing:%String,TOEDISDR:%String,TRECLOCDR:%String,TReturnAmt:%String,TReturnPrice:%String,TCode:%String,TRetReason:%String,TGeneric:%String,TBarcode:%String,TForm:%String,TManf:%String,TUser:%String,TDodis:%String,TReturnqty:%String,TSurqty:%String,Tpid:%String,TOECPRCode:%String,TRetPartFlag:%String,TDspQty:%String,TEncryptLevel:%String,TPatLevel:%String,TDodisBatch:%String,TPhacLbRowId:%String,TInclb:%String,TExpDate:%String,TBatchNo:%String,TRefundStatus:%String,TCyFlag:%String,TPivas,TMDodis,TRefuseData")
{
}

ClassMethod IBNO(inclb As %String) As %String
{
	n (inclb)
	&sql(select inclb_incib_dr->incib_no into :ibno from inc_itmlcbt where inclb_rowid=:inclb)
	q:SQLCODE ""
	q $g(ibno)
}

/// description:按照申请单退药
/// creator:lq
/// 退药药房id,退药人id;退药单号前缀,申请子表id^退药数量,申请子表id^退药数量
ClassMethod SELALLTORET(retrqno As %String, UserDR As %String) As %String
{
	
	n (retrqno,UserDR)	
	q:retrqno="" -101
	s ReqId=$o(^RETRQ(0,"RETRQNO",retrqno,""))
	q:ReqId="" -102
	s RecLocDR=$p(^RETRQ(ReqId),"^",2)
	s Pre="RT"
	s chl="",reqIDStr=""
 	f  s chl=$o(^RETRQ(ReqId,"I",chl)) q:(chl="")  d
 	.s Status=$p(^RETRQ(ReqId,"I",chl),"^",10)
 	.q:Status'="Prove"
 	.s Qty=$p(^RETRQ(ReqId,"I",chl),"^",3)
 	.s ReqItmID=ReqId_"||"_chl
 	.s ReturnQty=##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(ReqItmID)	//已退数量
 	.s SurQty=Qty-ReturnQty	//此申请未退数量
 	.i reqIDStr="" d
 	..s reqIDStr=ReqItmID_"^"_SurQty
 	.e  d
 	..s reqIDStr=reqIDStr_","_ReqItmID_"^"_SurQty
 	q:reqIDStr="" -103
 	s Ret=##class(web.DHCSTPHARETURN).ExecReturnByReq("","",RecLocDR,UserDR,Pre,reqIDStr)
	q Ret
}

ClassMethod ListRetPrint(pid, inci) As %String
{
	n (inci,pid)
	s tmp=$o(^TMP("GetRetHZ",pid,inci))
	q:tmp="" ""
	s str=^TMP("GetRetHZ",pid,tmp)
	k ^TMP("GetRetHZ",pid,tmp)
	q str
}

ClassMethod GetPid(n) As %String
{
	q $I(^DHCSTRETOTAL("RET"))
}

ClassMethod GetRetHZ(retno, pid) As %String
{
	n (retno,pid)
	//Description:退药后汇总N个退药单上的药品为打印退药单准备数据 for 华西一院
	//Creator: lq  2008-12-06
	s retrowid=""
	f  s retrowid=$o(^PHARET(0,"NO",retno,retrowid)) q:retrowid=""  d
	.s reclocdr=$p(^PHARET(retrowid),"^",5)
	.s recloc=$p(^CTLOC(+reclocdr),"^",2)
	.s deptdr=$p(^PHARET(retrowid),"^",6)
	.s dept=$p(^CTLOC(+deptdr),"^",2)
	.s retSub=0
	.f  s retSub=$o(^PHARET(retrowid,"I",retSub)) q:retSub=""  d
	..s inci=$p(^PHARET(retrowid,"I",retSub),"^",11)
	..s desc=##class(PHA.COM.Data.Base).InciDesc(inci)
	..s uomdr=$p(^INCI(+inci,1),"^",10)
	..s uom=##class(PHA.COM.Data.Base).UomDesc(uomdr)
	..s qty=$p(^PHARET(retrowid,"I",retSub),"^",2)
	..s price=$p(^PHARET(retrowid,"I",retSub),"^",4)
	..s amt=$p(^PHARET(retrowid,"I",retSub),"^",5)
	..i '$d(^TMP("GetRetHZ",pid,inci)) d 
	...s ^TMP("GetRetHZ",pid,inci)=desc_"^"_""_"^"_qty_"^"_uom_"^"_inci_"^"_recloc_"^"_dept_"^"_price_"^"_amt
	..e  d
	...s $p(^TMP("GetRetHZ",pid,inci),"^",3)=$p(^TMP("GetRetHZ",pid,inci),"^",3)+qty
	...;s $p(^TMP("GetRetHZ",pid,inci),"^",8)=$p(^TMP("GetRetHZ",pid,inci),"^",8)+price
	...s $p(^TMP("GetRetHZ",pid,inci),"^",9)=$p(^TMP("GetRetHZ",pid,inci),"^",9)+amt
	q 0
}

ClassMethod GetRetrqShowFlag(retrqno, deptid, doclocflag) As %String
{
 //zdm,2009-03-23
 n (retrqno,deptid,doclocflag)
 s ret=0
 q:retrqno="" 0 
 s config=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_ReqWard") //获取设置
 s rqrowid=""
 f  s rqrowid=$o(^RETRQ(0,"RETRQNO",retrqno,rqrowid)) q:(rqrowid="")!(ret=1)  d
 .s phaci=$p(^RETRQ(rqrowid),"^",24)
 .s orditemrowid=$p(^DHCPHAC(+phaci,"I",$p(phaci,"||",2)),"^",7)
 .s warddr=$p(^DHCPHAC(+phaci),"^",4)
 .s ordlocrowid=""
 .i warddr=""  d
 ..s ordlocrowid=##Class(web.DHCSTKUTIL).UserDept(orditemrowid)
 .;
 .i '((doclocflag=0)&(warddr="")&(config=1)) d
 ..i '((doclocflag=1)&(deptid'=$g(ordlocrowid))) d ;特殊科室
 ...s ret=1
 q ret
}

/// Creator:Liang Qiang
/// CreatDate:2009-04-19
/// Description:判断该申请单是否已经执行退药完毕,用于组件 dhcpha.seekpharetrequesttoret
/// Input:申请单号
/// Output:0 - 已执行退药完毕  1 - 部分退药  2 -未执行
/// Return:0 - 已执行退药完毕  1 - 部分退药
/// Others:  w ##class(web.DHCSTPHARETURN2).GetRetrqStatus("BJDTYYRETREQ20160602001")
/// 弃用,yunhaibao,2021-07-13
/// 使用,##class(web.DHCINPHA.Request).IsRequestFinished
ClassMethod GetRetrqStatus(retrqno) As %String
{
 n (retrqno)
 s code="Prove"
 s ret=0
 s i=0
 q:retrqno="" 0
 s exit=0 
 s rqrowid=""
 f  s rqrowid=$o(^RETRQ(0,"RETRQNO",retrqno,rqrowid)) q:(rqrowid="")!(exit=1)  d
 .s i=i+1
 .s status=$p(^RETRQ(rqrowid),"^",14)
 .i status="Execute"  d    ;申请单退药完毕
 ..s ret=0
 ..s exit=1
 .q:exit=1 
 .s ret=2  ;默认未执行
 .s chl=0
 .f  s chl=$o(^RETRQ(rqrowid,"I",chl)) q:(chl="")!(exit=1)  d
 ..s status=$p(^RETRQ(rqrowid,"I",chl),"^",10)
 ..i status="Execute"  d
 ...s exit=1
 ...s ret=1
 ..s reqqty=$p(^RETRQ(rqrowid,"I",chl),"^",3)
 ..s ReturnQty=+##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(rqrowid_"||"_chl)
 ..i (+reqqty>+ReturnQty)&&(+ReturnQty>0) d
 ...s exit=1
 ...s ret=1
 ..
 .
 q ret
}

ClassMethod GetRetReqTotalByNoExecute(ByRef qHandle As %Binary, pid) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:pid="" $$$OK
    s inci=""
    f  s inci=$o(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,inci)) q:inci=""  d
    .s sp=""
    .f  s sp=$o(^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,inci,sp)) q:sp=""  d
    ..s spdata=^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid,inci,sp)
    ..s desc=$p(spdata,"^",12)
    ..s uom=$p(spdata,"^",20) 
    ..s reqqty=$p(spdata,"^",6)
    ..i (reqqty<1)&&($p(reqqty,".",1)="") s reqqty=0_reqqty
    ..s returnedqty=$p(spdata,"^",30)
    ..i (returnedqty<1)&&($p(returnedqty,".",1)="") s returnedqty=0_returnedqty
    ..s surqty=$p(spdata,"^",31)
    ..i (surqty<1)&&($p(surqty,".",1)="") s surqty=0_surqty
    ..s form=$p(spdata,"^",27)
    ..s manf=$p(spdata,"^",29)
    ..s sp=$p(spdata,"^",7)
    ..i (sp<1)&&($p(sp,".",1)="") s sp=0_sp
    ..s amount=$p(spdata,"^",8)
    ..i (amount<1)&&($p(amount,".",1)="") s amount=0_amount
    ..d OutRowInciToRet
    k ^TMP("DHCST",$this,"GetRetReqByNoToRet","RETREQTOTAL",pid)
	Quit $$$OK
OutRowInciToRet 
	set Data=$lb(desc,uom,reqqty,returnedqty,surqty,form,manf,sp,amount)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetRetReqTotalByNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRetReqTotalByNoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
	}
	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetRetReqTotalByNo(pid) As %Query(ROWSPEC = "Tdesc:%String,Tuom:%String,Treqqty:%String,Treturnedqty:%String,TSurqty:%String,Tform:%String,Tmanf:%String,Tprice:%String,Tamount:%String")
{
}

ClassMethod GetRetReqTotalByNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRetReqTotalByNoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description:按别名过滤INCI
/// Input:申请单号,INCI
/// Output:0 - 不存在, 1 - 存在
/// Creator:Liang Qiang
/// CreatDate:2010-06-09
ClassMethod CheckReqItem(retrqno, inci) As %String
{
	 n (retrqno,inci)
	 s code="Prove"
	 s ret=0
	 s i=0
	 q:retrqno="" 0
	 s exit=0 
	 s rqrowid=""
	 f  s rqrowid=$o(^RETRQ(0,"RETRQNO",retrqno,rqrowid)) q:(rqrowid="")!(exit=1)  d
	 .s chl=0
	 .f  s chl=$o(^RETRQ(rqrowid,"I",chl)) q:(chl="")!(exit=1)  d
	 ..s oeori=$p(^RETRQ(rqrowid,"I",chl),"^",1)
	 ..s ord=+oeori
	 ..s itm=$p(oeori,"||",2)
	 ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
     ..s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
     ..s tmpinci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") )
     ..q:tmpinci=""
     ..i (inci'="")&(tmpinci=inci) d
     ...s exit=1
     ..q:exit=1
     .
	 q exit
}

ClassMethod ListRetReqTotal(pid As %String, i As %Integer) As %String
{
	
	n (pid,i)
	s tmpstr=^TMP(pid,"RETREQ",i)
	
	q tmpstr
}

/// 返回申请单退费状态
/// Input:申请单号
/// Output:1 全退  2部分退 0 未退
/// Creator:LiangQiang
/// w ##class(web.DHCSTPHARETURN2).GetReqRefundStatus("BJDTYYRETREQ20160527002")
ClassMethod GetReqRefundStatus(ReqNo) As %String
{
	n (ReqNo)
	s refund=0
	s i=0,h=0,ret=0
	s retrq="",retFlag=0
	f  s retrq=$o(^RETRQ(0,"RETRQNO",ReqNo,retrq)) q:retrq=""  d
	.s reqsub=""
	.f  s reqsub=$o(^RETRQ(retrq,"I",reqsub)) q:reqsub=""  d
	..s i=i+1
	..s RefundStatus=$p(^RETRQ(retrq,"I",reqsub),"^",12)
	..s Status=$p(^RETRQ(retrq),"^",14)
	..i Status'="Prove" s RefundStatus=1
	..s reqqty=$p(^RETRQ(retrq,"I",reqsub),"^",3)
	..s Dodis=$p(^RETRQ(retrq,"I",reqsub),"^",11)
    ..//s ReturnQty=+##class(web.DHCSTPHARETURN).GetReqReturnedQty(Dodis)  ;已退数量
    ..s ReturnQty=+##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(retrq_"||"_reqsub)
    ..i (RefundStatus="1")||(reqqty'>ReturnQty) d
    ...s h=h+1
    ...s refund=1
    ..i (reqqty>ReturnQty)&&(+ReturnQty>0) d
    ...s refund=1
    ...s h=h+2
	i refund=1 d
	.i i=h d
	..s ret=1
	.e  d
	..s ret=2	
	Q:ret=0 ##class(PHA.COM.Base).Get("可退费")
	Q:ret=1 ##class(PHA.COM.Base).Get("已退费")
	Q:ret=2 ##class(PHA.COM.Base).Get("可部分退费")
}

/// 提交申请单退费
/// Input:申请单号
/// Output:0 成功  1 失败
/// Creator:LiangQiang
/// CreatDate:2011-11-23
ClassMethod SubmitRefund(ReqNoStr, User) As %String
{
	n (ReqNoStr,User)
	s cnt=$l(ReqNoStr,"^")
	s ret=0
	f i=2:1:cnt d
	.s reqno=$p(ReqNoStr,"^",i)
	.s err=..ReqNoRefund(reqno,User)
	.i err'=0 s ret=err
	q:ret'=0 ret
	q 0
}

ClassMethod NewPid() As %String
{
 q $I(^DHCSTPHARETURN("COLL"))
}

/// 提交申请单退费过程处理
/// Input:申请单号
/// Output:0 成功  1 失败
/// Creator:LiangQiang
/// zdm,2012-04-01,退药申请表结构更改
ClassMethod ReqNoRefund(ReqNo, User) As %String
{
	n (ReqNo,User)
	s addflag=0 //附加费用 
	s payedflag=0 
	s refund=0
	s retrq=""
	f  s retrq=$o(^RETRQ(0,"RETRQNO",ReqNo,retrq)) q:retrq=""  d
	.s chl=""
	.f  s chl=$o(^RETRQ(retrq,"I",chl)) q:chl=""  d
	..s retrqitm=retrq_"||"_chl
	..s RefundStatus=$p(^RETRQ(retrq,"I",chl),"^",12)
    ..q:RefundStatus="1" 
    ..s dodis=$p(^RETRQ(retrq,"I",chl),"^",11)
    ..s retqty=$p(^RETRQ(retrq,"I",chl),"^",3)
    ..s retqty=##class(web.DHCSTPHARETURN).GetReqItmSurplus(retrqitm)   ;该申请单剩余未退数量
    ..s PartFlag=##Class(web.DHCSTPHARETURN2).GetRetParted(dodis,retqty)	//部分退药的控制 zhouyg 20120928
    ..i PartFlag=0 s addflag=1
    ..q:PartFlag=0
    ..s ret=+##class(web.DHCSTPHARETURN).AllowReturn("","",dodis,retqty)
    ..q:ret'=1 
    ..s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)
    ..s IfDspPaid=##Class(web.DHCSTKUTIL).IfRetForPaidNew(ordexeid) //liangqiang 2014-01-06
    ..i IfDspPaid=0 s payedflag=1
    ..q:IfDspPaid=0 
    ..s oeori=$p(^RETRQ(retrq,"I",chl),"^",1)
    ..s admid=$p(^RETRQ(retrq),"^",5)
    ..//s ret=##class(web.DHCSTPHARETURN).GetPayflag(oeori,admid) //liangqiang 2014-01-06
    ..s ret=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admid) //20160310 标准版开发
    ..i ret=0 s payedflag=1
    ..q:ret=0
    ..l +^DHCRETREQUSET(retrqitm):5  e  q
    ..tstart
    ..s err=..InsertDODIS(retrqitm,User)
    ..i err'=0 l -^DHCRETREQUSET(retrqitm)
    ..i err'=0 tro
    ..i err=-11 s payedflag=1
    ..q:err'=0
    ..s dodis=$p(^RETRQ(retrq,"I",chl),"^",11)
    ..s err=..UpdReqNoRefundStatus(retrqitm,"1")
    ..s:err=0 err=##class(web.DHCSTPHARETURN).UpdBillStatus(dodis)
    ..i err'=0 l -^DHCRETREQUSET(retrqitm)
    ..i err'=0 tro
    ..q:err'=0
    ..
    ..tcommit
    ..l -^DHCRETREQUSET(retrqitm)
    ..s refund=1
    .
    q:addflag=1 -97  //有附加收费项目,不允许退费
    q:payedflag=1 -98
    q:refund=0 -99
    q 0
}

/// 插入退费记录
/// Input:申请单号ID
/// Output:0 成功  1 失败
/// Creator:LiangQiang
ClassMethod InsertDODIS(retrq, user) As %String
{
	//插入dhc_oedispensing表(根据退药申请单数据)
	n (retrq,user)
	s retrqitm=retrq
	s chl=$p(retrq,"||",2)
	s retrq=+retrq
	q:retrq="" -11
	q:chl="" -11
	s Status=$p(^RETRQ(retrq,"I",chl),"^",10)
	q:Status'="Prove" -9 
    s RefundStatus=$p(^RETRQ(retrq,"I",chl),"^",12)
    q:RefundStatus="1" -10
	s dd=+$h
	s tt=$p($h,",",2)
    s oeori=$p(^RETRQ(retrq,"I",chl),"^",1)
    q:$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",5)="P" -11 //已结算   
	s type="Y",status="R"
	s pointer="R"_retrqitm
	s recloc=$p(^RETRQ(retrq),"^",2)
	s dept=$p(^RETRQ(retrq),"^",7)    ;申请退药科室
	s adm=$p(^RETRQ(retrq),"^",5)
	s datedosing=$p(^RETRQ(retrq,"I",chl),"^",2)
	s dodis=$p(^RETRQ(retrq,"I",chl),"^",11)  ;配药表id
	s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)
	s dspid=$o(^DHCOEDISQTY(0,"OEORE",ordexeid,""),-1) 
	s dspstatus=$p($g(^DHCOEDISQTY(dspid)),"^",7)
	s rdspid=$s(dspstatus="R":dspid,1:"")
	s inci=$p(^RETRQ(retrq,"I",chl),"^",13) 
	s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
 	s phcUomId=$p(^PHCD(+Phcdf,"DF",+$p(Phcdf,"||",2),2),"^",4)
 	i phcUomId="" trollback
 	q:phcUomId="" -1
 	s err=0
 	s $ZT="Error^DHCSTERROR"			;增加错误处理
 	//1、处理打包主表
 	i rdspid'=""  d
	.s DspID=rdspid
	e  d
	.&sql(insert into dhc_oedispensing(DSP_OEORI_DR,DSP_QtyUOM,
	DSP_Status,DSP_Date,DSP_Time,DSP_User,DSP_ConfirmUser,DSP_Type,
	DSP_Pointer,DSP_DateAdd,DSP_TimeAdd,DSP_AdmLoc_DR,DSP_RecDep_DR,
	DSP_Adm_DR,DSP_OEORE_DR,DSP_DateDosing) values (:oeori,:phcUomId,
	:status,:dd,:tt,:user,:user,:type,:pointer,:dd,:tt,:dept,:recloc,
	:adm,:ordexeid,:datedosing))
	.i SQLCODE'=0  d
	..s ret=$$SqlErrorRecord^DHCSTERROR("InsertDODIS:dhc_oedispensing",retrqitm,SQLCODE_":"_%msg)
	..s err=-2
	.e  d
	..s DspID=$p(%ROWID,$c(1))
	.
	q:err'=0 err
	//2、处理打包子表
	s qty=$p(^RETRQ(retrq,"I",chl),"^",3)
    s qty=##class(web.DHCSTPHARETURN).GetReqItmSurplus(retrqitm)   ;该申请单剩余未退数量
	s phacLbRowId=$p(^RETRQ(retrq,"I",chl),"^",15)
	s phacId=+phacLbRowId
	s phacSubId=+$p(phacLbRowId,"||",2)
	s phacLbId=+$p(phacLbRowId,"||",3)
	s rp=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",3)
	s sp=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",5)
	s inclb=$p(^RETRQ(retrq,"I",chl),"^",16)
 	s DspbStr=DspID_"^"_inclb_"^"_qty_"^"_sp_"^"_rp_"^"_inci_"^"_status
 	s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
 	s InsSQLCODE=$p(RetIns,"^",1)
 	q:InsSQLCODE'=0 -3
 	//3、应计费组要求按照药学项基本单位回写打包主表数量(协定方只写付数)
 	s prescno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14) 	;处方号
 	s CheckXDPresc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckCMXDPTCom(prescno)
 	i CheckXDPresc=3  d											;协定方
	.s rdspqty=+$p(^DHCOEDISQTY(dodis),"^",5)
	.s $p(^DHCOEDISQTY(DspID),"^",2)=rdspqty
 	.s $p(^DHCOEDISQTY(DspID),"^",5)=rdspqty
 	.s $p(^DHCOEDISQTY(DspID),"^",11)=rdspqty
	e  d
 	.s uom=$p(^INCI(inci,1),"^",10)
 	.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,phcUomId)
 	.s:fac="" err=-4
 	.q:fac="" 
 	.s rdspqty=qty*fac
 	.s $p(^DHCOEDISQTY(DspID),"^",2)=+$p($G(^DHCOEDISQTY(DspID)),"^",2)+rdspqty
 	.s $p(^DHCOEDISQTY(DspID),"^",5)=+$p($G(^DHCOEDISQTY(DspID)),"^",5)+rdspqty
 	.s $p(^DHCOEDISQTY(DspID),"^",11)=+$p($G(^DHCOEDISQTY(DspID)),"^",11)+rdspqty
	q:err'=0 err
	q 0
}

/// 插入退费记录
/// Input:申请单号ID
/// Output:0 成功  1 失败
/// Creator:LiangQiang
ClassMethod UpdReqNoRefundStatus(retrq As %String, flag) As %String
{
	n (retrq,flag)
	&sql(update DHC_PhaRetRequestItm set RETRQI_RefundStatus=:flag where RETRQI_Rowid=:retrq )
	q:SQLCODE'=0 -1
	q 0
}

/// 撤消申请单退费
/// Input:申请单号ID
/// Output:0 成功  1 失败
/// Creator:LiangQiang
/// CreatDate:2011-11-23
ClassMethod RevokeReqNoRefundStatus(retrq As %String) As %String
{
	n (retrq)
	s requestdr=retrq
	s oeore=$p(^RETRQ(+retrq,"I",$p(retrq,"||",2)),"^",1)
	s ord=+oeore
	s itm=$p(oeore,"||",2)
	s pay=$p(^OEORD(ord,"I",itm,3),"^",5)
	q:pay="P" -9
    s status=$p(^RETRQ(+retrq),"^",14)
    q:status'="Prove" -11
    s RefundStatus=$p(^RETRQ(+retrq,"I",$p(retrq,"||",2)),"^",12)
    q:RefundStatus'="1" -10
    s dodis=$p(^RETRQ(+retrq,"I",$p(retrq,"||",2)),"^",11) ;配药表id
    s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)   
    s ord=+ordexeid
    s itm=$p(ordexeid,"||",2)
    s ore=$p(ordexeid,"||",3)
    s billstatus=$p(^OEORD(ord,"I",itm,"X",ore),"^",6)
    q:(billstatus="B")||(billstatus="R") -12
    s err=0
    tstart
    s rettype="Y"
    s retrq="R"_retrq
	&sql(delete from  dhc_oedispensing  where DSP_Pointer=:retrq and DSP_Type=:rettype)
	i SQLCODE'=0 s err=SQLCODE
	i err'=0 tro
	q:err'=0 -1
	s err=..UpdReqNoRefundStatus(requestdr,"")
	i err'=0 tro
	q:err'=0 -2
	s newstatus="I"
    &sql(update OE_OrdExec set OEORE_Billed=:newstatus where OEORE_Rowid=:ordexeid)  //(B和R不让撤,否再更成I,和杨艳秀商定,LiangQiang20130522)
    i SQLCODE'=0 s err=SQLCODE
	i err'=0 tro
	q:err'=0 -3
	tcommit 
	q 0
}

ClassMethod CreateReqLog(reqno, content, regnostr) As %String
{
	s tmpEncryptCode=0
	s len=$l(regnostr,"&")
	f ind=1:1:len  d
	.s regno=$p(regnostr,"&",ind)
	.s papmi=$o(^PAPERi("PAPMI_PatNo",regno,""))
	.s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 	.s EncryptCode=$p(EncryptLevelInfo,"^",3)
 	.i tmpEncryptCode<EncryptCode s tmpEncryptCode=EncryptCode 	
 	s content=content_"^"_regnostr
	s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("请求单号",reqno)
 	s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("接收科室^病区^登记号",content)
 	s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPREQPRT",condition,content,tmpEncryptCode)
 	q eventlogret
}

/// Description: 退药申请是否含有某状态数据
/// Debug:		 w ##class(web.DHCSTPHARETURN2).IsReqHasStatus(25,'Refuse')
ClassMethod IsReqHasStatus(req, status)
{
	&SQL(
		SELECT RETRQI_Rowid 
		FROM SQLUSER.DHC_PhaRetRequestItm WHERE RETRQI_RETRQ_ParRef = :req AND RETRQI_Status = :status
	)
	q:(SQLCODE = 0) "Y"
	q "N"
}

}
