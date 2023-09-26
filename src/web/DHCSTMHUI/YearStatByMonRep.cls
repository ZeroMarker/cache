Import sqluser

Class web.DHCSTMHUI.YearStatByMonRep Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.YearStatByMonRep","YearStatByMonRep",153,2014)
/// 根据月报数据进行年份统计(进价)
/// OutPut:
/// 月份,类组id,类组描述,inciCode,inciDesc,
/// 规格,单位,结余数量,结余金额,上次结余数量,
/// 上次结余金额,入库数量,入库金额,退货数量,退货金额
/// 转出数量, 转出金额,转入数量,转入金额,调整数量,
/// 调整金额,消耗数量,消耗金额,报损数量,报损金额,
/// 住院发放量,住院发放金额,调价损益数量,住院退药数量,住院退药金额,
/// 门诊发放数量,门诊发放金额,门诊非正常发放数量,门诊非正常发放金额,门诊退药数量,
/// 门诊退药金额,门诊非正常退药数量,门诊非正常退药金额,捐赠入库数量,捐赠入库金额,
/// 捐赠出库数量,捐赠出库金额,调价换票入库数量,调价换票入库金额,调教换票退货数量,
/// 调价换票退货金额,退货调价损益金额,住院退药调价损益,mRecQty,mRecAmt,
/// 盘点调整数量,盘点调整金额,制剂消耗数量,制剂消耗金额,制剂生成数量,
/// 制剂生成金额,门诊退药调价损益,转入调价损益,In合计,Out合计
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.YearStatByMonRep","YearStatByMonRep",3,"")
Query YearStatByMonRep(PhaLoc As %String, Year As %String, StMonth As %String, EdMonth As %String) As Query(ROWSPEC = "MonthNum,stkGrp,stkGrpDesc,inciCode,inciDesc,spec,uomDesc,qty:%Float,amt:%Float,lastQty:%Float,lastAmt:%Float,recQty:%Float,recAmt:%Float,retQty:%Float,retAmt:%Float,trOutQty:%Float,trOutAmt:%Float,trInQty:%Float,trInAmt:%Float,adjQty:%Float,adjAmt:%Float,csmQty:%Float,csmAmt:%Float,disposeQty:%Float,disposeAmt:%Float,phaInDspQty:%Float,phaInDspAmt:%Float,aspAmt:%Float,phaInRetQty:%Float,phaInRetAmt:%Float,phaOutDspQty:%Float,phaOutDspAmt:%Float,phaOutDspQtyS:%Float,phaOutDspAmtS:%Float,phaOutRetQty:%Float,phaOutRetAmt:%Float,phaOutRetQtyZ:%Float,phaOutRetAmtZ:%Float,giftRecQty:%Float,giftRecAmt:%Float,giftTrOutQty:%Float,giftTrOutAmt:%Float,chgRecQty:%Float,chgRecAmt:%Float,chgRetQty:%Float,chgRetAmt:%Float,retAspAmt:%Float,phaRetAspAmt:%Float,mRecQty:%Float,mRecAmt:%Float,stktkAdjQty:%Float,stktkAdjAmt:%Float,manuXQty:%Float,manuXAmt:%Float,manuMQty:%Float,manuMAmt:%Float,phaOutRetAspAmt:%Float,trInAspAmt:%Float,InAmt:%Float,OutAmt:%Float,stkCatDesc") [ SqlProc ]
{
}

ClassMethod YearStatByMonRepExecute(ByRef qHandle As %Binary, PhaLoc As %String, Year As %String, StMonth As %String, EdMonth As %String) As %Status
{
 n (qHandle, PhaLoc, Year,StMonth,EdMonth)
 s ^tmpli("YearStatByMonRep")=$lb(PhaLoc, Year)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 i StMonth="" s StMonth="01"
 i EdMonth="" s EdMonth="12"
 i Year="" s Year=$p($zd(+$h,3),"-",1)
 s StartDate=$zdh(Year_"-"_StMonth_"-01",3)
 s EndDate=$zdh(Year_"-"_EdMonth_"-28",3)
 &sql(declare MonRepCursor cursor for 
	select DHCSM_Month,%id  from dhc_stkmon
	where DHCSM_CTLOC_DR=:PhaLoc and (DHCSM_Month>=:StartDate and DHCSM_Month<=:EndDate )
	order by DHCSM_Month)	
 &sql(open MonRepCursor)
 f  &sql(fetch MonRepCursor into :RepMonth,:sm) q:SQLCODE  d
 .s MonthNum=$p($zd(RepMonth,3),"-",2)		;月份数字
 .s ch=""
 .f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
 ..s smr=sm_"||"_ch
 ..s row=^DHCSM(sm,"R",ch)
 ..s inci=$p(row,"^",3)  ;inci   .  
 ..s inciCode=$p(^INCI(inci,1),"^",1)		;inci code
 ..s inciDesc=$p(^INCI(inci,1),"^",2)		;inci desc
 ..
 ..s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 ..s stkGrpDesc=$p(stkgrpinfo,"^",2)
 ..s stkGrp=$p(stkgrpinfo,"^",5)
 ..;q:(stkgrpid'="")&(stkGrp'=stkgrpid)
 ..s stkcat=$p(^INCI(inci,2),"^",2)
 ..s stkCatDesc=$p(^INC("SC",stkcat),"^",2)
 ..;q:(stkcatid'="")&(stkcat'=stkcatid)  
 ..;q:(incdesc'="")&('$f(inciDesc,incdesc))
 ..
 ..s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
 ..s inciuomdr=$p(^INCI(inci,1),"^",10)	;uom dr
 ..s puruom=$p(^INCI(inci,3),"^",6)		;purch uom dr 
 ..i puruom="" s puruom=inciuomdr
 ..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puruom,inciuomdr)
 ..s uomDesc=$p(^CT("UOM",puruom),"^",2)	;uom desc
 ..s qty=$p(row,"^",6)					;qty
 ..s qty=qty/fac
 ..s amt=$p(row,"^",8)					;amount
 ..s lastQty=$p(row,"^",9)				;qty of last month
 ..s lastQty=lastQty/fac
 ..s lastAmt=$p(row,"^",11)				;amount of last month
 ..
 ..s stat=$o(^SMSTATI(0,"SMR",smr,""))
 ..q:stat=""
 ..s stats=$G(^SMSTATI(stat))
 ..
 ..s recQty=$P(stats,"^",2)/fac			;入库数量
 ..s recAmt=$P(stats,"^",3)				;入库金额
 ..s retQty=$P(stats,"^",4)/fac			;退货数量
 ..s retAmt=$P(stats,"^",5)				;退货金额
 ..s trOutQty=$P(stats,"^",6)/fac		;转出数量
 ..s trOutAmt=$P(stats,"^",7)			;转出金额
 ..s trInQty=$P(stats,"^",8)/fac		;转入数量
 ..s trInAmt=$P(stats,"^",9)			;转入金额
 ..s adjQty=$P(stats,"^",10)/fac		;库存调整数量
 ..s adjAmt=$P(stats,"^",11)			;库存调整金额
 ..s csmQty=$P(stats,"^",12)/fac		;消耗数量
 ..s csmAmt=$P(stats,"^",13)			;消耗金额
 ..s disposeQty=$P(stats,"^",14)/fac	;报损数量
 ..s disposeAmt=$P(stats,"^",15)		;报损金额
 ..s phaInDspQty=$P(stats,"^",16)/fac	;发药数量(住院)
 ..s phaInDspAmt=$P(stats,"^",17)		;发药金额(住院)
 ..s aspAmt=$P(stats,"^",18)			;调价损益金额
 ..s phaInRetQty=$P(stats,"^",19)/fac	;退药数量(住院)
 ..s phaInRetAmt=$P(stats,"^",20)		;退药金额(住院)
 ..
 ..s giftRecQty=$P(stats,"^",21)/fac	;入库数量(赠品)
 ..s giftRecAmt=$P(stats,"^",22)		;入库(赠品)
 ..s giftTrOutQty=$P(stats,"^",23)/fac	;转出数量(赠品)
 ..s giftTrOutAmt=$P(stats,"^",24)		;转出金额(赠品)
 ..
 ..s chgRecQty=$P(stats,"^",25)/fac		;入库数量(调价换票)
 ..s chgRecAmt=$P(stats,"^",26)			;入库金额(调价换票)
 ..s chgRetQty=$P(stats,"^",27)/fac		;退货数量(调价换票)
 ..s chgRetAmt=$P(stats,"^",28)			;退货金额(调价换票)
 ..
 ..s phaOutDspQty=$P(stats,"^",29)/fac	;发药数量(门诊)
 ..s phaOutDspAmt=$P(stats,"^",30)		;发药金额(门诊)
 ..s phaOutDspQtyS=$P(stats,"^",31)/fac	;发药数量(门诊非正常)
 ..s phaOutDspAmtS=$P(stats,"^",32)		;发药金额(门诊非正常)
 ..
 ..s phaOutRetQty=$P(stats,"^",33)/fac	;退药数量(门诊)
 ..s phaOutRetAmt=$P(stats,"^",34)		;退药金额(门诊)
 ..s phaOutRetQtyZ=$P(stats,"^",35)/fac	;退药数量(门诊非正常)
 ..s phaOutRetAmtZ=$P(stats,"^",36)		;退药金额量(门诊非正常)
 ..
 ..s trInAspAmt=$P(stats,"^",38)		;库存转入调价损益
 ..s retAspAmt=$P(stats,"^",39)			;退货调价损益
 ..s stktkAdjQty=$P(stats,"^",40)/fac	;盘点调整数量
 ..s stktkAdjAmt=$P(stats,"^",41)		;盘点调整金额 
 ..s manuXQty=$P(stats,"^",42)/fac
 ..s manuXAmt=$P(stats,"^",43)
 ..s manuMQty=$P(stats,"^",44)/fac
 ..s manuMAmt=$P(stats,"^",45)
 ..s mRecQty=$P(stats,"^",46)/fac
 ..s mRecAmt=$P(stats,"^",47)
 ..s phaOutRetAspAmt=$P(stats,"^",48)	;门诊退药调价损益
 ..s phaRetAspAmt=$P(stats,"^",49)		;住院退药调价损益
 ..
 ..
 ..s phaRetAmt=phaInRetAmt+phaOutRetAmt+phaOutRetAmtZ	;退药金额
 ..s DspAmt=phaInDspAmt+phaOutDspAmt+phaOutDspAmtS		;发药金额
 ..s InAmt=recAmt+trInAmt+phaRetAmt+manuXAmt				//入库金额+转入金额+患者退药金额+制剂消耗金额
 ..s OutAmt=retAmt+trOutAmt+csmAmt+disposeAmt+DspAmt+manuMAmt	//退货金额+转出金额+消耗金额+报损金额+发药金额+制剂生成金额
 ..i adjAmt>0 s InAmt=InAmt+adjAmt
 ..e  s OutAmt=OutAmt+adjAmt
 ..i stktkAdjAmt>0 s InAmt=InAmt+stktkAdjAmt
 ..e  s OutAmt=OutAmt+stktkAdjAmt
 ..i aspAmt>0 s InAmt=InAmt+aspAmt
 ..e  s OutAmt=OutAmt+aspAmt
 ..i retAspAmt>0 s InAmt=InAmt+retAspAmt
 ..e  s OutAmt=OutAmt+retAspAmt
 ..i phaRetAspAmt>0 s InAmt=InAmt+phaRetAspAmt
 ..e  s OutAmt=OutAmt+phaRetAspAmt
 ..i phaOutRetAspAmt>0 s InAmt=InAmt+phaOutRetAspAmt
 ..e  s OutAmt=OutAmt+phaOutRetAspAmt
 ..i trInAspAmt>0 s InAmt=InAmt+trInAspAmt
 ..e  s OutAmt=OutAmt+trInAspAmt
 ..
 ..d OutPutRow
 ..
 &sql(close	MonRepCursor)
 Quit $$$OK
 
OutPutRow
 s Data=$lb(MonthNum,stkGrp,stkGrpDesc,inciCode,inciDesc,spec,uomDesc,qty,amt,lastQty,
 			lastAmt,recQty,recAmt,retQty,retAmt,trOutQty,trOutAmt,trInQty,trInAmt,adjQty,
 			adjAmt,csmQty,csmAmt,disposeQty,disposeAmt,phaInDspQty,phaInDspAmt,aspAmt,phaInRetQty,phaInRetAmt,
 			phaOutDspQty,phaOutDspAmt,phaOutDspQtyS,phaOutDspAmtS,phaOutRetQty,phaOutRetAmt,phaOutRetQtyZ,phaOutRetAmtZ,giftRecQty,giftRecAmt,
 			giftTrOutQty,giftTrOutAmt,chgRecQty,chgRecAmt,chgRetQty,chgRetAmt,retAspAmt,phaRetAspAmt,mRecQty,mRecAmt,
 			stktkAdjQty,stktkAdjAmt,manuXQty,manuXAmt,manuMQty,manuMAmt,phaOutRetAspAmt,trInAspAmt,InAmt,OutAmt,
 			stkCatDesc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	根据月报数据统计年度出库信息(进价)
/// Creater:	wangjiabin
/// CreateDate:	2014-03-02
/// Table:		dhc_stkmontrans
/// Input:		月份,类组id,类组描述,inciCode,inciDesc,入库单位,数量(入库单位),进价金额,业务科室id,业务科室desc,
/// 			科室组id,科室组desc,台帐类型,规格,库存分类,招标标志,进口标志,高值标志,收费标志,监管级别,
/// 			微创介入id,微创介入标志信息
/// Output:		
/// Return:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.YearStatByMonRep","YearStatTKByMonRep",153,2014)
Query YearStatTKByMonRep(PhaLoc As %String, Year As %String, StMonth As %String, EdMonth As %String) As Query(ROWSPEC = "MonthNum,stkGrp,stkGrpDesc,inciCode,inciDesc,puruomdesc,qtyPUom:%Float,transRpAmt:%Float,transLoc,transLocDesc,transSLG,tranSLGDesc,transType,Spec,stkCatDesc,PbFlag,ImpFlag,HVFlag,ChargeFlag,Supervision,BookDr,BookDesc") [ SqlProc ]
{
}

ClassMethod YearStatTKByMonRepExecute(ByRef qHandle As %Binary, PhaLoc As %String, Year As %String, StMonth As %String, EdMonth As %String) As %Status
{
	n (qHandle, PhaLoc, Year, StMonth, EdMonth)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	k YearStatTKInciInfo
	i StMonth="" s StMonth="01"
	i EdMonth="" s EdMonth="12"
	i Year="" s Year=$p($zd(+$h,3),"-",1)
	s StartDate=$zdh(Year_"-"_StMonth_"-01",3)
 	s EndDate=$zdh(Year_"-"_EdMonth_"-28",3)
	&sql(declare MonRepTKCursor cursor for 
		select DHCSM_Month,%id  from dhc_stkmon
		where DHCSM_CTLOC_DR=:PhaLoc and (DHCSM_Month>=:StartDate and DHCSM_Month<=:EndDate )
		order by DHCSM_Month)
	&sql(open MonRepTKCursor)
	f  &sql(fetch MonRepTKCursor into :RepMonth,:sm) q:SQLCODE  d
	.s MonthNum=$p($zd(RepMonth,3),"-",2)		;月份数字
	.s ch=""
	.f  s ch=$o(^DHCSM(sm,"R",ch)) q:ch=""  d
	..s smr=sm_"||"_ch
	..s row=^DHCSM(sm,"R",ch)
	..q:'$d(^DHCSM(sm,"R",ch,"T"))		;没有trans数据的,过滤
	..
	..s inci=$p(row,"^",3)
	..
	..i '$d(YearStatTKInciInfo(inci)) d
	...s inciCode=$p(^INCI(inci,1),"^",1)
	...s inciDesc=$p(^INCI(inci,1),"^",2)
	...s stkgrpinfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s stkGrpDesc=$p(stkgrpinfo,"^",2)
	...s stkGrp=$p(stkgrpinfo,"^",5)
	...s stkcat=$p(^INCI(inci,2),"^",2)
	...s stkCatDesc=$p(^INC("SC",stkcat),"^",2)
	...s buom=$p(^INCI(inci,1),"^",10)
	...s puruom=$p(^INCI(inci,3),"^",6)
	...s buomdesc=$p(^CT("UOM",buom),"^",2)
	...i puruom="" s puruom=buom,puruomdesc=buomdesc
	...e  s puruomdesc=$p(^CT("UOM",puruom),"^",2)
	...s pfac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puruom,buom)
	...
	...s PbFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmPbFlag(inci)
	...s:PbFlag="Y" PbFlag="招标"
	...s:PbFlag="N" PbFlag="非招标"
	...s ImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(inci)
	...s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	...s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(inci)
	...s Surpervison=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSupervision(inci)
	...s BookInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBookCat(inci)
	...s BookDr=$p(BookInfo,"^",1)
	...s BookDesc=$p(BookInfo,"^",3)
	...s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	...s tmpInciInfo1=inciCode_"^"_inciDesc_"^"_stkGrp_"^"_stkGrpDesc_"^"_stkcat_"^"_stkCatDesc_"^"_buomdesc_"^"_puruomdesc_"^"_pfac_"^"_PbFlag
	...s tmpInciInfo2=ImpFlag_"^"_HVFlag_"^"_ChargeFlag_"^"_Surpervison_"^"_BookDr_"^"_BookDesc_"^"_Spec
	...s YearStatTKInciInfo(inci)=tmpInciInfo1_"^"_tmpInciInfo2
	..e  d
	...s InciInfo=YearStatTKInciInfo(inci)
	...s inciCode=$p(InciInfo,"^",1)
	...s inciDesc=$p(InciInfo,"^",2)
	...s stkGrp=$p(InciInfo,"^",3)
	...s stkGrpDesc=$p(InciInfo,"^",4)
	...s stkcat=$p(InciInfo,"^",5)
	...s stkCatDesc=$p(InciInfo,"^",6)
	...s buomdesc=$p(InciInfo,"^",7)
	...s puruomdesc=$p(InciInfo,"^",8)
	...s pfac=$p(InciInfo,"^",9)
	...s PbFlag=$p(InciInfo,"^",10)
	...s ImpFlag=$p(InciInfo,"^",11)
	...s HVFlag=$p(InciInfo,"^",12)
	...s ChargeFlag=$p(InciInfo,"^",13)
	...s Surpervison=$p(InciInfo,"^",14)
	...s BookDr=$p(InciInfo,"^",15)
	...s BookDesc=$p(InciInfo,"^",16)
	...s Spec=$p(InciInfo,"^",17)
	..
	..;q:(stkgrpid'="")&(stkGrp'=stkgrpid)
	..;q:(stkcatid'="")&(stkcat'=stkcatid)  
	..;q:(incdesc'="")&('$f(inciDesc,incdesc))
	..
	..s sub=0
	..f  s sub=$o(^DHCSM(sm,"R",ch,"T",sub)) q:sub=""  d
	...s transInfo=^(sub)
	...s transType=$p(transInfo,"^",1)
	...q:(transType'="T")&&(transType'="K")		;不是TK的过滤
	...s transQty=$p(transInfo,"^",4)
	...s transRpAmt=$p(transInfo,"^",5)
	...s transLoc=$p(transInfo,"^",6)
	...s transLocDesc=$p(^CTLOC(transLoc),"^",2)
	...s transSLG=$p(transInfo,"^",10)
	...s tranSLGDesc=$s(transSLG'="":$p(^DHCSLG(transSLG),"^",2),1:"")
	...s qtyPUom=transQty/pfac
	...
	...d OutPutRowTK
	..
	&sql(close MonRepTKCursor)
	Quit $$$OK
OutPutRowTK
	s Data=$lb(MonthNum,stkGrp,stkGrpDesc,inciCode,inciDesc,puruomdesc,qtyPUom,transRpAmt,transLoc,transLocDesc,
			transSLG,tranSLGDesc,transType,Spec,stkCatDesc,PbFlag,ImpFlag,HVFlag,ChargeFlag,Supervision,
			BookDr,BookDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
