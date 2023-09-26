Import sqluser

Class web.DHCSTMHUI.YearStatByMonCatRep Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.YearStatByMonCatRep","YearStatByMonRep",6,2017,1,5)
/// 根据月报数据进行年份统计
/// Table: DHC_StkMonSumIn_CatGrp
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
Query YearStatByMonRep(PhaLoc As %String, Year As %String, StMonth As %String, EdMonth As %String) As Query(ROWSPEC = "MonthNum,stkGrp,stkGrpDesc,amt:%Float,lastAmt:%Float,recAmt:%Float,retAmt:%Float,trOutAmt:%Float,trInAmt:%Float,adjAmt:%Float,csmAmt:%Float,disposeAmt:%Float,phaInDspAmt:%Float,aspAmt:%Float,phaInRetAmt:%Float,phaOutDspAmt:%Float,phaOutDspAmtS:%Float,phaOutRetAmt:%Float,phaOutRetAmtZ:%Float,giftRecAmt:%Float,giftTrOutAmt:%Float,chgRecAmt:%Float,chgRetAmt:%Float,retAspAmt:%Float,phaRetAspAmt:%Float,mRecAmt:%Float,stktkAdjAmt:%Float,manuXAmt:%Float,manuMAmt:%Float,phaOutRetAspAmt:%Float,trInAspAmt:%Float,InAmt:%Float,OutAmt:%Float,stkCatDesc") [ SqlProc ]
{
}

ClassMethod YearStatByMonRepExecute(ByRef qHandle As %Binary, PhaLoc As %String, Year As %String, StMonth As %String, EdMonth As %String) As %Status
{
 n (qHandle, PhaLoc, Year, StMonth, EdMonth)
 ;s ^tsr("YearStatByMonRep")=PhaLoc_","_Year_","_StMonth_","_EdMonth
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
 .s SumRowId=""
 .f  s SumRowId=$o(^DHCSMSum("SUMCG",0,"Mon",sm,SumRowId)) q:SumRowId=""  d
 ..s row=^DHCSMSum("SUMCG",SumRowId)
 ..s stkcat=$p(row,"^",2)
 ..s stkCatDesc=$p(^INC("SC",stkcat),"^",2)
 ..s stkGrp=$p(row,"^",3)
 ..s stkGrpDesc=$p(^DHCSCG(stkGrp),"^",2)
 ..s amt=$p(row,"^",4)					;amount
 ..s lastAmt=$p(row,"^",5)				;amount of last month
 ..s recAmt=$P(row,"^",6)				;入库金额
 ..s retAmt=$P(row,"^",7)				;退货金额
 ..s trOutAmt=$P(row,"^",8)			;转出金额
 ..s trInAmt=$P(row,"^",9)			;转入金额
 ..s adjAmt=$P(row,"^",10)			;库存调整金额
 ..s csmAmt=$P(row,"^",11)			;消耗金额
 ..s disposeAmt=$P(row,"^",12)		;报损金额
 ..s aspAmt=$P(row,"^",13)			;调价损益金额
 ..s giftRecAmt=$P(row,"^",14)		;入库(赠品)
 ..s giftTrOutAmt=$P(row,"^",15)		;转出金额(赠品)
 ..s chgRecAmt=$P(row,"^",16)			;入库金额(调价换票)
 ..s chgRetAmt=$P(row,"^",17)			;退货金额(调价换票)
 ..s phaInDspAmt=$P(row,"^",18)		;发药金额(住院)
 ..s phaInRetAmt=$P(row,"^",19)		;退药金额(住院)
 ..s phaOutDspAmt=$P(row,"^",20)		;发药金额(门诊)
 ..s phaOutDspAmtS=$P(row,"^",22)		;发药金额(门诊非正常)
 ..s phaOutRetAmt=$P(row,"^",21)		;退药金额(门诊)
 ..s phaOutRetAmtZ=$P(row,"^",23)		;退药金额量(门诊非正常)
 ..s trInAspAmt=$P(row,"^",29)		;库存转入调价损益
 ..s retAspAmt=$P(row,"^",28)			;退货调价损益
 ..s stktkAdjAmt=$P(row,"^",24)		;盘点调整金额
 ..s manuXAmt=$P(row,"^",25)
 ..s manuMAmt=$P(row,"^",26)
 ..s mRecAmt=$P(row,"^",27)
 ..s phaOutRetAspAmt=$P(row,"^",31)	;门诊退药调价损益
 ..s phaRetAspAmt=$P(row,"^",30)		;住院退药调价损益
 ..
 ..s phaRetAmt=phaInRetAmt+phaOutRetAmt+phaOutRetAmtZ	;退药金额
 ..s DspAmt=phaInDspAmt+phaOutDspAmt+phaOutDspAmtS		;发药金额
 ..s InAmt=recAmt+trInAmt+phaRetAmt+manuXAmt					//入库金额+转入金额+患者退药金额+制剂消耗金额
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
 s Data=$lb(MonthNum,stkGrp,stkGrpDesc,amt,
 			lastAmt,recAmt,retAmt,trOutAmt,trInAmt,
 			adjAmt,csmAmt,disposeAmt,phaInDspAmt,aspAmt,phaInRetAmt,
 			phaOutDspAmt,phaOutDspAmtS,phaOutRetAmt,phaOutRetAmtZ,giftRecAmt,
 			giftTrOutAmt,chgRecAmt,chgRetAmt,retAspAmt,phaRetAspAmt,mRecAmt,
 			stktkAdjAmt,manuXAmt,manuMAmt,phaOutRetAspAmt,trInAspAmt,InAmt,OutAmt,
 			stkCatDesc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	根据月报汇总数据统计年度出库信息
/// Creater:	xuchao
/// CreateDate:	2016-08-18
/// Table:		DHC_StkMonSum_TransLoc
/// Input:
/// Output:
/// Return:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.YearStatByMonCatRep","YearStatTKByMonRep",153,2016)
Query YearStatTKByMonRep(PhaLoc As %String, Year As %String, StMonth As %String, EdMonth As %String) As Query(ROWSPEC = "MonthNum,stkGrp,stkGrpDesc,transRpAmt:%Float,transLoc,transLocDesc,transType,stkcat,stkCatDesc,transSpAmt:%Float") [ SqlProc ]
{
}

ClassMethod YearStatTKByMonRepExecute(ByRef qHandle As %Binary, PhaLoc As %String, Year As %String, StMonth As %String, EdMonth As %String) As %Status
{
	n (qHandle, PhaLoc, Year, StMonth, EdMonth)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
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
	.s SumRowId=""
	.f  s SumRowId=$o(^DHCSMSum("SUMTL",0,"Mon",sm,SumRowId)) q:SumRowId=""  d
	..s row=^DHCSMSum("SUMTL",SumRowId)
	..s transType=$p(row,"^",2)
    ..q:(transType'="TK")		;不是TK的过滤
    ..s transLoc=$p(row,"^",5)
    ..s transLocDesc=$p(^CTLOC(transLoc),"^",2)
 	..s stkcat=$p(row,"^",3)
	..s stkCatDesc=$p(^INC("SC",stkcat),"^",2)
 	..s stkGrp=$p(row,"^",4)
 	..s stkGrpDesc=$p(^DHCSCG(stkGrp),"^",2)
 	..s transRpAmt=$p(row,"^",6)
 	..s transSpAmt=$p(row,"^",7)
	..d OutPutRowTK
	..
	&sql(close MonRepTKCursor)
	Quit $$$OK
OutPutRowTK
	s Data=$lb(MonthNum,stkGrp,stkGrpDesc,transRpAmt,transLoc,transLocDesc,transType,stkcat,stkCatDesc,transSpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
