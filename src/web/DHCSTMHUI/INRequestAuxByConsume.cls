Import sqluser

Class web.DHCSTMHUI.INRequestAuxByConsume Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 根据消耗检索需要请求的药品
/// Author:zhwh
/// Date:2012-07-19
/// Argu:
///  ToLoc - 请求科室rowid
///  StartDate - 起始日期
///  EndDate - 截止日期
///  Days - 参考天数
///  SCG - 类组rowid
///  FrLoc - 供应科室rowid
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INRequestAuxByConsume","LocItmForReq","","",^tmpxu)
Query LocItmForReq(Params As %String) As Query(ROWSPEC = "Inci,Code,Description,Spec,Manf,Uom,UomDesc,StkQty:%Float,AvaQty:%Float,DailyDispQty:%Float,ReqQtyAll,Qty:%Float,DispQtyAll,HvFlag")
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
	
	s StartDate=..DH2L(StartDate),EndDate=..DH2L(EndDate)
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
	.s DispQtyAll=..TotalItmDisp(Incil,StartDate,EndDate)
	.;w DispQtyAll 
	.q:DispQtyAll'<0 
	.s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,pToLoc,+$h)
	.s AvaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB(Incil,"")
	.s DailyDispQty=(-DispQtyAll)/DispDays
	.s ReqQtyAll=DailyDispQty*pDays
	.q:(AvaQty>ReqQtyAll)
	.s Code=$p(^INCI(Inci,1),"^",1)
	.s Description=$p(^INCI(Inci,1),"^",2)
	.s BUom=$p(^INCI(Inci,1),"^",10)
	.s Uom=$p(^INCI(Inci,3),"^",6)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
	.s Qty=ReqQtyAll-AvaQty
	.i Qty<0 s Qty=0
	.//按换算单位换算数量
	.s DailyDispQty=$fn(DailyDispQty/Fac,"",2)  ;日发药量
	.s ReqQtyAll=$fn(ReqQtyAll/Fac,"",2)  ;days天需求量
	.s StkQty=$fn(StkQty/Fac,"",2)  ;dhc 库存
	.s AvaQty=$fn(AvaQty/Fac,"",2)  ;可用开医嘱量
	.s Qty=$fn(Qty/Fac,"",0)     ;建议申请量
	.s UomDesc=$p(^CT("UOM",Uom),"^",2)
	.s DispQtyAll=$fn((-DispQtyAll)/Fac,"",2)  ;日期范围内发药总量 2007-01-05
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci),"^",3)
    .s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
    .q:pHvFlag'=HvFlag
	.d OutPutRow
	.
	Quit $$$OK
OutPutRow
	s Data=$lb(Inci,Code,Description,Spec,Manf,Uom,UomDesc,StkQty,AvaQty,DailyDispQty,ReqQtyAll,Qty,DispQtyAll,HvFlag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 统计销售
/// Author:zhwh
/// Date:2012-07-19
/// Argu:
///  Incil - 科室库存项rowid
///  StartDate - 起始日期
///  EndDate - 截止日期
/// Return:
///   销售数量  
ClassMethod TotalItmDisp(Incil As %String, StartDate As %String, EndDate As %String)
{
	n ( Incil,StartDate,EndDate)
	s Types="MP^MY^MF^MH"
	s Uom=$p(^INCI(+Incil,1),"^",10) q:Uom="" 0
	s TotalQty=0,DispQty=0
	f i=1:1:$l(Types,"^") d
	.s TrType=$P(Types,"^",i)
	.f Date=StartDate:1:EndDate  d
	..s Intr=""
	..f  s Intr=$o(^DHCINTR(0,"ILTYPEDATE",Incil,TrType,Date,Intr)) q:Intr=""  d
	...s DispUom=$p(^DHCINTR(Intr),"^",10)
	...s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(DispUom,Uom) 
	...s DispQty=$p(^DHCINTR(Intr),"^",6)
	...s DispQty=DispQty*Fac
	...s TotalQty=TotalQty+DispQty
	q TotalQty
}

}
