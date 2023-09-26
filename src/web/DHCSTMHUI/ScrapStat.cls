Import sqluser

/// Descript:库存报损统计
/// Creater:    caoting
/// CreateDate:	2012-12-02
/// 
Class web.DHCSTMHUI.ScrapStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	库存报损统计
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	库存报损统计
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ScrapStat","ScrapStatPrt","{""Loc"":""163"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""StartDate"":""01/03/2021"",""EndDate"":""10/03/2021"",""ScgStk"":"""",""ScrapReason"":"""",""Inci"":"""",""InciDesc"":""""}")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ScrapStat","ScrapStatPrt","{""Loc"":"""",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""StartDate"":""01/03/2021"",""EndDate"":""10/03/2021"",""ScgStk"":"""",""ScrapReason"":"""",""Inci"":"""",""InciDesc"":""""}")
Query ScrapStatPrt(Params As %Text) As Query(ROWSPEC = "Inci,InciCode,InciDesc,UomDesc,ScrapQty:%Float,Sp:%Float,Rp:%Float,SpAmt:%Float,RpAmt:%Float,Manf,Spec,LocDesc") [ SqlProc ]
{
}

ClassMethod ScrapStatPrtExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
 	n (qHandle,Params)
 	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("Loc")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkType=..sssCode()
	s ItmDr=PJObj.%Get("Inci")
	s ReasonDr=PJObj.%Get("ScrapReason")
	s StkGrpType=PJObj.%Get("ScgStk")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s SelScrapIfEmptyLoc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTINSCRAPM","SelScrapIfLocEmpty",Param)  ;科室为空时能否查报损数据
	q:(SelScrapIfEmptyLoc="N")&&(Loc="") $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
 	s pid=..NewPid()
 
 	f Date=StartDate:1:EndDate  d
 	.s INTR=""
 	.f  s INTR=$o(^DHCINTR(0,"TypeDate","D",Date,INTR))  Q:INTR=""  D
 	..s TrPointer=$p(^DHCINTR(INTR),"^",9)
 	..s ScrapDr=+TrPointer
 	..s reasondr=$p(^DHCINSP(ScrapDr),"^",4)
 	..q:(ReasonDr'="")&(reasondr'=ReasonDr)
 	..s scgdr=$p(^DHCINSP(ScrapDr),"^",13)
 	..q:(StkGrpType'="")&(scgdr'=StkGrpType)
 	..s stktypedr=$p(^DHCINSP(ScrapDr),"^",15)
 	..q:(StkType'="")&(stktypedr'=StkType)
 	..s locdr=$p(^DHCINSP(ScrapDr),"^",5)
 	..q:(Loc'="")&(locdr'=Loc)
 	..s ScrapSub=$P(TrPointer,"||",2)
 	..s INCI=$p(^DHCINTR(INTR),"^",15)
 	..q:(ItmDr'="")&(INCI'=ItmDr)
 	..s INCLB=$p(^DHCINTR(INTR),"^",7) 
 	..s ILSub=$p(INCLB,"||",2)
 	..q:'$d(^INCI(INCI))
 	..s LocDr=$p(^INCI(INCI,"IL",ILSub),"^",1)
 	..s InciCode=$p(^INCI(INCI,1),"^",1)
 	..s InciDesc=$p(^INCI(INCI,1),"^",2)
 	..s buomdr=$p(^INCI(INCI,1),"^",10)
 	..q:(ItmDr'="")&(ItmDr'=INCI)
 	..s mdata=^DHCINSP(ScrapDr,"I",ScrapSub)
 	..s Qty=$p(mdata,"^",3)	//报损单位数量
 	..s Sp=$p(mdata,"^",8)		//报损单位售价
 	..s Uomdr=$p(mdata,"^",2)	//报损单位
 	..s SpAmt=$p(mdata,"^",9)	//售价金额
 	..s Rp=$p(mdata,"^",4)		//进价
 	..s RpAmt=$p(mdata,"^",5)	//进价金额
 	..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uomdr,buomdr)
 	..s bSp=Sp/fac
 	..s bRp=Rp/fac
 	..s Qty=Qty*fac
 	..s UomDesc=$P($G(^CT("UOM",buomdr)),"^",2)  ;数量单位都转化为基本单位
 	..s ManfStr=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(INCI)
 	..s ManfDesc=$P(ManfStr,"^",3)
 	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(InciCode,INCI)
 	..s LocDesc=""
 	..s:locdr'="" LocDesc=$p(^CTLOC(locdr),"^",2)
 	..s index=INCI_"^"_ManfDesc_"^"_bSp_"^"_bRp_"^"_locdr
 	..i $d(^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",index)) d
 	...s $p(^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",index),"^",5)=$p(^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",index),"^",5)+Qty
 	...s $p(^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",index),"^",7)=$p(^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",index),"^",7)+SpAmt
 	...s $p(^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",index),"^",9)=$p(^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",index),"^",9)+RpAmt
 	..e  d
 	...s ^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",index)=INCI_"^"_InciCode_"^"_InciDesc_"^"_UomDesc_"^"_Qty_"^"_Sp_"^"_SpAmt_"^"_Rp_"^"_RpAmt_"^"_ManfDesc_"^"_Spec_"^"_LocDesc
 
 	s h=""
 	f  s h=$o(^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",h)) q:h=""  d
 	.s Sdata=^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid,"index",h)
 	.s Inci=$P(Sdata,"^",1)
 	.s InciCode=$P(Sdata,"^",2)
 	.s InciDesc=$P(Sdata,"^",3)
 	.s UomDesc=$P(Sdata,"^",4)
 	.s ScrapQty=$P(Sdata,"^",5)
 	.s Sp=$P(Sdata,"^",6)
 	.s Rp=$P(Sdata,"^",8)
 	.s SpAmt=$P(Sdata,"^",7)
 	.s RpAmt=$P(Sdata,"^",9)
 	.s Manf=$P(Sdata,"^",10)
 	.s Spec=$P(Sdata,"^",11)
 	.s LocDesc=$P(Sdata,"^",12)
 	.d OutPutRow
 	k ^TMP("DHCSTM","ScrapStat","ScrapStatPrt",pid)
 	Quit $$$OK
OutPutRow
 	s Data=$lb(Inci,InciCode,InciDesc,UomDesc,ScrapQty,Sp,Rp,SpAmt,RpAmt,Manf,Spec,LocDesc)   
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

}
