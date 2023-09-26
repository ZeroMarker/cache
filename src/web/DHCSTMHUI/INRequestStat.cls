Import sqluser

/// Descript: 库存请求统计
/// Creater: zhangxiao
/// CreateDate:	2015-03-26
/// 
Class web.DHCSTMHUI.INRequestStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	库存请求统计
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		IN_Request
/// Input:		排序，查询条件
/// Return：	库存请求统计
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INRequestStat","INRequestStatPrt","{""Loc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""21/09/2016"",""EndDate"":""21/09/2018"",""ScgStk"":"""",""Inci"":"""",""InciDesc"":""""}")	
Query INRequestStatPrt(Params As %Text) As Query(ROWSPEC = "inci,incicode,incidesc,spec,qty:%Float,uomdr,UomDesc,BuomQty:%Float,scgDesc,VendorDesc,date,Reclocdr,RecLocDesc,rp:%Float,rpAmt:%Float") [ SqlProc ]
{
}

ClassMethod INRequestStatPrtExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
 	n (qHandle,Params)
 	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("Loc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrpType=PJObj.%Get("ScgStk")
	s ItmDr=PJObj.%Get("Inci")
	s ItmDesc=PJObj.%Get("InciDesc")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	
 	s pid=..NewPid()

 	f Date=StartDate:1:EndDate  d
 	.s INRQ=""
 	.f  s INRQ=$o(^INRQ(0,"Date",Date,INRQ)) q:INRQ=""  D
 	..s locdr=$p(^INRQ(INRQ),"^",5)  ;供给科室id
 	..q:(Loc'="")&(locdr'=Loc)        ;供给科室判断
 	..s Complate=$p(^INRQ(INRQ),"^",8) ;完成标志
 	..q:Complate'="Y"
 	..;过滤模板数据
 	..s template=""
 	..&sql(select inrq_template  into:template  from DHC_INRequest where INRQ_INRQ_DR=:INRQ)
 	..q:template="Y" 
 	..;过滤模板数据
 	..s DHCINRQ=""
 	..s DHCINRQ=$O(^DHCINRQ(0,"INRQ",INRQ,DHCINRQ))
 	..s AuditDate=$p(^DHCINRQ(DHCINRQ),"^",12)
 	..s ProvAuditDate=$p(^DHCINRQ(DHCINRQ),"^",15)
 	..q:(AuditDate="")!(ProvAuditDate="")
 	..s scgdr=$P(^DHCINRQ(DHCINRQ),"^",10)
 	..q:(StkGrpType'="")&(scgdr'=StkGrpType)
 	..s Reclocdr=$p(^INRQ(INRQ),"^",6)
 	..s INRQI=""
 	..f  s INRQI=$O(^INRQ(INRQ,"RQI",INRQI)) q:INRQI=""  D
 	...s INCI=$P(^INRQ(INRQ,"RQI",INRQI),"^",4)
 	...q:(ItmDr'="")&(INCI'=ItmDr)
 	...s InciDesc=$p(^INCI(INCI,1),"^",2)
 	...q:(ItmDesc'="")&(InciDesc'[ItmDesc)
 	...s CTUOM=$P(^INRQ(INRQ,"RQI",INRQI),"^",5)
 	...s QTY=$P(^INRQ(INRQ,"RQI",INRQI),"^",3)
 	...s BUOM=$P(^INCI(INCI,1),"^",10)
 	...s Fac=##Class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CTUOM,BUOM)
 	...s QTY=QTY*Fac   ;所有请求数量全部折算成基本单位的库存数量
 	...i $d(^TMP("DHCSTM","INRequestStat","INRequestStatPrt",pid,"INCI",INCI)) d
 	....s $p(^TMP("DHCSTM","INRequestStat","INRequestStatPrt",pid,"INCI",INCI),"^",2)=$p(^TMP("DHCSTM","INRequestStat","INRequestStatPrt",pid,"INCI",INCI),"^",2)+QTY
 	...e  d
 	....s ^TMP("DHCSTM","INRequestStat","INRequestStatPrt",pid,"INCI",INCI)=INCI_"^"_QTY_"^"_BUOM_"^"_Date_"^"_Reclocdr

	s h=""
 	f  s h=$o(^TMP("DHCSTM","INRequestStat","INRequestStatPrt",pid,"INCI",h)) q:h=""  d
 	.s data=^TMP("DHCSTM","INRequestStat","INRequestStatPrt",pid,"INCI",h)
 	.s inci=$p(data,"^",1)
 	.s qty=$p(data,"^",2)
 	.s uomdr=$p(data,"^",3)
 	.s date=..DL2H($p(data,"^",4))
 	.s Reclocdr=$p(data,"^",5)
 	.s UomDesc=$P($G(^CT("UOM",uomdr)),"^",2)
 	.s RecLocDesc=$p(^CTLOC(Reclocdr),"^",2)
 	.s incicode=$p(^INCI(inci,1),"^",1)
 	.s incidesc=$p(^INCI(inci,1),"^",2)
 	.s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(incicode,inci)
 	.s scgDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",2)
 	.s VendorDesc=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastVen(inci),"^",2)
 	.s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(inci,uomdr)
 	.s rpAmt=rp*qty
 	.s BuomQty=##Class(web.DHCSTMHUI.Common.DrugStkCommon).IL(inci,Loc,+$H)  ;基本单位的库存数量
 	.d OutPutRow

 	k ^TMP("DHCSTM","INRequestStat","INRequestStatPrt",pid)
 	Quit $$$OK
OutPutRow
 	s Data=$lb(inci,incicode,incidesc,spec,qty,uomdr,UomDesc,BuomQty,scgDesc,VendorDesc,date,Reclocdr,RecLocDesc,rp,rpAmt)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

/// Descript:	库存请求统计
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		IN_Request
/// Input:		排序，查询条件
/// Return：	库存请求统计
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INRequestStat","INRequestStat","2015-03-26","2015-03-26","153","","")	
Query INRequestStat(Params As %Text) As Query(ROWSPEC = "inci,incicode,incidesc,spec,qty:%Float,uomdr,UomDesc,BuomQty:%Float,scgDesc,VendorDesc,date,Reclocdr,RecLocDesc,rp:%Float,rpAmt:%Float") [ SqlProc ]
{
}

ClassMethod INRequestStatExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
 	n (qHandle,Params)
 	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("Loc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrpType=PJObj.%Get("ScgStk")
	s ItmDr=PJObj.%Get("Inci")
	s ItmDesc=PJObj.%Get("InciDesc")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	
 	q:Loc="" ""
 	q:StartDate="" ""
 	q:EndDate="" ""
 
 	f Date=StartDate:1:EndDate  d
 	.s INRQ=""
 	.f  s INRQ=$o(^INRQ(0,"Date",Date,INRQ)) q:INRQ=""  D
 	..s locdr=$p(^INRQ(INRQ),"^",5)  ;供给科室id
 	..q:(Loc'="")&(locdr'=Loc)        ;供给科室判断
 	..s Complate=$p(^INRQ(INRQ),"^",8) ;完成标志
 	..q:Complate'="Y"
 	..;过滤模板数据
 	..s template=""
 	..&sql(select inrq_template  into:template  from DHC_INRequest where INRQ_INRQ_DR=:INRQ)
 	..q:template="Y" 
 	..;过滤模板数据
 	..s DHCINRQ=""
 	..s DHCINRQ=$O(^DHCINRQ(0,"INRQ",INRQ,DHCINRQ))
 	..s AuditDate=$p(^DHCINRQ(DHCINRQ),"^",12)
 	..s ProvAuditDate=$p(^DHCINRQ(DHCINRQ),"^",15)
 	..q:(AuditDate="")!(ProvAuditDate="")
 	..s scgdr=$P(^DHCINRQ(DHCINRQ),"^",10)
 	..q:(StkGrpType'="")&(scgdr'=StkGrpType)
 	..s Reclocdr=$p(^INRQ(INRQ),"^",6)
 	..s INRQI=""
 	..f  s INRQI=$O(^INRQ(INRQ,"RQI",INRQI)) q:INRQI=""  d
 	...s INCI=$P(^INRQ(INRQ,"RQI",INRQI),"^",4)
 	...q:(ItmDr'="")&(INCI'=ItmDr)
 	...s InciDesc=$p(^INCI(INCI,1),"^",2)
 	...;q:(ItmDesc'="")&(InciDesc'[ItmDesc)
 	...s CTUOM=$P(^INRQ(INRQ,"RQI",INRQI),"^",5)
 	...s QTY=$P(^INRQ(INRQ,"RQI",INRQI),"^",3)
 	...s BUOM=$P(^INCI(INCI,1),"^",10)
 	...s Fac=##Class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(CTUOM,BUOM)
 	...s QTY=QTY*Fac   ;所有请求数量全部折算成基本单位的库存数量
 	...s UomDesc=$P($G(^CT("UOM",BUOM)),"^",2)
 	...s RecLocDesc=$p(^CTLOC(Reclocdr),"^",2)
 	...s incicode=$p(^INCI(INCI,1),"^",1)
 	...s incidesc=$p(^INCI(INCI,1),"^",2)
 	...s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(incicode,INCI)
 	...s scgDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(INCI),"^",2)
 	...s VendorDesc=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastVen(INCI),"^",2)
 	...s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(INCI,BUOM)
 	...s rpAmt=rp*QTY
 	...s BuomQty=##Class(web.DHCSTMHUI.Common.DrugStkCommon).IL(INCI,Loc,+$H)  ;基本单位的库存数量
	...s Datetmp=..DL2H(Date)
 	...d OutPutRow1
 	Quit $$$OK
OutPutRow1
 	s Data=$lb(inci,incicode,incidesc,spec,QTY,uomdr,UomDesc,BuomQty,scgDesc,VendorDesc,Datetmp,Reclocdr,RecLocDesc,rp,rpAmt)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

}
