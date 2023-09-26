Import sqluser

/// Descript:	订单汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
Class web.DHCSTMHUI.InPoStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	订单汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		IN_Po,In_PoItm
/// Input:		排序，查询条件
/// Return：	订单汇总信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.InPoStat","InPoStat","{""PoLoc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""13/09/2016"",""EndDate"":""13/09/2018"",""StkScg"":"""",""Vendor"":"""",""Inci"":"""",""InciDesc"":""""}")	
Query InPoStat(Params As %Text) As Query(ROWSPEC = "inpo,vendorid,vendorname,inci,incicode,incidesc,spec,qty:%Float,buom,uomdesc,rpamt:%Float,reqloc,UnitCost:%Float,PurNo,PurDate,Model,IngrNo,RecQty:%Float,RpAmt:%Float,PoStatusDesc") [ SqlProc ]
{
}

ClassMethod InPoStatExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("PoLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s Vendor=PJObj.%Get("Vendor")
	s Inci=PJObj.%Get("Inci")
	
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	
	q:Loc="" $$$OK
	q:StartDate="" $$$OK
 	q:EndDate="" $$$OK
 
 	f Date=StartDate:1:EndDate  d
 	.s inpo=""
 	.f  s inpo=$o(^INPO(0,"Date",Date,inpo)) q:inpo=""  d
 	..s comp=""
 	..s comp=$p(^INPO(inpo),"^",9)
 	..q:comp'="Y"
 	..s dhcinpo=""
 	..s dhcinpo=$o(^DHCINPO(0,"INPO",inpo,""))
 	..s locdr=""
 	..s:dhcinpo'="" locdr=$p(^DHCINPO(dhcinpo),"^",2)
 	..q:(Loc'="")&&(locdr'=Loc)
 	..s scg=""
 	..s scg=$p(^DHCINPO(dhcinpo),"^",3)
 	..s vendorid="",vendorname=""
 	..s vendorid=$p(^INPO(inpo),"^",2)
 	..q:(Vendor'="")&&(vendorid'=Vendor)
 	..s:vendorid'="" vendorname=$p(^APC("APCVM",vendorid),"^",3)
 	..s reqlocdr="",reqloc=""
 	..s reqlocdr=$p(^DHCINPO(dhcinpo),"^",5)  ;请求科室
 	..s:reqlocdr'="" reqloc=$p(^CTLOC(reqlocdr),"^",2)     ;请求科室
 	..s PoStatus=##class(web.DHCSTMHUI.INPO).GetPoStatus(inpo)
 	..s PoStatusDesc=$s(PoStatus=0:"未入库",PoStatus=1:"部分入库",PoStatus:"全部入库",1:"")
 	..s ch=""
 	..f  s ch=$o(^INPO(inpo,"POI",ch)) q:ch=""  d
 	...s inci=$p(^INPO(inpo,"POI",ch),"^",1)
 	...s InpoItmId=inpo_"||"_ch
 	...q:(Inci'="")&&(inci'=Inci)
 	...s CanceledFlag="N"
 	...s dhcinpoi=$o(^DHCINPOI(0,"INPOI",InpoItmId,""))
 	...s CanceledFlag=$p(^DHCINPOI(dhcinpoi),"^",4)
 	...q:CanceledFlag="Y"
 	...s qty=$p(^INPO(inpo,"POI",ch),"^",7)
 	...s ctuom=$p(^INPO(inpo,"POI",ch),"^",3)
 	...s UnitCost=$p(^INPO(inpo,"POI",ch),"^",4)
 	...s rpamt=$p(^INPO(inpo,"POI",ch),"^",5)
 	...;数量转化为基本单位
 	...s buom=$P(^INCI(inci,1),"^",10)
 	...s fac=##Class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(ctuom,buom)
 	...s qty=qty*fac
 	...s uomdesc=$P($G(^CT("UOM",buom)),"^",2)
 	...s incicode=$p(^INCI(inci,1),"^",1)
 	...s incidesc=$p(^INCI(inci,1),"^",2)
 	...s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(incicode,inci)
 	...s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci)
 	...s PurInfo=##class(web.DHCSTMHUI.INPO).GetPlanItmInfo(InpoItmId)
 	...s PurNo=$p(PurInfo,"^",5)
 	...s PurDate=$p(PurInfo,"^",6)
 	...s Ingr=0
	...f  s Ingr=$o(^DHCINGR(0,"PODR",InpoItmId,Ingr)) q:Ingr=""  d
	....q:'$d(^DHCINGR(Ingr))
	....s IngrNo=$p(^DHCINGR(Ingr),"^",1)
	....s Chl=0
	....f  s Chl=$o(^DHCINGR(0,"PODR",InpoItmId,Ingr,Chl)) q:Chl=""  d
	.....s Inclb=$p(^DHCINGR(Ingr,"GRI",Chl),"^",1)
	.....s RecQty=$p(^DHCINGR(Ingr,"GRI",Chl),"^",4)
	.....s RpAmt=$p(^DHCINGR(Ingr,"GRI",Chl),"^",31)
	.....s RecUomId=$p(^DHCINGR(Ingr,"GRI",Chl),"^",10)
	.....s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(RecUomId,buom)
	.....s RecQty=RecQty*Fac1
	.....s RpAmt=RpAmt*Fac1
 	.....d OutPutRow
 	Quit $$$OK
OutPutRow
 	S Data=$lb(inpo,vendorid,vendorname,inci,incicode,incidesc,spec,qty,buom,uomdesc,rpamt,reqloc,UnitCost,PurNo,PurDate,Model,IngrNo,RecQty,RpAmt,PoStatusDesc)   
 	S ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

}
