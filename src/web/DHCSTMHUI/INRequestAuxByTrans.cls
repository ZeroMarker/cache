Import sqluser

Class web.DHCSTMHUI.INRequestAuxByTrans Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 检索需要请求的库存项目列表
/// Author:XuChao
/// Argu:
/// Return:
///  待申请项目列表
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INRequestAuxByTrans","LocItmForReq","","",^tmpxu)
Query LocItmForReq(Params As %String) As Query(ROWSPEC = "Inci,Code,Description,Spec,Manf,Uom,UomDesc,StkQty:%Float,AvaQty:%Float,DailyDispQty:%Float,ReqQtyAll:%Float,Qty:%Float,HvFlag")
{
}

ClassMethod LocItmForReqExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")	//起始日期
	s EndDate=PJobj.%Get("EndDate")			//截止日期
	s pToLoc=PJobj.%Get("ReqLoc")			//申请部门 
	s pFrLoc=PJobj.%Get("SupLoc")			//供给部门
	s pDays=PJobj.%Get("Days")
	s pHvFlag=PJobj.%Get("HvFlag")
	s pScgStk=PJobj.%Get("ScgStk")
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	q:pToLoc="" $$$OK
	q:pDays="" $$$OK
	
	s StartDate=..DH2L(StartDate),EndDate=..DH2L(EndDate),pknum=0
	s DispDays=EndDate-StartDate+1
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",pToLoc,Inci)) q:+Inci=0  d
	.s Ch=$o(^INCI("IL_LOC",pToLoc,Inci,""))
	.s Incil=Inci_"||"_Ch
	.q:$p($g(^INCI(Inci,2)),"^",9)="Y"   //过滤"不可用"项 zhwh, 2011-06-22
	.i pFrLoc'="" q:$o(^INCI("IL_LOC",pFrLoc,Inci,""))=""  //若供应科室无此库存项则不予请求  zhwh, 2011-06-22
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.s ScgStk=$p(StkGrpInfo,"^",5)
	.q:ScgType'=..sssCode()
	.q:(pScgStk'="")&(("^"_pScgStk_"^")'[("^"_ScgStk_"^"))
	.s DispQty=..TotalItmTransIn(Incil,StartDate,EndDate)
	.q:DispQty<=0  
	.s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,pToLoc,+$h)
	.s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB(Incil,"")   //可用数
	.s DailyDispQty=DispQty/DispDays
	.s ReqQtyAll=DailyDispQty*pDays
	.q:AvaQty>ReqQtyAll
	.s Code=$p(^INCI(Inci,1),"^",1)
	.s Description=$p(^INCI(Inci,1),"^",2)
	.s BUom=$p(^INCI(Inci,1),"^",10)
	.s Uom=$p(^INCI(Inci,3),"^",6)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
	.s Qty=ReqQtyAll
	.s DailyDispQty=$fn(DailyDispQty/Fac,"",4) ;日发药量
	.s ReqQtyAll=$fn(ReqQtyAll/Fac,"",2)  ;days天需求量
	.s StkQty=$fn(StkQty/Fac,"",2)  ;dhc 库存
	.s AvaQty=$fn(AvaQty/Fac,"",2) ;可用开医嘱量
	.s Qty=$fn(Qty/Fac,"",0)     ;建议申请量
	.s UomDesc=$p(^CT("UOM",Uom),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci),"^",3)
    .s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
    .q:pHvFlag'=HvFlag	
	.d OutPutRow
	Quit $$$OK

OutPutRow
	s Data=$lb(Inci,Code,Description,Spec,Manf,Uom,UomDesc,StkQty,AvaQty,DailyDispQty,ReqQtyAll,Qty,HvFlag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 统计某科室库存项某日期范围内的转移入库数量
/// Argu：
///   incil - 科室库存rowid
///    StartDate  -起始日期
///    EndDate  -截止日期
/// Return:
///   转移入库数量合计(基本单位)
ClassMethod TotalItmTransIn(Incil As %String, StartDate As %String, EndDate As %String) As %String
{
 n (Incil,StartDate,EndDate)
 s Uom=$p(^INCI(+Incil,1),"^",10) q:Uom="" 0
 s TotalQty=0,TrQty=0
 f Date=StartDate:1:EndDate  d
 .s Intr=0
 .f  s Intr=$o(^DHCINTR(0,"ILTYPEDATE",Incil,"K",Date,Intr)) q:Intr=""  d    ; get INTR
 ..q:($p(^DHCINTR(Intr),"^",1)'="K")
 ..s TrUom=$p(^DHCINTR(Intr),"^",10)  ; dispensing uom
 ..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,Uom) ; factor 
 ..s TrQty=$p(^DHCINTR(Intr),"^",6)   ;dispensing qty
 ..s TrQty=TrQty*Fac
 ..s TotalQty=TotalQty+TrQty  ; total of qty in basic uom
 q TotalQty
}

}
